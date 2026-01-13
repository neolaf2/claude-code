---
name: Plan to Skill Conversion
description: This skill should be used when the user asks to "save plan as skill", "convert plan to skill", "generalize this workflow", "make this reusable", or wants to turn a successful KSTAR experience into a reusable Claude Code skill. Provides methodology for extracting generalizable patterns from execution plans.
version: 0.1.0
---

# Plan to Skill Conversion

Convert successful KSTAR plans into reusable Claude Code skills that can be automatically triggered for similar future tasks.

## When to Convert

Convert a plan to a skill when:
- `result.status` = success or partial (with high confidence)
- `learning.reuse_confidence` >= 0.7
- Plan steps are generalizable (not project-specific)
- Pattern likely to recur

## Conversion Process

### 1. Analyze Plan for Generalizability

Identify:
- **Fixed parts**: Steps that always apply (e.g., "run tests")
- **Parameterized parts**: Project-specific values (e.g., file paths)
- **Optional parts**: Steps that apply conditionally

### 2. Extract Trigger Conditions

From the original task, identify trigger phrases:
- Task intent keywords
- Problem domain terms
- Action verbs used

Example: "Add JWT authentication" → triggers: "add authentication", "implement JWT", "auth middleware"

### 3. Generalize Steps

Replace specific values with parameters:

Before (specific):
```json
{
  "description": "Create auth middleware in src/middleware/auth.ts",
  "tool": "Write",
  "parameters": {"file_path": "src/middleware/auth.ts"}
}
```

After (generalized):
```
Create [middleware-type] middleware in [target-path]
Tool: Write
Parameters: file_path = [middleware-directory]/[middleware-name].ts
```

### 4. Incorporate Lessons

Add warnings and recommendations from `learning`:

```markdown
## Known Issues
- [From learning.delta]: Always validate token expiration
- [From learning.lesson]: Include edge case tests

## Recommendations
[From learning.recommendation]
```

### 5. Generate Skill Structure

Create skill directory:

```
skills/generated-skill-name/
├── SKILL.md
├── references/
│   └── original-experience.md
└── examples/
    └── usage-example.md
```

## Skill Template

```markdown
---
name: [Generated Skill Name]
description: This skill should be used when [trigger conditions]. [Brief what it does].
version: 0.1.0
generated_from: [experience_id]
---

# [Skill Name]

## Overview
[What this skill accomplishes]

## When to Use
[Trigger conditions from original task]

## Process

### Step 1: [Generalized description]
- Tool: [Tool]
- Parameters: [Parameterized]
- Expected: [Expected output pattern]

### Step 2: ...

## Expected Result
[Generalized expected result]

## Known Issues
[From learning.delta and learning.lesson]

## Recommendations
[From learning.recommendation]

## Origin
Generated from experience [experience_id]
Original task: [task.intent]
Reuse confidence: [learning.reuse_confidence]
```

## Generalization Rules

### Rule 1: Replace Specifics with Parameters
| Specific | Parameter |
|----------|-----------|
| `src/routes/users.ts` | `[routes-directory]/[resource].ts` |
| `npm test` | `[test-command]` |
| `UserController` | `[ResourceName]Controller` |

### Rule 2: Keep Tool Sequences
If a tool sequence consistently works, preserve it:
```
Read → Write → Edit → Bash(test)
```

### Rule 3: Preserve Deviation Lessons
Any deviation with severity >= medium should become a warning in the skill.

### Rule 4: Set Confidence Threshold
Only skills with reuse_confidence >= 0.7 should be auto-generated.

## Example Conversion

### Original Experience

```json
{
  "task": { "intent": "Add JWT authentication middleware" },
  "plan": {
    "strategy": "TDD approach",
    "steps": [
      { "description": "Write auth tests", "tool": "Write", "expected_output": "3 test cases" },
      { "description": "Implement middleware", "tool": "Write", "expected_output": "verify() function" },
      { "description": "Apply to routes", "tool": "Edit", "expected_output": "Middleware applied" },
      { "description": "Run tests", "tool": "Bash", "expected_output": "All tests pass" }
    ]
  },
  "learning": {
    "lesson": "Always test expired tokens",
    "recommendation": "Include expiration tests in initial plan",
    "reuse_confidence": 0.85
  }
}
```

### Generated Skill

```markdown
---
name: Authentication Middleware
description: This skill should be used when "add authentication", "implement auth middleware", "JWT middleware", or "protect routes". Guides TDD implementation of authentication middleware.
version: 0.1.0
generated_from: 550e8400-e29b-41d4-a716-446655440000
---

# Authentication Middleware

## Overview
Implement authentication middleware using TDD approach.

## Process

### Step 1: Write authentication tests
- Tool: Write
- File: [test-directory]/auth.test.[ext]
- Expected: Test cases for valid, invalid, missing, AND expired tokens

### Step 2: Implement middleware
- Tool: Write
- File: [middleware-directory]/auth.[ext]
- Expected: Middleware with verify() function

### Step 3: Apply to routes
- Tool: Edit
- Target: [routes-file]
- Expected: Middleware applied to protected endpoints

### Step 4: Run tests
- Tool: Bash
- Command: [test-command]
- Expected: All tests pass

## Known Issues
- Token expiration was missed in original implementation
- Always include expired token test case

## Recommendations
- Include expiration tests in initial plan
- Test all auth edge cases before implementation
```

## Additional Resources

See `references/skill-template.md` for the complete skill template.
