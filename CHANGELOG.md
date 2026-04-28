# Changelog

All notable changes to the Walnut AI CLI (`walnutai`) and the cloud agent that runs it.

> Earlier entries (4.2.x and below) cover the Walnut AI VS Code extension. The extension now ships separately to the marketplace; this changelog has pivoted to track the CLI/cloud-agent release.

## [4.3.15] - 2026-04-28

Cloud-agent reliability release.

### Fixed
- **Long file writes no longer truncate silently.** The CLI was hardcoded to `maxTokens: 8192` regardless of model, then exited cleanly when the model hit that ceiling. Long READMEs, BRDs, and test plans came out half-written. Now uses the model's actual max output (Sonnet 4.6 → 64K, Opus 4.6 → 128K) and auto-continues up to 3 times if the model still hits the ceiling.
- **"No AI provider configured" now self-diagnoses.** When the cloud agent bails because it can't find an LLM, it now prints exactly what failed: was the project fetched? Did it have LLM models? What HTTP error came back? Which env vars are set? No more SSHing into the VM twice to figure out why.
- **Managed/credit-plan projects now work in the CLI.** The CLI was only reading `settings.ai_models.llm_models` (enterprise BYOM), so projects on Walnut-managed models silently failed with "no AI model". Added a fallback to `/ai-models/effective-config` which is the BYOM-aware endpoint.
- **AWS Bedrock SSL transient errors recover automatically.** Random `SSL alert number 20` / `BAD_RECORD_MAC` / `ECONNRESET` / `socket hang up` errors now trigger a one-shot reconnect + retry instead of dying.

### Improved
- **1-hour prompt cache TTL** is now latched on cloud-agent startup. Long-running tasks reuse cached system prompt + tools across all turns.

---

## [4.2.20] - 2026-01-30

### Fixed
- **Directory Exploration Bug** - Agent now uses Glob to discover folder structure BEFORE reading files
  - No more wrong path guesses like `walnut/frontend` instead of `walnut-frontend`
  - Agent won't ask user for directory structure - uses tools to discover it
  - Clear guidance in system prompt about exploration-first approach

- **Preflight Context Check** - Prevents "prompt is too long" errors
  - Estimates tokens BEFORE sending to API (includes new message + images)
  - Auto-compacts if projected tokens would exceed context limit
  - Checks both at message send AND during agentic loop iterations
  - Accounts for tool results that can accumulate tokens during iterations

## [4.2.19] - 2026-01-30

### Added
- **Message Queue** - Queue multiple messages while LLM is processing
  - Send follow-up messages without waiting for the current response to complete
  - Queued messages displayed above input area with position indicator
  - Edit queued messages before they're sent
  - Reorder queue by moving messages up
  - Remove messages from queue if no longer needed
  - Messages automatically sent in order when LLM finishes processing

## [4.2.18] - 2026-01-30

### Changed
- **Simplified server URL setting** - Single `walnut.server.url` setting instead of separate backend/MCP URLs
  - Backend URL derived as: `{serverUrl}/api`
  - MCP URL derived as: `{serverUrl}/mcp`
  - Handles trailing slashes automatically

### Fixed
- **Tavily API key secure storage** - Command Palette "Set Tavily API Key" stores key securely (password masked)

## [4.2.17] - 2026-01-29

### Added
- **WebSearch tool** - Search the web directly from Walnut AI
  - Uses Tavily API (reliable, high quality results)
  - 1000 free searches/month with Tavily free tier
  - API key stored securely via VS Code SecretStorage (password masked)
  - Setup: Command Palette → "Walnut Ai: Set Tavily API Key"
  - Clear instructions shown if API key not configured
  - Results include source attribution: `[Source: Tavily]`

## [4.2.16] - 2026-01-28

### Performance
- **Glob tool rewritten** - Switched from slow JavaScript walkDir to ripgrep `--files` (10-100x faster)
- Expected improvement: Large project glob from 5-30s → <100ms

