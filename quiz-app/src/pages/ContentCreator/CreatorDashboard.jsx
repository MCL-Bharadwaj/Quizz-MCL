import { useNavigate } from 'react-router-dom';
import { 
  BookOpen, 
  Code, 
  Rocket, 
  Trophy, 
  Zap, 
  Globe 
} from 'lucide-react';

const CreatorDashboard = ({ isDark }) => {
  const navigate = useNavigate();

  const levels = [
    {
      id: 0,
      name: 'Level 0',
      title: 'Foundation',
      description: 'Basic concepts and introduction to programming',
      icon: BookOpen,
      color: 'from-blue-500 to-blue-600',
      bgLight: 'bg-blue-50',
      bgDark: 'bg-blue-900/20',
      textColor: 'text-blue-600',
      darkTextColor: 'text-blue-400',
    },
    {
      id: 1,
      name: 'Level 1',
      title: 'Beginner',
      description: 'Core programming fundamentals and simple algorithms',
      icon: Code,
      color: 'from-green-500 to-green-600',
      bgLight: 'bg-green-50',
      bgDark: 'bg-green-900/20',
      textColor: 'text-green-600',
      darkTextColor: 'text-green-400',
    },
    {
      id: 2,
      name: 'Level 2',
      title: 'Intermediate',
      description: 'Data structures and problem-solving techniques',
      icon: Zap,
      color: 'from-yellow-500 to-yellow-600',
      bgLight: 'bg-yellow-50',
      bgDark: 'bg-yellow-900/20',
      textColor: 'text-yellow-600',
      darkTextColor: 'text-yellow-400',
    },
    {
      id: 3,
      name: 'Level 3',
      title: 'Advanced',
      description: 'Complex algorithms and advanced programming concepts',
      icon: Rocket,
      color: 'from-purple-500 to-purple-600',
      bgLight: 'bg-purple-50',
      bgDark: 'bg-purple-900/20',
      textColor: 'text-purple-600',
      darkTextColor: 'text-purple-400',
    },
    {
      id: 4,
      name: 'Level 4',
      title: 'Expert',
      description: 'Master-level challenges and competitive programming',
      icon: Trophy,
      color: 'from-red-500 to-red-600',
      bgLight: 'bg-red-50',
      bgDark: 'bg-red-900/20',
      textColor: 'text-red-600',
      darkTextColor: 'text-red-400',
    },
    {
      id: 'cs-explorer',
      name: 'CS Explorer',
      title: 'CS Explorer',
      description: 'Computer Science fundamentals and exploration',
      icon: Globe,
      color: 'from-indigo-500 to-indigo-600',
      bgLight: 'bg-indigo-50',
      bgDark: 'bg-indigo-900/20',
      textColor: 'text-indigo-600',
      darkTextColor: 'text-indigo-400',
    },
  ];

  const handleLevelClick = (levelId) => {
    navigate(`/creator/level/${levelId}/quizzes`);
  };

  return (
    <div className="p-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className={`text-4xl font-bold mb-2 ${isDark ? 'text-white' : 'text-gray-900'}`}>
          Content Creator Dashboard
        </h1>
        <p className={`text-lg ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
          Select a level to view and manage quizzes
        </p>
      </div>

      {/* Level Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {levels.map((level) => {
          const Icon = level.icon;
          return (
            <div
              key={level.id}
              onClick={() => handleLevelClick(level.id)}
              className={`
                relative overflow-hidden rounded-xl shadow-lg cursor-pointer
                transform transition-all duration-300 hover:scale-105 hover:shadow-2xl
                ${isDark ? 'bg-gray-800' : 'bg-white'}
              `}
            >
              {/* Gradient Header */}
              <div className={`h-32 bg-gradient-to-br ${level.color} p-6 relative`}>
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-white text-2xl font-bold mb-1">
                      {level.name}
                    </h3>
                    <p className="text-white/90 font-semibold">
                      {level.title}
                    </p>
                  </div>
                  <div className="bg-white/20 backdrop-blur-sm rounded-full p-3">
                    <Icon className="w-8 h-8 text-white" />
                  </div>
                </div>
              </div>

              {/* Card Content */}
              <div className="p-6">
                <p className={`text-sm mb-4 ${isDark ? 'text-gray-300' : 'text-gray-600'}`}>
                  {level.description}
                </p>
                
                <div className={`
                  inline-flex items-center gap-2 px-4 py-2 rounded-lg font-medium
                  ${isDark ? level.bgDark : level.bgLight}
                  ${isDark ? level.darkTextColor : level.textColor}
                `}>
                  <span>View Quizzes</span>
                  <svg 
                    className="w-4 h-4" 
                    fill="none" 
                    stroke="currentColor" 
                    viewBox="0 0 24 24"
                  >
                    <path 
                      strokeLinecap="round" 
                      strokeLinejoin="round" 
                      strokeWidth={2} 
                      d="M9 5l7 7-7 7" 
                    />
                  </svg>
                </div>
              </div>

              {/* Hover Effect Overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-transparent to-black/5 opacity-0 hover:opacity-100 transition-opacity duration-300 pointer-events-none" />
            </div>
          );
        })}
      </div>

      {/* Info Note */}
      <div className={`
        mt-8 p-4 rounded-lg border
        ${isDark ? 'bg-blue-900/20 border-blue-800 text-blue-300' : 'bg-blue-50 border-blue-200 text-blue-800'}
      `}>
        <p className="text-sm">
          <strong>Note:</strong> Currently, all quizzes are displayed under Level 1, regardless of their actual level. 
          Level-based quiz segregation will be implemented in a future update.
        </p>
      </div>
    </div>
  );
};

export default CreatorDashboard;
