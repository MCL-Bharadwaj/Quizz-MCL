import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, Clock, CheckCircle, XCircle, FileText, Loader2 } from 'lucide-react';
import { attemptApi } from '../../services/api';

const TutorStudentQuizzes = ({ isDark }) => {
  const { studentId } = useParams();
  const navigate = useNavigate();
  const [attempts, setAttempts] = useState([]);
  const [loading, setLoading] = useState(true);

  // Get student name (temporary - will come from backend later)
  const studentNames = {
    'student_1763632299617_672': 'Alice Johnson',
    'student_2': 'Bob Smith',
    'student_3': 'Charlie Brown',
    'student_4': 'Diana Prince',
    'student_5': 'Ethan Hunt',
    'student_6': 'Fiona Green',
    'student_7': 'George Wilson',
    'student_8': 'Hannah Lee'
  };

  const studentName = studentNames[studentId] || 'Student';

  useEffect(() => {
    fetchAttempts();
  }, [studentId]);

  const fetchAttempts = async () => {
    try {
      setLoading(true);
      // Fetch all attempts for this student
      const data = await attemptApi.getUserAttempts(studentId);
      // Only show completed attempts
      const completedAttempts = data.filter(attempt => attempt.status === 'completed');
      setAttempts(completedAttempts);
    } catch (error) {
      console.error('Error fetching attempts:', error);
    } finally {
      setLoading(false);
    }
  };

  const getScoreColor = (percentage) => {
    if (percentage >= 90) return 'text-green-500';
    if (percentage >= 75) return 'text-blue-500';
    if (percentage >= 60) return 'text-yellow-500';
    return 'text-red-500';
  };

  const getScoreBgColor = (percentage) => {
    if (percentage >= 90) return isDark ? 'bg-green-900/30 border-green-700' : 'bg-green-50 border-green-200';
    if (percentage >= 75) return isDark ? 'bg-blue-900/30 border-blue-700' : 'bg-blue-50 border-blue-200';
    if (percentage >= 60) return isDark ? 'bg-yellow-900/30 border-yellow-700' : 'bg-yellow-50 border-yellow-200';
    return isDark ? 'bg-red-900/30 border-red-700' : 'bg-red-50 border-red-200';
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
      </div>
    );
  }

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-6xl mx-auto">
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
          Back to Students
        </button>

        {/* Header */}
        <div className="mb-8">
          <h1 className={`text-4xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
            {studentName}'s Quizzes
          </h1>
          <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
            {attempts.length} quiz{attempts.length !== 1 ? 'zes' : ''} completed
          </p>
        </div>

        {/* Attempts List */}
        {attempts.length === 0 ? (
          <div className={`text-center py-12 rounded-xl border ${
            isDark ? 'border-gray-700 bg-gray-800/50' : 'border-gray-200 bg-gray-50'
          }`}>
            <FileText className={`w-16 h-16 mx-auto mb-4 ${isDark ? 'text-gray-600' : 'text-gray-400'}`} />
            <p className={`text-lg ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              No completed quizzes yet
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {attempts.map((attempt) => {
              const percentage = attempt.scorePercentage || 0;
              const passed = percentage >= 60;

              return (
                <button
                  key={attempt.attemptId}
                  onClick={() => navigate(`/tutor/attempt/${attempt.attemptId}/review`)}
                  className={`w-full p-6 rounded-xl border-2 transition-all hover:shadow-lg text-left ${
                    isDark 
                      ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                      : 'border-gray-200 bg-white hover:border-blue-300'
                  }`}
                >
                  <div className="flex items-start justify-between gap-4">
                    {/* Quiz Info */}
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-2">
                        <div className={`p-2 rounded-lg ${
                          passed 
                            ? 'bg-green-500/20' 
                            : 'bg-red-500/20'
                        }`}>
                          {passed ? (
                            <CheckCircle className="w-5 h-5 text-green-500" />
                          ) : (
                            <XCircle className="w-5 h-5 text-red-500" />
                          )}
                        </div>
                        <h3 className={`text-xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                          Quiz ID: {attempt.quizId.substring(0, 8)}...
                        </h3>
                      </div>

                      <div className="flex items-center gap-4 text-sm">
                        <div className="flex items-center gap-2">
                          <Clock className={`w-4 h-4 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                          <span className={isDark ? 'text-gray-400' : 'text-gray-600'}>
                            {formatDate(attempt.completedAt)}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Score */}
                    <div className={`px-6 py-4 rounded-xl border ${getScoreBgColor(percentage)}`}>
                      <p className={`text-xs font-medium mb-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                        Score
                      </p>
                      <div className="flex items-baseline gap-2">
                        <span className={`text-3xl font-bold ${getScoreColor(percentage)}`}>
                          {Math.round(percentage)}%
                        </span>
                      </div>
                      <p className={`text-xs mt-1 ${isDark ? 'text-gray-500' : 'text-gray-600'}`}>
                        {attempt.totalScore || 0} / {attempt.maxPossibleScore || 0} pts
                      </p>
                    </div>
                  </div>

                  <div className="mt-4 pt-4 border-t border-gray-700">
                    <span className="text-blue-500 font-medium">Review Attempt →</span>
                  </div>
                </button>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
};

export default TutorStudentQuizzes;
