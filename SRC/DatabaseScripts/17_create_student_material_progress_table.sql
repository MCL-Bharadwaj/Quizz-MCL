-- Student Material Progress Table DDL
-- Tracks student progress and submissions for materials

CREATE TABLE IF NOT EXISTS lms.student_material_progress (
    progress_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_material_id UUID NOT NULL REFERENCES lms.class_instance_materials(instance_material_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES lms.students(student_id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'Not Started' CHECK (status IN ('Not Started', 'In Progress', 'Completed', 'Submitted', 'Graded', 'Overdue')),
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    time_spent_minutes INTEGER DEFAULT 0,
    score DECIMAL(5, 2),
    max_score DECIMAL(5, 2),
    submission_url TEXT,
    submission_notes TEXT,
    feedback TEXT,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    submitted_at TIMESTAMP WITH TIME ZONE,
    graded_at TIMESTAMP WITH TIME ZONE,
    graded_by UUID REFERENCES lms.tutors(tutor_id),
    
    -- Unique progress record per student per material
    UNIQUE(instance_material_id, student_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_student_progress_instance_material ON lms.student_material_progress(instance_material_id);
CREATE INDEX IF NOT EXISTS idx_student_progress_student ON lms.student_material_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_student_progress_status ON lms.student_material_progress(status);