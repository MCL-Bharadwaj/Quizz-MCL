-- ============================================
-- Python Conditions Quiz Seed Data
-- ============================================

-- Insert Quiz: Python Conditions  
INSERT INTO quiz.quizzes (
    quiz_id,
    title,
    description,
    age_min,
    age_max,
    subject,
    difficulty,
    estimated_minutes,
    tags
) VALUES (
    'f47ac10b-58cc-4372-a567-0e02b2c3d479',
    'Python Conditions',
    'Test your understanding of conditional statements in Python including if, elif, else, and comparison operators.',
    10, 
    18,
    'computer_science',
    'easy',
    30,
    ARRAY['python', 'conditions', 'if-else', 'logic', 'beginner']
) ON CONFLICT DO NOTHING;

-- Question 1: Basic if statement
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '8c3f2a5e-9d1b-4e6f-a8c7-3d4e5f6a7b8c',
    'multiple_choice_single',
    'What is the correct syntax for an if statement in Python?',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "`if x = 5:`"},
            {"id": "b", "text": "`if (x == 5)`"},
            {"id": "c", "text": "`if x == 5:`"},
            {"id": "d", "text": "`if x == 5`"}
        ],
        "correct_answer": "c",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '8c3f2a5e-9d1b-4e6f-a8c7-3d4e5f6a7b8c', 1);

-- Question 2: Comparison operators
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '7b2e1f4d-8a9c-4d5e-b6f7-2c3d4e5f6a7b',
    'multiple_choice_single',
    'Which operator is used to check if two values are equal in Python?',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "`=`"},
            {"id": "b", "text": "`==`"},
            {"id": "c", "text": "`===`"},
            {"id": "d", "text": "`:=`"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '7b2e1f4d-8a9c-4d5e-b6f7-2c3d4e5f6a7b', 2);

-- Question 3: elif statement
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '6a1d0e3c-7b8a-4c9d-a5e6-1b2c3d4e5f6a',
    'multiple_choice_single',
    'What does the `elif` keyword stand for in Python?',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "else in function"},
            {"id": "b", "text": "else if"},
            {"id": "c", "text": "else loop"},
            {"id": "d", "text": "end if"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '6a1d0e3c-7b8a-4c9d-a5e6-1b2c3d4e5f6a', 3);

-- Question 4: Logical operators
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '5f9c0d2b-6a7b-4c8d-9e0f-1a2b3c4d5e6f',
    'multiple_choice_single',
    'Which logical operator returns `True` if both conditions are `True`?',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "`or`"},
            {"id": "b", "text": "`and`"},
            {"id": "c", "text": "`not`"},
            {"id": "d", "text": "`xor`"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '5f9c0d2b-6a7b-4c8d-9e0f-1a2b3c4d5e6f', 4);

-- Question 5: Nested conditions
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '4e8b0c1a-5f6a-4b7c-8d9e-0f1a2b3c4d5e',
    'multiple_choice_single',
    E'What will be the output of the following code?\n\n```python\nx = 10\nif x > 5:\n    if x > 15:\n        print("A")\n    else:\n        print("B")\nelse:\n    print("C")\n```',
    10, 18,
    'medium',
    60,
    'computer_science',
    'en-US',
    15.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "A"},
            {"id": "b", "text": "B"},
            {"id": "c", "text": "C"},
            {"id": "d", "text": "Error"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '4e8b0c1a-5f6a-4b7c-8d9e-0f1a2b3c4d5e', 5);

-- Question 6: Ternary operator
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '3d7a0b09-4e5f-4a6b-7c8d-9e0f1a2b3c4d',
    'multiple_choice_single',
    'What is the correct syntax for a ternary (conditional) expression in Python?',
    10, 18,
    'medium',
    45,
    'computer_science',
    'en-US',
    15.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "`result = if condition: value1 else: value2`"},
            {"id": "b", "text": "`result = value1 if condition else value2`"},
            {"id": "c", "text": "`result = condition ? value1 : value2`"},
            {"id": "d", "text": "`result = (condition) ? value1 : value2`"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '3d7a0b09-4e5f-4a6b-7c8d-9e0f1a2b3c4d', 6);

-- Question 7: Boolean evaluation
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '2c6908f8-3d4e-495a-6b7c-8d9e0f1a2b3c',
    'multiple_choice_single',
    E'What will be the output of this code?\n\n```python\nbool(0) and bool(10)\n```',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "True"},
            {"id": "b", "text": "False"},
            {"id": "c", "text": "0"},
            {"id": "d", "text": "10"}
        ],
        "correct_answer": "b",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '2c6908f8-3d4e-495a-6b7c-8d9e0f1a2b3c', 7);

-- Question 8: not operator
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    age_min,
    age_max,
    difficulty,
    estimated_seconds,
    subject,
    locale,
    points,
    allow_partial_credit,
    supports_read_aloud,
    content
) VALUES (
    '1b5807e7-2c3d-484e-5a6b-7c8d9e0f1a2b',
    'multiple_choice_single',
    'What does the `not` operator do in Python?',
    10, 18,
    'easy',
    30,
    'computer_science',
    'en-US',
    10.0,
    false,
    true,
    '{
        "options": [
            {"id": "a", "text": "Reverses the logical state of its operand"},
            {"id": "b", "text": "Compares two values"},
            {"id": "c", "text": "Negates a number"},
            {"id": "d", "text": "None of the above"}
        ],
        "correct_answer": "a",
        "shuffle_options": true
    }'::jsonb
);

INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '1b5807e7-2c3d-484e-5a6b-7c8d9e0f1a2b', 8);
