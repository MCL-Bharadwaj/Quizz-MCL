import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, User, Loader2, Eye, CheckCircle, XCircle, Clock } from 'lucide-react';
import { quizApi, attemptApi } from '../../services/api';

const TutorQuizStudents = ({ isDark }) => {
  const { levelId, classId, quizId } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [quiz, setQuiz] = useState(null);
  const [students, setStudents] = useState([]);

  // Get the actual student user ID from localStorage (same as student dashboard uses)
  const actualStudentId = localStorage.getItem('userId_student');
  
  // Temporary: Show the same student's attempts for all 8 student cards
  // This allows us to see the actual quiz data/responses
  const allStudents = [
    { id: actualStudentId, name: 'Alice Johnson', avatar: '👩' },
    { id: actualStudentId, name: 'Bob Smith', avatar: '👨' },
    { id: actualStudentId, name: 'Charlie Brown', avatar: '👦' },
    { id: actualStudentId, name: 'Diana Prince', avatar: '👩' },
    { id: actualStudentId, name: 'Ethan Hunt', avatar: '👨' },
    { id: actualStudentId, name: 'Fiona Green', avatar: '👩' },
    { id: actualStudentId, name: 'George Wilson', avatar: '👨' },
    { id: actualStudentId, name: 'Hannah Lee', avatar: '👩' }
  ].filter(student => student.id); // Filter out if no actual student ID exists

  useEffect(() => {
    fetchQuizAndAttempts();
  }, [quizId]);

  const fetchQuizAndAttempts = async () => {
    try {
      setLoading(true);
      
      // Fetch quiz details
      const quizData = await quizApi.getQuizById(quizId);
      setQuiz(quizData);

      // Fetch attempts for each student
      const studentsWithAttempts = await Promise.all(
        allStudents.map(async (student) => {
          try {
            const attemptsResponse = await attemptApi.getUserAttempts(student.id);
            const attempts = attemptsResponse.data || attemptsResponse.attempts || [];
            
            // Filter attempts for this specific quiz (both completed and in-progress)
            const quizAttempts = attempts.filter(
              attempt => attempt.quizId === quizId
            );

            // Get the latest attempt (most recent by startedAt date)
            const latestAttempt = quizAttempts.length > 0
              ? quizAttempts.reduce((latest, current) => {
                  const currentDate = new Date(current.startedAt);
                  const latestDate = new Date(latest.startedAt);
                  return currentDate > latestDate ? current : latest;
                })
              : null;

            return {
              ...student,
              latestAttempt: latestAttempt,
              attemptStatus: latestAttempt?.status || 'not_started',
              score: latestAttempt?.scorePercentage || 0,
              attemptDate: latestAttempt ? new Date(latestAttempt.startedAt) : null
            };
          } catch (error) {
            console.error(`Error fetching attempts for ${student.name}:`, error);
            return {
              ...student,
              latestAttempt: null,
              attemptStatus: 'not_started',
              score: 0,
              attemptDate: null
            };
          }
        })
      );

      setStudents(studentsWithAttempts);
    } catch (error) {
      console.error('Error fetching quiz and attempts:', error);
    } finally {
      setLoading(false);
    }
  };

  const getScoreColor = (score) => {
    if (score >= 90) return 'text-green-500';
    if (score >= 75) return 'text-blue-500';
    if (score >= 60) return 'text-yellow-500';
    return 'text-red-500';
  };

  const getScoreBgColor = (score) => {
    if (score >= 90) return isDark ? 'bg-green-900/30' : 'bg-green-100';
    if (score >= 75) return isDark ? 'bg-blue-900/30' : 'bg-blue-100';
    if (score >= 60) return isDark ? 'bg-yellow-900/30' : 'bg-yellow-100';
    return isDark ? 'bg-red-900/30' : 'bg-red-100';
  };

  const formatDate = (date) => {
    if (!date) return 'Not attempted';
    return new Date(date).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric'
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
      </div>
    );
  }

  if (!quiz) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>Quiz not found</p>
      </div>
    );
  }

  // Separate students into attempted and not attempted
  const studentsWithAttempts = students.filter(s => s.attemptStatus !== 'not_started');
  const studentsWithoutAttempts = students.filter(s => s.attemptStatus === 'not_started');

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-6xl mx-auto">
        {/* Back Button */}
        <button
          onClick={() => navigate(`/tutor/level/${levelId}/class/${classId}/quizzes`)}
          className={`flex items-center gap-2 mb-6 px-4 py-2 rounded-lg transition-colors ${
            isDark 
              ? 'hover:bg-gray-800 text-gray-400 hover:text-white' 
              : 'hover:bg-gray-100 text-gray-600 hover:text-gray-900'
          }`}
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Quizzes
        </button>

        {/* Quiz Header */}
        <div className={`p-6 rounded-xl border mb-8 ${
          isDark ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
        }`}>
          <div className="flex items-start gap-4">
            <div className="p-4 rounded-xl bg-gradient-to-br from-blue-500 to-cyan-500">
              <Eye className="w-8 h-8 text-white" />
            </div>
            <div className="flex-1">
              <h1 className={`text-3xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                {quiz.title}
              </h1>
              {quiz.description && (
                <p className={`mb-3 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                  {quiz.description}
                </p>
              )}
              <div className="flex items-center gap-4 text-sm">
                <span className={`px-3 py-1 rounded-full ${
                  isDark ? 'bg-blue-900/30 text-blue-400' : 'bg-blue-100 text-blue-700'
                }`}>
                  {studentsWithAttempts.length} / {students.length} Students Attempted
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Students Who Attempted */}
        {studentsWithAttempts.length > 0 && (
          <div className="mb-8">
            <h2 className={`text-2xl font-bold mb-4 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Student Attempts
            </h2>
            <div className="grid gap-4">
              {studentsWithAttempts
                .sort((a, b) => b.score - a.score)
                .map((student) => (
                  <div
                    key={student.id}
                    className={`p-6 rounded-xl border transition-all ${
                      isDark 
                        ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                        : 'border-gray-200 bg-white hover:border-gray-300'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4 flex-1">
                        {/* Avatar */}
                        <div className="w-16 h-16 rounded-full bg-gradient-to-br from-blue-500 to-purple-500 flex items-center justify-center text-3xl">
                          {student.avatar}
                        </div>

                        {/* Student Info */}
                        <div className="flex-1">
                          <h3 className={`text-xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                            {student.name}
                          </h3>
                          <div className="flex items-center gap-4 mt-2">
                            <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                              student.attemptStatus === 'completed'
                                ? isDark ? 'bg-green-900/30 text-green-400' : 'bg-green-100 text-green-700'
                                : isDark ? 'bg-blue-900/30 text-blue-400' : 'bg-blue-100 text-blue-700'
                            }`}>
                              {student.attemptStatus === 'completed' ? 'Completed' : 'In Progress'}
                            </span>
                            <div className="flex items-center gap-2">
                              <Clock className={`w-4 h-4 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                              <span className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                                {formatDate(student.attemptDate)}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* Score or Status */}
                        {student.attemptStatus === 'completed' ? (
                          <div className={`px-6 py-4 rounded-xl ${getScoreBgColor(student.score)}`}>
                            <p className={`text-sm font-medium mb-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                              Score
                            </p>
                            <p className={`text-3xl font-bold ${getScoreColor(student.score)}`}>
                              {Math.round(student.score)}%
                            </p>
                          </div>
                        ) : (
                          <div className={`px-6 py-4 rounded-xl ${
                            isDark ? 'bg-blue-900/30' : 'bg-blue-100'
                          }`}>
                            <p className={`text-sm font-medium mb-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                              Status
                            </p>
                            <p className={`text-lg font-bold ${isDark ? 'text-blue-400' : 'text-blue-600'}`}>
                              In Progress
                            </p>
                          </div>
                        )}

                        {/* View Details Button */}
                        <button
                          onClick={() => {
                            if (student.latestAttempt) {
                              if (student.attemptStatus === 'completed') {
                                navigate(`/tutor/attempt/${student.latestAttempt.attemptId}/review`);
                              } else {
                                alert('This attempt is still in progress. Student needs to complete the quiz first.');
                              }
                            }
                          }}
                          disabled={student.attemptStatus !== 'completed'}
                          className={`px-6 py-3 rounded-lg font-medium transition-all flex items-center gap-2 ${
                            student.attemptStatus === 'completed'
                              ? isDark
                                ? 'bg-blue-600 hover:bg-blue-700 text-white'
                                : 'bg-blue-500 hover:bg-blue-600 text-white'
                              : isDark
                                ? 'bg-gray-700 text-gray-500 cursor-not-allowed'
                                : 'bg-gray-200 text-gray-400 cursor-not-allowed'
                          }`}
                        >
                          <Eye className="w-5 h-5" />
                          View Details
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        )}

        {/* Students Who Haven't Attempted */}
        {studentsWithoutAttempts.length > 0 && (
          <div>
            <h2 className={`text-2xl font-bold mb-4 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Not Yet Attempted
            </h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {studentsWithoutAttempts.map((student) => (
                <div
                  key={student.id}
                  className={`p-4 rounded-xl border text-center ${
                    isDark 
                      ? 'border-gray-700 bg-gray-800/50' 
                      : 'border-gray-200 bg-gray-50'
                  }`}
                >
                  <div className="w-12 h-12 mx-auto mb-2 rounded-full bg-gradient-to-br from-gray-500 to-gray-600 flex items-center justify-center text-2xl">
                    {student.avatar}
                  </div>
                  <p className={`font-medium text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    {student.name}
                  </p>
                  <p className={`text-xs mt-1 ${isDark ? 'text-gray-500' : 'text-gray-500'}`}>
                    No attempts
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default TutorQuizStudents;
