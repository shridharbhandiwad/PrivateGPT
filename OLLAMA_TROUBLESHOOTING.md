# Ollama Troubleshooting Guide 🔧

This guide helps you resolve common Ollama-related issues when running Zoppler Radar AI.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Connection Issues](#connection-issues)
- [Model Download Issues](#model-download-issues)
- [Performance Issues](#performance-issues)
- [Windows-Specific Issues](#windows-specific-issues)
- [macOS-Specific Issues](#macos-specific-issues)
- [Linux-Specific Issues](#linux-specific-issues)

---

## Installation Issues

### ❌ "Ollama not found" Error

**Problem:** The startup script cannot find the Ollama executable.

**Solutions:**

#### Windows
1. **Download and Install:**
   - Visit https://ollama.com/download
   - Download the Windows installer
   - Run the installer (requires admin privileges)
   - Restart your terminal/command prompt

2. **Verify Installation:**
   ```cmd
   where ollama
   ollama --version
   ```

3. **If still not found:**
   - Check if Ollama is installed in: `C:\Users\YourUsername\AppData\Local\Programs\Ollama`
   - Add Ollama to your PATH:
     - Search "Environment Variables" in Windows
     - Edit "Path" variable
     - Add Ollama installation directory
     - Restart terminal

#### macOS
1. **Install via Homebrew (Recommended):**
   ```bash
   brew install ollama
   ```

2. **Or Download from Website:**
   - Visit https://ollama.com/download
   - Download the macOS installer
   - Drag Ollama to Applications folder

3. **Verify Installation:**
   ```bash
   which ollama
   ollama --version
   ```

#### Linux
1. **Install via Script:**
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

2. **Verify Installation:**
   ```bash
   which ollama
   ollama --version
   ```

---

## Connection Issues

### ❌ "Cannot connect to Ollama" Error

**Problem:** Ollama is installed but the service is not running.

**Solutions:**

#### Quick Fix (All Platforms)
```bash
# Start Ollama service
ollama serve
```

Keep this terminal open and run the application in another terminal.

#### Windows
1. **Check if Ollama is running:**
   ```cmd
   curl http://localhost:11434/api/version
   ```

2. **Start Ollama:**
   - **Option A:** Open Ollama app from Start Menu
   - **Option B:** Run in terminal: `ollama serve`
   - **Option C:** Restart the Ollama Windows service

3. **Configure as Windows Service:**
   - Ollama should auto-start on Windows
   - If not, reinstall Ollama

#### macOS
1. **Start Ollama:**
   ```bash
   # Option A: Open the app
   open -a Ollama
   
   # Option B: Run from terminal
   ollama serve
   ```

2. **Make Ollama start automatically:**
   ```bash
   # Using brew services
   brew services start ollama
   ```

#### Linux
1. **Start Ollama:**
   ```bash
   ollama serve
   ```

2. **Run as systemd service:**
   ```bash
   # Create service file
   sudo tee /etc/systemd/system/ollama.service > /dev/null <<EOF
   [Unit]
   Description=Ollama Service
   After=network-online.target
   
   [Service]
   ExecStart=$(which ollama) serve
   User=$USER
   Restart=always
   RestartSec=3
   
   [Install]
   WantedBy=default.target
   EOF
   
   # Enable and start
   sudo systemctl daemon-reload
   sudo systemctl enable ollama
   sudo systemctl start ollama
   
   # Check status
   sudo systemctl status ollama
   ```

### ❌ "Connection refused" or Port 11434 Issues

**Problem:** Ollama is trying to use a port that's already in use or blocked.

**Solutions:**

1. **Check if something else is using port 11434:**
   ```bash
   # Windows
   netstat -ano | findstr :11434
   
   # macOS/Linux
   lsof -i :11434
   ```

2. **Use a different port:**
   ```bash
   # Set custom port
   OLLAMA_HOST=0.0.0.0:11435 ollama serve
   ```
   
   Then update your `.env` file:
   ```
   OLLAMA_HOST=http://localhost:11435
   ```

3. **Check firewall settings:**
   - Ensure port 11434 is not blocked by firewall
   - Add exception for Ollama in Windows Defender/macOS Firewall

---

## Model Download Issues

### ❌ "Model not found" Error

**Problem:** No models are installed in Ollama.

**Solutions:**

1. **Download a model:**
   ```bash
   # Recommended model (7GB)
   ollama pull llama3.2
   
   # Smaller model (2GB) - faster download
   ollama pull phi3
   
   # Larger model (42GB) - best quality
   ollama pull llama3.1
   ```

2. **Verify downloaded models:**
   ```bash
   ollama list
   ```

3. **If download fails:**
   - Check internet connection
   - Check available disk space (models are large!)
   - Try a smaller model first: `ollama pull phi3`

### ❌ Download Interrupted or Slow

**Problem:** Model download is too slow or keeps failing.

**Solutions:**

1. **Resume interrupted download:**
   ```bash
   # Ollama automatically resumes from where it stopped
   ollama pull llama3.2
   ```

2. **Check download speed:**
   - Downloads are typically 50-500 MB/s depending on connection
   - Model sizes: phi3 (2GB), llama3.2 (7GB), llama3.1 (42GB)

3. **Free up disk space:**
   ```bash
   # Check available space
   df -h  # Linux/macOS
   
   # Windows: check via File Explorer
   ```

4. **Remove unused models:**
   ```bash
   # List models
   ollama list
   
   # Remove a model
   ollama rm model_name
   ```

---

## Performance Issues

### ⚠️ Slow Response Times

**Problem:** Ollama is responding but taking too long.

**Solutions:**

1. **Use a smaller/faster model:**
   ```bash
   # Try phi3 (fastest)
   ollama pull phi3
   ```
   
   Update `.env`:
   ```
   OLLAMA_MODEL=phi3
   ```

2. **Check system resources:**
   - **Minimum:** 8GB RAM, 10GB disk space
   - **Recommended:** 16GB RAM, SSD storage
   - Close other memory-intensive applications

3. **Enable GPU acceleration:**
   - **NVIDIA GPU:** Ensure CUDA drivers are installed
   - **Apple Silicon:** Automatically uses Metal
   - **AMD GPU:** Check Ollama documentation for ROCm support

4. **Verify GPU is being used:**
   ```bash
   # Check if GPU is detected
   ollama run llama3.2 "test"
   
   # On Linux/Windows with NVIDIA:
   nvidia-smi  # Should show ollama process
   ```

### ⚠️ Out of Memory Errors

**Problem:** System runs out of memory when using Ollama.

**Solutions:**

1. **Use smaller model:**
   ```bash
   ollama pull phi3  # Only 2GB
   ```

2. **Close other applications:**
   - Close browser tabs
   - Close IDE/heavy applications
   - Check task manager/activity monitor

3. **Check memory usage:**
   ```bash
   # Linux
   free -h
   
   # macOS
   top -l 1 | grep PhysMem
   
   # Windows
   # Open Task Manager (Ctrl+Shift+Esc)
   ```

4. **Increase swap space (Linux):**
   ```bash
   # Check current swap
   swapon --show
   
   # Create additional swap file (8GB example)
   sudo fallocate -l 8G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

---

## Windows-Specific Issues

### ❌ "Access Denied" during installation

**Solution:**
- Run installer as Administrator
- Disable antivirus temporarily during installation
- Check Windows Defender isn't blocking Ollama

### ❌ Ollama not starting automatically

**Solution:**
1. Check Windows Services:
   - Press `Win + R`, type `services.msc`
   - Find "Ollama Service"
   - Set to "Automatic" startup

2. Reinstall Ollama if service is missing

### ❌ Git Bash / MINGW64 Issues

**Problem:** Running `./start.bat` in Git Bash shows encoding issues or doesn't work properly.

**Solution:**
1. **Use Command Prompt or PowerShell instead:**
   ```cmd
   # Open Command Prompt and run:
   start.bat
   ```

2. **Or convert to use `start.sh` in Git Bash:**
   ```bash
   # In Git Bash:
   bash start.sh
   ```

3. **Fix path issues in Git Bash:**
   ```bash
   # Ensure Ollama is in PATH
   export PATH="$PATH:/c/Users/$USERNAME/AppData/Local/Programs/Ollama"
   ```

---

## macOS-Specific Issues

### ❌ "Ollama" cannot be opened because the developer cannot be verified

**Solution:**
1. Open System Preferences > Security & Privacy
2. Click "Open Anyway" for Ollama
3. Or disable Gatekeeper temporarily:
   ```bash
   sudo xattr -d com.apple.quarantine /Applications/Ollama.app
   ```

### ❌ Ollama not using Apple Silicon GPU

**Solution:**
- Ensure you downloaded the Apple Silicon version (not Intel)
- Check Activity Monitor > GPU tab to verify usage
- Ollama automatically uses Metal on Apple Silicon

---

## Linux-Specific Issues

### ❌ Permission denied when installing

**Solution:**
```bash
# Install requires sudo/root access
curl -fsSL https://ollama.com/install.sh | sudo sh
```

### ❌ Ollama crashes on start

**Solutions:**
1. **Check logs:**
   ```bash
   # If running as systemd service
   sudo journalctl -u ollama -f
   
   # If running manually, check output
   ollama serve
   ```

2. **Check GPU compatibility:**
   - NVIDIA: Ensure CUDA drivers installed
   - AMD: Check ROCm compatibility

3. **Update Ollama:**
   ```bash
   curl -fsSL https://ollama.com/install.sh | sh
   ```

### ❌ CPU-only mode (no GPU detected)

**Solution:**
```bash
# Check GPU drivers
nvidia-smi  # For NVIDIA
rocm-smi    # For AMD

# Reinstall drivers if needed
# NVIDIA CUDA: https://developer.nvidia.com/cuda-downloads
# AMD ROCm: https://rocm.docs.amd.com/
```

---

## Advanced Troubleshooting

### Check Ollama Version

```bash
ollama --version
```

Update if needed:
```bash
# Windows: Download latest installer
# macOS: brew upgrade ollama
# Linux: curl -fsSL https://ollama.com/install.sh | sh
```

### Test Ollama Directly

```bash
# Test basic functionality
ollama run llama3.2 "Hello, how are you?"

# Check API endpoint
curl http://localhost:11434/api/version

# List installed models
ollama list
```

### Check Application Logs

```bash
# Run the application with verbose logging
python app.py

# Check for connection errors in output
```

### Reset Ollama Completely

**Windows:**
```cmd
# Uninstall Ollama
# Delete: C:\Users\YourUsername\.ollama
# Reinstall from https://ollama.com/download
```

**macOS:**
```bash
# Uninstall
brew uninstall ollama  # If installed via brew
# Or delete /Applications/Ollama.app

# Remove data
rm -rf ~/.ollama

# Reinstall
brew install ollama
```

**Linux:**
```bash
# Remove Ollama
sudo rm /usr/local/bin/ollama
sudo rm -rf /usr/share/ollama
sudo systemctl disable ollama  # If using service

# Remove data
rm -rf ~/.ollama

# Reinstall
curl -fsSL https://ollama.com/install.sh | sh
```

---

## Getting Help

If you're still experiencing issues:

1. **Check Ollama Documentation:** https://ollama.com/docs
2. **Ollama GitHub Issues:** https://github.com/ollama/ollama/issues
3. **Application logs:** Review error messages in terminal output
4. **Internal Support:** Contact Zoppler IT support

---

## Quick Reference

### Essential Commands

```bash
# Install Ollama (Linux/macOS)
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama
ollama serve

# Download model
ollama pull llama3.2

# List models
ollama list

# Test Ollama
ollama run llama3.2 "test"

# Check API
curl http://localhost:11434/api/version

# Remove model
ollama rm model_name
```

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 8GB | 16GB+ |
| Disk Space | 10GB | 50GB+ (for multiple models) |
| CPU | 4 cores | 8+ cores |
| GPU | None (CPU works) | NVIDIA/Apple Silicon |

### Model Comparison

| Model | Size | RAM Needed | Speed | Quality |
|-------|------|------------|-------|---------|
| phi3 | 2GB | 4GB | ⚡⚡⚡ | ⭐⭐⭐ |
| llama3.2 | 7GB | 8GB | ⚡⚡ | ⭐⭐⭐⭐ |
| mistral | 7GB | 8GB | ⚡⚡ | ⭐⭐⭐⭐ |
| llama3.1 | 42GB | 32GB | ⚡ | ⭐⭐⭐⭐⭐ |

---

**Still need help?** Contact the Zoppler engineering team or IT support.
