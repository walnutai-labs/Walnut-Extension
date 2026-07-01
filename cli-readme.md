## 🌰 Walnut AI CLI v4.3.6

AI-powered coding assistant for your terminal by Walnut AI.

### ✨ Features
- **Agentic AI** — Multi-turn conversations with tool use (file editing, bash, search, grep)
- **Full File Operations** — Read, write, edit, glob, grep directly from the terminal
- **Rich Terminal UI** — Scrollable chat, markdown rendering, syntax highlighting
- **Smart Compaction** — AI-powered conversation summarization, auto-compacts at 90% context
- **Image Support** — Paste images from clipboard with `/image`
- **Input History** — Up/Down arrows to recall previous messages
- **20+ Slash Commands** — `/help`, `/mode dev|qa`, `/compact`, `/projects`, `/login`, `/model`, and more
- **Multi-Project** — Login, switch projects, switch AI models on the fly
- **Dev & QA Modes** — Switch between development and testing workflows

---

### 📦 Install on macOS / Linux

**Step 1:** Download `walnut-ai-v4.3.6.zip` from the assets below

**Step 2:** Open Terminal and run:
```bash
unzip walnut-ai-v4.3.6.zip
cd walnut-ai
bash install.sh
```

**Step 3:** Start Walnut AI:
```bash
walnutai
```

> The install script will automatically install [Bun](https://bun.sh) runtime if not already present.

---

### 📦 Install on Windows

**Step 1:** Download `walnut-ai-v4.3.6.zip` from the assets below

**Step 2:** Extract the zip file

**Step 3:** Open the `walnut-ai` folder, right-click `install.ps1` → **Run with PowerShell**

Or open PowerShell and run:
```powershell
cd walnut-ai
powershell -ExecutionPolicy Bypass -File install.ps1
```

**Step 4:** Restart your terminal, then run:
```powershell
walnutai
```

> The install script will automatically install [Bun](https://bun.sh) runtime if not already present.

---

### 🚀 Usage

```bash
walnutai                                    # Start interactive TUI
walnutai --server-url http://your-server    # Connect to your Walnut server
walnutai -p "explain this codebase"         # One-shot prompt
walnutai --help                             # Show all options
```

---

### ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Enter` | Send message |
| `Shift+Enter` | New line |
| `Up / Down` | Browse input history |
| `Ctrl+C` | Cancel current request |
| `Ctrl+D` | Exit |

---

### 🛠️ Commands

| Command | Description |
|---------|-------------|
| `/help` | Show all commands |
| `/login` | Login to Walnut AI |
| `/projects` | List/select projects |
| `/mode dev\|qa` | Switch development/QA mode |
| `/model <name>` | Change AI model |
| `/compact` | AI-powered conversation compaction |
| `/image` | Paste image from clipboard |
| `/cd <path>` | Change working directory |
| `/context` | Show context window usage |
| `/cost` | Show token usage and cost |
| `/status` | Show session info |
| `/undo` | Undo last AI turn |
| `/clear` | Clear conversation |
| `/exit` | Exit |

---

### 💻 Supported Platforms

| Platform | Architecture |
|----------|-------------|
| macOS | Apple Silicon (arm64), Intel (x64) |
| Linux | x64, arm64 |
| Windows | x64, arm64 |

---

### 🔄 Update
Download the latest release and re-run the install script. It will replace the previous installation.
