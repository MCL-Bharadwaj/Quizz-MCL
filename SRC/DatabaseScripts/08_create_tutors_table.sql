-- Tutor Table DDL
-- Stores tutor/teacher information linked to users

CREATE TABLE IF NOT EXISTS lms.tutors (
    tutor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES lms.users(user_id) ON DELETE CASCADE,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    termination_date DATE,
    department VARCHAR(100),
    title VARCHAR(100),
    qualifications VARCHAR(255),
    specializations VARCHAR(255),
    years_of_experience INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10, 2),
    is_full_time BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    -- max_students_per_class INTEGER DEFAULT 6,
    preferred_subjects VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_tutors_user_id ON lms.tutors(user_id);
CREATE INDEX idx_tutors_employee_id ON lms.tutors(employee_id);
CREATE INDEX idx_tutors_available ON lms.tutors(is_available);
CREATE INDEX idx_tutors_department ON lms.tutors(department);
CREATE INDEX idx_tutors_hire_date ON lms.tutors(hire_date);