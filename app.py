"""
Zoppler Radar AI Chatbot - Backend API
A specialized AI assistant for Defence and Automotive Radar engineering
Using Local LLM via Ollama
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, StreamingResponse
from pydantic import BaseModel
from typing import List, Optional
import httpx
import os
from datetime import datetime
import json

app = FastAPI(title="Zoppler Radar AI", version="1.0.0")

# CORS middleware for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# System prompt for Zoppler Radar AI
SYSTEM_PROMPT = """You are Zoppler Radar AI, an internal expert assistant for Zoppler Systems, specializing in Defence and Automotive Radar engineering.

**Scope**

You provide accurate, practical help on:
- Radar fundamentals (FMCW, Pulse, AESA, range–Doppler–angle)
- Defence radars (surveillance, tracking, ISAR/SAR, ECCM, C2, sensor fusion)
- Automotive radars (24/77 GHz, ADAS, tracking, fusion)
- Radar signal processing (FFT, CFAR, beamforming, Kalman filters)
- ML for radar (target/clutter classification, ISAR ML, GNN/LSTM/CNN)
- Radar software & systems (C/C++, Python, Qt, ROS, microservices, HMIs)

**Knowledge Handling**
- Prioritize uploaded files and internal documents as ground truth
- If information is missing, say so — do not hallucinate
- Ask clarifying questions only when necessary

**Behavior**
- Be precise, structured, and engineering-focused
- Prefer equations, tables, pseudo-code, and clear trade-offs
- Adjust depth for engineers vs management
- State assumptions explicitly

**Security**
- Treat all data as confidential
- No operational weapon usage or real-world attack guidance

**Identity**
You are not a general chatbot. You are a senior radar systems architect AI for Zoppler Systems."""


class Message(BaseModel):
    role: str
    content: str


class ChatRequest(BaseModel):
    messages: List[Message]
    stream: Optional[bool] = False


class ChatResponse(BaseModel):
    response: str
    timestamp: str


@app.get("/", response_class=HTMLResponse)
async def root():
    """Serve the main chat interface"""
    with open("static/index.html", "r") as f:
        return f.read()


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Zoppler Radar AI"}


@app.post("/api/chat")
async def chat(request: ChatRequest):
    """
    Main chat endpoint - handles both streaming and non-streaming responses
    Uses local Ollama LLM
    """
    try:
        # Get Ollama configuration
        ollama_host = os.getenv("OLLAMA_HOST", "http://localhost:11434")
        ollama_model = os.getenv("OLLAMA_MODEL", "llama3.2")
        
        # Convert messages to Ollama format
        # Ollama expects system prompt as part of the messages or separate
        messages = [
            {"role": msg.role, "content": msg.content}
            for msg in request.messages
        ]
        
        # Add system prompt at the beginning
        full_messages = [
            {"role": "system", "content": SYSTEM_PROMPT},
            *messages
        ]

        if request.stream:
            # Streaming response
            async def generate():
                try:
                    async with httpx.AsyncClient(timeout=120.0) as client:
                        async with client.stream(
                            "POST",
                            f"{ollama_host}/api/chat",
                            json={
                                "model": ollama_model,
                                "messages": full_messages,
                                "stream": True
                            }
                        ) as response:
                            if response.status_code != 200:
                                error_text = await response.aread()
                                yield f"data: {json.dumps({'error': f'Ollama error: {error_text.decode()}'})}\n\n"
                                return
                            
                            async for line in response.aiter_lines():
                                if line.strip():
                                    try:
                                        data = json.loads(line)
                                        if "message" in data and "content" in data["message"]:
                                            content = data["message"]["content"]
                                            if content:
                                                yield f"data: {json.dumps({'text': content})}\n\n"
                                        
                                        # Check if done
                                        if data.get("done", False):
                                            break
                                    except json.JSONDecodeError:
                                        continue
                    
                    yield "data: [DONE]\n\n"
                except httpx.ConnectError:
                    yield f"data: {json.dumps({'error': 'Cannot connect to Ollama. Make sure Ollama is running at ' + ollama_host})}\n\n"
                except Exception as e:
                    yield f"data: {json.dumps({'error': str(e)})}\n\n"

            return StreamingResponse(
                generate(),
                media_type="text/event-stream"
            )
        else:
            # Non-streaming response
            async with httpx.AsyncClient(timeout=120.0) as client:
                try:
                    response = await client.post(
                        f"{ollama_host}/api/chat",
                        json={
                            "model": ollama_model,
                            "messages": full_messages,
                            "stream": False
                        }
                    )
                    
                    if response.status_code != 200:
                        raise HTTPException(
                            status_code=response.status_code,
                            detail=f"Ollama error: {response.text}"
                        )
                    
                    data = response.json()
                    response_text = data.get("message", {}).get("content", "")
                    
                    return ChatResponse(
                        response=response_text,
                        timestamp=datetime.now().isoformat()
                    )
                    
                except httpx.ConnectError:
                    raise HTTPException(
                        status_code=503,
                        detail=f"Cannot connect to Ollama at {ollama_host}. Make sure Ollama is running."
                    )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/clear")
async def clear_conversation():
    """Clear conversation history"""
    return {"status": "success", "message": "Conversation cleared"}


# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
