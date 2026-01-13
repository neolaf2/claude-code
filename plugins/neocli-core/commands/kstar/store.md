---
description: Persist current KSTAR experience to memory
argument-hint: [--from-current | --force]
---

# Store KSTAR Experience

Persist the current or completed KSTAR experience to Supabase memory.

## Process

### 1. Determine Source

- `--from-current` or no args: Use active loop from `.claude/neocli-kstar.local.md`
- `--force`: Store even if loop incomplete (for debugging)

### 2. Validate Experience

Check that experience has minimum required data:
- situation.context
- task.intent
- plan.steps (at least one)
- result.status

### 3. Construct Experience JSON

Build the complete experience record from state file:

```json
{
  "kstar_version": "1.0",
  "experience_id": "[from state]",
  "agent": {
    "agent_id": "neocli-v0",
    "agent_name": "NeoCLI Core",
    "agent_version": "0.1.0",
    "role": "user-proxy"
  },
  "situation": { ... },
  "task": { ... },
  "plan": { ... },
  "execution": { ... },
  "result": { ... },
  "learning": { ... },
  "metadata": {
    "created_at": "[now]",
    "tags": "[extracted from context]"
  }
}
```

### 4. Generate Embedding

Create embedding for semantic search:
- Combine: situation.context + task.intent + learning.lesson
- Call embedding API or use MCP tool

### 5. Store to Supabase

Use the `kstar-memory` MCP server:

```sql
INSERT INTO kstar_experiences (
  experience_id,
  agent_id, agent_name, agent_version, agent_role,
  situation_context, situation_environment, situation_constraints, situation_inputs,
  task_id, task_intent, task_success_criteria, task_priority,
  plan_strategy, plan_steps, plan_expected_result,
  execution_start_time, execution_end_time, execution_steps,
  result_status, result_actual, result_deviation, result_error,
  learning_delta, learning_lesson, learning_recommendation, learning_reuse_confidence,
  tags, embedding
) VALUES (...)
RETURNING experience_id, created_at;
```

### 6. Update State File

Mark loop as recorded:

```yaml
---
active: false
experience_id: "[uuid]"
current_stage: 7
stored_at: "[timestamp]"
---
```

### 7. Confirm Storage

```
✅ Experience Stored

🔑 ID: 550e8400-e29b-41d4-a716-446655440000
📋 Task: Add JWT authentication
📊 Status: partial (1 deviation)
📚 Lesson: Always test expired tokens

🔍 Retrieve with: /kstar:recall 550e8400
🔎 Search related: /kstar:search "jwt authentication"
```

## Automatic Storage

Normally, storage happens automatically at Stage 6 of the KSTAR loop. This command is for:
- Manual storage after completion
- Debugging incomplete experiences
- Re-storing with corrections
