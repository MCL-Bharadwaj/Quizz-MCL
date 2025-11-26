-- Material Types Table DDL
-- Defines different types of learning materials

CREATE TABLE IF NOT EXISTS lms.material_types (
    material_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type_name VARCHAR(100) UNIQUE NOT NULL,
    type_description TEXT,
    icon_url TEXT,
    color_code VARCHAR(7), -- Hex color code
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_material_types_name ON lms.material_types(type_name);

-- Insert default material types
INSERT INTO lms.material_types (type_name, type_description) 
SELECT type_name, type_description
FROM (VALUES
    ('Learning Notes', 'Study notes and reading materials'),
    ('Practice Exercise', 'Interactive practice problems and exercises'),
    ('Homework', 'Take-home assignments'),
    ('Quiz', 'Short assessments and quizzes'),
    ('Exam', 'Formal examinations'),
    ('Video Lesson', 'Video-based learning content'),
    ('Audio Lesson', 'Audio-based learning content'),
    ('Presentation', 'Slide presentations and visual aids'),
    ('Document', 'PDF documents and text files'),
    ('Interactive Content', 'Interactive learning modules'),
    ('Lab Exercise', 'Hands-on laboratory work'),
    ('Project', 'Long-term project assignments')
) AS v(type_name, type_description)
WHERE NOT EXISTS (
    SELECT 1 
    FROM lms.material_types mt 
    WHERE mt.type_name = v.type_name
);

CREATE INDEX idx_material_types_name ON lms.material_types(type_name);

