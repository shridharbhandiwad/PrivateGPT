@echo off
REM Zoppler Radar AI - Quick Start Script for Windows

echo 🎯 Zoppler Radar AI - Starting...
echo.

REM Check if .env exists
if not exist .env (
    echo ⚠️  No .env file found. Creating from template...
    copy .env.example .env
    echo ✅ Created .env file
    echo.
    echo ⚠️  IMPORTANT: Please edit .env and add your ANTHROPIC_API_KEY
    echo    Get your API key from: https://console.anthropic.com/
    echo.
    pause
)

REM Check if virtual environment exists
if not exist venv (
    echo 📦 Creating virtual environment...
    python -m venv venv
    echo ✅ Virtual environment created
)

REM Activate virtual environment
echo 🔧 Activating virtual environment...
call venv\Scripts\activate.bat

REM Install/upgrade dependencies
echo 📥 Installing dependencies...
python -m pip install -q --upgrade pip
pip install -q -r requirements.txt
echo ✅ Dependencies installed

echo.
echo 🚀 Starting Zoppler Radar AI...
echo    Access the chatbot at: http://localhost:8000
echo    Press Ctrl+C to stop
echo.

REM Run the application
python app.py
