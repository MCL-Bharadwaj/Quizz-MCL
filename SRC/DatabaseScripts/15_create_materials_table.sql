-- Materials Table DDL
-- Stores learning materials and resources

CREATE TABLE IF NOT EXISTS lms.materials (
    material_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    material_type_id UUID NOT NULL REFERENCES lms.material_types(material_type_id),
    title VARCHAR(300) NOT NULL,
    description TEXT,
    content TEXT,
    file_url TEXT,
    file_size_bytes BIGINT,
    file_mime_type VARCHAR(100),
    thumbnail_url TEXT,
    duration_minutes INTEGER, -- For video/audio content
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced', 'Expert')),
    estimated_completion_time INTEGER, -- in minutes
    points_possible INTEGER DEFAULT 0,
    is_required BOOLEAN DEFAULT TRUE,
    is_published BOOLEAN DEFAULT FALSE,
    version VARCHAR(20) DEFAULT '1.0',
    tags TEXT, -- JSON array of tags
    metadata JSONB, -- Additional metadata
    created_by UUID NOT NULL REFERENCES lms.users(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_materials_type ON lms.materials(material_type_id);
CREATE INDEX IF NOT EXISTS idx_materials_created_by ON lms.materials(created_by);
CREATE INDEX IF NOT EXISTS idx_materials_published ON lms.materials(is_published);
CREATE INDEX IF NOT EXISTS idx_materials_difficulty ON lms.materials(difficulty_level);