import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { quizApi } from '../../services/api';
import { 
  Plus, 
  Edit, 
  Trash2, 
  BookOpen, 
  Clock, 
  BarChart,
  ArrowLeft,
  Search
} from 'lucide-react';

const CreatorLevelQuizzes = ({ isDark }) => {
  const { levelId } = useParams();
  const navigate = useNavigate();
  const [quizzes, setQuizzes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterDifficulty, setFilterDifficulty] = useState('all');

  const levelNames = {
    0: 'Level 0 - Foundation',
    1: 'Level 1 - Beginner',
    2: 'Level 2 - Intermediate',
    3: 'Level 3 - Advanced',
    4: 'Level 4 - Expert',
    'cs-explorer': 'CS Explorer',
  };

  useEffect(() => {
    fetchQuizzes();
  }, [levelId]);

  const fetchQuizzes = async () => {
    setLoading(true);
    try {
      const response = await quizApi.getQuizzes();
      // For now, show all quizzes regardless of level (as per requirement)
      setQuizzes(response.data || []);
    } catch (error) {
      console.error('Error fetching quizzes:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateQuiz = () => {
    navigate('/creator/quiz/create', { state: { levelId } });
  };

  const handleEditQuiz = (quizId) => {
    navigate(`/creator/quiz/${quizId}/questions`);
  };

  const handleDeleteQuiz = async (quizId) => {
    if (window.confirm('Are you sure you want to delete this quiz?')) {
      try {
        await quizApi.deleteQuiz(quizId);
        fetchQuizzes();
      } catch (error) {
        console.error('Error deleting quiz:', error);
        alert('Failed to delete quiz');
      }
    }
  };

  const getDifficultyColor = (difficulty) => {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return isDark ? 'text-green-400 bg-green-900/30' : 'text-green-700 bg-green-100';
      case 'medium':
        return isDark ? 'text-yellow-400 bg-yellow-900/30' : 'text-yellow-700 bg-yellow-100';
      case 'hard':
        return isDark ? 'text-red-400 bg-red-900/30' : 'text-red-700 bg-red-100';
      default:
        return isDark ? 'text-gray-400 bg-gray-700' : 'text-gray-700 bg-gray-200';
    }
  };

  const filteredQuizzes = quizzes.filter((quiz) => {
    const matchesSearch = quiz.title?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          quiz.description?.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesDifficulty = filterDifficulty === 'all' || quiz.difficulty === filterDifficulty;
    return matchesSearch && matchesDifficulty;
  });

  return (
    <div className="p-8">
      {/* Header */}
      <div className="mb-8">
        <button
          onClick={() => navigate('/creator/dashboard')}
          className={`
            flex items-center gap-2 mb-4 px-4 py-2 rounded-lg transition-colors
            ${isDark 
              ? 'text-gray-300 hover:text-white hover:bg-gray-800' 
              : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
            }
          `}
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Back to Dashboard</span>
        </button>

        <div className="flex items-center justify-between">
          <div>
            <h1 className={`text-4xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              {levelNames[levelId] || 'Unknown Level'}
            </h1>
            <p className={`text-lg ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              Manage quizzes for this level
            </p>
          </div>
          <button
            onClick={handleCreateQuiz}
            className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-lg hover:from-blue-700 hover:to-blue-800 transition-all shadow-lg hover:shadow-xl"
          >
            <Plus className="w-5 h-5" />
            <span className="font-semibold">Create New Quiz</span>
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className={`
        mb-6 p-4 rounded-lg flex flex-wrap gap-4
        ${isDark ? 'bg-gray-800' : 'bg-white shadow'}
      `}>
        {/* Search */}
        <div className="flex-1 min-w-[200px]">
          <div className="relative">
            <Search className={`absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
            <input
              type="text"
              placeholder="Search quizzes..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className={`
                w-full pl-10 pr-4 py-2 rounded-lg border transition-colors
                ${isDark 
                  ? 'bg-gray-700 border-gray-600 text-white placeholder-gray-400 focus:border-blue-500' 
                  : 'bg-white border-gray-300 text-gray-900 placeholder-gray-500 focus:border-blue-500'
                }
                focus:outline-none focus:ring-2 focus:ring-blue-500/20
              `}
            />
          </div>
        </div>

        {/* Difficulty Filter */}
        <div>
          <select
            value={filterDifficulty}
            onChange={(e) => setFilterDifficulty(e.target.value)}
            className={`
              px-4 py-2 rounded-lg border transition-colors cursor-pointer
              ${isDark 
                ? 'bg-gray-700 border-gray-600 text-white focus:border-blue-500' 
                : 'bg-white border-gray-300 text-gray-900 focus:border-blue-500'
              }
              focus:outline-none focus:ring-2 focus:ring-blue-500/20
            `}
          >
            <option value="all">All Difficulties</option>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </select>
        </div>
      </div>

      {/* Info Note */}
      <div className={`
        mb-6 p-4 rounded-lg border
        ${isDark ? 'bg-yellow-900/20 border-yellow-800 text-yellow-300' : 'bg-yellow-50 border-yellow-200 text-yellow-800'}
      `}>
        <p className="text-sm">
          <strong>Temporary Note:</strong> All quizzes are currently displayed here, regardless of level. 
          Level-based filtering will be implemented after discussing with stakeholders.
        </p>
      </div>

      {/* Quizzes List */}
      {loading ? (
        <div className="flex items-center justify-center h-64">
          <div className={`text-lg ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
            Loading quizzes...
          </div>
        </div>
      ) : filteredQuizzes.length === 0 ? (
        <div className={`
          text-center py-16 rounded-lg
          ${isDark ? 'bg-gray-800' : 'bg-white shadow'}
        `}>
          <BookOpen className={`w-16 h-16 mx-auto mb-4 ${isDark ? 'text-gray-600' : 'text-gray-400'}`} />
          <h3 className={`text-xl font-semibold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
            No quizzes found
          </h3>
          <p className={`mb-6 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
            {searchQuery || filterDifficulty !== 'all' 
              ? 'Try adjusting your filters' 
              : 'Create your first quiz to get started'
            }
          </p>
          {!searchQuery && filterDifficulty === 'all' && (
            <button
              onClick={handleCreateQuiz}
              className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Create First Quiz
            </button>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredQuizzes.map((quiz) => (
            <div
              key={quiz.quizId}
              className={`
                rounded-lg shadow-md overflow-hidden transition-all hover:shadow-xl
                ${isDark ? 'bg-gray-800' : 'bg-white'}
              `}
            >
              {/* Quiz Header */}
              <div className="p-6 pb-4">
                <h3 className={`text-xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                  {quiz.title}
                </h3>
                <p className={`text-sm mb-4 line-clamp-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                  {quiz.description || 'No description available'}
                </p>

                {/* Tags */}
                <div className="flex flex-wrap gap-2 mb-4">
                  {quiz.difficulty && (
                    <span className={`px-3 py-1 rounded-full text-xs font-medium ${getDifficultyColor(quiz.difficulty)}`}>
                      {quiz.difficulty}
                    </span>
                  )}
                  {quiz.subject && (
                    <span className={`px-3 py-1 rounded-full text-xs font-medium ${isDark ? 'bg-gray-700 text-gray-300' : 'bg-gray-100 text-gray-700'}`}>
                      {quiz.subject}
                    </span>
                  )}
                </div>

                {/* Stats */}
                <div className="flex items-center gap-4 text-sm">
                  {quiz.estimatedMinutes && (
                    <div className={`flex items-center gap-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                      <Clock className="w-4 h-4" />
                      <span>{quiz.estimatedMinutes} min</span>
                    </div>
                  )}
                  <div className={`flex items-center gap-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    <BarChart className="w-4 h-4" />
                    <span>Age {quiz.ageMin || 'N/A'}-{quiz.ageMax || 'N/A'}</span>
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className={`
                px-6 py-4 flex gap-2 border-t
                ${isDark ? 'border-gray-700 bg-gray-800/50' : 'border-gray-200 bg-gray-50'}
              `}>
                <button
                  onClick={() => handleEditQuiz(quiz.quizId)}
                  className={`
                    flex-1 flex items-center justify-center gap-2 px-4 py-2 rounded-lg transition-colors
                    ${isDark 
                      ? 'bg-blue-600 hover:bg-blue-700 text-white' 
                      : 'bg-blue-600 hover:bg-blue-700 text-white'
                    }
                  `}
                >
                  <Edit className="w-4 h-4" />
                  <span>Manage</span>
                </button>
                <button
                  onClick={() => handleDeleteQuiz(quiz.quizId)}
                  className={`
                    px-4 py-2 rounded-lg transition-colors
                    ${isDark 
                      ? 'bg-red-600/20 hover:bg-red-600/30 text-red-400' 
                      : 'bg-red-100 hover:bg-red-200 text-red-700'
                    }
                  `}
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Results Count */}
      {!loading && filteredQuizzes.length > 0 && (
        <div className={`mt-6 text-center text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
          Showing {filteredQuizzes.length} of {quizzes.length} quizzes
        </div>
      )}
    </div>
  );
};

export default CreatorLevelQuizzes;
