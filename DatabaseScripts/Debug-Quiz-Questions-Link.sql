-- ============================================================================
-- Debug Script: Check Quiz-Questions Relationship
-- Use this to diagnose issues with quizzes showing 0% score
-- ============================================================================

-- 1. Check which quizzes have questions in quiz_questions table
SELECT 
    q.quiz_id,
    q.title,
    COUNT(qq.question_id) as question_count
FROM quiz.quizzes q
LEFT JOIN quiz.quiz_questions qq ON q.quiz_id = qq.quiz_id
WHERE q.deleted_at IS NULL
GROUP BY q.quiz_id, q.title
ORDER BY q.created_at DESC;

-- 2. Check for orphaned questions (questions not linked to any quiz)
SELECT 
    question_id,
    question_text,
    question_type,
    created_at
FROM quiz.questions
WHERE deleted_at IS NULL
    AND question_id NOT IN (SELECT question_id FROM quiz.quiz_questions);

-- 3. Check attempts and their associated quiz questions
SELECT 
    a.attempt_id,
    a.quiz_id,
    q.title as quiz_title,
    a.status,
    a.total_score,
    a.max_possible_score,
    a.score_percentage,
    COUNT(DISTINCT qq.question_id) as questions_in_quiz,
    COUNT(DISTINCT r.question_id) as questions_answered
FROM quiz.attempts a
LEFT JOIN quiz.quizzes q ON a.quiz_id = q.quiz_id
LEFT JOIN quiz.quiz_questions qq ON a.quiz_id = qq.quiz_id
LEFT JOIN quiz.responses r ON a.attempt_id = r.attempt_id
WHERE a.created_at > NOW() - INTERVAL '1 day'  -- Last 24 hours
GROUP BY a.attempt_id, a.quiz_id, q.title, a.status, a.total_score, a.max_possible_score, a.score_percentage
ORDER BY a.created_at DESC;

-- 4. Check responses without corresponding quiz_questions entries (the bug!)
SELECT 
    r.response_id,
    r.attempt_id,
    a.quiz_id,
    r.question_id,
    r.points_earned,
    r.points_possible,
    q.question_text,
    CASE 
        WHEN qq.question_id IS NULL THEN 'NOT LINKED TO QUIZ'
        ELSE 'LINKED'
    END as link_status
FROM quiz.responses r
INNER JOIN quiz.attempts a ON r.attempt_id = a.attempt_id
INNER JOIN quiz.questions q ON r.question_id = q.question_id
LEFT JOIN quiz.quiz_questions qq ON a.quiz_id = qq.quiz_id AND r.question_id = qq.question_id
WHERE a.created_at > NOW() - INTERVAL '1 day'
ORDER BY r.created_at DESC;

-- 5. Fix orphaned responses by creating quiz_questions entries
-- WARNING: Only run this if you've verified the issue exists!
-- UNCOMMENT THE LINES BELOW TO FIX:

/*
INSERT INTO quiz.quiz_questions (quiz_id, question_id, position)
SELECT DISTINCT 
    a.quiz_id,
    r.question_id,
    ROW_NUMBER() OVER (PARTITION BY a.quiz_id ORDER BY r.created_at) as position
FROM quiz.responses r
INNER JOIN quiz.attempts a ON r.attempt_id = a.attempt_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM quiz.quiz_questions qq 
    WHERE qq.quiz_id = a.quiz_id AND qq.question_id = r.question_id
)
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- After running the fix, recalculate scores for affected attempts
UPDATE quiz.attempts a
SET 
    total_score = (
        SELECT COALESCE(SUM(r.points_earned), 0)
        FROM quiz.responses r
        WHERE r.attempt_id = a.attempt_id
    ),
    max_possible_score = (
        SELECT COALESCE(SUM(r.points_possible), 0)
        FROM quiz.responses r
        WHERE r.attempt_id = a.attempt_id
    ),
    score_percentage = (
        CASE 
            WHEN (SELECT COALESCE(SUM(r.points_possible), 0) FROM quiz.responses r WHERE r.attempt_id = a.attempt_id) > 0
            THEN ((SELECT COALESCE(SUM(r.points_earned), 0) FROM quiz.responses r WHERE r.attempt_id = a.attempt_id) / 
                  (SELECT COALESCE(SUM(r.points_possible), 0) FROM quiz.responses r WHERE r.attempt_id = a.attempt_id) * 100)
            ELSE 0
        END
    )
WHERE a.status = 'completed'
    AND a.created_at > NOW() - INTERVAL '1 day';
*/
