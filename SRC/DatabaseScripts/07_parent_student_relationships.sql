-- Parent-Student Relationships Table DDL
-- Manages the many-to-many relationships between parents and students

CREATE TABLE IF NOT EXISTS lms.parent_student_relationships (
    relationship_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES lms.parents(parent_id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES lms.students(student_id) ON DELETE CASCADE,
    relationship_type VARCHAR(50) NOT NULL CHECK (relationship_type IN ('Father', 'Mother', 'Guardian', 'Stepfather', 'Stepmother', 'Grandparent', 'Other')),
    is_primary_contact BOOLEAN DEFAULT FALSE,
    can_make_decisions BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Ensure unique parent-student relationships
    UNIQUE(parent_id, student_id, relationship_type)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_parent_student_parent_id ON lms.parent_student_relationships(parent_id);
CREATE INDEX IF NOT EXISTS idx_parent_student_student_id ON lms.parent_student_relationships(student_id);
CREATE INDEX IF NOT EXISTS idx_parent_student_primary ON lms.parent_student_relationships(is_primary_contact);