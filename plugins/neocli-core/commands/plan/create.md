---
description: Generate an explicit action plan with expected outcomes
argument-hint: <task description>
---

# Create Plan

Generate a detailed, step-by-step action plan with expected outcomes for each step. This is Stage 3 of the KSTAR loop, but can be used independently.

## Process

### 1. Understand the Task

From `$ARGUMENTS`, analyze:
- What needs to be accomplished
- What constraints exist
- What resources are available

### 2. Check for Prior Experience

Search for relevant KSTAR experiences:
```
/kstar:search <task keywords>
```

If matching experiences found with high confidence:
- Review their plans and lessons
- Incorporate applicable patterns
- Avoid known issues

### 3. Generate Plan

Use the `plan-generator` agent to create:

```json
{
  "strategy": "Overall approach",
  "steps": [
    {
      "step_id": "1",
      "description": "What to do",
      "tool": "Tool name",
      "parameters": {},
      "expected_output": "Verifiable outcome"
    }
  ],
  "expected_result": "Final outcome"
}
```

### 4. Display Plan

Show the plan in readable format:

```
📝 Plan: [Task summary]

Strategy: [Overall approach]

Steps:
1. [Description]
   Tool: [Tool]
   Expected: [Expected output]

2. [Description]
   Tool: [Tool]
   Expected: [Expected output]

...

Expected Result: [Final outcome]

Applied lessons from prior experiences:
- [Lesson 1 if applicable]
- [Lesson 2 if applicable]
```

### 5. Offer Options

After displaying plan:
- **Execute**: Start executing the plan (begins KSTAR loop)
- **Refine**: Modify the plan before execution
- **Save**: Save plan for later (without executing)

## Example

```
/plan:create Add input validation to user registration

📝 Plan: Add input validation to user registration

Strategy: Create validation schema, integrate with route, add tests

Steps:
1. Read current registration implementation
   Tool: Read
   Expected: Understand request structure

2. Create validation schema
   Tool: Write
   File: src/validators/registration.ts
   Expected: Zod schema for email, password, name

3. Integrate validation middleware
   Tool: Edit
   File: src/routes/auth.ts
   Expected: Route validates input, returns 400 on invalid

4. Add validation tests
   Tool: Write
   File: tests/validation.test.ts
   Expected: Tests for valid/invalid inputs

5. Run tests
   Tool: Bash
   Command: npm test
   Expected: All tests pass

Expected Result: Registration validates input, returns helpful errors

🎯 Ready to execute?
- /kstar:start [executes this plan]
- /plan:create [refine requirements]
```

## Without KSTAR

This command can be used standalone to generate plans without entering a full KSTAR loop. The plan can be:
- Executed manually
- Saved for reference
- Used as a starting point for discussion
