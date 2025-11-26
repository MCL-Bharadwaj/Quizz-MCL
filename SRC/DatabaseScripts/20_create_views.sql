-- Views for common queries and reporting
-- This file contains useful views for the LMS application

-- View: Active Students with User Information
CREATE VIEW lms.v_active_students AS
SELECT 
    s.student_id,
    s.student_number,
    u.user_id,
    u.email,
    u.first_name,
    u.last_name,
    u.phone,
    u.date_of_birth,
    s.enrollment_date,
    s.grade_level,
    s.emergency_contact_name,
    s.emergency_contact_phone
FROM lms.students s
JOIN lms.users u ON s.user_id = u.user_id
WHERE s.is_enrolled = TRUE AND u.is_active = TRUE;

-- View: Active Tutors with User Information
CREATE VIEW lms.v_active_tutors AS
SELECT 
    t.tutor_id,
    t.employee_id,
    u.user_id,
    u.email,
    u.first_name,
    u.last_name,
    u.phone,
    t.department,
    t.title,
    t.specializations,
    t.years_of_experience,
    t.is_available,
    t.max_students_per_class
FROM lms.tutors t
JOIN lms.users u ON t.user_id = u.user_id
WHERE t.is_available = TRUE AND u.is_active = TRUE;

-- View: Classroom Details with Program and Tutor Information
CREATE VIEW lms.v_classroom_details AS
SELECT 
    c.classroom_id,
    c.classroom_name,
    c.classroom_code,
    p.program_name,
    p.program_code,
    c.start_date,
    c.end_date,
    c.schedule_days,
    c.start_time,
    c.end_time,
    c.status,
    pt.first_name || ' ' || pt.last_name AS primary_tutor_name,
    st.first_name || ' ' || st.last_name AS secondary_tutor_name,
    c.capacity,
    (SELECT COUNT(*) FROM lms.classroom_enrollments ce WHERE ce.classroom_id = c.classroom_id AND ce.enrollment_status = 'Active') AS enrolled_count
FROM lms.classrooms c
JOIN lms.programs p ON c.program_id = p.program_id
JOIN lms.tutors t1 ON c.primary_tutor_id = t1.tutor_id
JOIN lms.users pt ON t1.user_id = pt.user_id
LEFT JOIN lms.tutors t2 ON c.secondary_tutor_id = t2.tutor_id
LEFT JOIN lms.users st ON t2.user_id = st.user_id;

-- View: Student Enrollments with Classroom and Program Details
CREATE VIEW lms.v_student_enrollments AS
SELECT 
    ce.enrollment_id,
    s.student_number,
    u.first_name || ' ' || u.last_name AS student_name,
    c.classroom_name,
    c.classroom_code,
    p.program_name,
    ce.enrollment_date,
    ce.enrollment_status,
    c.start_date AS class_start_date,
    c.end_date AS class_end_date
FROM lms.classroom_enrollments ce
JOIN lms.students s ON ce.student_id = s.student_id
JOIN lms.users u ON s.user_id = u.user_id
JOIN lms.classrooms c ON ce.classroom_id = c.classroom_id
JOIN lms.programs p ON c.program_id = p.program_id;

-- View: Class Instance Summary with Attendance
CREATE VIEW lms.v_class_instance_summary AS
SELECT 
    ci.instance_id,
    c.classroom_name,
    ci.instance_number,
    ci.session_date,
    ci.session_title,
    ci.status,
    tu.first_name || ' ' || tu.last_name AS conducting_tutor,
    COUNT(cia.attendance_id) AS total_students,
    COUNT(CASE WHEN cia.attendance_status = 'Present' THEN 1 END) AS present_count,
    COUNT(CASE WHEN cia.attendance_status = 'Absent' THEN 1 END) AS absent_count,
    COUNT(CASE WHEN cia.attendance_status = 'Late' THEN 1 END) AS late_count
FROM lms.class_instances ci
JOIN lms.classrooms c ON ci.classroom_id = c.classroom_id
JOIN lms.tutors t ON ci.conducting_tutor_id = t.tutor_id
JOIN lms.users tu ON t.user_id = tu.user_id
LEFT JOIN lms.class_instance_attendance cia ON ci.instance_id = cia.instance_id
GROUP BY ci.instance_id, c.classroom_name, ci.instance_number, ci.session_date, 
         ci.session_title, ci.status, tu.first_name, tu.last_name;

-- View: User Roles Summary
CREATE VIEW lms.v_user_roles AS
SELECT 
    u.user_id,
    u.email,
    u.first_name,
    u.last_name,
    STRING_AGG(r.role_name, ', 'ORDER BY r.role_name) AS roles,
    u.is_active AS user_active
FROM lms.users u
LEFT JOIN lms.user_roles ur ON u.user_id = ur.user_id AND ur.is_active = TRUE
LEFT JOIN lms.roles r ON ur.role_id = r.role_id AND r.is_active = TRUE
GROUP BY u.user_id, u.email, u.first_name, u.last_name, u.is_active;