#!/bin/bash

# ========================================
# Zoppler Radar AI - Setup Verification Script
# ========================================
# This script checks if everything is properly configured
# Run this before starting the application
# ========================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
WARNINGS=0

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_check() {
    echo -n "  Checking $1... "
}

print_pass() {
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASSED++))
}

print_fail() {
    echo -e "${RED}❌ FAIL${NC}"
    echo -e "${RED}     $1${NC}"
    ((FAILED++))
}

print_warning() {
    echo -e "${YELLOW}⚠️  WARNING${NC}"
    echo -e "${YELLOW}     $1${NC}"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}     ℹ️  $1${NC}"
}

print_header "Zoppler Radar AI - Setup Verification"

echo -e "${BLUE}This script will verify your setup and identify any issues.${NC}\n"

# ========================================
# Check 1: Python Installation
# ========================================
print_check "Python 3.11+ installation"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
    REQUIRED_VERSION="3.11"
    
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
        print_pass
        print_info "Python $PYTHON_VERSION detected"
    else
        print_warning "Python $PYTHON_VERSION detected (3.11+ recommended)"
        print_info "Application may still work but upgrade recommended"
    fi
else
    print_fail "Python 3 not found"
    print_info "Install from: https://www.python.org/downloads/"
fi

# ========================================
# Check 2: Ollama Installation
# ========================================
print_check "Ollama installation"
if command -v ollama &> /dev/null; then
    print_pass
    OLLAMA_VERSION=$(ollama --version 2>&1 || echo "unknown")
    print_info "Version: $OLLAMA_VERSION"
else
    print_fail "Ollama not found"
    print_info "Install from: https://ollama.com/download"
    print_info "See OLLAMA_TROUBLESHOOTING.md for help"
fi

