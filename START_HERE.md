# 🎯 START HERE - Zoppler Radar AI

## Run Your Application in ONE Command!

### Linux/Mac Users:
```bash
./launch
```

### Windows Users:
```bash
start.bat
```

---

## 🚀 What Happens When You Run It?

The script automatically:
1. ✅ Checks system requirements
2. ✅ Installs Ollama (if needed)
3. ✅ Downloads AI model (~7GB on first run)
4. ✅ Creates Python environment
5. ✅ Installs dependencies
6. ✅ Starts the chatbot

**Access at: http://localhost:8000**

---

## ⏱️ How Long Does It Take?

### First Time Run:
- **5-10 minutes** (downloading AI model)

### Subsequent Runs:
- **3-5 seconds** (everything is cached!)

---

## 📖 Available Scripts

| Script | Description | Use When |
|--------|-------------|----------|
| `./launch` | Simplest option | **Daily use** ⭐ |
| `./run.sh` | Full automation | **First time** ⭐ |
| `./start.sh` | Original quick start | Quick restarts |
| `start.bat` | Windows version | Windows users |

---

## 🎬 Quick Start Guide

### Step 1: Make Scripts Executable (First Time Only)
```bash
chmod +x launch run.sh start.sh
```

### Step 2: Run the Application
```bash
./launch
```

### Step 3: Open Browser
Navigate to: **http://localhost:8000**

### Step 4: Start Chatting!
Ask questions about radar systems, signal processing, or defense technology.

---

## 🛠️ Need More Info?

- **QUICK_RUN.md** - Simple getting started guide
- **RUN_OPTIONS.md** - All available run methods
- **README.md** - Complete documentation
- **LOCAL_LLM_SETUP.md** - Ollama configuration details

---

## 🚨 Troubleshooting

### "Permission denied"
```bash
chmod +x launch
./launch
```

### Port already in use
```bash
# Edit .env file
PORT=8080  # Change to any free port
```

### Need help?
Run the enhanced script for detailed output:
```bash
./run.sh
```

---

## 💡 Pro Tip

For the **absolute easiest** experience:

```bash
# First time (handles everything):
./run.sh

# Every other time:
./launch
```

---

## ✅ System Requirements

- Python 3.11+
- 8GB RAM (16GB recommended)
- 10GB free disk space
- Internet (first run only)

---

**🎉 You're all set! Just run `./launch` and start coding!**

Questions about radar engineering? Your AI assistant is ready to help! 🎯
