# Walnut AI - Intelligent Coding Assistant

**Walnut AI** is a powerful VS Code extension that brings AI-powered coding assistance directly into your development workflow. Chat with AI, understand your codebase, and execute tasks autonomously.

<p align="center">
  <img src="https://raw.githubusercontent.com/user-attachments/assets/walnut-demo.gif" alt="Walnut AI Demo" width="600"/>
</p>

---

## Key Features

### Conversational AI Chat
- **Natural Language Interface**: Ask questions, request code changes, or get explanations in plain English
- **Context-Aware**: Automatically understands your current file, selection, and workspace
- **Multi-Model Support**: Works with Claude, GPT-4, and other leading AI models
- **Extended Thinking**: See AI's reasoning process for complex tasks

### Autonomous Task Execution
- **File Operations**: AI can read, write, and edit files across your project
- **Terminal Commands**: Execute shell commands with approval workflow
- **Multi-Step Tasks**: Complex operations broken into manageable steps
- **Smart Retry**: Automatic retry with exponential backoff on timeouts

### Code Intelligence
- **Codebase Analysis**: AI understands your entire project structure
- **Semantic Search**: Find code by meaning, not just keywords
- **Code Explanation**: Get detailed explanations of complex code
- **Refactoring**: Intelligent code improvements and optimizations

### Developer Experience
- **Inline Tool Display**: See AI actions inline within conversations
- **Permission Modes**: Ask, Auto, and Plan modes for different workflows
- **Session History**: Save and restore conversation sessions
- **Image Support**: Attach screenshots for visual context
- **Task Tracking**: Built-in todo list for complex tasks

---

## Getting Started

1. **Install** the extension from VS Code Marketplace
2. **Open** the Walnut AI sidebar (click the Walnut icon in the activity bar)
3. **Login** with your Walnut account
4. **Select** a project and start chatting!

---

## Usage

### Chat Commands
- Type your question or request in the input area
- Use `@` to mention files from your workspace
- Use `/` for quick commands

### Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + Enter` | Send message |
| `Shift + Enter` | New line |
| `Shift + Tab` | Cycle permission mode |
| `Escape` | Stop current operation |

### Permission Modes

| Mode | Description |
|------|-------------|
| **Ask** | AI asks for approval before making changes |
| **Auto** | AI automatically approves safe operations |
| **Plan** | AI creates a plan before executing |

---

## Supported AI Providers

- **Anthropic Claude** (Claude 4.5 Opus, Claude 4 Sonnet, Claude 3.5)
- **OpenAI GPT** (GPT-4o, GPT-4o Mini)
- **Azure OpenAI**
- **AWS Bedrock**
- **Custom Endpoints**

---

## Configuration

Configure Walnut AI through VS Code settings (`Cmd/Ctrl + ,`):

| Setting | Description |
|---------|-------------|
| `walnut.server.backendUrl` | Walnut backend API URL |
| `walnut.server.mcpUrl` | MCP Server URL |
| `walnut.aiProvider` | AI provider selection |

---

## Requirements

- VS Code 1.98.0 or higher
- Active internet connection
- Walnut AI account (free tier available)

---

## What's New in 4.2.29

- **Auto-Retry**: Automatic retry with exponential backoff on timeouts
- **Parallel Sessions**: Multiple chat sessions running independently
- **Improved Stability**: Better error handling and session management
- **Performance**: Faster response streaming

---

## Privacy & Security

- Code is processed securely through Walnut's servers
- Conversations stored in your account for session continuity
- File operations require explicit approval in Ask mode
- No training on your code without consent

---

## Support

- **Website**: [wnut.ai](https://wnut.ai)
- **Email**: support@wnut.ai
- **Issues**: [GitHub Issues](https://github.com/walnutai/walnut-vscode/issues)

---

## License

MIT License - See [LICENSE.md](LICENSE.md) for details.

---

<p align="center">
  <strong>Walnut AI</strong> - Your intelligent coding companion
</p>
