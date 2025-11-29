-- Parent Table DDL
-- Stores parent/guardian information linked to users

CREATE TABLE IF NOT EXISTS lms.parents (
    parent_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES lms.users(user_id) ON DELETE CASCADE,
    occupation VARCHAR(100),
    employer VARCHAR(200),
    work_phone VARCHAR(20),
    preferred_contact_method VARCHAR(20) CHECK (preferred_contact_method IN ('Email', 'Phone', 'SMS', 'App Notification')),
    preferred_contact_time VARCHAR(50),
    is_primary_contact BOOLEAN DEFAULT FALSE,
    can_pickup_student BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- Parent records with NEW user_ids from pgAdmin (mapped by phone number and name)
INSERT INTO lms.parents (user_id, work_phone, preferred_contact_method, preferred_contact_time, can_pickup_student) VALUES
('cb53e19b-5a0c-4c6f-8eb9-86faec3b5ee3', '(972) 369-6780', 'Phone', 'Evening', TRUE),
('f52cf2ca-210f-4f1e-a4ae-eb4b84a7f952', '(206) 581-7960', 'Phone', 'Evening', TRUE), 
('57b07bbd-4f2e-41bd-be0d-f87c6b41c7ab', '(206) 327-3747', 'Phone', 'Evening', TRUE), 
('5321b5e0-c8b0-4a76-aef0-027872b67c93', '(425) 443-3903', 'Phone', 'Evening', TRUE),  
('d3cc2c84-078e-45af-b5a0-5d7d5a7b8e07', '(425) 615-3501', 'Phone', 'Evening', TRUE), 
('f0dd01d2-ce91-4e41-8338-d6524e673efe', '(206) 741-9830', 'Phone', 'Evening', TRUE), 
('05dabc08-f621-4bc9-8d7f-bb034c470ccc', '(909) 645-2156', 'Phone', 'Evening', TRUE), 
('7ee3b1ec-6a67-4d18-8b2c-7b8117e9abb1', '(484) 757-7966', 'Phone', 'Evening', TRUE), 
('2e855edf-eff2-41b5-ba91-129ba91264cf', '(248) 231-7218', 'Phone', 'Evening', TRUE), 
('9c10b878-7098-4d5b-a823-b850de40d6da', '16727271234', 'Phone', 'Evening', TRUE),    
('170e010e-6eaf-4222-8bd2-fe5c97205ce5', '(206) 886-7602', 'Phone', 'Evening', TRUE), 
('886c364f-75ec-4b83-a283-0937540f6226', '(425) 894-6479', 'Phone', 'Evening', TRUE), 
('eb49f56d-8c70-482d-a176-e4c34918e780', '(425) 340-4404', 'Phone', 'Evening', TRUE), 
('e830427a-8f1d-4351-867c-54e77fe2861c', '(425) 436-1610', 'Phone', 'Evening', TRUE),
('ce1a6f6f-a750-446a-ab4a-79fdfb5f99d5', '(425) 505-1296', 'Phone', 'Evening', TRUE), 
('064974d5-963c-4fad-b2f4-e521d32c1783', '(732) 322-6455', 'Phone', 'Evening', TRUE),  
('a4f8fd17-6730-4df1-acdf-64f0ddcf4294', '(818) 483-3699', 'Phone', 'Evening', TRUE),
('10ff78f2-84e5-4254-ae68-9041f962cfac', '(251) 391-6630', 'Phone', 'Evening', TRUE),  
('69bc0050-e38a-40f5-b25d-a64331be1002', '(443) 492-9073', 'Phone', 'Evening', TRUE), 
('801eedd0-03d0-4a41-bb31-46d37598ec28', '(425) 737-8523', 'Phone', 'Evening', TRUE), 
('d04afb66-9b3e-4c23-a384-3686b026c53a', '(425) 458-2683', 'Phone', 'Evening', TRUE), 
('c39f0028-f834-4348-b6d6-bff7a83a0ecf', '(724) 900-1498', 'Phone', 'Evening', TRUE), 
('fb813241-cf13-4111-9273-77bc1d871750', '(512) 541-5215', 'Phone', 'Evening', TRUE), 
('470520c8-49bd-401a-a877-8ab8f0b195df', '(312) 331-0835', 'Phone', 'Evening', TRUE);  

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_parents_user_id ON lms.parents(user_id);
CREATE INDEX IF NOT EXISTS idx_parents_primary_contact ON lms.parents(is_primary_contact);