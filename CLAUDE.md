# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the public Claude Code repository containing official plugins, examples, and GitHub automation. It is NOT the Claude Code application source code - it's a companion repository for plugin distribution and issue management.

## Repository Structure

- **plugins/** - Official Claude Code plugins (commands, agents, skills, hooks)
- **scripts/** - GitHub automation scripts (TypeScript/Bun for issue management)
- **examples/** - Example code (e.g., hook implementations)
- **.github/workflows/** - CI/CD workflows for issue triage, duplicate detection, auto-closing

## Plugin Development

### Plugin Structure
Each plugin follows this structure:
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata (name, description, version, author)
├── commands/                 # Slash commands (markdown files)
├── agents/                   # Specialized agents (markdown files)
├── skills/                   # Agent skills (SKILL.md files)
├── hooks/                    # Event handlers (hooks.json + scripts)
├── .mcp.json                 # MCP server configuration (optional)
└── README.md                 # Plugin documentation
```

### Key Plugins
- **commit-commands** - Git workflow automation (`/commit`, `/commit-push-pr`)
- **code-review** - Automated PR review with confidence scoring
- **plugin-dev** - Toolkit for developing plugins (`/plugin-dev:create-plugin`)
- **hookify** - Create custom hooks from conversation patterns
- **ralph-wiggum** - Self-referential iteration loops (`/ralph-loop`)

## Scripts

Scripts in `scripts/` are TypeScript files meant to run with Bun:
```bash
bun run scripts/auto-close-duplicates.ts
```

These scripts require `GITHUB_TOKEN` environment variable and are used in GitHub Actions workflows.

## GitHub Workflows

Workflows handle automated issue management:
- **claude-issue-triage.yml** - AI-powered issue labeling
- **claude-dedupe-issues.yml** - Duplicate detection
- **auto-close-duplicates.yml** - Auto-close confirmed duplicates
- **stale-issue-manager.yml** - Stale issue handling
- **oncall-triage.yml** - Critical issue escalation

## Hooks

Hooks are event handlers that run at specific points in Claude Code's lifecycle:
- **PreToolUse** - Before tool execution (validation)
- **PostToolUse** - After tool execution
- **Stop** - When session ends
- **SessionStart** - When session begins

Example hook implementation in `examples/hooks/bash_command_validator_example.py` shows how to validate bash commands.

## Testing Plugins Locally

```bash
claude --plugin-dir /path/to/plugin-name
```

Or configure in `.claude/settings.json`:
```json
{
  "plugins": ["/path/to/plugin-name"]
}
```
