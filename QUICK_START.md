# 🚀 Quick Start Guide - Zoppler Radar AI

Get up and running in 5 minutes!

## Prerequisites

- Python 3.11 or higher
- Anthropic API key ([Get one here](https://console.anthropic.com/))

## Setup Steps

### 1️⃣ Clone & Navigate
```bash
cd zoppler-radar-ai
```

### 2️⃣ Configure API Key
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and add your API key
# ANTHROPIC_API_KEY=your_actual_api_key_here
```

### 3️⃣ Run the Application

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
docker-compose up -d
```

### 4️⃣ Access the Chatbot
Open your browser to: **http://localhost:8000**

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
| "API key not configured" | Check `.env` file has valid `ANTHROPIC_API_KEY` |
| Port 8000 in use | Change `PORT=8080` in `.env` |
| Module not found | Activate virtual environment: `source venv/bin/activate` |
| Slow responses | Check API rate limits at console.anthropic.com |

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Customize the system prompt in `app.py`
- Adjust styling in `static/styles.css`
- Deploy to production using Docker

## Need Help?

- 📚 Check [README.md](README.md) for comprehensive docs
- 🐛 Report issues to the engineering team
- 💬 Internal support: engineering@zoppler.systems

---

**Happy engineering! 🎯**
