@echo off
REM ========================================
REM Zoppler Radar AI - Setup Verification Script (Windows)
REM ========================================
REM This script checks if everything is properly configured
REM Run this before starting the application
REM ========================================

setlocal enabledelayedexpansion

set PASSED=0
set FAILED=0
set WARNINGS=0

echo.
echo ========================================
echo  Zoppler Radar AI - Setup Verification
echo ========================================
echo.
echo This script will verify your setup and identify any issues.
echo.

REM ========================================
REM Check 1: Python Installation
REM ========================================
echo [1/11] Checking Python 3.11+ installation...
where python >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
    echo   ✅ PASS - Python !PYTHON_VERSION! detected
    set /a PASSED+=1
) else (
    echo   ❌ FAIL - Python not found
    echo      Install from: https://www.python.org/downloads/
    set /a FAILED+=1
)

REM ========================================
REM Check 2: Ollama Installation
REM ========================================
echo [2/11] Checking Ollama installation...
where ollama >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ PASS - Ollama is installed
    set /a PASSED+=1
    for /f "tokens=*" %%i in ('ollama --version 2^>^&1') do (
        echo      Version: %%i
        goto :ollama_version_done
    )
    :ollama_version_done
) else (
    echo   ❌ FAIL - Ollama not found
    echo      Install from: https://ollama.com/download
    echo      See OLLAMA_TROUBLESHOOTING.md for help
    set /a FAILED+=1
)

REM ========================================
REM Check 3: Ollama Service Running
REM ========================================
echo [3/11] Checking Ollama service status...
curl -s http://localhost:11434/api/version >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ PASS - Ollama service is running
    set /a PASSED+=1
) else (
    echo   ❌ FAIL - Ollama service not running
    echo      Start Ollama app or run: ollama serve
    echo      See OLLAMA_TROUBLESHOOTING.md for help
    set /a FAILED+=1
)

REM ========================================
REM Check 4: Ollama Models
REM ========================================
echo [4/11] Checking Ollama models installed...
where ollama >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    ollama list >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo   ✅ PASS - Models found
        set /a PASSED+=1
        echo      Installed models:
        for /f "skip=1 tokens=1" %%m in ('ollama list 2^>nul') do (
            echo        • %%m
        )
        
        REM Check for recommended model
        ollama list | findstr /C:"llama3.2" >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            echo      ✨ Recommended model llama3.2 is installed
        ) else (
            echo      ⚠️  WARNING: Recommended model llama3.2 not found
            echo      Install with: ollama pull llama3.2
            set /a WARNINGS+=1
        )
    ) else (
        echo   ❌ FAIL - No models installed
        echo      Pull a model: ollama pull llama3.2
        set /a FAILED+=1
    )
) else (
    echo   ❌ FAIL - Cannot check models (Ollama not installed)
    set /a FAILED+=1
)

REM ========================================
REM Check 5: Environment File
REM ========================================
echo [5/11] Checking .env configuration file...
if exist .env (
    echo   ✅ PASS - .env file exists
    set /a PASSED+=1
    
    findstr "OLLAMA_HOST" .env >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        for /f "tokens=2 delims==" %%a in ('findstr "OLLAMA_HOST" .env') do echo      OLLAMA_HOST: %%a
    )
    
    findstr "OLLAMA_MODEL" .env >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        for /f "tokens=2 delims==" %%a in ('findstr "OLLAMA_MODEL" .env') do echo      OLLAMA_MODEL: %%a
    )
) else (
    echo   ⚠️  WARNING - .env file not found
    echo      Will be created from .env.example on first run
    set /a WARNINGS+=1
    
    if exist .env.example (
        echo      Template file exists
    ) else (
        echo      ❌ FAIL - .env.example template missing
        set /a FAILED+=1
    )
)

REM ========================================
REM Check 6: Python Dependencies
REM ========================================
echo [6/11] Checking Python dependencies...
if exist requirements.txt (
    echo   ✅ PASS - requirements.txt found
    set /a PASSED+=1
) else (
    echo   ❌ FAIL - requirements.txt not found
    set /a FAILED+=1
)

REM ========================================
REM Check 7: Virtual Environment
REM ========================================
echo [7/11] Checking Python virtual environment...
if exist venv (
    echo   ✅ PASS - Virtual environment exists at .\venv
    set /a PASSED+=1
    
    if exist venv\Scripts\pip.exe (
        echo      pip is available in venv
    )
) else (
    echo   ⚠️  WARNING - Virtual environment not found
    echo      Will be created on first run
    echo      Or create now: python -m venv venv
    set /a WARNINGS+=1
)

