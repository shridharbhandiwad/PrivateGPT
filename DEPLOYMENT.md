# 🚀 Production Deployment Guide

Complete guide for deploying Zoppler Radar AI to production environments.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Docker Deployment](#docker-deployment)
3. [Kubernetes Deployment](#kubernetes-deployment)
4. [Reverse Proxy Setup](#reverse-proxy-setup)
5. [Monitoring & Logging](#monitoring--logging)
6. [Security Hardening](#security-hardening)
7. [Scaling](#scaling)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

- **Server**: Linux (Ubuntu 20.04+ or RHEL 8+)
- **RAM**: Minimum 2GB, recommended 4GB+
- **CPU**: 2+ cores
- **Storage**: 10GB+ available
- **Network**: Ports 80/443 open for external access
- **Docker**: v24.0+ or Kubernetes v1.27+
- **SSL Certificate**: For HTTPS (Let's Encrypt recommended)

## Docker Deployment

### Option 1: Docker Compose (Simple)

**1. Prepare Server**
```bash
# Install Docker and Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**2. Deploy Application**
```bash
# Clone repository
git clone <repository-url> /opt/zoppler-radar-ai
cd /opt/zoppler-radar-ai

# Configure environment
cp .env.example .env
nano .env  # Configure Ollama settings (defaults work for local setup)

# Start services
docker-compose up -d

# Verify
docker-compose ps
docker-compose logs -f
```

**3. Enable Auto-Start**
```bash
# Create systemd service
sudo nano /etc/systemd/system/zoppler-radar-ai.service
```

```ini
[Unit]
Description=Zoppler Radar AI
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/zoppler-radar-ai
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl enable zoppler-radar-ai
sudo systemctl start zoppler-radar-ai
```

### Option 2: Docker Swarm (High Availability)

```bash
# Initialize swarm
docker swarm init

# Create overlay network
docker network create --driver overlay zoppler-network

# Deploy stack
docker stack deploy -c docker-compose.yml zoppler

# Scale services
docker service scale zoppler_zoppler-radar-ai=3
```

## Kubernetes Deployment

### 1. Create Kubernetes Manifests

**deployment.yaml**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zoppler-radar-ai
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: zoppler-radar-ai
  template:
    metadata:
      labels:
        app: zoppler-radar-ai
    spec:
      containers:
      - name: zoppler-radar-ai
        image: zoppler/radar-ai:latest
        ports:
        - containerPort: 8000
        env:
        - name: OLLAMA_HOST
          value: "http://ollama-service:11434"
        - name: OLLAMA_MODEL
          value: "llama3.2"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: zoppler-radar-ai
  namespace: production
spec:
  selector:
    app: zoppler-radar-ai
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: LoadBalancer
```

**2. Deploy to Kubernetes**
```bash
# Create namespace
kubectl create namespace production

# Note: Ensure Ollama is deployed separately or accessible from cluster
# Option 1: Deploy Ollama as a service in the cluster
# Option 2: Use external Ollama instance (set OLLAMA_HOST)

# Deploy
kubectl apply -f deployment.yaml

# Verify
kubectl get pods -n production
kubectl get services -n production
```

## Reverse Proxy Setup

### Nginx Configuration

**1. Install Nginx**
```bash
sudo apt update
sudo apt install nginx
```

**2. Configure Site**
```bash
sudo nano /etc/nginx/sites-available/zoppler-radar-ai
```

```nginx
upstream zoppler_backend {
    server localhost:8000;
    keepalive 64;
}

server {
    listen 80;
    server_name radar-ai.zoppler.internal;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name radar-ai.zoppler.internal;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/radar-ai.zoppler.internal/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/radar-ai.zoppler.internal/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log /var/log/nginx/zoppler-radar-ai-access.log;
    error_log /var/log/nginx/zoppler-radar-ai-error.log;
    
    # Client body size (for file uploads)
    client_max_body_size 100M;
    
    location / {
        proxy_pass http://zoppler_backend;
        proxy_http_version 1.1;
        
        # WebSocket support (for streaming)
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts (important for streaming responses)
        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        
        # Buffering (disable for streaming)
        proxy_buffering off;
        proxy_request_buffering off;
    }
    
    # Static files cache
    location /static/ {
        proxy_pass http://zoppler_backend;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

**3. Enable and Restart**
```bash
sudo ln -s /etc/nginx/sites-available/zoppler-radar-ai /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### SSL Certificate (Let's Encrypt)

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Obtain certificate
sudo certbot --nginx -d radar-ai.zoppler.internal

# Auto-renewal (already configured)
sudo systemctl status certbot.timer
```

## Monitoring & Logging

### Prometheus + Grafana

**1. Add Metrics Endpoint to app.py**
```python
from prometheus_client import Counter, Histogram, generate_latest

# Metrics
chat_requests = Counter('chat_requests_total', 'Total chat requests')
response_time = Histogram('response_time_seconds', 'Response time')

@app.get("/metrics")
async def metrics():
    return Response(generate_latest(), media_type="text/plain")
```

**2. Prometheus Configuration**
```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'zoppler-radar-ai'
    static_configs:
      - targets: ['localhost:8000']
```

**3. Grafana Dashboard**
- Import dashboard template
- Configure data source (Prometheus)
- Set up alerts for high error rates

### Centralized Logging (ELK Stack)

```bash
# Install Filebeat
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.x.x-amd64.deb
sudo dpkg -i filebeat-8.x.x-amd64.deb

# Configure to ship logs to Elasticsearch
sudo nano /etc/filebeat/filebeat.yml

# Start Filebeat
sudo systemctl enable filebeat
sudo systemctl start filebeat
```

## Security Hardening

### 1. Firewall (UFW)
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
```

### 2. Fail2Ban (Brute Force Protection)
```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
```

### 3. AppArmor/SELinux
```bash
# Ubuntu: AppArmor
sudo aa-enforce /path/to/profile

# RHEL: SELinux
sudo setenforce 1
```

### 4. Regular Updates
```bash
# Automated security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

## Scaling

### Horizontal Scaling (Multiple Instances)

**Docker Compose**
```bash
docker-compose up -d --scale zoppler-radar-ai=3
```

**Kubernetes**
```bash
kubectl scale deployment zoppler-radar-ai --replicas=5 -n production
```

### Load Balancing

**Nginx Load Balancer**
```nginx
upstream zoppler_backend {
    least_conn;
    server backend1:8000;
    server backend2:8000;
    server backend3:8000;
}
```

### Auto-Scaling (Kubernetes HPA)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: zoppler-radar-ai-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: zoppler-radar-ai
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Troubleshooting

### Application Won't Start
```bash
# Check logs
docker-compose logs -f
# or
kubectl logs -f deployment/zoppler-radar-ai -n production

# Common issues:
# - Missing API key
# - Port already in use
# - Insufficient resources
```

### High CPU/Memory Usage
```bash
# Monitor resources
docker stats
# or
kubectl top pods -n production

# Solutions:
# - Increase resource limits
# - Scale horizontally
# - Optimize AI model parameters
```

### Slow Response Times
```bash
# Check API rate limits
# Check network latency
# Enable caching
# Increase worker processes
```

### SSL Certificate Issues
```bash
# Renew manually
sudo certbot renew --force-renewal

# Check expiration
sudo certbot certificates
```

## Backup & Recovery

### Database Backups (if implemented)
```bash
# Create backup script
cat > /opt/scripts/backup-zoppler.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec zoppler-radar-ai-db pg_dump -U zoppler > /backups/zoppler_$DATE.sql
find /backups -mtime +7 -delete
EOF

chmod +x /opt/scripts/backup-zoppler.sh

# Add to cron
crontab -e
0 2 * * * /opt/scripts/backup-zoppler.sh
```

## Health Checks

```bash
# Manual health check
curl https://radar-ai.zoppler.internal/health

# Automated monitoring (UptimeRobot, Pingdom, etc.)
```

---

**For additional support, contact the DevOps team.**
