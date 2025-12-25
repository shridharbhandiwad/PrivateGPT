# Setup Verification Guide 🔍

Quick guide to using the new setup verification and troubleshooting tools.

## Quick Start

### Before Running the Application

**Check if everything is set up correctly:**

**On Windows:**
```cmd
verify_setup.bat
```

**On Linux/macOS:**
```bash
./verify_setup.sh
```

### What Gets Checked

The verification script checks 11 critical requirements:

1. ✅ **Python 3.11+** - Required for running the application
2. ✅ **Ollama Installation** - Local LLM engine
3. ✅ **Ollama Service** - Must be running on port 11434
4. ✅ **AI Models** - At least one model installed
5. ✅ **Configuration** - .env file present
6. ✅ **Dependencies** - requirements.txt exists
7. ✅ **Virtual Environment** - Python venv setup
8. ✅ **Application Files** - app.py and static files
9. ✅ **Port Availability** - Port 8000 not in use
10. ✅ **System Resources** - Adequate RAM and disk space
11. ✅ **Internet** - For downloading models

### Understanding the Results

**✅ PASS (Green)** - Everything is working correctly  
**⚠️ WARNING (Yellow)** - Not critical, but should be addressed  
**❌ FAIL (Red)** - Must be fixed before running the application

## Example Output

### All Checks Pass
```
========================================
 Verification Summary
========================================

✅ Passed:   11
⚠️  Warnings: 0
❌ Failed:   0

╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     ✅ All checks passed! You're ready to go! 🎉     ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

To start the application:
  ./start.sh        (Linux/macOS)
  start.bat         (Windows)
```

### Issues Found
```
========================================
 Verification Summary
========================================

✅ Passed:   7
⚠️  Warnings: 1
❌ Failed:   3

╔═══════════════════════════════════════════════════════╗
║                                                       ║
║  ❌ Setup incomplete - Fix the errors above          ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

Recommended Actions:

1. Install Ollama:
   curl -fsSL https://ollama.com/install.sh | sh

2. Start Ollama service:
   ollama serve

3. Download a model:
   ollama pull llama3.2
```

## Enhanced Startup Scripts

The startup scripts (`start.sh` and `start.bat`) have been improved with:

### Auto-Detection & Auto-Fix
- ✅ Detects missing Ollama and offers to install
- ✅ Auto-starts Ollama if not running
- ✅ Auto-downloads models if missing
- ✅ Creates .env from template if needed
- ✅ Creates virtual environment automatically

### Better User Experience
- 🎯 Interactive prompts for installation
- 📊 Progress indicators for downloads
- ✅ Success/failure feedback for each step
- 🔄 Automatic retry for transient failures
- 📝 Clear next steps when issues occur

## Troubleshooting Resources

### 1. Quick Issues

**Ollama Not Found:**
```bash
# Windows
# Download from: https://ollama.com/download

# Linux
curl -fsSL https://ollama.com/install.sh | sh

# macOS
brew install ollama
```

**Ollama Not Running:**
```bash
ollama serve
```

**No Models:**
```bash
ollama pull llama3.2
```

### 2. Comprehensive Guide

For detailed troubleshooting, see **[OLLAMA_TROUBLESHOOTING.md](OLLAMA_TROUBLESHOOTING.md)**

This guide covers:
- ✅ Installation issues (all platforms)
- ✅ Connection problems
- ✅ Model download issues
- ✅ Performance optimization
- ✅ Platform-specific solutions
- ✅ Advanced troubleshooting

### 3. Documentation

- **[README.md](README.md)** - Main documentation and quick start
- **[LOCAL_LLM_SETUP.md](LOCAL_LLM_SETUP.md)** - Ollama setup guide
- **[OLLAMA_TROUBLESHOOTING.md](OLLAMA_TROUBLESHOOTING.md)** - Detailed troubleshooting
- **[OLLAMA_DEPENDENCY_CHECK_IMPROVEMENTS.md](OLLAMA_DEPENDENCY_CHECK_IMPROVEMENTS.md)** - Technical details of improvements

## Workflow

### Recommended Setup Process

```
1. Clone Repository
   ↓
2. Run Verification
   ./verify_setup.sh (or .bat)
   ↓
3. Fix Any Issues
   Follow recommendations
   ↓
4. Re-run Verification
   Confirm all checks pass
   ↓
5. Start Application
   ./start.sh (or .bat)
   ↓
6. Access Chatbot
   http://localhost:8000
```

### First-Time Setup

```bash
# 1. Verify system
./verify_setup.sh

# 2. If Ollama not installed, install it
curl -fsSL https://ollama.com/install.sh | sh  # Linux

# 3. Start Ollama
ollama serve &

# 4. Download model
ollama pull llama3.2

# 5. Verify again
./verify_setup.sh

# 6. Start application
./start.sh
```

### Troubleshooting Workflow

```
Issue Occurs
   ↓
Run Verification Script
   ↓
Review Failed Checks
   ↓
Check Troubleshooting Guide
   ↓
Apply Solution
   ↓
Re-run Verification
   ↓
Success! ✅
```

## What's New

### New Files
- ✅ `verify_setup.sh` - Unix verification script
- ✅ `verify_setup.bat` - Windows verification script
- ✅ `OLLAMA_TROUBLESHOOTING.md` - Comprehensive troubleshooting
- ✅ `OLLAMA_DEPENDENCY_CHECK_IMPROVEMENTS.md` - Technical documentation
- ✅ `SETUP_VERIFICATION_GUIDE.md` - This guide

### Enhanced Files
- ✅ `start.sh` - Interactive installation, auto-start service
- ✅ `start.bat` - Auto-open download page, auto-start service
- ✅ `README.md` - Added verification section
- ✅ `LOCAL_LLM_SETUP.md` - Added verification references

## Tips

### 🎯 Pro Tips

1. **Always run verification first** - Saves time by catching issues early
2. **Keep verification output** - Helpful for support tickets
3. **Check after updates** - Verify after system updates or changes
4. **Use in CI/CD** - Integrate verification in deployment pipelines
5. **Regular health checks** - Run periodically to catch issues

### 🚀 Power User

```bash
# One-liner setup check
./verify_setup.sh && ./start.sh

# Save verification output
./verify_setup.sh > setup_status.txt

# Check specific issues
./verify_setup.sh | grep "FAIL"

# Silent verification (exit code only)
./verify_setup.sh > /dev/null 2>&1 && echo "OK" || echo "ISSUES"
```

### 🔧 Developer

```bash
# Quick status check
curl http://localhost:11434/api/version

# List models
ollama list

# Test model
ollama run llama3.2 "test"

# Check port
lsof -i :8000  # Unix
netstat -ano | findstr :8000  # Windows
```

## Support

### Self-Service
1. Run `./verify_setup.sh` or `verify_setup.bat`
2. Check `OLLAMA_TROUBLESHOOTING.md`
3. Review `README.md`

### Need Help?
Include verification output when requesting support:
```bash
./verify_setup.sh > my_setup_status.txt
# Attach my_setup_status.txt to support request
```

## Version Info

**Release:** Ollama Dependency Check Improvements  
**Branch:** cursor/ollama-dependency-check-2695  
**Date:** December 25, 2025  
**Status:** ✅ Production Ready

---

**Happy Building! 🎯**

*For questions or issues, see the troubleshooting guide or contact support.*