# ========================================
# Check 3: Ollama Service Running
# ========================================
print_check "Ollama service status"
if curl -s http://localhost:11434/api/version &> /dev/null; then
    print_pass
    OLLAMA_API_VERSION=$(curl -s http://localhost:11434/api/version 2>&1 | grep -oP '"version":"\K[^"]+' || echo "unknown")
    print_info "API version: $OLLAMA_API_VERSION"
else
    print_fail "Ollama service not running"
    print_info "Start with: ollama serve"
    print_info "Or check OLLAMA_TROUBLESHOOTING.md"
fi

# ========================================
# Check 4: Ollama Models
# ========================================
print_check "Ollama models installed"
if command -v ollama &> /dev/null; then
    MODEL_COUNT=$(ollama list 2>/dev/null | tail -n +2 | wc -l)
    
    if [ "$MODEL_COUNT" -gt 0 ]; then
        print_pass
        print_info "Found $MODEL_COUNT model(s):"
        ollama list 2>/dev/null | tail -n +2 | while read -r line; do
            MODEL_NAME=$(echo "$line" | awk '{print $1}')
            print_info "  • $MODEL_NAME"
        done
        
        # Check for recommended models
        if ollama list 2>/dev/null | grep -q "llama3.2"; then
            print_info "✨ Recommended model llama3.2 is installed"
        else
            print_warning "Recommended model llama3.2 not found"
            print_info "Install with: ollama pull llama3.2"
        fi
    else
        print_fail "No models installed"
        print_info "Pull a model: ollama pull llama3.2"
    fi
else
    print_fail "Cannot check models (Ollama not installed)"
fi

# ========================================
# Check 5: Environment File
# ========================================
print_check ".env configuration file"
if [ -f ".env" ]; then
    print_pass
    
    # Check for key settings
    if grep -q "OLLAMA_HOST" .env; then
        OLLAMA_HOST=$(grep "OLLAMA_HOST" .env | cut -d'=' -f2 | tr -d ' ' | tr -d '"' | tr -d "'")
        print_info "OLLAMA_HOST: $OLLAMA_HOST"
    fi
    
    if grep -q "OLLAMA_MODEL" .env; then
        OLLAMA_MODEL=$(grep "OLLAMA_MODEL" .env | cut -d'=' -f2 | tr -d ' ' | tr -d '"' | tr -d "'")
        print_info "OLLAMA_MODEL: $OLLAMA_MODEL"
    fi
else
    print_warning ".env file not found"
    print_info "Will be created from .env.example on first run"
    
    if [ -f ".env.example" ]; then
        print_info "Template file exists"
    else
        print_fail ".env.example template missing"
    fi
fi

# ========================================
# Check 6: Python Dependencies
# ========================================
print_check "Python dependencies (requirements.txt)"
if [ -f "requirements.txt" ]; then
    print_pass
    print_info "requirements.txt found"
else
    print_fail "requirements.txt not found"
fi

# ========================================
# Check 7: Virtual Environment
# ========================================
print_check "Python virtual environment"
if [ -d "venv" ]; then
    print_pass
    print_info "Virtual environment exists at ./venv"
    
    # Check if dependencies are installed
    if [ -f "venv/bin/pip" ] || [ -f "venv/Scripts/pip.exe" ]; then
        print_info "pip is available in venv"
    fi
else
    print_warning "Virtual environment not found"
    print_info "Will be created on first run"
    print_info "Or create now: python3 -m venv venv"
fi

# ========================================
# Check 8: Application Files
# ========================================
print_check "Application files"
MISSING_FILES=()

if [ -f "app.py" ]; then
    print_pass
else
    print_fail "app.py not found"
    MISSING_FILES+=("app.py")
fi

print_check "Static files"
if [ -f "static/index.html" ] && [ -f "static/script.js" ] && [ -f "static/styles.css" ]; then
    print_pass
    print_info "All static files present"
else
    print_fail "Some static files missing"
    [ ! -f "static/index.html" ] && MISSING_FILES+=("static/index.html")
    [ ! -f "static/script.js" ] && MISSING_FILES+=("static/script.js")
    [ ! -f "static/styles.css" ] && MISSING_FILES+=("static/styles.css")
fi

# ========================================
# Check 9: Port Availability
# ========================================
print_check "Port 8000 availability"
if command -v lsof &> /dev/null; then
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port 8000 is already in use"
        print_info "Change PORT in .env or stop the service using port 8000"
    else
        print_pass
        print_info "Port 8000 is available"
    fi
elif command -v netstat &> /dev/null; then
    if netstat -tuln 2>/dev/null | grep -q ":8000 "; then
        print_warning "Port 8000 might be in use"
    else
        print_pass
        print_info "Port 8000 appears available"
    fi
else
    print_warning "Cannot check port availability (lsof/netstat not found)"
fi

# ========================================
# Check 10: System Resources
# ========================================
print_check "System resources"

# Check available RAM
if command -v free &> /dev/null; then
    AVAILABLE_RAM=$(free -g | awk '/^Mem:/{print $7}')
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    
    if [ "$AVAILABLE_RAM" -ge 4 ]; then
        print_pass
        print_info "RAM: ${AVAILABLE_RAM}GB available / ${TOTAL_RAM}GB total"
    else
        print_warning "Low available RAM: ${AVAILABLE_RAM}GB"
        print_info "Recommended: 8GB+. Consider using a smaller model (phi3)"
    fi
elif [ -f /proc/meminfo ]; then
    AVAILABLE_RAM=$(grep MemAvailable /proc/meminfo | awk '{print int($2/1024/1024)}')
    if [ "$AVAILABLE_RAM" -ge 4 ]; then
        print_pass
        print_info "RAM: ${AVAILABLE_RAM}GB available"
    else
        print_warning "Low available RAM: ${AVAILABLE_RAM}GB"
    fi
else
    print_warning "Cannot check RAM (free command not found)"
fi

# Check available disk space
print_check "Disk space"
if command -v df &> /dev/null; then
    AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}')
    AVAILABLE_SPACE_GB=$(df -BG . | awk 'NR==2 {print int($4)}')
    
    if [ "$AVAILABLE_SPACE_GB" -ge 10 ]; then
        print_pass
        print_info "Available: $AVAILABLE_SPACE"
    else
        print_warning "Low disk space: $AVAILABLE_SPACE"
        print_info "Recommended: 10GB+ for models"
    fi
