# Local LLM Setup Guide 🚀

This guide will help you set up Zoppler Radar AI to run completely offline using Ollama.

## Quick Start (5 minutes)

### 1. Install Ollama

**Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

**macOS:**
```bash
brew install ollama
```

**Windows:**
Download from [ollama.com/download](https://ollama.com/download)

### 2. Start Ollama Service

```bash
ollama serve
```

This will start Ollama on `http://localhost:11434`

### 3. Download a Model

In a new terminal:
```bash
# Recommended: Fast and capable (7GB)
ollama pull llama3.2

# OR for faster responses on limited hardware (2GB)
ollama pull phi3

# OR for best quality if you have GPU (42GB)
ollama pull llama3.1
```

### 4. Set Up the Application

```bash
# Clone and enter directory
cd zoppler-radar-ai

# Create Python virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Run the application
python app.py
```

### 5. Access the Chatbot

Open your browser to: **http://localhost:8000**

That's it! Your AI assistant is now running 100% locally! 🎉

## Model Comparison

| Model | RAM | Speed | Quality | Use Case |
|-------|-----|-------|---------|----------|
| phi3 | 2GB | ⚡⚡⚡ | ⭐⭐⭐ | Limited resources, fast responses |
| llama3.2 | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | **Best balance** - Recommended |
| mistral | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | Alternative to llama3.2 |
| codellama | 7GB | ⚡⚡ | ⭐⭐⭐⭐ | Code-heavy radar software tasks |
| llama3.1 | 42GB | ⚡ | ⭐⭐⭐⭐⭐ | Best quality, needs powerful GPU |

## Switching Models

```bash
# Pull new model
ollama pull mistral

# Update .env file
echo "OLLAMA_MODEL=mistral" >> .env

# Restart application
python app.py
```

## Verifying Ollama Installation

```bash
# Check if Ollama is running
curl http://localhost:11434/api/version

# List installed models
ollama list

# Test a model
ollama run llama3.2 "Hello, test response"
```

## Performance Tips

### For Best Speed
1. Use smaller models: `phi3` or `mistral`
2. Ensure Ollama has GPU access (auto-detected)
3. Close other memory-intensive applications
4. Use SSD for model storage

### For Best Quality
1. Use larger models: `llama3.1` or `llama3.2`
2. Ensure adequate RAM (16GB+ recommended)
3. Use GPU if available (dramatically faster)
4. Allow longer response timeout

## GPU Acceleration

Ollama automatically uses GPU if available:

**NVIDIA GPU (CUDA):**
- Linux: Should work automatically
- Windows: Install CUDA drivers
- Check: `nvidia-smi` should show GPU usage when running

**Apple Silicon (M1/M2/M3):**
- Automatically uses Metal acceleration
- Best performance with 16GB+ unified memory

**AMD GPU (ROCm):**
- Supported on Linux
- See Ollama documentation for setup

## Troubleshooting

### "Cannot connect to Ollama"
```bash
# Check if Ollama is running
curl http://localhost:11434/api/version

# If not, start it
ollama serve
```

### Slow Responses
```bash
# Try smaller model
ollama pull phi3

# Update .env
OLLAMA_MODEL=phi3
```

### Out of Memory
```bash
# Use smallest model
ollama pull phi3

# Or stop other applications
# Check memory: free -h (Linux) or Activity Monitor (Mac)
```

### Model Not Found
```bash
# List available models
ollama list

# Pull the model you want
ollama pull llama3.2

# Verify it's downloaded
ollama list
```

## Advanced Configuration

### Custom Ollama Host
If Ollama is running on another machine:

```bash
# In .env
OLLAMA_HOST=http://192.168.1.100:11434
```

### Model Parameters
Edit `app.py` to customize model behavior:

```python
# In the chat endpoint, add parameters:
"model": ollama_model,
"messages": full_messages,
"stream": True,
"options": {
    "temperature": 0.7,  # Lower = more focused, Higher = more creative
    "top_p": 0.9,        # Nucleus sampling
    "num_predict": 4096, # Max tokens to generate
}
```

## Benefits of Local LLM

✅ **Complete Privacy** - All conversations stay on your machine  
✅ **No API Costs** - Zero usage fees  
✅ **Offline Operation** - No internet required  
✅ **No Rate Limits** - Use as much as you want  
✅ **Full Control** - Customize model and parameters  
✅ **Fast Responses** - No network latency  
✅ **Data Security** - Sensitive radar data never leaves your network  

## Getting Help

If you encounter issues:

1. Check Ollama logs: `journalctl -u ollama` (Linux) or Ollama app (Mac/Windows)
2. Verify model is downloaded: `ollama list`
3. Test model directly: `ollama run llama3.2 "test"`
4. Check application logs when running `python app.py`

## Next Steps

- Try different models to find the best fit
- Customize the system prompt in `app.py`
- Add your own radar documentation for RAG (future feature)
- Deploy to internal server for team access

---

**Enjoy your private, offline AI assistant! 🎯**
