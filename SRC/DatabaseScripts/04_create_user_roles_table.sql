-- RBAC (Role-Based Access Control) Table DDL
-- This table manages the many-to-many relationship between users and roles

CREATE TABLE IF NOT EXISTS lms.user_roles (
    user_role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES lms.users(user_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES lms.roles(role_id) ON DELETE CASCADE,
    assigned_by UUID REFERENCES lms.users(user_id),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Ensure a user can't have the same role assigned multiple times
    UNIQUE(user_id, role_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON lms.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON lms.user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_active ON lms.user_roles(is_active);
CREATE INDEX IF NOT EXISTS idx_user_roles_assigned_by ON lms.user_roles(assigned_by);