REM ========================================
REM Check 8: Application Files
REM ========================================
echo [8/11] Checking application files...
if exist app.py (
    echo   ✅ PASS - app.py found
    set /a PASSED+=1
) else (
    echo   ❌ FAIL - app.py not found
    set /a FAILED+=1
)

echo [8/11] Checking static files...
if exist static\index.html (
    if exist static\script.js (
        if exist static\styles.css (
            echo   ✅ PASS - All static files present
            set /a PASSED+=1
        ) else (
            echo   ❌ FAIL - static\styles.css missing
            set /a FAILED+=1
        )
    ) else (
        echo   ❌ FAIL - static\script.js missing
        set /a FAILED+=1
    )
) else (
    echo   ❌ FAIL - static\index.html missing
    set /a FAILED+=1
)

REM ========================================
REM Check 9: Port Availability
REM ========================================
echo [9/11] Checking Port 8000 availability...
netstat -ano | findstr ":8000" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ⚠️  WARNING - Port 8000 is already in use
    echo      Change PORT in .env or stop the service using port 8000
    set /a WARNINGS+=1
) else (
    echo   ✅ PASS - Port 8000 is available
    set /a PASSED+=1
)

REM ========================================
REM Check 10: System Resources
REM ========================================
echo [10/11] Checking system resources...
echo   ℹ️  Check Task Manager for available RAM
echo      Recommended: 8GB+ available RAM
set /a PASSED+=1

REM ========================================
REM Check 11: Network Connectivity
REM ========================================
echo [11/11] Checking Internet connectivity...
curl -s --max-time 5 https://ollama.com >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo   ✅ PASS - Can reach ollama.com for model downloads
    set /a PASSED+=1
) else (
    echo   ⚠️  WARNING - Cannot reach ollama.com
    echo      Internet needed for downloading models
    echo      If models are already downloaded, this is okay
    set /a WARNINGS+=1
)

REM ========================================
REM Summary
REM ========================================
echo.
echo ========================================
echo  Verification Summary
echo ========================================
echo.
echo ✅ Passed:   !PASSED!
echo ⚠️  Warnings: !WARNINGS!
echo ❌ Failed:   !FAILED!
echo.

if !FAILED! EQU 0 (
    if !WARNINGS! EQU 0 (
        echo ╔═══════════════════════════════════════════════════════╗
        echo ║                                                       ║
        echo ║     ✅ All checks passed! You're ready to go! 🎉     ║
        echo ║                                                       ║
        echo ╚═══════════════════════════════════════════════════════╝
        echo.
        echo To start the application:
        echo   start.bat         (Recommended)
        echo   python app.py     (Direct)
        echo.
    ) else (
        echo ╔═══════════════════════════════════════════════════════╗
        echo ║                                                       ║
        echo ║  ⚠️  Setup complete with warnings                    ║
        echo ║                                                       ║
        echo ╚═══════════════════════════════════════════════════════╝
        echo.
        echo You can proceed, but review the warnings above.
        echo.
        echo To start the application:
        echo   start.bat
        echo.
    )
) else (
    echo ╔═══════════════════════════════════════════════════════╗
    echo ║                                                       ║
    echo ║  ❌ Setup incomplete - Fix the errors above          ║
    echo ║                                                       ║
    echo ╚═══════════════════════════════════════════════════════╝
    echo.
    echo Please address the failed checks before starting.
    echo.
    echo For help, see:
    echo   • OLLAMA_TROUBLESHOOTING.md - Detailed troubleshooting guide
    echo   • README.md - Installation instructions
    echo   • LOCAL_LLM_SETUP.md - Ollama setup guide
    echo.
)

REM ========================================
REM Next Steps Recommendations
REM ========================================
if !FAILED! GTR 0 (
    echo ========================================
    echo  Recommended Actions
    echo ========================================
    echo.
    
    where ollama >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo 1. Install Ollama:
        echo    Download from: https://ollama.com/download
        echo.
    )
    
    where ollama >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        curl -s http://localhost:11434/api/version >nul 2>nul
        if %ERRORLEVEL% NEQ 0 (
            echo 2. Start Ollama service:
            echo    - Open Ollama app from Start Menu, OR
            echo    - Run: ollama serve
            echo.
        )
        
        ollama list >nul 2>nul
        if %ERRORLEVEL% NEQ 0 (
            echo 3. Download a model:
            echo    ollama pull llama3.2  (recommended, 7GB)
            echo    ollama pull phi3       (smaller, 2GB)
            echo.
        )
    )
    
    echo For detailed help:
    echo   type OLLAMA_TROUBLESHOOTING.md
    echo.
)

echo ========================================
echo.

REM Exit with appropriate code
if !FAILED! GTR 0 (
    pause
    exit /b 1
) else (
    pause
    exit /b 0
)
