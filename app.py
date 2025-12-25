"""
Zoppler Radar AI Chatbot - Backend API
A specialized AI assistant for Defence and Automotive Radar engineering
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, StreamingResponse
from pydantic import BaseModel
from typing import List, Optional
import anthropic
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
    """
    try:
        # Check for API key
        api_key = os.getenv("ANTHROPIC_API_KEY")
        if not api_key:
            raise HTTPException(
                status_code=500,
                detail="ANTHROPIC_API_KEY not configured. Please set your API key in .env file."
            )

        client = anthropic.Anthropic(api_key=api_key)

        # Convert messages to Anthropic format
        messages = [
            {"role": msg.role, "content": msg.content}
            for msg in request.messages
        ]

        if request.stream:
            # Streaming response
            async def generate():
                try:
                    with client.messages.stream(
                        model="claude-3-5-sonnet-20241022",
                        max_tokens=4096,
                        system=SYSTEM_PROMPT,
                        messages=messages,
                    ) as stream:
                        for text in stream.text_stream:
                            yield f"data: {json.dumps({'text': text})}\n\n"
                    yield "data: [DONE]\n\n"
                except Exception as e:
                    yield f"data: {json.dumps({'error': str(e)})}\n\n"

            return StreamingResponse(
                generate(),
                media_type="text/event-stream"
            )
        else:
            # Non-streaming response
            message = client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=4096,
                system=SYSTEM_PROMPT,
                messages=messages,
            )

            return ChatResponse(
                response=message.content[0].text,
                timestamp=datetime.now().isoformat()
            )

    except anthropic.AuthenticationError:
        raise HTTPException(
            status_code=401,
            detail="Invalid API key. Please check your ANTHROPIC_API_KEY."
        )
    except anthropic.RateLimitError:
        raise HTTPException(
            status_code=429,
            detail="Rate limit exceeded. Please try again later."
        )
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
