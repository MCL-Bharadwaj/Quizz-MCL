-- Script to add code formatting to existing Python I/O questions
-- This will wrap code snippets in backticks for proper formatting

-- First, check which questions need formatting
SELECT 
    question_id, 
    LEFT(question_text, 100) as preview,
    subject
FROM quiz.questions
WHERE subject LIKE '%Python%' OR subject LIKE '%Input%'
ORDER BY created_at;

-- Example updates for common patterns:

-- Pattern 1: Questions with print() that need formatting
-- UPDATE quiz.questions
-- SET question_text = REPLACE(
--     question_text,
--     'print("Score:", 10)',
--     '```python
-- print("Score:", 10)
-- ```'
-- )
-- WHERE question_text LIKE '%print(%' 
--   AND question_text NOT LIKE '%```%';

-- Pattern 2: If you have questions like "What will this code print? print("Score:", 10)"
-- You can update them individually:

-- Example for a specific question:
-- UPDATE quiz.questions
-- SET question_text = 'What will this code print?
--
-- ```python
-- print("Score:", 10)
-- ```'
-- WHERE question_id = 'YOUR-QUESTION-ID'::uuid;

-- SAFER APPROACH: Update questions one by one
-- Step 1: Find the question
SELECT question_id, question_text 
FROM quiz.questions 
WHERE question_text LIKE '%print%'
  AND question_text NOT LIKE '%```%'
LIMIT 10;

-- Step 2: For each question, create an UPDATE statement
-- Template:
/*
UPDATE quiz.questions
SET question_text = 'What will this code print?

```python
[YOUR CODE HERE]
```'
WHERE question_id = 'QUESTION-ID-HERE'::uuid;
*/
