-- Class Instance Attendance Table DDL
-- Tracks student attendance for class sessions

CREATE TABLE IF NOT EXISTS lms.class_instance_attendance (
    attendance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES lms.class_instances(instance_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES lms.students(student_id) ON DELETE CASCADE,
    attendance_status VARCHAR(20) DEFAULT 'Present' CHECK (attendance_status IN ('Present', 'Absent', 'Late', 'Excused')),
    arrival_time TIMESTAMP WITH TIME ZONE,
    departure_time TIMESTAMP WITH TIME ZONE,
    participation_score INTEGER CHECK (participation_score >= 0 AND participation_score <= 100),
    notes TEXT,
    marked_by UUID REFERENCES lms.tutors(tutor_id),
    marked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique attendance record per student per instance
    UNIQUE(instance_id, student_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_attendance_instance ON lms.class_instance_attendance(instance_id);
CREATE INDEX IF NOT EXISTS idx_attendance_student ON lms.class_instance_attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_status ON lms.class_instance_attendance(attendance_status);