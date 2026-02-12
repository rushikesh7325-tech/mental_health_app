-- Enable UUID extension for secure identifiers
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table (Core information)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    password_hash TEXT NOT NULL,
    user_type VARCHAR(20) CHECK (user_type IN ('personal', 'university', 'company')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. University Data (Linked to University flow)
CREATE TABLE university_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    university_name VARCHAR(255) NOT NULL,
    verification_code VARCHAR(50),
    is_verified BOOLEAN DEFAULT FALSE
);

-- 3. Company Data (Linked to Company flow)
CREATE TABLE company_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    company_name VARCHAR(255) NOT NULL,
    role VARCHAR(100),
    org_code VARCHAR(50),
    is_verified BOOLEAN DEFAULT FALSE
);