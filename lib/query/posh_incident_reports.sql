CREATE TABLE posh_incident_reports (
    id SERIAL PRIMARY KEY,
    ref_id VARCHAR(20) UNIQUE NOT NULL, -- Human-readable ID (e.g., POSH-A9X2Z)
    user_id UUID NOT NULL REFERENCES users(id), 
    
    -- Anonymity Toggle
    is_anonymous BOOLEAN DEFAULT TRUE,
    reported_by_name TEXT, -- Stores real name or "ANON_PROTECTED"

    -- Incident Details
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    incident_occurrence TEXT, -- Stores "$date $time" from controller
    location TEXT,

    -- Legal Verification
    compliance_sig TEXT REFERENCES posh_training_compliance(digital_signature),
    training_verified BOOLEAN DEFAULT FALSE, -- isFlowComplete value
    
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for searching specific report references
CREATE INDEX idx_posh_reports_ref_id ON posh_incident_reports(ref_id);