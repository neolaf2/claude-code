# Deviation Patterns

Guide for classifying deviations between expected and actual outcomes.

## Deviation Types

| Type | Definition | Example |
|------|------------|---------|
| `none` | Outcome matches expectation exactly | Expected 3 tests, got 3 tests |
| `enhancement` | Outcome exceeds expectation positively | Expected basic auth, got auth + refresh tokens |
| `partial_failure` | Some criteria met, some not | 4/5 tests pass |
| `failure` | Outcome does not meet criteria | Build fails, tests error |
| `unexpected_success` | Expected failure but succeeded | Edge case worked without handling |

## Severity Levels

| Severity | Criteria | Action |
|----------|----------|--------|
| `low` | Minor deviation, goal achieved | Record only |
| `medium` | Notable deviation, goal partially achieved | Pattern aggregation |
| `high` | Significant deviation, goal not achieved | Immediate lesson extraction |

## Classification Matrix

| Deviation Type | Goal Achieved | Severity |
|---------------|---------------|----------|
| none | Yes | low |
| enhancement | Yes+ | low |
| partial_failure | Partial | medium |
| failure | No | high |
| unexpected_success | Yes (surprising) | medium |

## Common Patterns

### Pattern: Missing Edge Cases
- **Symptom**: Main path works, edge cases fail
- **Deviation**: partial_failure / medium
- **Lesson**: Add edge case tests to plan

### Pattern: Over-Engineering
- **Symptom**: Task complete but took longer than expected
- **Deviation**: enhancement / low
- **Lesson**: Scope creep detection

### Pattern: Environment Mismatch
- **Symptom**: Works locally, fails in different env
- **Deviation**: failure / high
- **Lesson**: Environment constraints in situation capture

### Pattern: Dependency Surprise
- **Symptom**: External dependency behaves unexpectedly
- **Deviation**: failure / high
- **Lesson**: Add dependency verification step to plan

## Learning Triggers

| Trigger Condition | Action |
|-------------------|--------|
| severity = high | Immediate lesson extraction |
| severity = medium, count >= 3 | Pattern aggregation |
| severity = low | Record only |
| reuse_confidence < 0.5 | Mark for review |
| same deviation 3+ times | Create preventive skill |
