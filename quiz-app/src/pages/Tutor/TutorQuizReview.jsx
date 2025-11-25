import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  ArrowLeft, CheckCircle, XCircle, Clock, Loader2, MessageSquare, 
  FileText, Send, X 
} from 'lucide-react';
import { attemptApi, quizApi, responseApi } from '../../services/api';
import { QuestionText } from '../../components/CodeBlock';

const TutorQuizReview = ({ isDark }) => {
  const { attemptId } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [attempt, setAttempt] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [responses, setResponses] = useState({});
  const [feedbackModal, setFeedbackModal] = useState({ open: false, questionId: null });
  const [feedbackText, setFeedbackText] = useState('');
  const [overallFeedback, setOverallFeedback] = useState('');
  const [showOverallFeedback, setShowOverallFeedback] = useState(false);

  useEffect(() => {
    fetchAttemptData();
  }, [attemptId]);

  const fetchAttemptData = async () => {
    try {
      setLoading(true);
      
      // Fetch attempt details
      const attemptData = await attemptApi.getAttemptById(attemptId);
      setAttempt(attemptData);

      // Fetch quiz questions
      const questionsData = await quizApi.getQuizQuestions(attemptData.quizId);
      setQuestions(questionsData.questions || []);

      // Fetch student responses
      const responsesData = await attemptApi.getAttemptResponses(attemptId);
      const responsesArray = responsesData.data || responsesData.responses || [];
      
      // Convert responses array to object for easy lookup
      const responsesObj = {};
      responsesArray.forEach(response => {
        responsesObj[response.questionId] = response;
      });
      setResponses(responsesObj);

    } catch (error) {
      console.error('Error fetching attempt data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenFeedback = (questionId) => {
    const response = responses[questionId];
    setFeedbackText(response?.gradingDetails?.feedback || '');
    setFeedbackModal({ open: true, questionId });
  };

  const handleSaveFeedback = async () => {
    // TODO: Implement feedback save API endpoint
    console.log('Saving feedback for question:', feedbackModal.questionId, feedbackText);
    alert('Feedback saved! (Note: API endpoint needs to be implemented)');
    setFeedbackModal({ open: false, questionId: null });
    setFeedbackText('');
  };

  const handleSaveOverallFeedback = () => {
    // TODO: Implement overall feedback save API endpoint
    console.log('Saving overall feedback for attempt:', attemptId, overallFeedback);
    alert('Overall feedback saved! (Note: API endpoint needs to be implemented)');
    setShowOverallFeedback(false);
  };

  const renderAnswer = (question, studentAnswer) => {
    if (!studentAnswer) return <span className="text-gray-500 italic">No answer provided</span>;

    if (question.questionType === 'multiple_choice_single') {
      return <span className="font-medium">{studentAnswer}</span>;
    }

    if (question.questionType === 'multiple_choice_multiple') {
      return (
        <div className="flex flex-wrap gap-2">
          {studentAnswer.map((ans, idx) => (
            <span key={idx} className={`px-3 py-1 rounded-full text-sm ${
              isDark ? 'bg-blue-900/30 text-blue-400' : 'bg-blue-100 text-blue-700'
            }`}>
              {ans}
            </span>
          ))}
        </div>
      );
    }

    if (question.questionType === 'true_false') {
      return <span className="font-medium">{studentAnswer ? 'True' : 'False'}</span>;
    }

    if (question.questionType === 'fill_in_blank' || question.questionType === 'short_answer') {
      return <span className="font-medium">{studentAnswer}</span>;
    }

    return <pre className={`p-4 rounded-lg ${isDark ? 'bg-gray-900' : 'bg-gray-100'}`}>
      {JSON.stringify(studentAnswer, null, 2)}
    </pre>;
  };

  const renderCorrectAnswer = (question) => {
    const content = question.content;

    if (question.questionType === 'multiple_choice_single') {
      return <span className="font-medium text-green-500">{content.correct_answer}</span>;
    }

    if (question.questionType === 'multiple_choice_multiple') {
      return (
        <div className="flex flex-wrap gap-2">
          {content.correct_answers.map((ans, idx) => (
            <span key={idx} className="px-3 py-1 rounded-full text-sm bg-green-500/20 text-green-500">
              {ans}
            </span>
          ))}
        </div>
      );
    }

    if (question.questionType === 'true_false') {
      return <span className="font-medium text-green-500">{content.correct_answer ? 'True' : 'False'}</span>;
    }

    if (question.questionType === 'fill_in_blank') {
      return (
        <div className="space-y-1">
          {content.correct_answers.map((ans, idx) => (
            <div key={idx} className="text-green-500 font-medium">• {ans}</div>
          ))}
        </div>
      );
    }

    if (question.questionType === 'short_answer') {
      return (
        <div className="space-y-1">
          {content.sample_answers.map((ans, idx) => (
            <div key={idx} className="text-green-500">• {ans}</div>
          ))}
        </div>
      );
    }

    return <span className="text-gray-500 italic">Complex answer type</span>;
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
      </div>
    );
  }

  if (!attempt) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>Attempt not found</p>
      </div>
    );
  }

  const percentage = attempt.scorePercentage || 0;

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-5xl mx-auto">
        {/* Back Button */}
        <button
          onClick={() => navigate(-1)}
          className={`flex items-center gap-2 mb-6 px-4 py-2 rounded-lg transition-colors ${
            isDark 
              ? 'hover:bg-gray-800 text-gray-400 hover:text-white' 
              : 'hover:bg-gray-100 text-gray-600 hover:text-gray-900'
          }`}
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Quizzes
        </button>

        {/* Header */}
        <div className={`p-6 rounded-xl border mb-6 ${
          isDark ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
        }`}>
          <div className="flex items-start justify-between mb-4">
            <div>
              <h1 className={`text-3xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                Quiz Review
              </h1>
              <div className="flex items-center gap-4 text-sm">
                <div className="flex items-center gap-2">
                  <Clock className={`w-4 h-4 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                  <span className={isDark ? 'text-gray-400' : 'text-gray-600'}>
                    {new Date(attempt.completedAt).toLocaleString()}
                  </span>
                </div>
              </div>
            </div>

            <div className="text-right">
              <p className={`text-sm mb-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                Final Score
              </p>
              <p className={`text-4xl font-bold ${
                percentage >= 90 ? 'text-green-500' :
                percentage >= 75 ? 'text-blue-500' :
                percentage >= 60 ? 'text-yellow-500' : 'text-red-500'
              }`}>
                {Math.round(percentage)}%
              </p>
              <p className={`text-sm mt-1 ${isDark ? 'text-gray-500' : 'text-gray-600'}`}>
                {attempt.totalScore || 0} / {attempt.maxPossibleScore || 0} points
              </p>
            </div>
          </div>

          {/* Overall Feedback Button */}
          <button
            onClick={() => setShowOverallFeedback(true)}
            className="w-full mt-4 px-4 py-3 bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 text-white rounded-lg font-medium transition-all flex items-center justify-center gap-2"
          >
            <MessageSquare className="w-5 h-5" />
            Provide Overall Feedback
          </button>
        </div>

        {/* Questions and Answers */}
        <div className="space-y-6">
          {questions.map((question, index) => {
            const response = responses[question.questionId];
            const isCorrect = response?.isCorrect;

            return (
              <div
                key={question.questionId}
                className={`p-6 rounded-xl border-2 ${
                  isDark ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
                }`}
              >
                {/* Question Header */}
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-3">
                      <span className={`flex items-center justify-center w-8 h-8 rounded-full font-bold ${
                        isDark ? 'bg-gray-700 text-white' : 'bg-gray-100 text-gray-900'
                      }`}>
                        {index + 1}
                      </span>
                      <h3 className={`text-lg font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                        Question {index + 1}
                      </h3>
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                        isDark ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-600'
                      }`}>
                        {question.points} pts
                      </span>
                    </div>
                    <div className={isDark ? 'text-gray-300' : 'text-gray-700'}>
                      <QuestionText text={question.questionText} isDark={isDark} />
                    </div>
                  </div>

                  <div className={`flex items-center gap-2 px-4 py-2 rounded-lg ${
                    isCorrect 
                      ? 'bg-green-500/20 text-green-500' 
                      : 'bg-red-500/20 text-red-500'
                  }`}>
                    {isCorrect ? (
                      <>
                        <CheckCircle className="w-5 h-5" />
                        <span className="font-medium">Correct</span>
                      </>
                    ) : (
                      <>
                        <XCircle className="w-5 h-5" />
                        <span className="font-medium">Incorrect</span>
                      </>
                    )}
                  </div>
                </div>

                {/* Student Answer */}
                <div className={`p-4 rounded-lg mb-3 ${
                  isDark ? 'bg-gray-900' : 'bg-gray-50'
                }`}>
                  <p className={`text-sm font-medium mb-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    Student's Answer:
                  </p>
                  <div className={isDark ? 'text-white' : 'text-gray-900'}>
                    {renderAnswer(question, response?.answerPayload)}
                  </div>
                </div>

                {/* Correct Answer */}
                <div className={`p-4 rounded-lg mb-3 ${
                  isDark ? 'bg-green-900/10' : 'bg-green-50'
                }`}>
                  <p className={`text-sm font-medium mb-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    Correct Answer:
                  </p>
                  <div className={isDark ? 'text-white' : 'text-gray-900'}>
                    {renderCorrectAnswer(question)}
                  </div>
                </div>

                {/* Existing Feedback */}
                {response?.gradingDetails?.feedback && (
                  <div className={`p-4 rounded-lg mb-3 ${
                    isDark ? 'bg-blue-900/10 border border-blue-700' : 'bg-blue-50 border border-blue-200'
                  }`}>
                    <p className={`text-sm font-medium mb-2 ${isDark ? 'text-blue-400' : 'text-blue-700'}`}>
                      Tutor Feedback:
                    </p>
                    <p className={isDark ? 'text-gray-300' : 'text-gray-700'}>
                      {response.gradingDetails.feedback}
                    </p>
                  </div>
                )}

                {/* Feedback Button */}
                <button
                  onClick={() => handleOpenFeedback(question.questionId)}
                  className={`w-full px-4 py-2 rounded-lg border-2 border-dashed transition-all hover:scale-105 flex items-center justify-center gap-2 ${
                    isDark 
                      ? 'border-gray-700 hover:border-blue-500 hover:bg-gray-700 text-gray-400 hover:text-white' 
                      : 'border-gray-300 hover:border-blue-500 hover:bg-blue-50 text-gray-600 hover:text-blue-600'
                  }`}
                >
                  <MessageSquare className="w-5 h-5" />
                  {response?.gradingDetails?.feedback ? 'Edit Feedback' : 'Add Feedback'}
                </button>
              </div>
            );
          })}
        </div>
      </div>

      {/* Question Feedback Modal */}
      {feedbackModal.open && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className={`max-w-2xl w-full rounded-xl p-6 ${
            isDark ? 'bg-gray-800 border border-gray-700' : 'bg-white'
          }`}>
            <div className="flex items-center justify-between mb-4">
              <h2 className={`text-2xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                Provide Feedback
              </h2>
              <button
                onClick={() => setFeedbackModal({ open: false, questionId: null })}
                className={`p-2 rounded-lg transition-colors ${
                  isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
                }`}
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <textarea
              value={feedbackText}
              onChange={(e) => setFeedbackText(e.target.value)}
              placeholder="Enter your feedback for this question..."
              rows={6}
              className={`w-full p-4 rounded-lg border resize-none ${
                isDark 
                  ? 'bg-gray-900 border-gray-700 text-white placeholder-gray-500' 
                  : 'bg-white border-gray-300 text-gray-900 placeholder-gray-400'
              }`}
            />

            <div className="flex gap-3 mt-4">
              <button
                onClick={handleSaveFeedback}
                className="flex-1 px-6 py-3 bg-blue-500 hover:bg-blue-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center gap-2"
              >
                <Send className="w-5 h-5" />
                Save Feedback
              </button>
              <button
                onClick={() => setFeedbackModal({ open: false, questionId: null })}
                className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                  isDark 
                    ? 'bg-gray-700 hover:bg-gray-600 text-white' 
                    : 'bg-gray-200 hover:bg-gray-300 text-gray-900'
                }`}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Overall Feedback Modal */}
      {showOverallFeedback && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className={`max-w-2xl w-full rounded-xl p-6 ${
            isDark ? 'bg-gray-800 border border-gray-700' : 'bg-white'
          }`}>
            <div className="flex items-center justify-between mb-4">
              <h2 className={`text-2xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                Overall Quiz Feedback
              </h2>
              <button
                onClick={() => setShowOverallFeedback(false)}
                className={`p-2 rounded-lg transition-colors ${
                  isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
                }`}
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <p className={`mb-4 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              Provide a summary of the student's overall performance on this quiz.
            </p>

            <textarea
              value={overallFeedback}
              onChange={(e) => setOverallFeedback(e.target.value)}
              placeholder="Enter your overall feedback for this quiz attempt..."
              rows={6}
              className={`w-full p-4 rounded-lg border resize-none ${
                isDark 
                  ? 'bg-gray-900 border-gray-700 text-white placeholder-gray-500' 
                  : 'bg-white border-gray-300 text-gray-900 placeholder-gray-400'
              }`}
            />

            <div className="flex gap-3 mt-4">
              <button
                onClick={handleSaveOverallFeedback}
                className="flex-1 px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-500 hover:from-blue-600 hover:to-purple-600 text-white rounded-lg font-medium transition-all flex items-center justify-center gap-2"
              >
                <Send className="w-5 h-5" />
                Save Overall Feedback
              </button>
              <button
                onClick={() => setShowOverallFeedback(false)}
                className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                  isDark 
                    ? 'bg-gray-700 hover:bg-gray-600 text-white' 
                    : 'bg-gray-200 hover:bg-gray-300 text-gray-900'
                }`}
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TutorQuizReview;
