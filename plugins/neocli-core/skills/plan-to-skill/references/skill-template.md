# Skill Template

Template for generating reusable skills from KSTAR experiences.

## SKILL.md Template

```markdown
---
name: [Skill Name]
description: This skill should be used when [trigger phrase 1], [trigger phrase 2], [trigger phrase 3]. [Brief description of what it does].
version: 0.1.0
generated_from: [experience_id]
original_task: [task.intent]
reuse_confidence: [learning.reuse_confidence]
---

# [Skill Name]

## Overview

[2-3 sentence description of what this skill accomplishes and when to use it]

## Trigger Conditions

This skill applies when the user:
- [Trigger condition 1 from task.intent]
- [Trigger condition 2 from keywords]
- [Trigger condition 3 from domain]

## Prerequisites

- [Environmental requirement 1]
- [Tool requirement 1]
- [Knowledge requirement 1]

## Process

### Step 1: [Generalized Step Title]

**Action**: [What to do]
**Tool**: [Tool name]
**Parameters**:
- [param_name]: [generalized value or placeholder]

**Expected Outcome**: [What should result]

**Notes**: [Any caveats or variations]

### Step 2: [Next Step Title]

[Continue pattern...]

## Expected Final Result

[Generalized description of successful completion]

## Verification

How to verify the skill was applied correctly:
1. [Verification step 1]
2. [Verification step 2]

## Known Issues & Warnings

### Issue 1: [From learning.delta]
**Problem**: [What went wrong originally]
**Prevention**: [How to avoid it]

### Issue 2: [If applicable]
...

## Recommendations

[From learning.recommendation - advice for future applications]

## Variations

### Variation A: [Different context]
[How the skill applies differently]

### Variation B: [Alternative approach]
[When to use alternative]

## Origin

- **Generated from**: [experience_id]
- **Original task**: [task.intent]
- **Original status**: [result.status]
- **Reuse confidence**: [learning.reuse_confidence]
- **Created**: [metadata.created_at]
```

## Parameter Placeholders

Use these standard placeholders for generalization:

| Placeholder | Meaning |
|-------------|---------|
| `[file-path]` | Any file path |
| `[directory]` | Any directory |
| `[resource-name]` | Name of resource (user, post, etc.) |
| `[test-command]` | Project's test runner |
| `[build-command]` | Project's build command |
| `[ext]` | File extension (ts, js, py, etc.) |
| `[framework]` | Framework being used |
| `[middleware-name]` | Name for middleware |

## Trigger Phrase Guidelines

Good trigger phrases are:
- Specific enough to match intent
- General enough to apply broadly
- Action-oriented (verbs)
- Domain-relevant (nouns)

Example triggers for "Add JWT authentication":
- "add authentication"
- "implement JWT"
- "auth middleware"
- "protect routes"
- "token validation"
