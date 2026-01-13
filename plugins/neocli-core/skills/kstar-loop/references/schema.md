# KSTAR JSON Schema

Complete schema for KSTAR experience records stored in Supabase.

## Top-Level Structure

```json
{
  "kstar_version": "1.0",
  "experience_id": "uuid",
  "agent": {},
  "situation": {},
  "task": {},
  "plan": {},
  "execution": {},
  "result": {},
  "learning": {},
  "metadata": {}
}
```

## Agent Identity

```json
"agent": {
  "agent_id": "string",
  "agent_name": "string",
  "agent_version": "string",
  "role": "string"
}
```

Identifies who learned this experience. Supports multi-agent shared memory.

## Situation (S)

```json
"situation": {
  "context": "string",
  "environment": {
    "os": "string",
    "runtime": "string",
    "channel": "string"
  },
  "constraints": ["string"],
  "inputs": {}
}
```

What the world looked like when the task started.

## Task (T)

```json
"task": {
  "task_id": "string",
  "intent": "string",
  "success_criteria": ["string"],
  "priority": "low | medium | high",
  "deadline": "ISO-8601 | null"
}
```

What the agent was trying to accomplish.

## Action Plan (Â)

```json
"plan": {
  "strategy": "string",
  "steps": [
    {
      "step_id": "string",
      "description": "string",
      "tool": "string",
      "parameters": {},
      "expected_output": "string"
    }
  ],
  "expected_result": "string"
}
```

Plans are explicit, inspectable, and replayable.

## Execution (A)

```json
"execution": {
  "start_time": "ISO-8601",
  "end_time": "ISO-8601",
  "steps_executed": [
    {
      "step_id": "string",
      "tool_used": "string",
      "actual_parameters": {},
      "output": "string",
      "status": "success | failure | partial"
    }
  ]
}
```

What actually happened during execution.

## Result (R)

```json
"result": {
  "status": "success | failure | partial",
  "actual_result": "string",
  "deviation": "none | minor | major",
  "error": "string | null"
}
```

Enables forecast vs. reality comparison.

## Learning Outcome (Δ)

```json
"learning": {
  "delta": "string",
  "lesson": "string",
  "recommendation": "string",
  "reuse_confidence": 0.0
}
```

What changed in the agent's future behavior.

## Metadata

```json
"metadata": {
  "created_at": "ISO-8601",
  "updated_at": "ISO-8601",
  "tags": ["string"],
  "related_experiences": ["uuid"],
  "embedding_id": "string | null"
}
```

## Minimal KSTAR (MVP)

For early systems, this minimum subset is valid:

```json
{
  "experience_id": "uuid",
  "situation": { "context": "string" },
  "task": { "intent": "string" },
  "plan": { "steps": [] },
  "result": { "status": "success | failure" }
}
```

## Supabase Table Schema

```sql
CREATE TABLE kstar_experiences (
  experience_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id TEXT NOT NULL,
  agent_name TEXT NOT NULL,
  agent_version TEXT NOT NULL,
  agent_role TEXT,

  situation_context TEXT,
  situation_environment JSONB,
  situation_constraints JSONB,
  situation_inputs JSONB,

  task_id UUID,
  task_intent TEXT NOT NULL,
  task_success_criteria JSONB,
  task_priority TEXT,
  task_deadline TIMESTAMPTZ,

  plan_strategy TEXT,
  plan_steps JSONB,
  plan_expected_result JSONB,

  execution_start_time TIMESTAMPTZ,
  execution_end_time TIMESTAMPTZ,
  execution_steps JSONB,

  result_status TEXT,
  result_actual JSONB,
  result_deviation JSONB,
  result_error TEXT,

  learning_delta TEXT,
  learning_lesson TEXT,
  learning_recommendation TEXT,
  learning_reuse_confidence DECIMAL(3,2),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  tags TEXT[],
  related_experiences UUID[],
  embedding VECTOR(1536)
);

CREATE INDEX idx_experiences_agent ON kstar_experiences(agent_id);
CREATE INDEX idx_experiences_status ON kstar_experiences(result_status);
CREATE INDEX idx_experiences_created ON kstar_experiences(created_at);
CREATE INDEX idx_experiences_tags ON kstar_experiences USING GIN(tags);
CREATE INDEX idx_experiences_embedding ON kstar_experiences
  USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```
