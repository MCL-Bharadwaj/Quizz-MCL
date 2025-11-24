-- ✅ CORRECTED Example: Python Programming Quiz with Formatted Code
-- This demonstrates the CORRECT way to store questions using question_text column

-- Insert a quiz
INSERT INTO quiz.quizzes (
    quiz_id, 
    title, 
    description, 
    difficulty, 
    subject, 
    estimated_minutes,
    age_min,
    age_max,
    tags
) VALUES (
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'Python Conditions with Code',
    E'Test your understanding of Python conditional statements with real code examples.\n\nTopics covered:\n- If/else statements\n- Comparison operators\n- Code reading',
    'medium',
    'Python Programming',
    15,
    12,
    18,
    ARRAY['python', 'conditionals', 'code-reading']
);

-- ✅ Question 1: Simple code output with newlines
-- NOTE: question_text is separate from content!
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    E'What is the output of this Python code?\n\n```python\nx = 10\ny = 5\n\nif x > y:\n    print("x is greater")\nelse:\n    print("y is greater")\n```',
    12, 18,
    'easy',
    60,
    'Python Programming',
    'en-US',
    10,
    '{
        "options": [
            {"id": "a", "text": "x is greater"},
            {"id": "b", "text": "y is greater"},
            {"id": "c", "text": "Error"},
            {"id": "d", "text": "Nothing is printed"}
        ],
        "correct_answer": "a",
        "explanation": "Since x (10) is greater than y (5), the condition x > y is True. Therefore, the if block executes and prints \"x is greater\". The else block is skipped."
    }'::jsonb,
    NOW()
);

-- ✅ Question 2: Loop with code block
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    E'How many times will "Hello" be printed?\n\n```python\nfor i in range(3):\n    print("Hello")\n```',
    12, 18,
    'easy',
    60,
    'Python Programming',
    'en-US',
    10,
    '{
        "options": [
            {"id": "a", "text": "1 time"},
            {"id": "b", "text": "2 times"},
            {"id": "c", "text": "3 times"},
            {"id": "d", "text": "4 times"}
        ],
        "correct_answer": "c",
        "explanation": "The range(3) function generates numbers 0, 1, 2 (three numbers). The loop runs once for each number, so \"Hello\" is printed 3 times."
    }'::jsonb,
    NOW()
);

-- ✅ Question 3: Fill in blank with code
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'fill_in_blank',
    E'Complete this Python function to check if a number is even:\n\n```python\ndef is_even(num):\n    return num ___ 2 == 0\n```',
    12, 18,
    'medium',
    90,
    'Python Programming',
    'en-US',
    15,
    '{
        "template": "def is_even(num):\n    return num ___ 2 == 0",
        "blanks": [
            {
                "id": "1",
                "correct_answer": "%",
                "accepted_answers": ["%", " % ", "mod", "modulo"]
            }
        ],
        "explanation": "The modulo operator (%) returns the remainder of division. If num % 2 equals 0, the number is even."
    }'::jsonb,
    NOW()
);

-- ✅ Question 4: Multiple choice with code in options
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    E'Which Python code correctly checks if a variable x is positive?',
    12, 18,
    'medium',
    90,
    'Python Programming',
    'en-US',
    15,
    '{
        "options": [
            {"id": "a", "text": "```python\nif x > 0:\n    print(\"Positive\")\n```"},
            {"id": "b", "text": "```python\nif x >= 0:\n    print(\"Positive\")\n```"},
            {"id": "c", "text": "```python\nif x != 0:\n    print(\"Positive\")\n```"},
            {"id": "d", "text": "```python\nif x < 0:\n    print(\"Positive\")\n```"}
        ],
        "correct_answer": "a",
        "explanation": "Option A is correct: x > 0 checks if x is strictly greater than zero (positive). Option B includes zero. Option C includes negative numbers. Option D checks for negative."
    }'::jsonb,
    NOW()
);

-- ✅ Question 5: Ordering question
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'ordering',
    E'Arrange these lines of Python code in the correct order to create a working program:\n\nThe program should:\n1. Define a variable\n2. Check a condition\n3. Print a result',
    12, 18,
    'hard',
    120,
    'Python Programming',
    'en-US',
    20,
    '{
        "items": [
            {"id": "1", "text": "```python\nage = 15\n```"},
            {"id": "2", "text": "```python\nif age >= 13:\n```"},
            {"id": "3", "text": "```python\n    print(\"Teenager\")\n```"},
            {"id": "4", "text": "```python\nelse:\n```"},
            {"id": "5", "text": "```python\n    print(\"Child\")\n```"}
        ],
        "correct_order": ["1", "2", "3", "4", "5"],
        "explanation": "Correct sequence: Define variable → if condition → indented if block → else → indented else block"
    }'::jsonb,
    NOW()
);

-- ✅ Question 6: Matching question
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
    content,
    created_at
) VALUES (
    gen_random_uuid(),
    'matching',
    E'Match each Python operator with its function:',
    12, 18,
    'medium',
    90,
    'Python Programming',
    'en-US',
    15,
    '{
        "left_items": [
            {"id": "1", "text": "```==```"},
            {"id": "2", "text": "```!=```"},
            {"id": "3", "text": "```>```"},
            {"id": "4", "text": "```%```"}
        ],
        "right_items": [
            {"id": "a", "text": "Greater than"},
            {"id": "b", "text": "Not equal to"},
            {"id": "c", "text": "Equal to"},
            {"id": "d", "text": "Modulo (remainder)"}
        ],
        "correct_pairs": [
            {"left": "1", "right": "c"},
            {"left": "2", "right": "b"},
            {"left": "3", "right": "a"},
            {"left": "4", "right": "d"}
        ],
        "explanation": "== checks equality, != checks inequality, > checks if left is greater, % returns remainder of division"
    }'::jsonb,
    NOW()
);

-- Link all questions to the quiz
INSERT INTO quiz.quiz_questions (quiz_question_id, quiz_id, question_id, question_order)
SELECT 
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    q.question_id,
    ROW_NUMBER() OVER (ORDER BY q.created_at)
FROM quiz.questions q
WHERE q.subject = 'Python Programming' 
  AND q.created_at > NOW() - INTERVAL '1 minute';

-- Verify the quiz was created correctly
SELECT 
    qz.title,
    qz.difficulty,
    COUNT(qq.question_id) as question_count
FROM quiz.quizzes qz
LEFT JOIN quiz.quiz_questions qq ON qz.quiz_id = qq.quiz_id
WHERE qz.quiz_id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
GROUP BY qz.quiz_id, qz.title, qz.difficulty;

-- View the questions
SELECT 
    q.question_type,
    LEFT(q.question_text, 50) as question_preview,
    q.points
FROM quiz.questions q
WHERE q.subject = 'Python Programming'
  AND q.created_at > NOW() - INTERVAL '1 minute'
ORDER BY q.created_at;
