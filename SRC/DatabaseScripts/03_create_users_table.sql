-- User Table DDL
-- Generic user table that serves as the base for all user types
CREATE TABLE IF NOT EXISTS lms.users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other', 'Prefer not to say')),
    address1 VARCHAR(100),
    address2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    profile_picture_url TEXT ,
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO lms.users (email, password_hash, first_name, last_name, phone, gender, address1, city, state, country, postal_code, is_active, is_verified, created_at)
VALUES ('mithinti.swetha@gmail.com', 'hashed123', 'Sravan', 'vemulapalli', '(972) 369-6780', 'Male', '7563 Perennial St', 'Frisco', 'Texas', 'US', '75035', TRUE, TRUE, '2025-09-20 12:01 AM');

 INSERT INTO lms.users (email, password_hash, first_name, last_name, phone, gender, address1, city, state, country, postal_code, is_active, is_verified, created_at)
VALUES ('tvikrantht@gmail.com', 'hashed13', 'Rutvik Reddy', 'Thati', '(206) 581-7960', 'Male', '10102 162nd Ave NE', 'Redmond', 'Washington (WA)', 'US', '98052', TRUE, TRUE, '2025-09-16 10:46 PM');

INSERT INTO lms.users (email, password_hash, first_name, last_name, phone, gender, address1, city, state, country, postal_code, is_active, is_verified, created_at)
VALUES ('sananthu.family@gmail.com', 'hashe123', 'Rishith', 'Ananthu', '(206) 327-3747', 'Male', '4004 179th Place Southeast', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-09-15 9:37 PM');

INSERT INTO lms.users (email, password_hash, first_name, last_name, phone, gender, address1, city, state, country, postal_code, is_active, is_verified, created_at)
VALUES
('laxmangulaka@gmail.com', 'hashe123', 'Ikshitaram', 'Gulaka', '(425) 443-3903', 'Male', '30095 219th Place Southeast', 'Covington', 'Washington (WA)', 'US', '98042', TRUE, TRUE, '2025-09-11 01:08 PM'),
('savitalasrinivas1@gmail.com', 'hashe123', 'Akshaya', 'Savitala', '(425) 615-3501', 'Female', '9107 225th Way NE', 'Redmond', 'Washington (WA)', 'US', '98053', TRUE, TRUE, '2025-09-10 08:23 PM'),
('njinnamuri@gmail.com', 'hashe123', 'Nishant', 'Innamuri', '(206) 741-9830', 'Male', '18515 42nd Avenue Southeast', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-09-10 04:22 PM'),
('kalyankp@gmail.com', 'hashe123', 'Aaryan', 'Panuganti', '(909) 645-2156', 'Male', '18533 36th dr se', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-09-08 07:17 AM'),
('phani.nalap@gmail.com', 'hashe123', 'Srinika', 'Nallapareddy', '(484) 757-7966', 'Female', '5118 Hyannis Ct', 'Weddington', 'North Carolina (NC)', 'US', '28104', TRUE, TRUE, '2025-09-07 05:47 PM'),
('divakar.hb@gmail.com', 'hashe123', 'Divakara', 'Basavaraju', '(248) 231-7218', 'Male', '18511 40th Avenue Southeast', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-09-06 08:00 PM'),
('ksatyagupta@yahoo.com', 'hashe123', 'Rishi', 'Raaj', '16727271234', 'Male', '36th Ave SE Unit D', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-09-01 12:30 PM'),
('sivaraju.sateesh@gmail.com', 'hashe123', 'Atul', 'Sivaraju', '(206) 886-7602', 'Male', '19300 24th Avenue Southeast', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-07-19 02:23 PM'),
('swethapanja@gmail.com', 'hashe123', 'Shreyas', 'Jyothula', '(425) 894-6479', 'Male', '3820 221st Place Southeast', 'Bothell', 'Washington (WA)', 'US', '98021', TRUE, TRUE, '2025-07-19 11:31 AM'),
('narendra.katlamudi@gmail.com', 'hashe123', 'Narendra', 'Katlamudi', '(425) 340-4404', 'Male', '22811 Northeast 22nd Street', 'Sammamish', 'Washington (WA)', 'US', '98074', TRUE, TRUE, '2025-07-09 06:55 AM'),
('kranthi.sama@gmail.com', 'hashe123', 'SriNidhi', 'Sama', '(425) 436-1610', 'Female', '17022 126th STSE', 'Snohomish', 'Washington (WA)', 'US', '98290', TRUE, TRUE, '2025-07-08 08:42 PM'),
('gyan.kintali@gmail.com', 'hashe123', 'Gyan', 'Deep Kintali', '(425) 505-1296', 'Male', '3814 192nd Pl Se', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-07-08 08:38 PM'),
('kuramanisha@gmail.com', 'hashe123', 'Sriya', 'Suggala', '(732) 322-6455', 'Female', '392 Yorkshire Drive', 'St. Augustine', 'Florida (FL)', 'US', '32092', TRUE, TRUE, '2025-07-08 08:14 PM'),
('b.praneetha@gmail.com', 'hashe123', 'Tej', 'Simha Reddy Tummapudi', '(818) 483-3699', 'Male', '3521 193rd st se unit a', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-07-07 11:01 PM'),
('satya.mulupuru@gmail.com', 'hashe123', 'Shreyansh', 'Mulupuru', '(251) 391-6630', 'Male', '2551 Bishop Ct', 'Prosper', 'Texas (TX)', 'US', '75078', TRUE, TRUE, '2025-07-07 08:01 PM'),
('kethana.mullangi@gmail.com', 'hashe123', 'Ketana', 'Mullangi', '(443) 492-9073', 'Female', '433 West Side Drive Apt 303', 'Gaithersburg', 'Maryland (MD)', 'US', '20878', TRUE, TRUE, '2025-07-07 06:55 PM'),
('lakshme23@yahoo.com', 'hashe123', 'Charvy', 'Dinesh', '(425) 737-8523', 'Female', '19507 38th Dr se', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-07-06 11:00 PM'),
('sowmyav12@gmail.com', 'hashe123', 'Saketh', 'Voora', '(425) 458-2683', 'Male', '2018 156th Avenue Northeast', 'Bellevue', 'Washington (WA)', 'US', '98007', TRUE, TRUE, '2025-07-06 10:42 PM'),
('shachisinha@gmail.com', 'hashe123', 'Aaryana', 'Sinha', '(724) 900-1498', 'Female', '18627 46th Ave Se Unit A', 'Bothell', 'Washington (WA)', 'US', '98012', TRUE, TRUE, '2025-07-03 07:06 PM'),
('sudheerdv@gmail.com', 'hashe123', 'Moksha', 'Dacepalli', '(512) 541-5215', 'Female', '14310 SE 49th St', 'Bellevue', 'Washington (WA)', 'US', '98006', TRUE, TRUE, '2025-07-02 11:15 PM'),
('girishledala@gmail.com', 'hashe123', 'Vihaan', 'Ledala', '(312) 331-0835', 'Male', '7341 Hillock Road', 'Frisco', 'Texas (TX)', 'US', '75035', TRUE, TRUE, '2025-07-02 12:59 PM');




-- Create indexes for performance
CREATE INDEX idx_users_email ON lms.users(email);
CREATE INDEX idx_users_active ON lms.users(is_active);
CREATE INDEX idx_users_verified ON lms.users(is_verified);
CREATE INDEX idx_users_name ON lms.users(first_name, last_name);