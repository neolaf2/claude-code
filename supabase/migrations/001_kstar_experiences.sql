-- KSTAR Experiences Schema Migration
-- NeoCLI Core Plugin
--
-- Run this migration against your Supabase project:
--   - Local: supabase db reset
--   - Remote: Execute in Supabase Studio SQL Editor

-- Enable pgvector extension for semantic search embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- KSTAR Experiences table
-- Stores structured learning experiences from the KSTAR loop
CREATE TABLE kstar_experiences (
  experience_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Agent identity (who learned this)
  agent_id TEXT NOT NULL,
  agent_name TEXT NOT NULL,
  agent_version TEXT NOT NULL,
  agent_role TEXT,

  -- Situation (S) - What the world looked like
  situation_context TEXT,
  situation_environment JSONB,
  situation_constraints JSONB,
  situation_inputs JSONB,

  -- Task (T) - What we were trying to accomplish
  task_id UUID,
  task_intent TEXT NOT NULL,
  task_success_criteria JSONB,
  task_priority TEXT,
  task_deadline TIMESTAMPTZ,

  -- Plan (Â) - How we planned to do it
  plan_strategy TEXT,
  plan_steps JSONB,
  plan_expected_result JSONB,

  -- Execution (A) - What actually happened
  execution_start_time TIMESTAMPTZ,
  execution_end_time TIMESTAMPTZ,
  execution_steps JSONB,

  -- Result (R) - The outcome
  result_status TEXT,
  result_actual JSONB,
  result_deviation JSONB,
  result_error TEXT,

  -- Learning (Δ) - What we learned
  learning_delta TEXT,
  learning_lesson TEXT,
  learning_recommendation TEXT,
  learning_reuse_confidence DECIMAL(3,2),

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  tags TEXT[],
  related_experiences UUID[],

  -- Vector embedding for semantic search (1536 dimensions for OpenAI embeddings)
  embedding VECTOR(1536)
);

-- Indexes for common queries
CREATE INDEX idx_experiences_agent ON kstar_experiences(agent_id);
CREATE INDEX idx_experiences_status ON kstar_experiences(result_status);
CREATE INDEX idx_experiences_created ON kstar_experiences(created_at);
CREATE INDEX idx_experiences_tags ON kstar_experiences USING GIN(tags);

-- Vector similarity search index (IVFFlat for approximate nearest neighbor)
CREATE INDEX idx_experiences_embedding ON kstar_experiences
  USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Auto-update updated_at timestamp on row modification
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER kstar_experiences_updated_at
  BEFORE UPDATE ON kstar_experiences
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Row Level Security (optional - enable if needed)
-- ALTER TABLE kstar_experiences ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Users can read own experiences" ON kstar_experiences
--   FOR SELECT USING (auth.uid()::text = agent_id);

-- Helpful comments
COMMENT ON TABLE kstar_experiences IS 'KSTAR learning loop experiences - stores structured learning from plan-execute-learn cycles';
COMMENT ON COLUMN kstar_experiences.embedding IS 'Vector embedding for semantic similarity search (1536d for OpenAI ada-002)';
COMMENT ON COLUMN kstar_experiences.learning_reuse_confidence IS 'Confidence score 0.00-1.00 for reusing this experience in similar future tasks';
