---
description: Begin a new KSTAR learning loop for a task
argument-hint: <task description>
---

# Start KSTAR Loop

Initialize a new KSTAR learning loop for the given task. This activates the 7-stage learning process: Situation → Task → Plan → Execute → Compare → Record → Learn.

## Process

### 1. Check for Active Loop

First, check if there's already an active KSTAR loop:

```bash
if [ -f ".claude/neocli-kstar.local.md" ]; then
  grep -q "^active: true" ".claude/neocli-kstar.local.md"
fi
```

If active, warn user and offer to:
- Continue existing loop
- Cancel existing and start new
- View status of existing

### 2. Capture Situation (Stage 1)

Analyze the current context:
- Working directory and project type
- Relevant files mentioned or implied
- Environment (OS, runtime, tools available)
- Constraints (from user request or project conventions)

### 3. Define Task (Stage 2)

From `$ARGUMENTS`, extract:
- **Intent**: What the user wants to accomplish
- **Success Criteria**: Measurable outcomes (ask if unclear)
- **Priority**: Infer from language or ask
- **Deadline**: If mentioned

### 4. Generate Plan (Stage 3)

Create an explicit action plan with:
- Strategy (overall approach)
- Steps with expected outputs
- Tools to be used per step

Use the `plan-generator` agent for complex tasks.

### 5. Initialize State File

Create `.claude/neocli-kstar.local.md`:

```markdown
---
active: true
experience_id: "[generated-uuid]"
current_stage: 3
iteration: 1
started_at: "[ISO-8601 timestamp]"
agent:
  agent_id: "neocli-v0"
  agent_name: "NeoCLI Core"
  agent_version: "0.1.0"
  role: "user-proxy"
---

# Situation

[Captured situation details]

## Context
[Project context]

## Environment
[Runtime environment]

## Constraints
[Identified constraints]

# Task

**Intent**: [Task intent from arguments]

**Success Criteria**:
1. [Criterion 1]
2. [Criterion 2]

**Priority**: [Priority level]

# Plan

## Strategy
[Overall approach]

## Steps

### Step 1: [Description]
- Tool: [Tool name]
- Expected: [Expected output]
- Status: pending

[Additional steps...]

# Execution Log

[Will be populated during execution]
```

### 6. Begin Execution (Stage 4)

After state file is created:
1. Confirm plan with user (show summary)
2. Begin executing Step 1
3. Log actual outcomes to Execution Log section
4. Continue through all steps

The stop hook will enforce completion of all stages before allowing session exit.

## Output

After initialization, display:
- KSTAR loop started message
- Experience ID for reference
- Task summary
- Plan overview
- First step to execute

## Example

```
/kstar:start Add JWT authentication to the API

✅ KSTAR Loop Started
📋 Experience ID: 550e8400-e29b-41d4-a716-446655440000

📍 Situation: TypeScript REST API project (Express.js)
🎯 Task: Add JWT authentication middleware
📝 Plan: TDD approach with 4 steps

Ready to execute Step 1: Write auth tests
```
