import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, BookOpen, Users, Plus, X, Loader2, Check } from 'lucide-react';
import { quizApi } from '../../services/api';

const TutorAssignedQuizzes = ({ isDark }) => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [quizzes, setQuizzes] = useState([]);
  const [showAssignModal, setShowAssignModal] = useState(false);
  const [selectedQuiz, setSelectedQuiz] = useState(null);
  const [selectedClasses, setSelectedClasses] = useState([]);

  // Temporary: Hardcoded levels and classes
  const levels = [
    { id: 0, name: 'Level 0' },
    { id: 1, name: 'Level 1' }
  ];

  const classes = [
    { id: 1, name: 'Level 0 - Class 1', levelId: 0 },
    { id: 2, name: 'Level 0 - Class 2', levelId: 0 },
    { id: 3, name: 'Level 1 - Class 1', levelId: 1 },
    { id: 4, name: 'Level 1 - Class 2', levelId: 1 }
  ];

  // Temporary: Hardcoded assignments (quiz → classes)
  const [assignments, setAssignments] = useState({
    // quizId: [classId1, classId2, ...]
    // Example: quiz 'abc123' is assigned to classes 1 and 2
  });

  useEffect(() => {
    fetchQuizzes();
  }, []);

  const fetchQuizzes = async () => {
    try {
      setLoading(true);
      const response = await quizApi.getQuizzes();
      setQuizzes(response.data || []);
    } catch (error) {
      console.error('Error fetching quizzes:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenAssign = (quiz) => {
    setSelectedQuiz(quiz);
    setSelectedClasses(assignments[quiz.quizId] || []);
    setShowAssignModal(true);
  };

  const handleToggleClass = (classId) => {
    if (selectedClasses.includes(classId)) {
      setSelectedClasses(selectedClasses.filter(id => id !== classId));
    } else {
      setSelectedClasses([...selectedClasses, classId]);
    }
  };

  const handleSaveAssignment = () => {
    // TODO: Implement assignment save API endpoint
    console.log('Assigning quiz', selectedQuiz.quizId, 'to classes', selectedClasses);
    
    // Update local state
    setAssignments({
      ...assignments,
      [selectedQuiz.quizId]: selectedClasses
    });

    alert('Quiz assignment saved! (Note: API endpoint needs to be implemented)');
    setShowAssignModal(false);
    setSelectedQuiz(null);
    setSelectedClasses([]);
  };

  const getAssignedClassesText = (quizId) => {
    const assignedIds = assignments[quizId] || [];
    if (assignedIds.length === 0) return 'Not assigned';
    
    const assignedNames = assignedIds.map(id => {
      const cls = classes.find(c => c.id === id);
      return cls ? cls.name : '';
    }).filter(Boolean);

    return assignedNames.join(', ');
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
          onClick={() => navigate('/tutor')}
          className={`flex items-center gap-2 mb-6 px-4 py-2 rounded-lg transition-colors ${
            isDark 
              ? 'hover:bg-gray-800 text-gray-400 hover:text-white' 
              : 'hover:bg-gray-100 text-gray-600 hover:text-gray-900'
          }`}
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Dashboard
        </button>

        {/* Header */}
        <div className="mb-8">
          <h1 className={`text-4xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
            Assigned Quizzes
          </h1>
          <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
            View and manage quiz assignments to your classes
          </p>
        </div>

        {/* Development Note */}
        <div className={`p-4 mb-6 rounded-lg border ${
          isDark ? 'bg-blue-900/10 border-blue-700' : 'bg-blue-50 border-blue-200'
        }`}>
          <p className={`text-sm ${isDark ? 'text-blue-400' : 'text-blue-700'}`}>
            <strong>Note:</strong> Currently showing temporary data. Quiz assignments are stored locally and will be replaced with database backend.
          </p>
        </div>

        {/* Quizzes List */}
        {quizzes.length === 0 ? (
          <div className={`text-center py-12 rounded-xl border ${
            isDark ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
          }`}>
            <BookOpen className={`w-16 h-16 mx-auto mb-4 ${isDark ? 'text-gray-600' : 'text-gray-400'}`} />
            <p className={`text-lg ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              No quizzes available
            </p>
          </div>
        ) : (
          <div className="grid gap-4">
            {quizzes.map((quiz) => {
              const assignedIds = assignments[quiz.quizId] || [];
              const isAssigned = assignedIds.length > 0;

              return (
                <div
                  key={quiz.quizId}
                  className={`p-6 rounded-xl border transition-all ${
                    isDark 
                      ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                      : 'border-gray-200 bg-white hover:border-gray-300'
                  }`}
                >
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-3">
                        <div className={`p-3 rounded-lg bg-gradient-to-br from-blue-500 to-purple-500`}>
                          <BookOpen className="w-6 h-6 text-white" />
                        </div>
                        <div>
                          <h3 className={`text-xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                            {quiz.title}
                          </h3>
                          {quiz.description && (
                            <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                              {quiz.description}
                            </p>
                          )}
                        </div>
                      </div>

                      {/* Assignment Status */}
                      <div className="flex items-start gap-4 mt-4">
                        <div className="flex items-center gap-2">
                          <Users className={`w-5 h-5 ${isDark ? 'text-gray-500' : 'text-gray-400'}`} />
                          <span className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                            Assigned to:
                          </span>
                        </div>
                        <div className="flex-1">
                          {isAssigned ? (
                            <div className="flex flex-wrap gap-2">
                              {assignedIds.map(classId => {
                                const cls = classes.find(c => c.id === classId);
                                return cls ? (
                                  <span
                                    key={classId}
                                    className={`px-3 py-1 rounded-full text-sm font-medium ${
                                      isDark ? 'bg-green-900/30 text-green-400' : 'bg-green-100 text-green-700'
                                    }`}
                                  >
                                    {cls.name}
                                  </span>
                                ) : null;
                              })}
                            </div>
                          ) : (
                            <span className={`text-sm italic ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                              Not assigned to any class
                            </span>
                          )}
                        </div>
                      </div>
                    </div>

                    {/* Assign Button */}
                    <button
                      onClick={() => handleOpenAssign(quiz)}
                      className={`ml-4 px-4 py-2 rounded-lg font-medium transition-colors flex items-center gap-2 ${
                        isAssigned
                          ? isDark
                            ? 'bg-gray-700 hover:bg-gray-600 text-white'
                            : 'bg-gray-200 hover:bg-gray-300 text-gray-900'
                          : 'bg-blue-500 hover:bg-blue-600 text-white'
                      }`}
                    >
                      <Plus className="w-5 h-5" />
                      {isAssigned ? 'Edit Assignment' : 'Assign to Class'}
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Assignment Modal */}
      {showAssignModal && selectedQuiz && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className={`max-w-2xl w-full rounded-xl p-6 ${
            isDark ? 'bg-gray-800 border border-gray-700' : 'bg-white'
          }`}>
            <div className="flex items-center justify-between mb-6">
              <h2 className={`text-2xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                Assign Quiz to Classes
              </h2>
              <button
                onClick={() => setShowAssignModal(false)}
                className={`p-2 rounded-lg transition-colors ${
                  isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
                }`}
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className={`p-4 mb-6 rounded-lg border ${
              isDark ? 'border-gray-700 bg-gray-900' : 'border-gray-200 bg-gray-50'
            }`}>
              <p className={`font-medium ${isDark ? 'text-white' : 'text-gray-900'}`}>
                {selectedQuiz.title}
              </p>
              {selectedQuiz.description && (
                <p className={`text-sm mt-1 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                  {selectedQuiz.description}
                </p>
              )}
            </div>

            <p className={`mb-4 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              Select the classes you want to assign this quiz to:
            </p>

            {/* Classes by Level */}
            <div className="space-y-4 mb-6">
              {levels.map(level => {
                const levelClasses = classes.filter(c => c.levelId === level.id);
                
                return (
                  <div key={level.id}>
                    <h3 className={`text-sm font-medium mb-2 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                      {level.name}
                    </h3>
                    <div className="grid grid-cols-2 gap-3">
                      {levelClasses.map(cls => {
                        const isSelected = selectedClasses.includes(cls.id);
                        
                        return (
                          <button
                            key={cls.id}
                            onClick={() => handleToggleClass(cls.id)}
                            className={`p-4 rounded-lg border-2 transition-all text-left relative ${
                              isSelected
                                ? 'border-blue-500 bg-blue-500/10'
                                : isDark
                                  ? 'border-gray-700 hover:border-gray-600'
                                  : 'border-gray-200 hover:border-gray-300'
                            }`}
                          >
                            <div className="flex items-center justify-between">
                              <div>
                                <p className={`font-medium ${isDark ? 'text-white' : 'text-gray-900'}`}>
                                  {cls.name.replace(`${level.name} - `, '')}
                                </p>
                                <p className={`text-sm ${isDark ? 'text-gray-500' : 'text-gray-600'}`}>
                                  8 students
                                </p>
                              </div>
                              {isSelected && (
                                <Check className="w-6 h-6 text-blue-500" />
                              )}
                            </div>
                          </button>
                        );
                      })}
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Action Buttons */}
            <div className="flex gap-3">
              <button
                onClick={handleSaveAssignment}
                disabled={selectedClasses.length === 0}
                className={`flex-1 px-6 py-3 rounded-lg font-medium transition-all flex items-center justify-center gap-2 ${
                  selectedClasses.length === 0
                    ? 'bg-gray-500 cursor-not-allowed'
                    : 'bg-blue-500 hover:bg-blue-600'
                } text-white`}
              >
                <Check className="w-5 h-5" />
                Save Assignment
              </button>
              <button
                onClick={() => setShowAssignModal(false)}
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

export default TutorAssignedQuizzes;
