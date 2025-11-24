-- Example: Python Programming Quiz with Formatted Code
-- This demonstrates how to store questions with code blocks and newlines

-- Insert a quiz
INSERT INTO quiz.quizzes (
    quiz_id, 
    title, 
    description, 
    difficulty, 
    subject, 
    estimated_minutes,
    age_min,
    age_max
) VALUES (
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'Python Conditions with Code',
    'Test your understanding of Python conditional statements with real code examples',
    'medium',
    'Python Programming',
    15,
    12,
    18
);

-- Question 1: Simple code output with newlines
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'multiple_choice',
    '{
        "text": "What is the output of this Python code?\n\n```python\nx = 10\ny = 5\n\nif x > y:\n    print(\"x is greater\")\nelse:\n    print(\"y is greater\")\n```",
        "choices": [
            {"id": "a", "text": "x is greater"},
            {"id": "b", "text": "y is greater"},
            {"id": "c", "text": "Error"},
            {"id": "d", "text": "Nothing is printed"}
        ],
        "correctAnswers": ["a"],
        "explanation": "Since x (10) is greater than y (5), the condition x > y is True.\nTherefore, the if block executes and prints \"x is greater\".\n\nThe else block is skipped because the condition was True."
    }'::jsonb,
    10,
    NOW()
);

-- Question 2: Multiple code blocks comparison
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'multiple_choice',
    '{
        "text": "Which code snippet correctly checks if a number is even?\n\nOption 1:\n```python\nif num % 2 == 0:\n    print(\"Even\")\n```\n\nOption 2:\n```python\nif num / 2 == 0:\n    print(\"Even\")\n```",
        "choices": [
            {"id": "a", "text": "Option 1"},
            {"id": "b", "text": "Option 2"},
            {"id": "c", "text": "Both are correct"},
            {"id": "d", "text": "Neither is correct"}
        ],
        "correctAnswers": ["a"],
        "explanation": "Option 1 is correct because:\n- % is the modulo operator (returns remainder)\n- Even numbers have remainder 0 when divided by 2\n\nOption 2 is wrong because:\n- / is division, not modulo\n- Division by 2 will never equal 0 (except for 0 itself)"
    }'::jsonb,
    10,
    NOW()
);

-- Question 3: Code with inline explanation
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'true_false',
    '{
        "text": "The following code will print \"Adult\":\n\n```python\nage = 16\n\nif age >= 18:\n    print(\"Adult\")\nelif age >= 13:\n    print(\"Teenager\")\nelse:\n    print(\"Child\")\n```",
        "correctAnswer": false,
        "explanation": "False. The code will print \"Teenager\" because:\n\n1. First condition (age >= 18): False, since 16 < 18\n2. Second condition (age >= 13): True, since 16 >= 13\n3. Prints \"Teenager\" and stops (elif found)\n\nThe else block never executes."
    }'::jsonb,
    10,
    NOW()
);

-- Question 4: Fill in the blank with code context
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'fill_in_blank',
    '{
        "text": "Complete the code to check if a number is positive:\n\n```python\nnum = 5\n\nif num ___ 0:\n    print(\"Positive\")\n```",
        "template": "if num ___ 0:",
        "blanks": [
            {
                "id": "1",
                "correctAnswer": ">",
                "acceptedAnswers": [">", "greater than"]
            }
        ],
        "explanation": "The greater than operator (>) checks if num is larger than 0.\n\nAlternatively, you could write:\n```python\nif num > 0:\n    print(\"Positive\")\nelif num < 0:\n    print(\"Negative\")\nelse:\n    print(\"Zero\")\n```"
    }'::jsonb,
    10,
    NOW()
);

-- Question 5: Matching with code snippets
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'matching',
    '{
        "text": "Match each code snippet with its correct output:\n\nConsider these independent code blocks:",
        "leftItems": [
            {"id": "1", "text": "```python\nprint(5 > 3)\n```"},
            {"id": "2", "text": "```python\nprint(5 == 5)\n```"},
            {"id": "3", "text": "```python\nprint(5 != 5)\n```"},
            {"id": "4", "text": "```python\nprint(not True)\n```"}
        ],
        "rightItems": [
            {"id": "a", "text": "True"},
            {"id": "b", "text": "False"},
            {"id": "c", "text": "Error"},
            {"id": "d", "text": "None"}
        ],
        "correctPairs": [
            {"left": "1", "right": "a"},
            {"left": "2", "right": "a"},
            {"left": "3", "right": "b"},
            {"left": "4", "right": "b"}
        ],
        "explanation": "Boolean expressions:\n- 5 > 3 is True (5 is greater)\n- 5 == 5 is True (equal values)\n- 5 != 5 is False (values are equal)\n- not True is False (logical negation)"
    }'::jsonb,
    15,
    NOW()
);

-- Question 6: Short answer with code context
INSERT INTO quiz.questions (
    question_id,
    quiz_id,
    question_type,
    content,
    points,
    created_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'short_answer',
    '{
        "text": "Explain what happens in this code:\n\n```python\nx = 10\n\nif x > 5 and x < 15:\n    print(\"In range\")\n```\n\nWhat values of x would cause \"In range\" to be printed?",
        "correctAnswer": "The code prints \"In range\" when x is greater than 5 AND less than 15. So x must be between 6 and 14 (inclusive). Both conditions must be True for the print statement to execute.",
        "keywords": [
            "greater than 5",
            "less than 15",
            "both conditions",
            "and operator",
            "6 to 14"
        ],
        "explanation": "The \"and\" operator requires both conditions to be True:\n\n1. x > 5 must be True\n2. x < 15 must be True\n\nValid range: 6, 7, 8, 9, 10, 11, 12, 13, 14\n\nNote: x = 5 and x = 15 are NOT included because:\n- 5 > 5 is False\n- 15 < 15 is False"
    }'::jsonb,
    15,
    NOW()
);

-- Link questions to quiz
INSERT INTO quiz.quiz_questions (quiz_question_id, quiz_id, question_id, question_order)
SELECT 
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    q.question_id,
    ROW_NUMBER() OVER (ORDER BY q.created_at)
FROM quiz.questions q
WHERE q.quiz_id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

-- Verify the quiz
SELECT 
    q.title,
    COUNT(qq.question_id) as question_count,
    SUM(qs.points) as total_points
FROM quiz.quizzes q
LEFT JOIN quiz.quiz_questions qq ON q.quiz_id = qq.quiz_id
LEFT JOIN quiz.questions qs ON qq.question_id = qs.question_id
WHERE q.quiz_id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
GROUP BY q.title;
