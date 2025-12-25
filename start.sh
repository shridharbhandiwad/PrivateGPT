#!/bin/bash

# Zoppler Radar AI - Quick Start Script (Local LLM)

echo "🎯 Zoppler Radar AI - Starting (Local LLM)..."
echo ""

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "⚠️  Ollama not found. Please install Ollama first:"
    echo ""
    
    # Detect OS and provide appropriate installation command
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "   To install on Linux, run:"
        echo "   curl -fsSL https://ollama.com/install.sh | sh"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   To install on macOS, run:"
        echo "   brew install ollama"
        echo "   OR download from: https://ollama.com/download"
    else
        echo "   Download from: https://ollama.com/download"
    fi
    
    echo ""
    read -p "Would you like to install Ollama now? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "📥 Installing Ollama..."
            curl -fsSL https://ollama.com/install.sh | sh
            if [ $? -eq 0 ]; then
                echo "✅ Ollama installed successfully!"
                echo ""
            else
                echo "❌ Installation failed. Please install manually."
                exit 1
            fi
        elif [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
            echo "📥 Installing Ollama via Homebrew..."
            brew install ollama
            if [ $? -eq 0 ]; then
                echo "✅ Ollama installed successfully!"
                echo ""
            else
                echo "❌ Installation failed. Please install manually."
                exit 1
            fi
        else
            echo "❌ Automatic installation not available for your system."
            echo "   Please install manually from: https://ollama.com/download"
            exit 1
        fi
    else
        echo "Installation cancelled. Please install Ollama and run this script again."
        exit 1
    fi
fi

# Check if Ollama is running
echo "🔍 Checking if Ollama service is running..."
if ! curl -s http://localhost:11434/api/version &> /dev/null; then
    echo "⚠️  Ollama is not running. Attempting to start Ollama..."
    echo ""
    
    # Try to start Ollama in background
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # On macOS, try to open Ollama app
        if [ -d "/Applications/Ollama.app" ]; then
            open -a Ollama 2>/dev/null &
            echo "   Opened Ollama app..."
        else
            nohup ollama serve > /tmp/ollama.log 2>&1 &
            echo "   Started Ollama serve in background..."
        fi
    else
        # On Linux, start in background
        nohup ollama serve > /tmp/ollama.log 2>&1 &
        echo "   Started Ollama serve in background (PID: $!)"
    fi
    
    # Wait for Ollama to start
    echo "   Waiting for Ollama to start..."
    for i in {1..10}; do
        sleep 1
        if curl -s http://localhost:11434/api/version &> /dev/null; then
            echo "✅ Ollama started successfully!"
            echo ""
            break
        fi
        if [ $i -eq 10 ]; then
            echo "❌ Failed to start Ollama automatically."
            echo "   Please start Ollama manually:"
            echo "   - Run 'ollama serve' in another terminal, OR"
            echo "   - Open the Ollama app"
            echo ""
            read -p "Press Enter after starting Ollama..."
            
            # Check one more time
            if ! curl -s http://localhost:11434/api/version &> /dev/null; then
                echo "❌ Still cannot connect to Ollama. Exiting."
                exit 1
            fi
        fi
    done
else
    echo "✅ Ollama is running"
    echo ""
fi

# Check if a model is installed
echo "🔍 Checking for available models..."
if ! ollama list | grep -q llama; then
    echo "⚠️  No Llama models found. Pulling llama3.2..."
    echo "   This may take a few minutes (~7GB download)..."
    echo "   You can grab a coffee while this downloads ☕"
    echo ""
    
    if ollama pull llama3.2; then
        echo "✅ Model downloaded successfully!"
        echo ""
    else
        echo "❌ Failed to download model. Please check your internet connection."
        echo "   You can try manually: ollama pull llama3.2"
        exit 1
    fi
else
    echo "✅ Llama model found"
    echo ""
fi

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Creating from template..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo "   (Using default Ollama configuration)"
    echo ""
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install/upgrade dependencies
echo "📥 Installing dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt
echo "✅ Dependencies installed"

echo ""
echo "🚀 Starting Zoppler Radar AI..."
echo "   Access the chatbot at: http://localhost:8000"
echo "   Press Ctrl+C to stop"
echo ""

# Run the application
python app.py
