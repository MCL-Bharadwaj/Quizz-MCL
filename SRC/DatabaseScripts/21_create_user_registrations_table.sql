-- User Registrations Table DDL
-- Stores all registration form submissions for audit trail

CREATE TABLE IF NOT EXISTS lms.user_registrations (
    -- Primary key
    registration_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- User type
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('student', 'tutor', 'parent')),
    
    -- Basic user information (from frontend form)
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other', 'Prefer not to say')),
    
    -- Address information (from frontend form)
    address1 VARCHAR(100),
    address2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    
    -- Role-specific data as JSON
    student_data JSONB,
    tutor_data JSONB,
    parent_data JSONB,
    
    -- Link to created user
    user_id UUID REFERENCES lms.users(user_id) ON DELETE SET NULL,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_registrations_email ON lms.user_registrations(email);
CREATE INDEX IF NOT EXISTS idx_user_registrations_user_type ON lms.user_registrations(user_type);
CREATE INDEX IF NOT EXISTS idx_user_registrations_user_id ON lms.user_registrations(user_id);
CREATE INDEX IF NOT EXISTS idx_user_registrations_created_at ON lms.user_registrations(created_at DESC);
