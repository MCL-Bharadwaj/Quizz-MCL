-- Quick test: Add one sample question with code formatting
-- This will help test the CodeBlock component

-- First, let's see what quizzes exist
SELECT quiz_id, title FROM quiz.quizzes LIMIT 5;

-- Add a test question (run the INSERT after confirming a quiz exists above)
-- Replace 'QUIZ-ID-HERE' with an actual quiz_id from the query above

/*
DO $$
DECLARE
    v_question_id UUID := gen_random_uuid();
    v_quiz_id UUID := 'QUIZ-ID-HERE'::uuid; -- CHANGE THIS!
    v_next_position INT;
BEGIN
    -- Insert the question
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
        v_question_id,
        'multiple_choice_single',
        'What will this code print?

```python
print("Score:", 10)
```',
        'easy',
        30,
        'Python',
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

    -- Get the next position for this quiz
    SELECT COALESCE(MAX(position), 0) + 1 INTO v_next_position
    FROM quiz.quiz_questions
    WHERE quiz_id = v_quiz_id;

    -- Link to quiz
    INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
    VALUES (v_quiz_id, v_question_id, v_next_position);

    RAISE NOTICE 'Question added successfully with ID: %', v_question_id;
END $$;
*/
