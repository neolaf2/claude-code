---
description: Retrieve a KSTAR experience by ID
argument-hint: <experience-id>
---

# Recall KSTAR Experience

Retrieve a specific experience record from memory by its ID.

## Process

### 1. Validate Input

Check that `$1` is a valid UUID format:

```bash
if [[ ! "$1" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
  echo "Invalid experience ID format. Expected UUID."
  exit 1
fi
```

### 2. Query Supabase

Use the `kstar-memory` MCP server:

```sql
SELECT * FROM kstar_experiences
WHERE experience_id = $1;
```

### 3. Format Output

Display the experience in readable format:

```
📋 KSTAR Experience: 550e8400-e29b-41d4-a716-446655440000

📅 Created: 2024-01-15 10:45:00 UTC
🤖 Agent: NeoCLI Core v0.1.0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 SITUATION
   Context: TypeScript REST API project with Express.js
   Environment: darwin / node-20.10.0 / cli
   Constraints:
   - Maintain backward compatibility
   - All existing tests must pass

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 TASK
   Intent: Add JWT authentication middleware
   Priority: high

   Success Criteria:
   ✓ JWT validation middleware created
   ✓ Protected routes return 401 without token
   ✓ Protected routes return data with token
   ✓ All existing tests pass
   ✗ New tests cover auth scenarios (partial)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 PLAN
   Strategy: TDD approach - write failing tests first

   Steps:
   1. Write auth tests → ✅ 3 test cases created
   2. Create JWT middleware → ✅ auth.ts created
   3. Apply to routes → ✅ Middleware applied
   4. Run tests → ⚠️ 22/23 passed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 RESULT
   Status: partial
   Deviation: minor

   Expected: All tests pass
   Actual: Expired token edge case not handled

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 LEARNING
   Delta: JWT expiration checking was not included

   Lesson: Always include token expiration validation
   when implementing JWT auth.

   Recommendation: Future JWT implementations should
   include expired token test cases in initial plan.

   Reuse Confidence: 85%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🏷️  Tags: authentication, jwt, middleware, typescript, tdd
🔗 Related: (none)
```

### 4. Not Found

If experience doesn't exist:

```
❌ Experience not found: 550e8400-e29b-41d4-a716-446655440000

Try:
- /kstar:search <keywords> to find related experiences
- /kstar:status to see recent experiences
```