else
    print_warning "Cannot check disk space"
fi

# ========================================
# Check 11: Network Connectivity (for model download)
# ========================================
print_check "Internet connectivity"
if curl -s --max-time 5 https://ollama.com > /dev/null 2>&1; then
    print_pass
    print_info "Can reach ollama.com for model downloads"
else
    print_warning "Cannot reach ollama.com"
    print_info "Internet needed for downloading models"
    print_info "If models are already downloaded, this is okay"
fi

# ========================================
# Summary
# ========================================
print_header "Verification Summary"

echo -e "${GREEN}✅ Passed:  $PASSED${NC}"
echo -e "${YELLOW}⚠️  Warnings: $WARNINGS${NC}"
echo -e "${RED}❌ Failed:  $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}║     ✅ All checks passed! You're ready to go! 🎉     ║${NC}"
    echo -e "${GREEN}║                                                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}To start the application:${NC}"
    echo -e "  ${GREEN}./start.sh${NC}        (Linux/macOS)"
    echo -e "  ${GREEN}start.bat${NC}         (Windows)"
    echo -e "  ${GREEN}bash run.sh${NC}       (Full automated setup)"
    echo ""
elif [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                       ║${NC}"
    echo -e "${YELLOW}║  ⚠️  Setup complete with warnings                    ║${NC}"
    echo -e "${YELLOW}║                                                       ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}You can proceed, but review the warnings above.${NC}"
    echo ""
    echo -e "${BLUE}To start the application:${NC}"
    echo -e "  ${GREEN}./start.sh${NC}        (Linux/macOS)"
    echo -e "  ${GREEN}start.bat${NC}         (Windows)"
    echo ""
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                       ║${NC}"
    echo -e "${RED}║  ❌ Setup incomplete - Fix the errors above          ║${NC}"
    echo -e "${RED}║                                                       ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Please address the failed checks before starting.${NC}"
    echo ""
    echo -e "${BLUE}For help, see:${NC}"
    echo -e "  • ${BLUE}OLLAMA_TROUBLESHOOTING.md${NC} - Detailed troubleshooting guide"
    echo -e "  • ${BLUE}README.md${NC} - Installation instructions"
    echo -e "  • ${BLUE}LOCAL_LLM_SETUP.md${NC} - Ollama setup guide"
    echo ""
fi

# ========================================
# Next Steps Recommendations
# ========================================
if [ $FAILED -gt 0 ] || [ $WARNINGS -gt 0 ]; then
    print_header "Recommended Actions"
    
    if ! command -v ollama &> /dev/null; then
        echo -e "${BLUE}1. Install Ollama:${NC}"
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo -e "   ${GREEN}curl -fsSL https://ollama.com/install.sh | sh${NC}"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "   ${GREEN}brew install ollama${NC}"
        else
            echo -e "   Download from: ${BLUE}https://ollama.com/download${NC}"
        fi
        echo ""
    fi
    
    if command -v ollama &> /dev/null && ! curl -s http://localhost:11434/api/version &> /dev/null; then
        echo -e "${BLUE}2. Start Ollama service:${NC}"
        echo -e "   ${GREEN}ollama serve${NC}"
        echo ""
    fi
    
    if command -v ollama &> /dev/null; then
        MODEL_COUNT=$(ollama list 2>/dev/null | tail -n +2 | wc -l)
        if [ "$MODEL_COUNT" -eq 0 ]; then
            echo -e "${BLUE}3. Download a model:${NC}"
            echo -e "   ${GREEN}ollama pull llama3.2${NC}  (recommended, 7GB)"
            echo -e "   ${GREEN}ollama pull phi3${NC}       (smaller, 2GB)"
            echo ""
        fi
    fi
    
    echo -e "${BLUE}For detailed help:${NC}"
    echo -e "  ${GREEN}cat OLLAMA_TROUBLESHOOTING.md${NC}"
    echo ""
fi

echo -e "${BLUE}========================================${NC}\n"

# Exit with appropriate code
if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
