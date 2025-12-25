# Zoppler Radar AI 🎯

An intelligent internal assistant specialized in Defence and Automotive Radar engineering. Built for Zoppler Systems engineering teams.

**Now running 100% locally with Ollama - No API keys, no internet required!**

![Python](https://img.shields.io/badge/python-3.11+-blue.svg)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-green.svg)
![Ollama](https://img.shields.io/badge/Ollama-Local%20LLM-green.svg)
![License](https://img.shields.io/badge/license-Internal-red.svg)

## 🚀 Features

### Expert Knowledge Domains

- **🎯 Radar Fundamentals**: FMCW, Pulse, AESA, range–Doppler–angle processing
- **🛡️ Defence Radar Systems**: Surveillance, tracking, ISAR/SAR, ECCM, C2, sensor fusion
- **🚗 Automotive Radar**: 24/77 GHz systems, ADAS, object tracking, multi-sensor fusion
- **📊 Signal Processing**: FFT, CFAR, beamforming, Kalman filters, matched filtering
- **🤖 Machine Learning**: Target/clutter classification, ISAR ML, GNN/LSTM/CNN architectures
- **💻 Radar Software**: C/C++, Python, Qt, ROS, microservices, real-time systems, HMIs

### Key Capabilities

✅ **Precise Engineering Guidance** - Structured, technical responses with equations and trade-offs  
✅ **Context-Aware** - Prioritizes internal documents and uploaded files as ground truth  
✅ **Security-Focused** - All conversations confidential, no operational attack guidance  
✅ **Adaptive Depth** - Adjusts technical level for engineers vs management  
✅ **Professional Interface** - Modern, responsive web UI with streaming responses

## 📋 Prerequisites

- **Python 3.11+**
- **Ollama** (for running local LLM models)
- **Docker** (optional, for containerized deployment)
- **8GB+ RAM recommended** (16GB+ for larger models)

## 🛠️ Installation

### Step 1: Install Ollama

**On Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**On macOS:**
```bash
brew install ollama
```

**On Windows:**
Download and install from [ollama.com/download](https://ollama.com/download)

### Step 2: Pull a Model

Start Ollama and download a model (recommended: llama3.2 for good balance of speed and quality):

```bash
# Start Ollama service (if not auto-started)
ollama serve

# In another terminal, pull a model
ollama pull llama3.2

# Alternative models you can try:
# ollama pull llama3.1      # Larger, more capable
# ollama pull mistral       # Fast and efficient
# ollama pull codellama     # Optimized for code
# ollama pull phi3          # Smaller, faster (2GB)
```

### Step 3: Set Up the Application

**Option A: Local Setup (Recommended for Development)**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zoppler-radar-ai
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env to customize Ollama settings (optional)
   # Default values work if Ollama is running locally
   ```

5. **Run the application**
   ```bash
   python app.py
   ```

6. **Access the chatbot**
   Open your browser to: **http://localhost:8000**

**Option B: Docker Deployment (For Production)**

1. **Ensure Ollama is running on host**
   ```bash
   ollama serve
   ```

2. **Clone and configure**
   ```bash
   git clone <repository-url>
   cd zoppler-radar-ai
   cp .env.example .env
   # Edit .env if needed (defaults work for local setup)
   ```

3. **Update docker-compose.yml** to use host network or link to Ollama

4. **Build and run**
   ```bash
   docker-compose up -d
   ```

5. **Access the chatbot**
   Open your browser to: **http://localhost:8000**

## 🤖 Choosing a Model

Different models offer different trade-offs:

| Model | Size | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| **phi3** | 2GB | ⚡⚡⚡ | ⭐⭐⭐ | Quick responses, limited RAM |
| **llama3.2** | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | **Recommended balance** |
| **mistral** | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | Fast and capable |
| **llama3.1** | 42GB | ⚡ | ⭐⭐⭐⭐⭐ | Best quality, needs GPU |
| **codellama** | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | Code-focused tasks |

Change model in `.env`:
```bash
OLLAMA_MODEL=llama3.2  # or mistral, phi3, etc.
```

## 📁 Project Structure

```
zoppler-radar-ai/
├── app.py                 # FastAPI backend with chat endpoints
├── static/
│   ├── index.html        # Main chat interface
│   ├── styles.css        # Modern, responsive styling
│   └── script.js         # Frontend logic and streaming
├── requirements.txt      # Python dependencies
├── Dockerfile           # Docker image configuration
├── docker-compose.yml   # Docker Compose setup
├── .env.example         # Environment template
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## 🎨 User Interface

The chatbot features a professional, engineering-focused interface:

- **Dark theme** optimized for extended use
- **Streaming responses** for real-time interaction
- **Specialty tags** highlighting expertise areas
- **Responsive design** for desktop and mobile
- **Code formatting** with syntax highlighting
- **Markdown support** for equations and technical content

## 🔐 Security & Compliance

- **Confidential by default**: All conversations treated as internal
- **No operational guidance**: Refuses real-world attack/weapon usage instructions
- **Ground truth priority**: Relies on uploaded documents over general knowledge
- **No data persistence**: Conversations not stored (can be modified if needed)
- **API key security**: Environment-based configuration

## 🧪 Example Use Cases

### 1. FMCW Radar Design
```
User: "What's the optimal chirp bandwidth for a 77 GHz automotive radar 
       targeting 0.1m range resolution?"

AI: Provides calculation steps, trade-offs, and regulatory considerations
```

### 2. Signal Processing Pipeline
```
User: "Design a 2D CFAR detector for clutter suppression in maritime surveillance"

AI: Delivers algorithm pseudo-code, parameter recommendations, and performance analysis
```

### 3. Machine Learning Integration
```
User: "Compare GNN vs LSTM for radar target tracking with occlusions"

AI: Technical comparison table, architecture diagrams, and implementation guidance
```

### 4. System Architecture
```
User: "Microservice architecture for real-time radar data processing in ROS2"

AI: System design, message patterns, latency considerations, and code examples
```

## 🛠️ Customization

### Modify System Prompt

Edit the `SYSTEM_PROMPT` variable in `app.py` to adjust the AI's behavior, expertise areas, or constraints.

### Change AI Model

Update the model in your `.env` file:
```bash
OLLAMA_MODEL=llama3.2  # Current
# OLLAMA_MODEL=mistral  # Alternative
# OLLAMA_MODEL=phi3     # Smaller/faster
```

Make sure to pull the new model first:
```bash
ollama pull mistral
```

### Adjust Styling

Modify `static/styles.css` to change colors, layout, or branding:
```css
:root {
    --primary-color: #1e40af;    /* Brand color */
    --radar-green: #10b981;       /* Accent color */
    /* ... */
}
```

## 📊 API Endpoints

### `GET /`
Returns the main chat interface (HTML)

### `GET /health`
Health check endpoint for monitoring
```json
{"status": "healthy", "service": "Zoppler Radar AI"}
```

### `POST /api/chat`
Main chat endpoint supporting streaming responses
```json
{
  "messages": [
    {"role": "user", "content": "Explain FMCW chirp modulation"}
  ],
  "stream": true
}
```

### `POST /api/clear`
Clears conversation history (frontend-only, no backend persistence)

## 🚦 Troubleshooting

### "Cannot connect to Ollama"
- Ensure Ollama is running: `ollama serve`
- Check Ollama is accessible: `curl http://localhost:11434/api/version`
- Verify OLLAMA_HOST in `.env` matches your Ollama installation

### "Model not found"
- Pull the model first: `ollama pull llama3.2`
- Verify model name: `ollama list`
- Update OLLAMA_MODEL in `.env` to match available model

### Port 8000 already in use
- Change port in `.env`: `PORT=8080`
- Or stop the conflicting service

### Slow responses
- Try a smaller/faster model: `ollama pull phi3`
- Ensure enough RAM available (8GB+ recommended)
- Consider using GPU acceleration if available
- Close other memory-intensive applications

### Out of memory errors
- Use a smaller model like `phi3` or `mistral`
- Close other applications
- Increase system swap space

### Response quality issues
- Try a larger model: `ollama pull llama3.1`
- Adjust temperature and other parameters in code
- Ensure model is fully downloaded: `ollama pull <model> --verbose`

## 🔄 Development Workflow

1. **Make changes** to `app.py`, `static/index.html`, `styles.css`, or `script.js`
2. **With Docker Compose**: Changes to static files are live (volume-mounted)
3. **With local Python**: Restart the server to see backend changes
4. **Test in browser**: Hard refresh (Ctrl+Shift+R) to clear cache

## 📈 Production Deployment

For production deployment, consider:

1. **Reverse Proxy**: Use Nginx/Apache in front of FastAPI
2. **HTTPS**: Enable SSL/TLS certificates
3. **Authentication**: Add user authentication layer
4. **Rate Limiting**: Implement API rate limiting
5. **Monitoring**: Add logging and metrics (Prometheus/Grafana)
6. **Scaling**: Deploy multiple instances behind load balancer

Example Nginx configuration:
```nginx
server {
    listen 443 ssl;
    server_name radar-ai.zoppler.internal;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🤝 Contributing

This is an internal Zoppler Systems tool. For improvements or issues:

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit pull request with clear description

## 📝 License

Internal use only - Zoppler Systems. All rights reserved.

## 🆘 Support

For technical support or questions:
- **Internal Wiki**: [Link to internal documentation]
- **Engineering Team**: engineering@zoppler.systems
- **IT Support**: it-support@zoppler.systems

## 🎯 Roadmap

Future enhancements under consideration:

- [ ] File upload support for analyzing radar data files
- [ ] Integration with internal documentation database
- [ ] Multi-language support (Python, C++, MATLAB code generation)
- [ ] Conversation history with search
- [ ] Team collaboration features
- [ ] Custom knowledge base training
- [ ] Integration with internal tools (Jira, Confluence)
- [ ] Voice input for hands-free operation

---

**Built with ❤️ for Zoppler Systems Engineering Teams**

*Powered by Local LLMs via Ollama | FastAPI | Modern Web Technologies*

## 🌟 Benefits of Local LLM

- **🔒 Complete Privacy**: All data stays on your machine
- **💰 Zero API Costs**: No usage fees or rate limits
- **🚀 No Internet Required**: Works offline
- **⚡ Fast Responses**: No network latency
- **🎯 Full Control**: Choose and customize your model
