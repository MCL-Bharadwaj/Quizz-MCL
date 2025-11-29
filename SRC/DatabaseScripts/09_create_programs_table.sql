-- Programs Table DDL
-- Stores information about different educational programs


CREATE TABLE IF NOT EXISTS lms.programs (
    program_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_name VARCHAR(200) NOT NULL,
    program_code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    objectives TEXT,
    prerequisites TEXT,
    duration_weeks INTEGER,
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced', 'Expert')),
    age_group_min INTEGER,
    age_group_max INTEGER,
    max_class_size INTEGER DEFAULT 10,
    min_class_size INTEGER DEFAULT 3,
    price DECIMAL(10, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    is_active BOOLEAN DEFAULT TRUE,
    created_by UUID REFERENCES lms.users(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO lms.programs (program_name,program_code,description,objectives,duration_weeks,difficulty_level,
    currency,
    is_active
) VALUES ('The Beginner','Level 0','This fun and engaging program helps kids develop curiosity and 
problem-solving skills through exciting puzzles, logic games,
 and creative challenges. It encourages young minds to 
 think critically and explore how things work, 
 setting the stage for an easy and enjoyable start to learning 
 coding and technology','Builds curiosity and early problem-solving skills through puzzles and 
 simple logic, preparing kids for coding.','44 ','Beginner','USD','TRUE');

INSERT INTO lms.programs (program_name,program_code,description,objectives,duration_weeks,difficulty_level,currency,
    is_active
) VALUES ('The Thinker','Level 1','This course introduces beginners to the basics of programming, 
focusing on logic, coding, and computer systems through 
simple, hands-on Python activities. It helps students 
build a strong foundation for future learning in programming.
','Introduces beginners to programming fundamentals, focusing on logic, coding, and systems through hands-on Python activities. 
Students build a strong foundation for further learning','44 ','Intermediate','USD','TRUE');

INSERT INTO lms.programs (program_name,program_code,description,objectives,duration_weeks,difficulty_level,
    
    currency,
    is_active
) VALUES ('The Builder','Level 2','This course is designed for students who already have some programming 
experience or are preparing for coding competitions like 
USACO. It focuses on advanced problem-solving, complex 
projects, and a deep understanding of algorithms and data 
structures using Python and Rust.
','Designed for students with prior programming experience or those preparing for competitions like USACO. 
It covers advanced problem-solving, complex projects, 
and in-depth exploration of algorithms and 
data structures using Python and Rust.','44 ','Advanced','USD','TRUE');

INSERT INTO lms.programs (program_name,program_code,description,objectives,duration_weeks,difficulty_level,
    
    currency,
    is_active
) VALUES ('The Creator','Level 3','This course is for students aiming to master programming and problem-solving. It focuses on applied algorithms, 
creative coding, and teamwork through collaborative 
development using tools like GitHub. The content aligns with 
advanced programs such as USACO Gold and Platinum levels.',
'For students advancing toward mastery in programming and 
problem-solving, with an emphasis on applied algorithms, 
creative coding, and collaborative development using tools 
like GitHub. In line with USACO Gold and Platinum programs 
or similar level.','44 ','Advanced','USD','TRUE');

INSERT INTO lms.programs (program_name,program_code,description,objectives,duration_weeks,difficulty_level,
    
    currency,
    is_active
) VALUES ('The Innovator','Level 4','This course focuses on guiding 
students to develop and contribute to large-scale projects, 
helping them build strong personal portfolios that enhance 
their college applications',
'Students will focus on developing and 
contributing to large-scale projects while building 
strong personal portfolios to support 
college admissions.','44 ','Expert','USD','TRUE');








-- Create indexes for performance
CREATE INDEX idx_programs_code ON lms.programs(program_code);
CREATE INDEX idx_programs_active ON lms.programs(is_active);
CREATE INDEX idx_programs_difficulty ON lms.programs(difficulty_level);
CREATE INDEX idx_programs_age_group ON lms.programs(age_group_min, age_group_max);
CREATE INDEX idx_programs_created_by ON lms.programs(created_by);