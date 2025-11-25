import { useParams, useNavigate } from 'react-router-dom';
import { Users, ArrowLeft, GraduationCap } from 'lucide-react';

const TutorLevelClasses = ({ isDark }) => {
  const { levelId } = useParams();
  const navigate = useNavigate();

  const levelNames = {
    '0': 'Level 0 - Foundational Programming',
    '1': 'Level 1 - Basic Python Programming'
  };

  // Temporary: 2 classes per level
  const classes = [
    {
      id: 1,
      name: 'Class 1',
      studentCount: 8,
      color: 'from-blue-500 to-indigo-500'
    },
    {
      id: 2,
      name: 'Class 2',
      studentCount: 8,
      color: 'from-purple-500 to-pink-500'
    }
  ];

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
          <div className="flex items-center gap-3 mb-2">
            <div className="p-3 rounded-lg bg-gradient-to-br from-blue-500 to-cyan-500">
              <GraduationCap className="w-6 h-6 text-white" />
            </div>
            <h1 className={`text-4xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
              {levelNames[levelId] || `Level ${levelId}`}
            </h1>
          </div>
          <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
            Select a class to view its quizzes and student performance
          </p>
        </div>

        {/* Classes Grid */}
        <div className="grid md:grid-cols-2 gap-6">
          {classes.map((classItem) => (
            <button
              key={classItem.id}
              onClick={() => navigate(`/tutor/level/${levelId}/class/${classItem.id}/quizzes`)}
              className={`p-8 rounded-2xl border-2 transition-all transform hover:scale-105 hover:shadow-xl text-left ${
                isDark 
                  ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                  : 'border-gray-200 bg-white hover:border-gray-300'
              }`}
            >
              <div className={`inline-flex p-4 rounded-xl bg-gradient-to-br ${classItem.color} mb-4`}>
                <Users className="w-8 h-8 text-white" />
              </div>
              
              <h3 className={`text-2xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                {classItem.name}
              </h3>
              
              <div className="flex items-center justify-between mt-6">
                <div>
                  <p className={`text-3xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                    {classItem.studentCount}
                  </p>
                  <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    Students
                  </p>
                </div>
                <span className="text-blue-500 font-medium">View Students →</span>
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TutorLevelClasses;
