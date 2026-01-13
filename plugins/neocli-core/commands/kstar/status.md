---
description: View current KSTAR loop state and progress
---

# KSTAR Status

Display the current state of the active KSTAR learning loop.

## Process

### 1. Check State File

Read `.claude/neocli-kstar.local.md`:

```bash
if [ ! -f ".claude/neocli-kstar.local.md" ]; then
  echo "No active KSTAR loop"
  exit 0
fi
```

### 2. Parse State

Extract from YAML frontmatter:
- `active`: Whether loop is running
- `experience_id`: Current experience ID
- `current_stage`: Which stage (1-7)
- `iteration`: Loop iteration count
- `started_at`: When loop started

### 3. Display Status

Format and display:

```
📊 KSTAR Loop Status

🔑 Experience ID: [uuid]
⏱️  Started: [timestamp] ([duration] ago)
🔄 Iteration: [n]

📍 Current Stage: [n]/7 - [Stage Name]

Progress:
[1] ✅ Situation - Captured
[2] ✅ Task - Defined
[3] ✅ Plan - Generated
[4] 🔄 Execute - In Progress (Step 2/4)
[5] ⏳ Compare - Pending
[6] ⏳ Record - Pending
[7] ⏳ Learn - Pending

📋 Task: [intent]

📝 Current Step:
   Step 2: Implement JWT middleware
   Tool: Write
   Expected: Middleware with verify() function
```

### 4. Show Execution Summary

If in execution stage, show:
- Completed steps with outcomes
- Current step
- Remaining steps

## No Active Loop

If no loop is active:

```
📊 KSTAR Status

No active KSTAR loop.

Recent experiences:
- [uuid] Add JWT auth (2 hours ago) ✅
- [uuid] Fix user validation (yesterday) ✅

Use /kstar:start <task> to begin a new loop.
```
