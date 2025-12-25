# 🎯 Zoppler Radar AI - Run Options

## 🚀 Quick Start (Choose One Method)

### ⭐ Option 1: Ultra Simple (RECOMMENDED)
```bash
./launch
```
**What it does:** Runs everything automatically in one command!

---

### ⭐ Option 2: Enhanced Full Script
```bash
./run.sh
```
**What it does:**
- ✅ Checks/installs Ollama
- ✅ Downloads AI models automatically
- ✅ Creates virtual environment
- ✅ Installs all dependencies
- ✅ Starts the application
- ✅ Colored output with progress indicators

---

### Option 3: Original Script
```bash
./start.sh
```
**What it does:** Original streamlined startup script

---

### Option 4: Windows Users
```bash
start.bat
```
**What it does:** Windows version of the startup script

---

### Option 5: Docker
```bash
docker-compose up
```
**What it does:** Runs in isolated Docker container

---

### Option 6: Manual (For Development)
```bash
# Terminal 1: Start Ollama
ollama serve

# Terminal 2: Start Application
source venv/bin/activate
python app.py
```

---

## 📊 Comparison

| Method | Ease | Auto-Install | Best For |
|--------|------|--------------|----------|
| `./launch` | ⭐⭐⭐⭐⭐ | Yes | **Everyone** |
| `./run.sh` | ⭐⭐⭐⭐⭐ | Yes | **First-time users** |
| `./start.sh` | ⭐⭐⭐⭐ | Partial | Quick restarts |
| `start.bat` | ⭐⭐⭐⭐ | Partial | Windows users |
| `docker-compose` | ⭐⭐⭐ | Yes | Production |
| Manual | ⭐⭐ | No | Development |

---

## 🎬 First Time Setup

### Absolute Beginner? Run This:
```bash
# Make scripts executable
chmod +x launch run.sh start.sh

# Run the enhanced script
./run.sh
```

The script will:
1. Check your Python version
2. Install Ollama (if needed)
3. Download AI model (~7GB, ~5-10 min)
4. Setup everything automatically
5. Start the application

**Access at: http://localhost:8000**

---

## ⚡ Subsequent Runs

After first setup, just run:
```bash
./launch
```

It takes only **3-5 seconds** to start!

---

## 🛠️ What Each Script Contains

### `run.sh` (NEW - Enhanced)
- Full system checks
- Automatic Ollama installation
- Model management
- Virtual environment setup
- Dependency installation
- Colored output with emojis
- Error handling
- ~250 lines of robust automation

### `start.sh` (Original)
- Basic checks
- Quick setup
- Assumes Ollama installed
- ~65 lines of streamlined code

### `launch` (Ultra Simple)
- Just calls `run.sh`
- 2 lines - the simplest option!

---

## 📦 What Gets Installed

### First Run (~5-10 minutes):
1. **Ollama** (if not installed) - Local LLM runtime
2. **AI Model** (llama3.2) - ~7GB download
3. **Python Dependencies**:
   - FastAPI (web framework)
   - Uvicorn (web server)
   - httpx (HTTP client)
   - pydantic (data validation)

### Disk Space Needed:
- AI Model: ~7GB
- Python Dependencies: ~200MB
- Application Code: ~100KB
- **Total: ~7.5GB**

---

## 🔧 Configuration

All configuration in `.env` file:

```bash
# Ollama Settings
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=llama3.2

# Server Settings
HOST=0.0.0.0
PORT=8000
ENVIRONMENT=production
```

### Change AI Model:
```bash
# Edit .env
OLLAMA_MODEL=mistral  # or phi3, llama3.1, codellama

# Pull the model
ollama pull mistral

# Restart application
./launch
```

---

## 🚨 Troubleshooting

### Script Won't Run
```bash
chmod +x launch run.sh start.sh
```

### Ollama Already Running
Just run `./launch` - it will detect and use it

### Different Port Needed
```bash
# Edit .env
PORT=8080

# Restart
./launch
```

### Want to Start Fresh
```bash
# Remove virtual environment
rm -rf venv

# Remove config
rm .env

# Run setup again
./run.sh
```

---

## 🎯 Recommended Workflow

### For First Time:
```bash
./run.sh
```
*Handles everything including installation*

### For Daily Use:
```bash
./launch
```
*Fastest startup*

### For Development:
```bash
# Terminal 1
ollama serve

# Terminal 2
source venv/bin/activate
python app.py
```
*Manual control for debugging*

---

## 📝 Script Locations

```
/workspace/
├── launch          ← 🌟 Simplest (run this!)
├── run.sh          ← 🚀 Full automation
├── start.sh        ← ⚡ Original quick start
├── start.bat       ← 🪟 Windows version
└── docker-compose.yml ← 🐳 Docker option
```

---

## 💡 Pro Tips

1. **First time?** Use `./run.sh` for full automation
2. **Daily use?** Use `./launch` for speed
3. **Development?** Use manual method with 2 terminals
4. **Production?** Use Docker with `docker-compose up`
5. **Different model?** Edit `.env` and restart

---

## 🆘 Need Help?

1. Check **QUICK_RUN.md** - Simple instructions
2. Check **README.md** - Full documentation
3. Check **LOCAL_LLM_SETUP.md** - Ollama details
4. Run with verbose output: `bash -x ./run.sh`

---

## ✅ Quick Checklist

Before running for the first time:

- [ ] Python 3.11+ installed
- [ ] 8GB+ RAM available
- [ ] 10GB+ free disk space
- [ ] Internet connection (first time only)
- [ ] Made scripts executable: `chmod +x launch run.sh start.sh`

Then just run: `./launch`

---

**🎉 That's it! Your AI chatbot will be running at http://localhost:8000**

Choose the method that works best for you:
- **Easiest:** `./launch`
- **Most robust:** `./run.sh`
- **Original:** `./start.sh`
