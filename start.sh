#!/bin/bash

# Zoppler Radar AI - Quick Start Script (Local LLM)

echo "🎯 Zoppler Radar AI - Starting (Local LLM)..."
echo ""

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "⚠️  Ollama not found. Please install Ollama first:"
    echo "   curl -fsSL https://ollama.com/install.sh | sh"
    echo ""
    exit 1
fi

# Check if Ollama is running
if ! curl -s http://localhost:11434/api/version &> /dev/null; then
    echo "⚠️  Ollama is not running. Starting Ollama..."
    echo "   Please ensure 'ollama serve' is running in another terminal"
    echo ""
    read -p "Press Enter after starting Ollama..."
fi

# Check if a model is installed
if ! ollama list | grep -q llama; then
    echo "⚠️  No models found. Pulling llama3.2..."
    echo "   This may take a few minutes (7GB download)..."
    ollama pull llama3.2
    echo "✅ Model downloaded"
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
