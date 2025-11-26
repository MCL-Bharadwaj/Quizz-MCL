-- Class Instance Materials Junction Table DDL
-- Links materials to specific class instances

CREATE TABLE IF NOT EXISTS lms.class_instance_materials (
    instance_material_id UUID PRIMARY KEY DEFAULT   gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES lms.class_instances(instance_id) ON DELETE CASCADE,
    material_id UUID NOT NULL REFERENCES lms.materials(material_id) ON DELETE CASCADE,
    sequence_order INTEGER NOT NULL DEFAULT 1,
    is_required BOOLEAN DEFAULT TRUE,
    due_date TIMESTAMP WITH TIME ZONE,
    points_possible INTEGER DEFAULT 0,
    instructions TEXT,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    assigned_by UUID REFERENCES lms.tutors(tutor_id),
    
    -- Unique material per instance
    UNIQUE(instance_id, material_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_instance_materials_instance ON lms.class_instance_materials(instance_id);
CREATE INDEX IF NOT EXISTS idx_instance_materials_material ON lms.class_instance_materials(material_id);
CREATE INDEX IF NOT EXISTS idx_instance_materials_sequence ON lms.class_instance_materials(sequence_order);