---
description: Convert a KSTAR plan/experience into a reusable skill
argument-hint: [--name <skill-name>] [--from <experience-id>]
---

# Save Plan as Skill

Convert a successful KSTAR experience into a reusable Claude Code skill that can be automatically triggered for similar future tasks.

## Process

### 1. Determine Source

- No args: Use current active loop from `.claude/neocli-kstar.local.md`
- `--from <id>`: Retrieve experience from Supabase by ID
- `--name <name>`: Override generated skill name

### 2. Validate Eligibility

Check that experience meets criteria:
- `result.status` is 'success' or 'partial'
- `learning.reuse_confidence` >= 0.7
- Plan has generalizable steps (not all project-specific)

If criteria not met, warn user and offer to proceed anyway.

### 3. Analyze for Generalization

Identify:
- Fixed patterns (always apply)
- Parameterized elements (project-specific → placeholders)
- Learned warnings (from deviations)

### 4. Extract Triggers

From `task.intent`, extract trigger phrases for skill description:
- Action verbs (add, implement, create, fix)
- Domain nouns (authentication, validation, API)
- Technology terms (JWT, REST, middleware)

### 5. Generate Skill

Create skill directory structure:

```
.claude/skills/[skill-name]/
├── SKILL.md
└── references/
    └── original-experience.md
```

Use the plan-to-skill skill methodology to:
- Generalize step descriptions
- Add parameter placeholders
- Incorporate lessons as warnings
- Set trigger phrases in description

### 6. Confirm Creation

Display:
- Skill location
- Trigger phrases
- Summary of generalized steps
- Warnings incorporated

## Output

```
✅ Skill Created

📁 Location: .claude/skills/auth-middleware/SKILL.md

🎯 Triggers:
- "add authentication"
- "implement JWT"
- "auth middleware"

📝 Steps:
1. Write authentication tests
2. Implement middleware
3. Apply to routes
4. Run tests

⚠️ Warnings Incorporated:
- Always test expired tokens (from learning)

📊 Origin:
- Experience: 550e8400-...
- Confidence: 85%

The skill will auto-trigger when similar tasks are requested.
```

## Example

```
/plan:save --name auth-middleware

Converting experience to reusable skill...

Analyzed:
- 4 plan steps (3 generalizable, 1 fixed)
- 1 deviation lesson incorporated
- 85% reuse confidence

Generated triggers:
- "add authentication"
- "implement auth"
- "JWT middleware"

Created: .claude/skills/auth-middleware/SKILL.md

✅ Skill ready for reuse!
```

## Notes

- Skills are saved to project's `.claude/skills/` directory
- They become available for future sessions in this project
- High-confidence skills can be promoted to user-global (`~/.claude/skills/`)
- Consider reviewing generated skill before relying on it
