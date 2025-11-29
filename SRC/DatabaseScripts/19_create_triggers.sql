-- Create triggers for automatic timestamp updates
-- This file contains trigger functions and triggers for maintaining updated_at columns

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION lms.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to all tables with updated_at columns
CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON lms.roles 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON lms.users 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON lms.students 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_parents_updated_at BEFORE UPDATE ON lms.parents 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_tutors_updated_at BEFORE UPDATE ON lms.tutors 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_programs_updated_at BEFORE UPDATE ON lms.programs 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_classrooms_updated_at BEFORE UPDATE ON lms.classrooms 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_classroom_enrollments_updated_at BEFORE UPDATE ON lms.classroom_enrollments 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_class_instances_updated_at BEFORE UPDATE ON lms.class_instances 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_material_types_updated_at BEFORE UPDATE ON lms.material_types 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON lms.materials 
    FOR EACH ROW EXECUTE FUNCTION lms.update_updated_at_column();