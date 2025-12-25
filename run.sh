#!/bin/bash

# ========================================
# Zoppler Radar AI - Complete Setup & Run Script
# ========================================
# This script handles EVERYTHING needed to run the application:
# - System checks
# - Ollama installation and setup
# - Python environment
# - Dependencies
# - Application startup
# ========================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ========================================
# STEP 1: Check Python Installation
# ========================================
print_header "Step 1: Checking Python Installation"

if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed!"
    print_info "Please install Python 3.11+ from: https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | grep -oP '\d+\.\d+' | head -1)
REQUIRED_VERSION="3.11"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    print_warning "Python $PYTHON_VERSION detected. Python 3.11+ is recommended."
else
    print_success "Python $PYTHON_VERSION detected"
fi

# ========================================
# STEP 2: Check/Install Ollama
# ========================================
print_header "Step 2: Checking Ollama Installation"

if ! command -v ollama &> /dev/null; then
    print_warning "Ollama not found. Installing Ollama..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Installing Ollama on Linux..."
        curl -fsSL https://ollama.com/install.sh | sh
        print_success "Ollama installed successfully"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            print_info "Installing Ollama via Homebrew..."
            brew install ollama
            print_success "Ollama installed successfully"
        else
            print_error "Please install Ollama manually from: https://ollama.com/download"
            exit 1
        fi
    else
        print_error "Please install Ollama manually from: https://ollama.com/download"
        exit 1
    fi
else
    print_success "Ollama is installed"
fi

# ========================================
# STEP 3: Start Ollama Service
# ========================================
print_header "Step 3: Ensuring Ollama is Running"

# Check if Ollama is already running
if curl -s http://localhost:11434/api/version &> /dev/null; then
    OLLAMA_VERSION=$(curl -s http://localhost:11434/api/version | grep -oP '"version":"\K[^"]+' || echo "unknown")
    print_success "Ollama is running (version: $OLLAMA_VERSION)"
else
    print_warning "Ollama is not running. Starting Ollama service..."
    
    # Try to start Ollama in background
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # On macOS, Ollama runs as an app
        open -a Ollama 2>/dev/null || {
            print_info "Starting Ollama serve in background..."
            nohup ollama serve > /tmp/ollama.log 2>&1 &
            sleep 3
        }
    else
        # On Linux, start as background service
        print_info "Starting Ollama serve in background..."
        nohup ollama serve > /tmp/ollama.log 2>&1 &
        OLLAMA_PID=$!
        sleep 3
        
        # Verify it started
        if curl -s http://localhost:11434/api/version &> /dev/null; then
            print_success "Ollama started successfully (PID: $OLLAMA_PID)"
        else
            print_error "Failed to start Ollama. Check /tmp/ollama.log for details"
            exit 1
        fi
    fi
fi

# ========================================
# STEP 4: Check/Pull AI Model
# ========================================
print_header "Step 4: Checking AI Model"

# Determine which model to use
if [ -f .env ]; then
    MODEL=$(grep OLLAMA_MODEL .env | cut -d '=' -f2 | tr -d ' ' || echo "llama3.2")
else
    MODEL="llama3.2"
fi

print_info "Checking for model: $MODEL"

if ollama list | grep -q "$MODEL"; then
    print_success "Model '$MODEL' is available"
else
    print_warning "Model '$MODEL' not found. Downloading..."
    print_info "This may take several minutes (model size: ~7GB)"
    
    if ollama pull "$MODEL"; then
        print_success "Model '$MODEL' downloaded successfully"
    else
        print_error "Failed to download model. Please check your internet connection."
        exit 1
    fi
fi

# ========================================
# STEP 5: Setup Environment File
# ========================================
print_header "Step 5: Configuring Environment"

if [ ! -f .env ]; then
    print_warning "No .env file found. Creating from template..."
    
    if [ -f .env.example ]; then
        cp .env.example .env
        print_success "Created .env file from template"
    else
        print_info "Creating default .env file..."
        cat > .env << EOF
# Zoppler Radar AI Configuration
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=llama3.2
HOST=0.0.0.0
PORT=8000
ENVIRONMENT=production
EOF
        print_success "Created default .env file"
    fi
else
    print_success ".env file already exists"
fi

# ========================================
# STEP 6: Setup Python Virtual Environment
# ========================================
print_header "Step 6: Setting Up Python Environment"

if [ ! -d "venv" ]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"
else
    print_success "Virtual environment already exists"
fi

# Activate virtual environment
print_info "Activating virtual environment..."
source venv/bin/activate
print_success "Virtual environment activated"

# ========================================
# STEP 7: Install Dependencies
# ========================================
print_header "Step 7: Installing Dependencies"

print_info "Upgrading pip..."
pip install --quiet --upgrade pip

if [ -f requirements.txt ]; then
    print_info "Installing Python packages..."
    pip install --quiet -r requirements.txt
    print_success "Dependencies installed successfully"
else
    print_error "requirements.txt not found!"
    exit 1
fi

# ========================================
# STEP 8: Verify Application Files
# ========================================
print_header "Step 8: Verifying Application Files"

REQUIRED_FILES=("app.py" "static/index.html" "static/script.js" "static/styles.css")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Found: $file"
    else
        print_error "Missing: $file"
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    print_error "Missing required files. Cannot start application."
    exit 1
fi

# ========================================
# STEP 9: Start Application
# ========================================
print_header "Step 9: Starting Zoppler Radar AI"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║         🎯 Zoppler Radar AI is Starting...          ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📊 Configuration:${NC}"
echo -e "   • Model: $MODEL"
echo -e "   • Ollama: http://localhost:11434"
echo -e "   • Application: http://localhost:8000"
echo ""
echo -e "${YELLOW}🌐 Access your chatbot at: ${GREEN}http://localhost:8000${NC}"
echo ""
echo -e "${BLUE}Press Ctrl+C to stop the server${NC}"
echo ""
echo -e "${BLUE}========================================${NC}\n"

# Run the application
python app.py

# ========================================
# Cleanup (if script is interrupted)
# ========================================
cleanup() {
    echo ""
    print_info "Shutting down..."
    
    # Deactivate virtual environment
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate 2>/dev/null || true
    fi
    
    print_success "Application stopped"
    exit 0
}

trap cleanup SIGINT SIGTERM
