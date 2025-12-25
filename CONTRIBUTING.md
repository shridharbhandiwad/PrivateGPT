# Contributing to Zoppler Radar AI

Thank you for contributing to make Zoppler Radar AI better! This document provides guidelines for internal team members.

## Development Workflow

### 1. Setting Up Development Environment

```bash
# Clone the repository
git clone <repository-url>
cd zoppler-radar-ai

# Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies with dev tools
pip install -r requirements.txt
pip install pytest black ruff
```

### 2. Making Changes

#### Code Style

- **Python**: Follow PEP 8, use `black` for formatting
  ```bash
  black app.py
  ```

- **JavaScript**: Use consistent ES6+ syntax, 2-space indentation
- **CSS**: Use CSS custom properties (variables), mobile-first approach

#### Project Structure

```
app.py           # Backend API - add new endpoints here
static/
  ├── index.html # UI structure - modify layout here
  ├── styles.css # Styling - update theme/colors here
  └── script.js  # Frontend logic - add features here
```

### 3. Testing Changes

#### Manual Testing
1. Start the application: `python app.py`
2. Open browser to http://localhost:8000
3. Test your changes thoroughly
4. Try edge cases and error scenarios

#### Automated Testing (Future)
```bash
pytest tests/
```

### 4. Committing Changes

#### Commit Message Format
```
<type>: <short description>

<detailed description if needed>

Examples:
feat: add file upload support for radar data analysis
fix: resolve streaming response timeout issue
docs: update installation instructions
style: improve mobile responsiveness
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: UI/CSS changes
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks

### 5. Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** with clear, focused commits

3. **Test thoroughly** - ensure nothing breaks

4. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **PR Description** should include:
   - What changed and why
   - Testing performed
   - Screenshots (for UI changes)
   - Any breaking changes

## Areas for Contribution

### High Priority
- [ ] File upload support for analyzing `.csv`, `.mat`, `.h5` radar data
- [ ] Conversation history persistence
- [ ] Multi-user authentication system
- [ ] Integration with internal documentation database

### Medium Priority
- [ ] Dark/light theme toggle
- [ ] Code syntax highlighting for responses
- [ ] Export conversation to PDF
- [ ] Real-time collaboration features

### Enhancement Ideas
- [ ] Voice input support
- [ ] Keyboard shortcuts
- [ ] Equation rendering (LaTeX/MathJax)
- [ ] Diagram generation (PlantUML, Mermaid)
- [ ] Integration with Jira/Confluence
- [ ] Custom knowledge base training

## Code Guidelines

### Backend (app.py)

```python
# Good: Clear endpoint with proper error handling
@app.post("/api/analyze")
async def analyze_radar_data(file: UploadFile):
    try:
        # Validate file
        if not file.filename.endswith(('.csv', '.mat')):
            raise HTTPException(400, "Invalid file type")
        
        # Process
        data = await process_file(file)
        return {"status": "success", "data": data}
    
    except Exception as e:
        logger.error(f"Analysis failed: {e}")
        raise HTTPException(500, str(e))
```

### Frontend (script.js)

```javascript
// Good: Modular, error-handled function
async function uploadFile(file) {
    const formData = new FormData();
    formData.append('file', file);
    
    try {
        const response = await fetch('/api/upload', {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) throw new Error('Upload failed');
        return await response.json();
    } catch (error) {
        console.error('Upload error:', error);
        this.showError('Failed to upload file');
    }
}
```

### CSS (styles.css)

```css
/* Good: Use CSS variables, mobile-first */
.new-feature {
    /* Mobile first */
    padding: 10px;
    background: var(--surface);
    
    /* Tablet and up */
    @media (min-width: 768px) {
        padding: 20px;
    }
}
```

## System Prompt Modifications

When updating the AI's behavior in `app.py`:

1. **Be Specific**: Clear, technical language
2. **Test Thoroughly**: Try diverse queries
3. **Document Changes**: Note in commit message
4. **Consider Edge Cases**: How does it handle ambiguity?

```python
# Example: Adding new domain expertise
SYSTEM_PROMPT = """
... existing prompt ...

**New Domain: Quantum Radar**
- Quantum entanglement for sensing
- Quantum illumination techniques
- Performance advantages and limitations
"""
```

## Security Considerations

### ⚠️ Never Commit:
- API keys or credentials
- User data or conversations
- Internal IP addresses or system details
- Proprietary algorithms or classified info

### ✅ Always:
- Use environment variables for secrets
- Sanitize user inputs
- Validate file uploads
- Log security-relevant events
- Follow principle of least privilege

## Documentation

When adding features, update:
- [ ] README.md (if user-facing)
- [ ] Inline code comments
- [ ] API endpoint docstrings
- [ ] This CONTRIBUTING.md (if process changes)

## Questions?

- **Technical Questions**: Ask in #radar-ai-dev Slack channel
- **Architecture Decisions**: Discuss with senior engineers
- **Security Concerns**: Contact security team immediately

## Recognition

Major contributors will be recognized in:
- Internal engineering blog posts
- Quarterly engineering reviews
- Project documentation

---

**Thank you for making Zoppler Radar AI better!** 🎯
