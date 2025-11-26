-- Student Table DDL
-- Extends user information with student-specific data

CREATE TABLE IF NOT EXISTS lms.students (
    student_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES lms.users(user_id) ON DELETE CASCADE,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    -- student_name VARCHAR(200) NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    graduation_date DATE,
    grade_level VARCHAR(20),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relationship VARCHAR(50),
    special_needs TEXT,
    learning_preferences TEXT,
    is_enrolled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- Student records with NEW user_ids from pgAdmin (mapped by phone number)
INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES ('cb53e19b-5a0c-4c6f-8eb9-86faec3b5ee3','MCL001','2025-09-20 12:01 AM','Sravan vemulapalli','(972) 369-6780','Father','NA',true,'2025-09-20 12:01 AM');

INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES ('f52cf2ca-210f-4f1e-a4ae-eb4b84a7f952','MCL002','2025-09-16 10:46 PM','Vikranth Thati','(206) 581-7960','Father','NA',true,'2025-09-16 10:46 PM');

INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES ('57b07bbd-4f2e-41bd-be0d-f87c6b41c7ab','MCL003','2025-09-15 09:37 PM','DeepikaRan Potti','(206) 327-3747','Mother','NA',true,'2025-09-15 09:37 PM');

INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES ('5321b5e0-c8b0-4a76-aef0-027872b67c93','MCL004','2025-09-11 01:08 PM','Laxman Gulaka','(425) 443-3903','Father','NA',true,'2025-09-11 01:08 PM');

INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES ('d3cc2c84-078e-45af-b5a0-5d7d5a7b8e07','MCL005','2025-09-10 08:23 PM','Srinivas Savitala','(425) 615-3501','Father','NA',true,'2025-09-10 08:23 PM');


INSERT INTO lms.students (
    user_id,student_number,enrollment_date,emergency_contact_name,emergency_contact_phone,emergency_contact_relationship,
    special_needs,
    is_enrolled,
    created_at
) VALUES
('f0dd01d2-ce91-4e41-8338-d6524e673efe','MCL006','2025-09-10 04:22 PM','VENKATA SUNEEL INNAMURI','(206) 741-9830','Father','NA',true,'2025-09-10 04:22 PM'),
('05dabc08-f621-4bc9-8d7f-bb034c470ccc','MCL007','2025-09-08 07:17 AM','kalyana krishna panuganti','(909) 645-2156','Father','NA',true,'2025-09-08 07:17 AM'),
('7ee3b1ec-6a67-4d18-8b2c-7b8117e9abb1','MCL008','2025-09-07 05:47 PM','Phanikumar Nalap Reddy','(484) 757-7966','Father','NA',true,'2025-09-07 05:47 PM'),
('2e855edf-eff2-41b5-ba91-129ba91264cf','MCL009','2025-09-06 08:00 PM','Divakara Basavaraju','(248) 231-7218','Father','NA',true,'2025-09-06 08:00 PM'),
('9c10b878-7098-4d5b-a823-b850de40d6da','MCL010','2025-09-01 12:30 PM','Pradeep Nagaraja','16727271234','Father','NA',true,'2025-09-01 12:30 PM'),
('170e010e-6eaf-4222-8bd2-fe5c97205ce5','MCL011','2025-07-19 2:23 PM','Sateesh','(206) 886-7602','Father','NA',true,'2025-07-19 02:23 PM'),
('886c364f-75ec-4b83-a283-0937540f6226','MCL012','2025-07-19 11:31 AM','Swetha Panja','(425) 894-6479','Mother','NA',true,'2025-07-19 11:31 AM'),
('eb49f56d-8c70-482d-a176-e4c34918e780','MCL013','2025-07-09 06:55 AM','Narendra Katlamudi','(425) 340-4404','Father','NA',true,'2025-07-09 06:55 AM'),
('e830427a-8f1d-4351-867c-54e77fe2861c','MCL014','2025-07-08 08:42 PM','Kranthi Sama','(425) 436-1610','Father','NA',true,'2025-07-08 08:42 PM'),
('ce1a6f6f-a750-446a-ab4a-79fdfb5f99d5','MCL015','2025-07-08 08:38 PM','Venkata Kintali','(425) 505-1296','Father','NA',true,'2025-07-08 08:38 PM'),
('064974d5-963c-4fad-b2f4-e521d32c1783','MCL016','2025-07-08 08:14 PM','Bhanu Prasad Suggala','(732) 322-6455','Father','NA',true,'2025-07-08 08:14 PM'),
('a4f8fd17-6730-4df1-acdf-64f0ddcf4294','MCL017','2025-07-07 11:01 PM','praneetha bl','(818) 483-3699','Mother','NA',true,'2025-07-07 11:01 PM'),
('10ff78f2-84e5-4254-ae68-9041f962cfac','MCL018','2025-07-07 08:01 PM','Padma Kurapati','(251) 391-6630','Mother','NA',true,'2025-07-07 08:01 PM'),
('69bc0050-e38a-40f5-b25d-a64331be1002','MCL019','2025-07-07 06:55 PM','Siva Krishna Mullangi','(443) 492-9073','Father','NA',true,'2025-07-07 06:55 PM'),
('801eedd0-03d0-4a41-bb31-46d37598ec28','MCL020','2025-07-06 11:00 PM','L Aruppukottai Sitharanjan','(425) 737-8523','Father','NA',true,'2025-07-06 11:00 PM'),
('d04afb66-9b3e-4c23-a384-3686b026c53a','MCL021','2025-07-06 10:42 PM','Sowmya Vuppalanchi','(425) 458-2683','Mother','NA',true,'2025-07-06 10:42 PM'),
('c39f0028-f834-4348-b6d6-bff7a83a0ecf','MCL022','2025-07-03 07:06 PM','Shachi Sinha','(724) 900-1498','Mother','NA',true,'2025-07-03 07:06 PM'),
('fb813241-cf13-4111-9273-77bc1d871750','MCL023','2025-07-02 11:15 PM','Sudhir Dachepalli','(512) 541-5215','Father','NA',true,'2025-07-02 11:15 PM'),
('470520c8-49bd-401a-a877-8ab8f0b195df','MCL024','2025-07-02 12:59 PM','Girish K Ledala','(312) 331-0835','Father','NA',true,'2025-07-02 12:59 PM');


-- Create indexes for performance
CREATE INDEX idx_students_user_id ON lms.students(user_id);
CREATE INDEX idx_students_number ON lms.students(student_number);
CREATE INDEX idx_students_enrolled ON lms.students(is_enrolled);
CREATE INDEX idx_students_enrollment_date ON lms.students(enrollment_date);
CREATE INDEX idx_students_grade_level ON lms.students(grade_level);