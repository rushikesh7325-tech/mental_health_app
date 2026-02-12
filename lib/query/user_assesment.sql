CREATE TABLE user_assessments (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL, -- Reference to your auth table
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Step 2: Mood
    mood_state TEXT,

    -- Step 3: Primary Challenges
    primary_challenges TEXT[],

    -- Step 4: Coping Mechanisms (Stored as JSONB for the Boolean Map)
    coping_mechanisms JSONB,

    -- Step 5: Support Level
    support_level_score INTEGER,

    -- Step 6: Sleep Patterns
    sleep_patterns JSONB, -- Stores {"hours": "6", "quality": "Fair"}

    -- Step 7: Physical Activity
    physical_activity_frequency TEXT,

    -- Step 8: Mindfulness Routine
    mindfulness_routine JSONB, -- Stores score, label, and details

    -- Step 9: Stress Sources
    stress_sources TEXT[],

    -- Step 10: Stress Locations
    stress_locations TEXT[],

    -- Step 11: Barriers to Entry
    barriers_to_entry TEXT[],

    -- Step 12: Learning Preferences
    learning_preferences JSONB, -- Stores index and label

    -- Step 13: Weekly Commitment
    weekly_commitment TEXT,

    -- Step 14: Open Sharing
    open_reflection TEXT,

    -- Step 15: Selected Insights
    selected_insights TEXT[]
);

-- Indexing for performance
CREATE INDEX idx_user_assessments_user_id ON user_assessments(user_id);