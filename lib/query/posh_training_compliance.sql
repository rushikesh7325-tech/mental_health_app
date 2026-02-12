CREATE TABLE posh_training_compliance (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Consent Data
    is_acknowledge_accepted BOOLEAN DEFAULT FALSE,
    consent_timestamp TIMESTAMP WITH TIME ZONE,
    digital_signature TEXT UNIQUE, -- Stores the generated "SIG-..." string

    -- Module Completion Status (Mapping to completedModules map)
    verbal_complete BOOLEAN DEFAULT FALSE,
    physical_complete BOOLEAN DEFAULT FALSE,
    digital_complete BOOLEAN DEFAULT FALSE,
    workplace_complete BOOLEAN DEFAULT FALSE,
    evidence_complete BOOLEAN DEFAULT FALSE,

    -- Audit Logs: Time Spent in Seconds (Mapping to moduleTimeSpent map)
    verbal_time_seconds INTEGER DEFAULT 0,
    physical_time_seconds INTEGER DEFAULT 0,
    digital_time_seconds INTEGER DEFAULT 0,
    workplace_time_seconds INTEGER DEFAULT 0,
    evidence_time_seconds INTEGER DEFAULT 0,

    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for quickly validating a signature during report submission
CREATE INDEX idx_posh_compliance_signature ON posh_training_compliance(digital_signature);