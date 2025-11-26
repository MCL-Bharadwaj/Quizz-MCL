-- Classroom Enrollments Table DDL
-- Manages student enrollments in classrooms

CREATE TABLE IF NOT EXISTS lms.classroom_enrollments (
    enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    classroom_id UUID NOT NULL REFERENCES lms.classrooms(classroom_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES lms.students(student_id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    enrollment_status VARCHAR(20) DEFAULT 'Active' CHECK (enrollment_status IN ('Active', 'Dropped', 'Completed', 'Withdrawn')),
    enrollment_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique enrollment per student per classroom
    UNIQUE(classroom_id, student_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_classroom_enrollments_classroom ON lms.classroom_enrollments(classroom_id);
CREATE INDEX IF NOT EXISTS idx_classroom_enrollments_student ON lms.classroom_enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_classroom_enrollments_status ON lms.classroom_enrollments(enrollment_status);