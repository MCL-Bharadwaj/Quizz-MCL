import { useNavigate } from 'react-router-dom';
import { BookOpen, Users, ClipboardList } from 'lucide-react';

const TutorDashboard = ({ isDark }) => {
  const navigate = useNavigate();

  // Temporary: Only Level 0 and Level 1 for now
  const levels = [
    {
      id: 0,
      name: 'Level 0',
      description: 'Foundational Programming Concepts',
      icon: BookOpen,
      color: 'from-blue-500 to-cyan-500'
    },
    {
      id: 1,
      name: 'Level 1',
      description: 'Basic Python Programming',
      icon: BookOpen,
      color: 'from-green-500 to-emerald-500'
    }
  ];

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className={`text-4xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
            Tutor Dashboard
          </h1>
          <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
            Manage your classes, students, and quiz assignments
          </p>
        </div>

        {/* Quick Actions */}
        <div className="grid md:grid-cols-3 gap-6 mb-8">
          <button
            onClick={() => navigate('/tutor/assigned-quizzes')}
            className={`p-6 rounded-xl border-2 border-dashed transition-all hover:scale-105 ${
              isDark 
                ? 'border-gray-700 bg-gray-800/50 hover:bg-gray-800 hover:border-blue-500' 
                : 'border-gray-300 bg-white hover:bg-blue-50 hover:border-blue-500'
            }`}
          >
            <ClipboardList className="w-8 h-8 mb-3 text-blue-500" />
            <h3 className={`text-lg font-semibold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Assigned Quizzes
            </h3>
            <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              View and manage quiz assignments for your classes
            </p>
          </button>

          <div className={`p-6 rounded-xl border ${
            isDark ? 'border-gray-700 bg-gray-800/50' : 'border-gray-200 bg-white'
          }`}>
            <Users className="w-8 h-8 mb-3 text-green-500" />
            <h3 className={`text-lg font-semibold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Total Students
            </h3>
            <p className={`text-3xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
              16
            </p>
            <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              Across 4 classes
            </p>
          </div>

          <div className={`p-6 rounded-xl border ${
            isDark ? 'border-gray-700 bg-gray-800/50' : 'border-gray-200 bg-white'
          }`}>
            <BookOpen className="w-8 h-8 mb-3 text-purple-500" />
            <h3 className={`text-lg font-semibold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Active Levels
            </h3>
            <p className={`text-3xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
              2
            </p>
            <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
              Level 0 & Level 1
            </p>
          </div>
        </div>

        {/* Levels Section */}
        <div className="mb-8">
          <h2 className={`text-2xl font-bold mb-4 ${isDark ? 'text-white' : 'text-gray-900'}`}>
            Teaching Levels
          </h2>
          <p className={`mb-6 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
            Select a level to view classes and students
          </p>

          <div className="grid md:grid-cols-2 gap-6">
            {levels.map((level) => {
              const Icon = level.icon;
              return (
                <button
                  key={level.id}
                  onClick={() => navigate(`/tutor/level/${level.id}/classes`)}
                  className={`p-8 rounded-2xl border-2 transition-all transform hover:scale-105 hover:shadow-xl text-left ${
                    isDark 
                      ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                      : 'border-gray-200 bg-white hover:border-gray-300'
                  }`}
                >
                  <div className={`inline-flex p-4 rounded-xl bg-gradient-to-br ${level.color} mb-4`}>
                    <Icon className="w-8 h-8 text-white" />
                  </div>
                  
                  <h3 className={`text-2xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
                    {level.name}
                  </h3>
                  
                  <p className={`mb-4 ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                    {level.description}
                  </p>

                  <div className="flex items-center justify-between">
                    <span className={`text-sm font-medium ${isDark ? 'text-gray-500' : 'text-gray-500'}`}>
                      2 Classes • 8 Students each
                    </span>
                    <span className="text-blue-500 font-medium">View Classes →</span>
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* Note for Development */}
        <div className={`p-4 rounded-lg border ${
          isDark ? 'bg-yellow-900/20 border-yellow-700' : 'bg-yellow-50 border-yellow-200'
        }`}>
          <p className={`text-sm ${isDark ? 'text-yellow-400' : 'text-yellow-800'}`}>
            <strong>Note:</strong> Login segregation is not yet implemented. Currently showing Level 0 and Level 1 with temporary class/student data.
          </p>
        </div>
      </div>
    </div>
  );
};

export default TutorDashboard;
