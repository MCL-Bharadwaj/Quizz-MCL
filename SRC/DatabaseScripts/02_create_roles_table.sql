CREATE TABLE IF NOT EXISTS lms.roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert default roles (only if they don't already exist)
INSERT INTO lms.roles (role_name, role_description)
VALUES
    ('Student', 'Students enrolled in classes'),
    ('Tutors', 'Teachers/Tutors conducting classes'),
    ('Parent', 'Parents/Guardians of students'),
    ('Content Creator', 'Users who create and manage program content'),
    ('Administrator', 'System administrators with full access');

-- Ignore duplicates manually if re-run
ALTER TABLE lms.roles ADD CONSTRAINT unique_role_name UNIQUE (role_name);


-- Create indexes for performance (only if they don't already exist)
CREATE INDEX IF NOT EXISTS idx_roles_name ON lms.roles(role_name);
CREATE INDEX IF NOT EXISTS idx_roles_active ON lms.roles(is_active);         