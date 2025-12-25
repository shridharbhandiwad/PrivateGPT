# 🚀 Quick Run Guide

## Single Command to Run Everything

### **Linux/Mac:**
```bash
./run.sh
```

### **Windows:**
```bash
start.bat
```

That's it! The script handles everything automatically:

✅ Checks Python installation  
✅ Installs/checks Ollama  
✅ Starts Ollama service  
✅ Downloads AI model (if needed)  
✅ Creates .env configuration  
✅ Sets up virtual environment  
✅ Installs dependencies  
✅ Starts the application  

## What the Script Does

```
┌─────────────────────────────────────┐
│  Step 1: Check Python (3.11+)      │
├─────────────────────────────────────┤
│  Step 2: Install/Check Ollama      │
├─────────────────────────────────────┤
│  Step 3: Start Ollama Service      │
├─────────────────────────────────────┤
│  Step 4: Download AI Model (~7GB)  │
├─────────────────────────────────────┤
│  Step 5: Create .env Config        │
├─────────────────────────────────────┤
│  Step 6: Setup Python venv         │
├─────────────────────────────────────┤
│  Step 7: Install Dependencies      │
├─────────────────────────────────────┤
│  Step 8: Verify Files              │
├─────────────────────────────────────┤
│  Step 9: Start Application         │
└─────────────────────────────────────┘
```

## Access the Application

Once started, open your browser to:

**🌐 http://localhost:8000**

## Stopping the Application

Press **Ctrl+C** in the terminal where the script is running.

## First Run

The **first time** you run the script, it will:
- Download the AI model (~7GB) - takes 5-10 minutes depending on your internet
- Install Python dependencies - takes 1-2 minutes
- Create necessary configuration files

**Subsequent runs** will be much faster (just a few seconds to start).

## Troubleshooting

### Permission Denied
```bash
chmod +x run.sh
./run.sh
```

### Port Already in Use
Edit `.env` and change:
```bash
PORT=8080  # Or any other free port
```

### Ollama Connection Issues
```bash
# Manually start Ollama
ollama serve

# In another terminal
./run.sh
```

### Model Not Found
```bash
# Manually pull a model
ollama pull llama3.2

# Then run
./run.sh
```

## Alternative Run Methods

### Method 1: Enhanced Script (Recommended)
```bash
./run.sh
```

### Method 2: Original Script
```bash
./start.sh
```

### Method 3: Docker
```bash
docker-compose up
```

### Method 4: Manual
```bash
# 1. Start Ollama
ollama serve

# 2. In another terminal
source venv/bin/activate
python app.py
```

## System Requirements

- **OS**: Linux, macOS, or Windows
- **Python**: 3.11 or higher
- **RAM**: 8GB minimum (16GB recommended)
- **Disk**: 10GB free space (for AI models)
- **Internet**: Required for initial setup only

## Choosing Different AI Models

Edit `.env` file:
```bash
OLLAMA_MODEL=llama3.2      # Default (7GB)
# OLLAMA_MODEL=mistral     # Alternative (7GB)
# OLLAMA_MODEL=phi3        # Smaller, faster (2GB)
# OLLAMA_MODEL=llama3.1    # Larger, better (42GB)
```

Then pull the model:
```bash
ollama pull mistral
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Script won't run | Run `chmod +x run.sh` first |
| Ollama not found | Script will install it automatically |
| Model download fails | Check internet connection |
| Python not found | Install Python 3.11+ |
| Out of memory | Use smaller model like `phi3` |
| Port conflict | Change PORT in `.env` file |

## Need Help?

- Check the full **README.md** for detailed documentation
- See **LOCAL_LLM_SETUP.md** for Ollama setup details
- View **TROUBLESHOOTING.md** for common issues (if available)

---

**💡 Tip**: The script is fully automated. Just run `./run.sh` and wait for the browser to open!
