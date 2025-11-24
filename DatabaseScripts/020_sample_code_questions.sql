-- Sample questions with code formatting for Input/Output questions
-- Run this script to add example questions to your database

-- Note: Replace the quiz_id UUID with your actual quiz ID
-- You can get quiz IDs by running: SELECT quiz_id, title FROM quiz.quizzes;

-- Example 1: Simple print statement (Python)
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What will this code print?

```python
print("Score:", 10)
```',
    'easy',
    30,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "Score:10"},
            {"id": "b", "text": "Score: 10"},
            {"id": "c", "text": "Score 10"},
            {"id": "d", "text": "10 Score"}
        ],
        "correctAnswer": "b"
    }'::jsonb
);

-- Example 2: Variable output
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What is the output of this code?

```python
x = 5
y = 10
print(x + y)
```',
    'easy',
    45,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "5"},
            {"id": "b", "text": "10"},
            {"id": "c", "text": "15"},
            {"id": "d", "text": "510"}
        ],
        "correctAnswer": "c"
    }'::jsonb
);

-- Example 3: String concatenation
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What will be printed?

```python
name = "Alice"
age = 25
print(name + " is " + str(age) + " years old")
```',
    'medium',
    60,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "Alice is 25 years old"},
            {"id": "b", "text": "name is age years old"},
            {"id": "c", "text": "Alice is age years old"},
            {"id": "d", "text": "Error"}
        ],
        "correctAnswer": "a"
    }'::jsonb
);

-- Example 4: Multiple print statements
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What is the output of this code?

```python
print("Hello")
print("World")
```',
    'easy',
    30,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "HelloWorld"},
            {"id": "b", "text": "Hello World"},
            {"id": "c", "text": "Hello\nWorld (on separate lines)"},
            {"id": "d", "text": "Hello\tWorld"}
        ],
        "correctAnswer": "c"
    }'::jsonb
);

-- Example 5: Input function
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What does the `input()` function return in Python?',
    'easy',
    45,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "Always returns a number"},
            {"id": "b", "text": "Always returns a string"},
            {"id": "c", "text": "Returns whatever type the user enters"},
            {"id": "d", "text": "Returns a list"}
        ],
        "correctAnswer": "b"
    }'::jsonb
);

-- Example 6: Type conversion
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What will happen when this code runs?

```python
age = input("Enter your age: ")
next_age = age + 1
print(next_age)
```',
    'medium',
    60,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "It will print the age plus 1"},
            {"id": "b", "text": "It will cause an error"},
            {"id": "c", "text": "It will print the age twice"},
            {"id": "d", "text": "It will print \"age + 1\""}
        ],
        "correctAnswer": "b"
    }'::jsonb
);

-- Example 7: Format strings
INSERT INTO quiz.questions (
    question_id,
    question_type,
    question_text,
    difficulty,
    estimated_seconds,
    subject,
    points,
    content
) VALUES (
    gen_random_uuid(),
    'multiple_choice_single',
    'What will this code print?

```python
name = "Bob"
score = 95
print(f"{name} scored {score} points")
```',
    'medium',
    60,
    'Python Input and Output',
    10,
    '{
        "options": [
            {"id": "a", "text": "Bob scored 95 points"},
            {"id": "b", "text": "{name} scored {score} points"},
            {"id": "c", "text": "name scored score points"},
            {"id": "d", "text": "Error"}
        ],
        "correctAnswer": "a"
    }'::jsonb
);

-- Now, link these questions to a quiz (you need to create the relationships)
-- Example: Link questions to quiz_id 'YOUR-QUIZ-ID-HERE'
/*
INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
SELECT 
    'YOUR-QUIZ-ID-HERE'::uuid as quiz_id,
    question_id,
    ROW_NUMBER() OVER (ORDER BY created_at) as position
FROM quiz.questions
WHERE subject = 'Python Input and Output'
  AND question_id NOT IN (SELECT question_id FROM quiz.quiz_questions WHERE quiz_id = 'YOUR-QUIZ-ID-HERE'::uuid);
*/
