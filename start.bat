@echo off
REM Zoppler Radar AI - Quick Start Script for Windows (Local LLM)

echo 🎯 Zoppler Radar AI - Starting (Local LLM)...
echo.

REM Check if Ollama is installed
where ollama >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Ollama not found. Please install Ollama first:
    echo    Download from: https://ollama.com/download
    echo.
    pause
    exit /b 1
)

REM Check if Ollama is running
curl -s http://localhost:11434/api/version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Ollama is not running. Please start Ollama first.
    echo    Open Ollama app or run 'ollama serve' in another terminal
    echo.
    pause
)

REM Check if a model is installed
ollama list | findstr /C:"llama" >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  No models found. Pulling llama3.2...
    echo    This may take a few minutes (7GB download)...
    ollama pull llama3.2
    echo ✅ Model downloaded
    echo.
)

REM Check if .env exists
if not exist .env (
    echo ⚠️  No .env file found. Creating from template...
    copy .env.example .env
    echo ✅ Created .env file
    echo    (Using default Ollama configuration)
    echo.
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
