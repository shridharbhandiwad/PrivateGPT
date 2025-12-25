// Zoppler Radar AI - Frontend JavaScript

class ZopplerChat {
    constructor() {
        this.messages = [];
        this.isProcessing = false;
        
        // DOM elements
        this.chatContainer = document.getElementById('chatContainer');
        this.messageInput = document.getElementById('messageInput');
        this.sendButton = document.getElementById('sendButton');
        this.clearButton = document.getElementById('clearButton');
        this.loadingIndicator = document.getElementById('loadingIndicator');
        
        this.initializeEventListeners();
    }

    initializeEventListeners() {
        // Send button click
        this.sendButton.addEventListener('click', () => this.sendMessage());
        
        // Enter to send (Shift+Enter for new line)
        this.messageInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });
        
        // Auto-resize textarea
        this.messageInput.addEventListener('input', () => {
            this.messageInput.style.height = 'auto';
            this.messageInput.style.height = this.messageInput.scrollHeight + 'px';
        });
        
        // Clear conversation
        this.clearButton.addEventListener('click', () => this.clearConversation());
    }

    async sendMessage() {
        const content = this.messageInput.value.trim();
        
        if (!content || this.isProcessing) return;
        
        // Add user message
        this.addMessage('user', content);
        this.messages.push({ role: 'user', content });
        
        // Clear input
        this.messageInput.value = '';
        this.messageInput.style.height = 'auto';
        
        // Show loading
        this.setProcessing(true);
        
        try {
            await this.getAIResponse();
        } catch (error) {
            this.addMessage('assistant', `❌ Error: ${error.message}`);
        } finally {
            this.setProcessing(false);
        }
    }

    async getAIResponse() {
        const response = await fetch('/api/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                messages: this.messages,
                stream: true
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.detail || 'Failed to get response');
        }

        // Create assistant message container
        const messageElement = this.createMessageElement('assistant', '');
        const contentElement = messageElement.querySelector('.message-content');
        
        let fullResponse = '';
        
        // Read streaming response
        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        
        while (true) {
            const { done, value } = await reader.read();
            if (done) break;
            
            const chunk = decoder.decode(value);
            const lines = chunk.split('\n');
            
            for (const line of lines) {
                if (line.startsWith('data: ')) {
                    const data = line.slice(6);
                    
                    if (data === '[DONE]') {
                        break;
                    }
                    
                    try {
                        const parsed = JSON.parse(data);
                        if (parsed.text) {
                            fullResponse += parsed.text;
                            contentElement.innerHTML = this.formatMessage(fullResponse);
                            this.scrollToBottom();
                        }
                        if (parsed.error) {
                            throw new Error(parsed.error);
                        }
                    } catch (e) {
                        if (e instanceof SyntaxError) continue;
                        throw e;
                    }
                }
            }
        }
        
        // Save complete response
        this.messages.push({ role: 'assistant', content: fullResponse });
    }

    addMessage(role, content) {
        // Remove welcome message if it exists
        const welcomeMessage = this.chatContainer.querySelector('.welcome-message');
        if (welcomeMessage) {
            welcomeMessage.remove();
        }
        
        const messageElement = this.createMessageElement(role, content);
        this.chatContainer.appendChild(messageElement);
        this.scrollToBottom();
    }

    createMessageElement(role, content) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${role}`;
        
        const timestamp = new Date().toLocaleTimeString('en-US', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
        
        const roleLabel = role === 'user' ? 'You' : 'Zoppler Radar AI';
        
        messageDiv.innerHTML = `
            <div class="message-header">
                <span class="message-role">${roleLabel}</span>
                <span class="message-timestamp">${timestamp}</span>
            </div>
            <div class="message-content">${this.formatMessage(content)}</div>
        `;
        
        return messageDiv;
    }

    formatMessage(content) {
        if (!content) return '';
        
        // Escape HTML
        let formatted = content
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
        
        // Format code blocks
        formatted = formatted.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, lang, code) => {
            return `<pre><code>${code.trim()}</code></pre>`;
        });
        
        // Format inline code
        formatted = formatted.replace(/`([^`]+)`/g, '<code>$1</code>');
        
        // Format bold
        formatted = formatted.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
        
        // Format italic
        formatted = formatted.replace(/\*([^*]+)\*/g, '<em>$1</em>');
        
        // Format line breaks
        formatted = formatted.replace(/\n/g, '<br>');
        
        return formatted;
    }

    setProcessing(processing) {
        this.isProcessing = processing;
        this.sendButton.disabled = processing;
        this.messageInput.disabled = processing;
        this.loadingIndicator.style.display = processing ? 'flex' : 'none';
    }

    clearConversation() {
        if (!confirm('Clear the entire conversation?')) return;
        
        this.messages = [];
        this.chatContainer.innerHTML = `
            <div class="welcome-message">
                <h2>Welcome to Zoppler Radar AI</h2>
                <p>I'm your internal expert assistant specializing in Defence and Automotive Radar engineering.</p>
                <div class="capabilities">
                    <div class="capability">
                        <strong>🎯 Radar Fundamentals</strong>
                        <span>FMCW, Pulse, AESA, range–Doppler–angle</span>
                    </div>
                    <div class="capability">
                        <strong>🛡️ Defence Systems</strong>
                        <span>Surveillance, tracking, ISAR/SAR, ECCM, C2</span>
                    </div>
                    <div class="capability">
                        <strong>🚗 Automotive Radar</strong>
                        <span>24/77 GHz, ADAS, tracking, sensor fusion</span>
                    </div>
                    <div class="capability">
                        <strong>📊 Signal Processing</strong>
                        <span>FFT, CFAR, beamforming, Kalman filters</span>
                    </div>
                    <div class="capability">
                        <strong>🤖 Machine Learning</strong>
                        <span>Target classification, GNN/LSTM/CNN</span>
                    </div>
                    <div class="capability">
                        <strong>💻 Software & Systems</strong>
                        <span>C/C++, Python, Qt, ROS, microservices</span>
                    </div>
                </div>
                <p class="security-note">🔒 All conversations are confidential. I provide engineering guidance only.</p>
            </div>
        `;
    }

    scrollToBottom() {
        this.chatContainer.scrollTop = this.chatContainer.scrollHeight;
    }
}

// Initialize chat when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new ZopplerChat();
});
