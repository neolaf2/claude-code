---
description: Semantic search for relevant KSTAR experiences
argument-hint: <query> [--limit N] [--min-confidence 0.7]
---

# Search KSTAR Experiences

Find relevant prior experiences using semantic search. Returns experiences similar to the query based on situation, task, and lessons learned.

## Process

### 1. Parse Arguments

Extract from `$ARGUMENTS`:
- `query`: The search query text
- `--limit N`: Max results (default: 5)
- `--min-confidence`: Minimum similarity threshold (default: 0.7)

### 2. Generate Query Embedding

Create embedding vector from the query text for semantic comparison.

### 3. Search Supabase

Use the `kstar-memory` MCP server with vector similarity:

```sql
SELECT
  experience_id,
  task_intent,
  result_status,
  learning_lesson,
  learning_recommendation,
  learning_reuse_confidence,
  tags,
  created_at,
  1 - (embedding <=> $query_embedding) as similarity
FROM kstar_experiences
WHERE 1 - (embedding <=> $query_embedding) > $min_confidence
ORDER BY embedding <=> $query_embedding
LIMIT $limit;
```

### 4. Format Results

Display matching experiences ranked by relevance:

```
🔍 Search Results for: "jwt authentication"

Found 3 relevant experiences:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. 📋 Add JWT authentication middleware
   🔑 ID: 550e8400-e29b-41d4-a716-446655440000
   📊 Similarity: 94%
   ✅ Status: partial

   💡 Lesson: Always include token expiration validation
   📝 Recommendation: Include expired token test cases

   🏷️  Tags: authentication, jwt, middleware

   → /kstar:recall 550e8400-...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

2. 📋 Implement OAuth2 flow
   🔑 ID: 661f9511-f30c-52e5-b827-557766551111
   📊 Similarity: 78%
   ✅ Status: success

   💡 Lesson: Use state parameter to prevent CSRF
   📝 Recommendation: Always validate redirect URIs

   🏷️  Tags: authentication, oauth, security

   → /kstar:recall 661f9511-...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. 📋 Add API key authentication
   🔑 ID: 772a0622-g41d-63f6-c938-668877662222
   📊 Similarity: 71%
   ✅ Status: success

   💡 Lesson: Rate limit by API key, not just IP
   📝 Recommendation: Add key rotation mechanism

   🏷️  Tags: authentication, api-key, rate-limiting

   → /kstar:recall 772a0622-...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Applicable Lessons for Current Task:
1. Include token expiration tests (94% match)
2. Use state parameter for CSRF prevention (78% match)
3. Consider rate limiting by auth mechanism (71% match)
```

### 5. No Results

If no matches found:

```
🔍 Search Results for: "quantum computing optimization"

No matching experiences found.

Try:
- Broader search terms
- Lower --min-confidence threshold
- Check /kstar:status for recent experiences
```

## Usage Examples

```bash
# Basic search
/kstar:search "authentication middleware"

# With result limit
/kstar:search "database migration" --limit 10

# Lower confidence threshold
/kstar:search "performance optimization" --min-confidence 0.5
```
