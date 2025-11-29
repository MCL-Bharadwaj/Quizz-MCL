-- Classroom Table DDL
-- Stores information about classrooms/classes


CREATE TABLE lms.classrooms (
    classroom_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    classroom_name VARCHAR(200) NOT NULL,
    classroom_code VARCHAR(50) UNIQUE NOT NULL,
    program_id UUID NOT NULL REFERENCES lms.programs(program_id) ON DELETE CASCADE,
    primary_tutor_id UUID NOT NULL REFERENCES lms.tutors(tutor_id),
    secondary_tutor_id UUID REFERENCES lms.tutors(tutor_id),
    room_number VARCHAR(50),
    capacity INTEGER NOT NULL DEFAULT 20,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    schedule_days VARCHAR(20) NOT NULL, -- e.g., 'Mon,Wed,Fri' or 'Daily'
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    timezone VARCHAR(50) DEFAULT 'UTC',
    is_online BOOLEAN DEFAULT FALSE,
    meeting_url TEXT,
    status VARCHAR(20) DEFAULT 'Planned' CHECK (status IN ('Planned', 'Active', 'Completed', 'Cancelled', 'Postponed')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Ensure end_date is after start_date
    CONSTRAINT chk_classroom_dates CHECK (end_date >= start_date),
    -- Ensure end_time is after start_time
    CONSTRAINT chk_classroom_times CHECK (end_time > start_time)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_classrooms_code ON lms.classrooms(classroom_code);
CREATE INDEX IF NOT EXISTS idx_classrooms_program_id ON lms.classrooms(program_id);
CREATE INDEX IF NOT EXISTS idx_classrooms_primary_tutor ON lms.classrooms(primary_tutor_id);
CREATE INDEX IF NOT EXISTS idx_classrooms_status ON lms.classrooms(status);
CREATE INDEX IF NOT EXISTS idx_classrooms_dates ON lms.classrooms(start_date, end_date);