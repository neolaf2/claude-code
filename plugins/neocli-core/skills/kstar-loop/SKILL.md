---
name: KSTAR Learning Loop
description: This skill should be used when the user asks to "start a KSTAR loop", "learn from execution", "plan with expectations", "record experience", "compare expected vs actual", "retrieve past experiences", or mentions learning loops, adaptive behavior, experience memory, plan-driven execution, or structured learning. Provides the complete KSTAR methodology for self-improving agent behavior.
version: 0.1.0
---

# KSTAR Learning Loop

KSTAR is a 7-stage closed learning loop that enables adaptive behavior through structured experience recording and retrieval. Every task execution produces reusable experience.

## The 7 Stages

| Stage | Name | Purpose |
|-------|------|---------|
| 1 | **Situation** | Capture context, environment, constraints |
| 2 | **Task** | Define intent, success criteria |
| 3 | **Plan** | Generate steps with expected outcomes |
| 4 | **Execute** | Run plan, record actual outcomes |
| 5 | **Compare** | Expected vs actual, classify deviation |
| 6 | **Record** | Persist experience to memory |
| 7 | **Learn** | Extract lessons, update recommendations |

## Stage 1: Situation Capture

Normalize incoming request into structured situation:

```json
{
  "context": "Working on TypeScript REST API project",
  "environment": {
    "os": "darwin",
    "runtime": "node-20",
    "channel": "cli"
  },
  "constraints": ["Maintain backward compatibility", "Tests must pass"],
  "inputs": { "user_request": "...", "relevant_files": [...] }
}
```

Key questions to answer:
- What is the current working context?
- What environmental factors affect execution?
- What constraints must be satisfied?

## Stage 2: Task Definition

Define the task with measurable success criteria:

```json
{
  "task_id": "uuid",
  "intent": "Add JWT authentication middleware",
  "success_criteria": [
    "JWT validation works for protected routes",
    "Unauthenticated requests return 401",
    "All existing tests pass"
  ],
  "priority": "high",
  "deadline": null
}
```

The intent must be specific and actionable. Success criteria must be verifiable.

## Stage 3: Plan Generation

Create explicit action plan with expected outcomes for each step:

```json
{
  "strategy": "TDD approach - write failing tests first",
  "steps": [
    {
      "step_id": "1",
      "description": "Write auth middleware tests",
      "tool": "Write",
      "parameters": { "file_path": "tests/auth.test.ts" },
      "expected_output": "3 test cases, all failing"
    },
    {
      "step_id": "2",
      "description": "Implement JWT validation",
      "tool": "Write",
      "parameters": { "file_path": "src/middleware/auth.ts" },
      "expected_output": "Middleware with verify() function"
    }
  ],
  "expected_result": "All tests pass, auth working"
}
```

Plans are explicit, inspectable, and replayable.

## Stage 4: Execution

Execute plan step-by-step, recording actual outcomes:

For each step:
1. Log the planned action to state file
2. Execute using the specified tool
3. Capture actual output/outcome
4. Compare to expected output
5. Record in execution trace

State persists in `.claude/neocli-kstar.local.md`.

## Stage 5: Comparison

Compare expected vs actual for each step and overall:

```json
{
  "step_deviations": [
    {
      "step_id": "2",
      "expected": "Middleware with verify() function",
      "actual": "Created with verify() plus helper utils",
      "deviation_type": "enhancement",
      "severity": "low"
    }
  ],
  "overall": {
    "expected": "All tests pass",
    "actual": "4/5 tests pass",
    "deviation_type": "partial_failure",
    "severity": "medium"
  }
}
```

Deviation types: `none`, `enhancement`, `partial_failure`, `failure`, `unexpected_success`
Severity: `low`, `medium`, `high`

## Stage 6: Record

Persist complete experience to Supabase via MCP:

Use the `kstar-memory` MCP server to store the structured experience record containing all stages. See `references/schema.md` for the complete JSON schema.

The experience includes:
- Agent identity
- Situation and task
- Plan with all steps
- Execution trace with actual outcomes
- Comparison results
- Learning outcomes

## Stage 7: Learn

Extract lessons from deviations:

```json
{
  "delta": "JWT edge case handling needed",
  "lesson": "Always test expired tokens and malformed headers",
  "recommendation": "Add edge case tests before implementation",
  "reuse_confidence": 0.85
}
```

Learning triggers:
- **severity = high**: Immediate lesson extraction
- **severity = medium**: Pattern aggregation (3+ similar)
- **severity = low**: Record only

## State File Format

KSTAR loop state persists in `.claude/neocli-kstar.local.md`:

```markdown
---
active: true
experience_id: "uuid"
current_stage: 3
iteration: 1
started_at: "2024-01-15T10:30:00Z"
agent:
  agent_id: "neocli-v0"
  agent_name: "NeoCLI Core"
---

# Situation
[Captured situation]

# Task
[Task definition]

# Plan
[Current plan]

# Execution Log
[Step-by-step execution record]
```

## Reuse & Retrieval

Before generating new plans, search for relevant prior experiences:

1. Query by semantic similarity to current situation/task
2. Apply lessons from matching experiences
3. Prefer proven plans over generating new ones
4. Adjust confidence based on context similarity

Use `/kstar:search <query>` to find relevant experiences.

## Commands

- `/kstar:start <task>` - Begin new KSTAR loop
- `/kstar:status` - View current loop state
- `/kstar:store` - Manually persist current experience
- `/kstar:recall <id>` - Retrieve experience by ID
- `/kstar:search <query>` - Semantic search experiences

## Additional Resources

- `references/schema.md` - Complete KSTAR JSON schema
- `references/deviation-patterns.md` - Deviation classification guide
- `examples/experience.json` - Example complete experience record
