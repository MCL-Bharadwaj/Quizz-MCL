-- Class Instance Table DDL
-- Represents individual class sessions/meetings

CREATE TABLE IF NOT EXISTS lms.class_instances (
    instance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    classroom_id UUID NOT NULL REFERENCES lms.classrooms(classroom_id) ON DELETE CASCADE,
    instance_number INTEGER NOT NULL, -- Sequential number within the classroom
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    actual_start_time TIMESTAMP WITH TIME ZONE,
    actual_end_time TIMESTAMP WITH TIME ZONE,
    conducting_tutor_id UUID NOT NULL REFERENCES lms.tutors(tutor_id),
    assistant_tutor_id UUID REFERENCES lms.tutors(tutor_id),
    session_title VARCHAR(200),
    session_description TEXT,
    learning_objectives TEXT,
    location VARCHAR(200),
    meeting_url TEXT,
    recording_url TEXT,
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'In Progress', 'Completed', 'Cancelled', 'Postponed')),
    attendance_required BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Ensure unique instance number per classroom
    UNIQUE(classroom_id, instance_number),
    -- Ensure end_time is after start_time
    CONSTRAINT chk_instance_times CHECK (end_time > start_time)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_class_instances_classroom ON lms.class_instances(classroom_id);
CREATE INDEX IF NOT EXISTS idx_class_instances_date ON lms.class_instances(session_date);
CREATE INDEX IF NOT EXISTS idx_class_instances_tutor ON lms.class_instances(conducting_tutor_id);
CREATE INDEX IF NOT EXISTS idx_class_instances_status ON lms.class_instances(status);