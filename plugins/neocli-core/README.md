# NeoCLI Core

NeoCLI is a user proxy arena built on Claude Code that implements the KSTAR learning loop for adaptive, self-improving agent behavior.

## Overview

NeoCLI transforms Claude Code into a learning agent that:
- Plans tasks with explicit expectations
- Executes plans while observing outcomes
- Compares expected vs actual results
- Records experiences to persistent memory
- Learns from deviations to improve future performance
- Converts successful patterns into reusable skills

## The KSTAR Learning Loop

KSTAR is a 7-stage closed learning loop:

| Stage | Name | Purpose |
|-------|------|---------|
| 1 | **Situation** | Capture context, environment, constraints |
| 2 | **Task** | Define intent and success criteria |
| 3 | **Plan** | Generate steps with expected outcomes |
| 4 | **Execute** | Run plan, record actual outcomes |
| 5 | **Compare** | Analyze expected vs actual, classify deviations |
| 6 | **Record** | Persist experience to Supabase memory |
| 7 | **Learn** | Extract lessons, update recommendations |

## Commands

### KSTAR Loop

| Command | Description |
|---------|-------------|
| `/kstar:start <task>` | Begin a new KSTAR learning loop |
| `/kstar:status` | View current loop state and progress |
| `/kstar:store` | Persist current experience to memory |
| `/kstar:recall <id>` | Retrieve an experience by ID |
| `/kstar:search <query>` | Semantic search for relevant experiences |

### Planning

| Command | Description |
|---------|-------------|
| `/plan:create <task>` | Generate an explicit action plan |
| `/plan:save` | Convert successful plan to reusable skill |

## Installation

### 1. Install the Plugin

```bash
claude --plugin-dir /path/to/neocli-core
```

Or add to your project's `.claude/settings.json`:

```json
{
  "plugins": ["/path/to/neocli-core"]
}
```

### 2. Configure Supabase

Set environment variables for the memory backend:

**Local Development:**
```bash
# Start local Supabase
supabase start

# Set environment variables
export NEOCLI_SUPABASE_URL=http://localhost:54321
export NEOCLI_SUPABASE_KEY=<your-local-anon-key>
```

**Production:**
```bash
export NEOCLI_SUPABASE_URL=https://your-project.supabase.co
export NEOCLI_SUPABASE_KEY=<your-anon-key>
```

### 3. Initialize Database

Run the schema migration in your Supabase project:

```sql
-- See skills/kstar-loop/references/schema.md for full schema
CREATE TABLE kstar_experiences (
  experience_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id TEXT NOT NULL,
  task_intent TEXT NOT NULL,
  -- ... see schema.md for complete definition
);
```

## Usage

### Start a Learning Loop

```bash
/kstar:start Add JWT authentication to the API
```

This will:
1. Capture your current situation (project, environment)
2. Define the task with success criteria
3. Generate an explicit plan
4. Execute the plan step-by-step
5. Compare results to expectations
6. Store the experience
7. Extract lessons for future use

### Search Past Experiences

```bash
/kstar:search "authentication middleware"
```

Find relevant prior experiences and apply their lessons to current tasks.

### Convert to Reusable Skill

```bash
/plan:save --name auth-middleware
```

Turn successful patterns into skills that auto-trigger on similar future tasks.

## Architecture

```
neocli-core/
├── .claude-plugin/plugin.json    # Plugin manifest
├── .mcp.json                     # Supabase MCP config
├── commands/
│   ├── kstar/                    # KSTAR loop commands
│   └── plan/                     # Planning commands
├── agents/
│   ├── kstar-orchestrator.md     # Main loop orchestrator
│   ├── plan-generator.md         # Step-by-step planning
│   ├── experience-recorder.md    # Memory persistence
│   └── deviation-analyzer.md     # Expected vs actual comparison
├── skills/
│   ├── kstar-loop/               # Core KSTAR methodology
│   └── plan-to-skill/            # Skill generation
└── hooks/
    ├── hooks.json                # Hook configuration
    └── scripts/
        ├── session-start.sh      # Load loop state
        └── stop-hook.sh          # Enforce loop completion
```

## State Management

KSTAR loop state persists in `.claude/neocli-kstar.local.md`:

```yaml
---
active: true
experience_id: "uuid"
current_stage: 3
---

# Situation
[Context details]

# Task
[Task definition]

# Plan
[Action plan]

# Execution Log
[Step outcomes]
```

The stop hook enforces completion of all 7 stages before allowing session exit.

## Skills

### KSTAR Loop Skill
Core methodology for the 7-stage learning loop. Auto-triggers on learning-related requests.

### Plan-to-Skill Skill
Methodology for converting successful experiences into reusable skills.

## Agents

| Agent | Purpose |
|-------|---------|
| `kstar-orchestrator` | Orchestrates the complete KSTAR loop |
| `plan-generator` | Creates explicit, verifiable action plans |
| `experience-recorder` | Structures and persists experiences |
| `deviation-analyzer` | Compares expected vs actual outcomes |

## Memory Schema

Experiences are stored in Supabase with:
- Situation (context, environment, constraints)
- Task (intent, success criteria)
- Plan (strategy, steps, expected outcomes)
- Execution (actual outcomes, timestamps)
- Result (status, deviations)
- Learning (lessons, recommendations, confidence)
- Metadata (tags, embeddings for semantic search)

## Requirements

- Claude Code (latest version)
- Supabase (local or cloud)
- Node.js 18+ (for MCP server)

## Version

0.1.0 - Initial release

## Author

NeoCLI Team
