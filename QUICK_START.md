# 🚀 Quick Start Guide - Zoppler Radar AI

Get up and running with **100% local AI** in 5 minutes - no API keys needed!

## Prerequisites

- Python 3.11 or higher
- 8GB+ RAM (16GB+ recommended)
- Ollama (we'll install this)

## Setup Steps

### 1️⃣ Install Ollama

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

### 2️⃣ Start Ollama & Download Model
```bash
# Start Ollama service
ollama serve

# In another terminal, pull a model
ollama pull llama3.2  # Recommended (7GB)
# OR: ollama pull phi3  # Smaller/faster (2GB)
```

### 3️⃣ Configure Application
```bash
cd zoppler-radar-ai

# Copy the example environment file
cp .env.example .env

# Default settings work out of the box!
# Optionally edit .env to change model or host
```

### 4️⃣ Run the Application

**Option A: Using Quick Start Script (Easiest)**
```bash
# Linux/Mac
./start.sh

# Windows
start.bat
```

**Option B: Manual Setup**
```bash
# Create virtual environment
python -m venv venv

# Activate it
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Run the app
python app.py
```

**Option C: Using Docker**
```bash
# Ensure Ollama is running on host first!
docker-compose up -d
```

### 5️⃣ Access the Chatbot
Open your browser to: **http://localhost:8000**

🎉 **You're now running a fully local AI assistant!**

## First Questions to Try

### Radar Fundamentals
```
"Explain the difference between FMCW and pulse-Doppler radar"
```

### Signal Processing
```
"Design a 2D FFT processing chain for a 77 GHz automotive radar"
```

### Defence Systems
```
"What are the key ECCM techniques for modern surveillance radars?"
```

### Machine Learning
```
"How can I use CNNs for radar target classification?"
```

### System Architecture
```
"Design a microservices architecture for real-time radar data processing"
```

## Stopping the Application

- **Local**: Press `Ctrl+C` in the terminal
- **Docker**: Run `docker-compose down`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Cannot connect to Ollama" | Ensure Ollama is running: `ollama serve` |
| "Model not found" | Pull the model: `ollama pull llama3.2` |
| Port 8000 in use | Change `PORT=8080` in `.env` |
| Module not found | Activate virtual environment: `source venv/bin/activate` |
| Slow responses | Try smaller model: `ollama pull phi3` and update `.env` |
| Out of memory | Use `phi3` model (2GB) instead of `llama3.2` (7GB) |

## Model Options

Switch between models for different needs:

```bash
# Fast responses on limited hardware
ollama pull phi3
echo "OLLAMA_MODEL=phi3" >> .env

# Best quality (needs more RAM/GPU)
ollama pull llama3.1
echo "OLLAMA_MODEL=llama3.1" >> .env

# Restart app to use new model
python app.py
```

## Why Local LLM?

✅ **Complete Privacy** - Data never leaves your machine  
✅ **Zero Costs** - No API fees or rate limits  
✅ **Works Offline** - No internet required  
✅ **Fast & Secure** - Perfect for sensitive radar data  

## Next Steps

- Read [LOCAL_LLM_SETUP.md](LOCAL_LLM_SETUP.md) for detailed Ollama guide
- Check full [README.md](README.md) for comprehensive documentation
- Customize the system prompt in `app.py`
- Try different models: `ollama list`

## Need Help?

- 📚 [LOCAL_LLM_SETUP.md](LOCAL_LLM_SETUP.md) - Detailed setup guide
- 📚 [README.md](README.md) - Complete documentation
- 🐛 Report issues to the engineering team
- 💬 Internal support: engineering@zoppler.systems

---

**Happy engineering with local AI! 🎯**
