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
    echo    After installation:
    echo    1. Install Ollama from the link above
    echo    2. Restart this script
    echo    3. Ollama will automatically start on Windows
    echo.
    set /p "OPEN_URL=Would you like to open the download page? (y/n): "
    if /i "%OPEN_URL%"=="y" start https://ollama.com/download
    echo.
    pause
    exit /b 1
)

REM Check if Ollama is running
echo 🔍 Checking if Ollama service is running...
curl -s http://localhost:11434/api/version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Ollama is not running. Attempting to start Ollama...
    echo.
    
    REM Try to start Ollama service
    start /B ollama serve >nul 2>nul
    
    REM Wait a few seconds for Ollama to start
    echo    Waiting for Ollama to start...
    timeout /t 5 /nobreak >nul
    
    REM Check again
    curl -s http://localhost:11434/api/version >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to start Ollama automatically.
        echo    Please start Ollama manually:
        echo    - Open the Ollama app from Start menu, OR
        echo    - Run 'ollama serve' in another terminal
        echo.
        pause
        exit /b 1
    ) else (
        echo ✅ Ollama started successfully!
        echo.
    )
) else (
    echo ✅ Ollama is running
    echo.
)

REM Check if a model is installed
echo 🔍 Checking for available models...
ollama list 2>nul | findstr /C:"llama" >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  No Llama models found. Pulling llama3.2...
    echo    This may take a few minutes (~7GB download^)...
    echo    You can grab a coffee while this downloads ☕
    echo.
    ollama pull llama3.2
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Model downloaded successfully!
        echo.
    ) else (
        echo ❌ Failed to download model. Please check your internet connection.
        echo    You can try manually: ollama pull llama3.2
        echo.
        pause
        exit /b 1
    )
) else (
    echo ✅ Llama model found
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
