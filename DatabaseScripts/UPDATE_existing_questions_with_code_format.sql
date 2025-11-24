-- ============================================
-- UPDATE EXISTING QUESTIONS WITH CODE FORMATTING
-- Run this script to add code formatting to questions already in your database
-- ============================================

-- IMPORTANT: Backup your database before running this script!
-- Run: pg_dump -h mcl-lms-dev.postgres.database.azure.com -U mcladmin -d postgres > backup.sql

-- ============================================
-- UPDATE PYTHON CONDITIONS QUIZ QUESTIONS
-- ============================================

-- Question 1: Update if statement syntax options
UPDATE quiz.questions
SET content = jsonb_set(
    content,
    '{options}',
    '[
        {"id": "a", "text": "`if x = 5:`"},
        {"id": "b", "text": "`if (x == 5)`"},
        {"id": "c", "text": "`if x == 5:`"},
        {"id": "d", "text": "`if x == 5`"}
    ]'::jsonb
)
WHERE question_id = '8c3f2a5e-9d1b-4e6f-a8c7-3d4e5f6a7b8c';

-- Question 2: Update comparison operators
UPDATE quiz.questions
SET content = jsonb_set(
    content,
    '{options}',
    '[
        {"id": "a", "text": "`=`"},
        {"id": "b", "text": "`==`"},
        {"id": "c", "text": "`===`"},
        {"id": "d", "text": "`:=`"}
    ]'::jsonb
)
WHERE question_id = '7b2e1f4d-8a9c-4d5e-b6f7-2c3d4e5f6a7b';

-- Question 3: Update elif keyword question
UPDATE quiz.questions
SET question_text = 'What does the `elif` keyword stand for in Python?'
WHERE question_id = '6a1d0e3c-7b8a-4c9d-a5e6-1b2c3d4e5f6a';

-- Question 4: Update logical operators
UPDATE quiz.questions
SET question_text = 'Which logical operator returns `True` if both conditions are `True`?',
    content = jsonb_set(
        content,
        '{options}',
        '[
            {"id": "a", "text": "`or`"},
            {"id": "b", "text": "`and`"},
            {"id": "c", "text": "`not`"},
            {"id": "d", "text": "`xor`"}
        ]'::jsonb
    )
WHERE question_id = '5f9c0d2b-6a7b-4c8d-9e0f-1a2b3c4d5e6f';

-- Question 5: Update nested conditions with code block
UPDATE quiz.questions
SET question_text = E'What will be the output of the following code?\n\n```python\nx = 10\nif x > 5:\n    if x > 15:\n        print("A")\n    else:\n        print("B")\nelse:\n    print("C")\n```'
WHERE question_id = '4e8b0c1a-5f6a-4b7c-8d9e-0f1a2b3c4d5e';

-- Question 6: Update ternary operator options
UPDATE quiz.questions
SET content = jsonb_set(
    content,
    '{options}',
    '[
        {"id": "a", "text": "`result = if condition: value1 else: value2`"},
        {"id": "b", "text": "`result = value1 if condition else value2`"},
        {"id": "c", "text": "`result = condition ? value1 : value2`"},
        {"id": "d", "text": "`result = (condition) ? value1 : value2`"}
    ]'::jsonb
)
WHERE question_id = '3d7a0b09-4e5f-4a6b-7c8d-9e0f1a2b3c4d';

-- Question 7: Update boolean evaluation with code block
UPDATE quiz.questions
SET question_text = E'What will be the output of this code?\n\n```python\nbool(0) and bool(10)\n```'
WHERE question_id = '2c6908f8-3d4e-495a-6b7c-8d9e0f1a2b3c';

-- Question 8: Update not operator question
UPDATE quiz.questions
SET question_text = 'What does the `not` operator do in Python?'
WHERE question_id = '1b5807e7-2c3d-484e-5a6b-7c8d9e0f1a2b';

-- ============================================
-- UPDATE ANY OTHER QUESTIONS WITH PYTHON CODE
-- ============================================

-- Find all questions that might have Python code (for manual review)
SELECT 
    question_id,
    question_type,
    LEFT(question_text, 80) as question_preview,
    subject
FROM quiz.questions
WHERE (
    question_text LIKE '%print(%'
    OR question_text LIKE '%def %'
    OR question_text LIKE '%if %'
    OR question_text LIKE '%for %'
    OR question_text LIKE '%while %'
    OR question_text LIKE '% = %'
    OR subject LIKE '%ython%'
    OR subject LIKE '%omputer%'
)
AND question_text NOT LIKE '%```%'  -- Exclude already formatted
ORDER BY created_at DESC;

-- ============================================
-- GENERIC UPDATE TEMPLATE
-- Use this template for other questions with code
-- ============================================

/*
-- Template for updating question_text with code block:
UPDATE quiz.questions
SET question_text = E'Your question text here?\n\n```python\nYour code here\n```'
WHERE question_id = 'YOUR-QUESTION-ID'::uuid;

-- Template for updating inline code in question_text:
UPDATE quiz.questions
SET question_text = 'Question with `inline_code()` function?'
WHERE question_id = 'YOUR-QUESTION-ID'::uuid;

-- Template for updating code in options:
UPDATE quiz.questions
SET content = jsonb_set(
    content,
    '{options}',
    '[
        {"id": "a", "text": "`code option 1`"},
        {"id": "b", "text": "`code option 2`"},
        {"id": "c", "text": "`code option 3`"},
        {"id": "d", "text": "`code option 4`"}
    ]'::jsonb
)
WHERE question_id = 'YOUR-QUESTION-ID'::uuid;
*/

-- ============================================
-- VERIFY UPDATES
-- ============================================

-- Check updated questions
SELECT 
    question_id,
    question_text,
    content->'options' as options
FROM quiz.questions
WHERE question_id IN (
    '8c3f2a5e-9d1b-4e6f-a8c7-3d4e5f6a7b8c',
    '7b2e1f4d-8a9c-4d5e-b6f7-2c3d4e5f6a7b',
    '6a1d0e3c-7b8a-4c9d-a5e6-1b2c3d4e5f6a',
    '5f9c0d2b-6a7b-4c8d-9e0f-1a2b3c4d5e6f',
    '4e8b0c1a-5f6a-4b7c-8d9e-0f1a2b3c4d5e',
    '3d7a0b09-4e5f-4a6b-7c8d-9e0f1a2b3c4d',
    '2c6908f8-3d4e-495a-6b7c-8d9e0f1a2b3c',
    '1b5807e7-2c3d-484e-5a6b-7c8d9e0f1a2b'
);

-- Count questions with code formatting
SELECT 
    'Questions with code blocks' as type,
    COUNT(*) as count
FROM quiz.questions
WHERE question_text LIKE '%```%'
UNION ALL
SELECT 
    'Questions with inline code' as type,
    COUNT(*) as count
FROM quiz.questions
WHERE question_text LIKE '%`%' AND question_text NOT LIKE '%```%';