### Improved
- **Grep tool enhancements**:
  - `--hidden` flag to search hidden files (.env, .gitignore, etc.)
  - `--max-columns 500` to truncate long lines (prevents minified JS consuming context)
  - Leading dash pattern handling with `-e` flag
  - Relative path output for cleaner results
- **Conservative exclusions** for top 10 programming languages:
  - Only excludes truly useless files (binaries, dependencies, OS junk)
  - Keeps logs, temp, coverage, build folders searchable
  - Shared exclusion list between Grep and Glob tools

### Fixed
- **WebFetch tool now works** - AI content processing was defined but never wired up
  - Fetched web pages are now summarized by LLM instead of returning raw markdown
  - Uses same model as main agent for processing

### Technical
- Grep and Glob now both use ripgrep (like Claude Code)
- `DEFAULT_EXCLUSIONS` exported from Grep.ts for shared use

## [4.1.9] - 2025-01-24

### Fixed
- Fixed crash when displaying error messages in certain scenarios
- Improved stability of activity indicator during long operations
- Enhanced error handling throughout the application

### Changed
- Updated default server URLs to production endpoints

## [4.1.8] - 2025-01-23

### Added
- Context window tracking with real-time token usage display
- Automatic context compaction when nearing token limits
- Compaction status messages in chat

### Improved
- Token counter always visible in UI
- Better handling of large conversations

## [4.1.7] - 2025-01-18

### Added
- TodoWrite tool for task tracking and progress visibility
- Enhanced agent prompt for better task completion
- Proactive task list creation for complex work

### Fixed
- Agent no longer stops mid-implementation
- Improved tool card status updates

## [4.1.6] - 2025-01-17

### Added
- Scroll-to-bottom button with new messages indicator
- Keyboard shortcut hints in input area
- Message timestamps
- Message actions (copy, feedback) on hover
- Enhanced code blocks with Copy and Apply buttons

### Improved
- Tool card icons and loading states
- Stop button design
- Overall UI polish

## [4.1.5] - 2025-01-13

### Added
- Test case generation from Playwright scripts
- Full test data support (parameters, datasets, datarows)
- Test scenario preview UI

### Improved
- Intelligence Hub test case workflow

## [4.1.4] - 2025-01-12

### Added
- Excel/CSV import with auto-detection
- Azure DevOps integration for story import
- Dynamic type support for external integrations

### Fixed
- Feature work items display in Action Items table
- Document-derived features now appear in table view

## [4.1.3] - 2025-01-10

### Fixed
- Story ID consistency between SSE events and API
- Batch completion indicator clearing
- Loading state after generation complete

### Changed
- Batch size now configurable via environment variable

## [4.1.2] - 2025-01-08

### Added
- Real-time SSE streaming for story generation
- Progressive structure extraction during document analysis
- Page reload recovery for ongoing generation jobs

### Improved
- Reduced polling frequency with SSE as primary update method
- Better progress visibility during long operations

## [4.1.1] - 2025-01-08

### Added
- Background story generation with progress tracking
- Save/Delete/Export buttons for Intelligence Hub
- Duplicate detection when saving stories

## [4.1.0] - 2025-01-03

### Added
- Streaming response display in sidebar
- Force cancellation for MCP agent operations
- Smart fallback for file/directory operations

### Fixed
- Multiple file read operations reliability
- Tool card loading state after stop
- Security validation for file paths

## [4.0.0] - 2025-01-01

### Added
- Complete UI overhaul with modern design
- Inline tool execution display
- Extended thinking support
- Multi-model AI support
- MCP server integration
- Session history and restore
- Image attachment support
- File mention with @ autocomplete

### Changed
- New permission modes: Ask, Auto, Plan
- Improved conversation flow
- Better error handling and display

---

For more details, visit [Walnut AI](https://wnut.ai)
