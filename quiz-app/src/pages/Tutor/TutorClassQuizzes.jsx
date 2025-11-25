import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, BookOpen, Loader2, Users, CheckCircle } from 'lucide-react';
import { quizApi } from '../../services/api';

const TutorClassQuizzes = ({ isDark }) => {
  const { levelId, classId } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [quizzes, setQuizzes] = useState([]);

  // Temporary: Level names
  const levelNames = {
    0: 'Level 0',
    1: 'Level 1'
  };

  useEffect(() => {
    fetchQuizzes();
  }, []);

  const fetchQuizzes = async () => {
    try {
      setLoading(true);
      const response = await quizApi.getQuizzes();
      const allQuizzes = response.data || [];
      
      // Show all quizzes (not filtering by level, as per requirement)
      // All students in a class share the same quizzes
      setQuizzes(allQuizzes);
    } catch (error) {
      console.error('Error fetching quizzes:', error);
    } finally {
      setLoading(false);
    }
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
          onClick={() => navigate(`/tutor/level/${levelId}/classes`)}
          className={`flex items-center gap-2 mb-6 px-4 py-2 rounded-lg transition-colors ${
            isDark 
              ? 'hover:bg-gray-800 text-gray-400 hover:text-white' 
              : 'hover:bg-gray-100 text-gray-600 hover:text-gray-900'
          }`}
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Classes
        </button>

        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-4 mb-4">
            <div className="p-4 rounded-xl bg-gradient-to-br from-purple-500 to-pink-500">
              <BookOpen className="w-8 h-8 text-white" />
            </div>
            <div>
              <h1 className={`text-4xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                Class {classId} Quizzes
              </h1>
              <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
                {levelNames[levelId]} • {quizzes.length} {quizzes.length === 1 ? 'Quiz' : 'Quizzes'}
              </p>
            </div>
          </div>
        </div>

        {/* Development Note */}
        <div className={`p-4 mb-6 rounded-lg border ${
          isDark ? 'bg-blue-900/10 border-blue-700' : 'bg-blue-50 border-blue-200'
        }`}>
          <p className={`text-sm ${isDark ? 'text-blue-400' : 'text-blue-700'}`}>
            <strong>Note:</strong> Currently showing all quizzes for {levelNames[levelId]}. All students in this class share the same quizzes.
          </p>
        </div>

        {/* Quizzes Grid */}
        {quizzes.length === 0 ? (
          <div className={`text-center py-16 rounded-xl border ${
            isDark ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
          }`}>
            <BookOpen className={`w-16 h-16 mx-auto mb-4 ${isDark ? 'text-gray-600' : 'text-gray-400'}`} />
            <h3 className={`text-2xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              No Quizzes Available
            </h3>
            <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
              No quizzes have been assigned to {levelNames[levelId]} yet.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {quizzes.map((quiz) => (
              <div
                key={quiz.quizId}
                className={`group rounded-xl border p-6 transition-all cursor-pointer hover:scale-105 ${
                  isDark 
                    ? 'border-gray-700 bg-gray-800 hover:border-blue-500 hover:shadow-blue-500/20' 
                    : 'border-gray-200 bg-white hover:border-blue-500 hover:shadow-blue-500/20'
                } shadow-lg hover:shadow-xl`}
                onClick={() => navigate(`/tutor/level/${levelId}/class/${classId}/quiz/${quiz.quizId}/students`)}
              >
                {/* Quiz Icon */}
                <div className="mb-4">
                  <div className={`inline-flex p-4 rounded-xl bg-gradient-to-br from-blue-500 to-cyan-500`}>
                    <BookOpen className="w-8 h-8 text-white" />
                  </div>
                </div>

                {/* Quiz Title */}
                <h3 className={`text-xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                  {quiz.title}
                </h3>

                {/* Quiz Description */}
                {quiz.description && (
                  <p className={`text-sm mb-4 line-clamp-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    {quiz.description}
                  </p>
                )}

                {/* Quiz Stats */}
                <div className={`pt-4 border-t ${isDark ? 'border-gray-700' : 'border-gray-200'}`}>
                  <div className="flex items-center justify-between text-sm">
                    <div className="flex items-center gap-2">
                      <Users className={`w-4 h-4 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                      <span className={isDark ? 'text-gray-400' : 'text-gray-600'}>
                        8 Students
                      </span>
                    </div>
                    <div className="flex items-center gap-2">
                      <CheckCircle className={`w-4 h-4 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                      <span className={isDark ? 'text-gray-400' : 'text-gray-600'}>
                        View Attempts
                      </span>
                    </div>
                  </div>
                </div>

                {/* Hover Arrow */}
                <div className={`mt-4 pt-4 border-t transition-all ${
                  isDark ? 'border-gray-700' : 'border-gray-200'
                } group-hover:translate-x-2`}>
                  <span className={`text-sm font-medium ${
                    isDark ? 'text-blue-400' : 'text-blue-600'
                  }`}>
                    View Students →
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default TutorClassQuizzes;
