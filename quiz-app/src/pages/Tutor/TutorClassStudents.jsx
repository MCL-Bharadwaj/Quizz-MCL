import { useParams, useNavigate } from 'react-router-dom';
import { User, ArrowLeft, GraduationCap, TrendingUp } from 'lucide-react';

const TutorClassStudents = ({ isDark }) => {
  const { levelId, classId } = useParams();
  const navigate = useNavigate();

  // Temporary: 8 students per class
  const students = [
    { id: 'student_1763632299617_672', name: 'Alice Johnson', quizzesCompleted: 12, avgScore: 85 },
    { id: 'student_2', name: 'Bob Smith', quizzesCompleted: 10, avgScore: 78 },
    { id: 'student_3', name: 'Charlie Brown', quizzesCompleted: 15, avgScore: 92 },
    { id: 'student_4', name: 'Diana Prince', quizzesCompleted: 8, avgScore: 88 },
    { id: 'student_5', name: 'Ethan Hunt', quizzesCompleted: 14, avgScore: 76 },
    { id: 'student_6', name: 'Fiona Green', quizzesCompleted: 11, avgScore: 90 },
    { id: 'student_7', name: 'George Wilson', quizzesCompleted: 9, avgScore: 82 },
    { id: 'student_8', name: 'Hannah Lee', quizzesCompleted: 13, avgScore: 95 }
  ];

  const getScoreColor = (score) => {
    if (score >= 90) return 'text-green-500';
    if (score >= 75) return 'text-blue-500';
    if (score >= 60) return 'text-yellow-500';
    return 'text-red-500';
  };

  const getScoreBgColor = (score) => {
    if (score >= 90) return isDark ? 'bg-green-900/30' : 'bg-green-50';
    if (score >= 75) return isDark ? 'bg-blue-900/30' : 'bg-blue-50';
    if (score >= 60) return isDark ? 'bg-yellow-900/30' : 'bg-yellow-50';
    return isDark ? 'bg-red-900/30' : 'bg-red-50';
  };

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
          <div className="flex items-center gap-3 mb-2">
            <div className="p-3 rounded-lg bg-gradient-to-br from-purple-500 to-pink-500">
              <GraduationCap className="w-6 h-6 text-white" />
            </div>
            <h1 className={`text-4xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
              Class {classId} Students
            </h1>
          </div>
          <p className={isDark ? 'text-gray-400' : 'text-gray-600'}>
            Level {levelId} • {students.length} Students
          </p>
        </div>

        {/* Students Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
          {students.map((student) => (
            <button
              key={student.id}
              onClick={() => navigate(`/tutor/student/${student.id}/quizzes`)}
              className={`p-6 rounded-xl border-2 transition-all transform hover:scale-105 hover:shadow-lg text-left ${
                isDark 
                  ? 'border-gray-700 bg-gray-800 hover:border-gray-600' 
                  : 'border-gray-200 bg-white hover:border-blue-300'
              }`}
            >
              {/* Student Avatar */}
              <div className="flex items-center gap-3 mb-4">
                <div className="p-3 rounded-full bg-gradient-to-br from-blue-500 to-purple-500">
                  <User className="w-6 h-6 text-white" />
                </div>
                <div className="flex-1 min-w-0">
                  <h3 className={`font-bold truncate ${isDark ? 'text-white' : 'text-gray-900'}`}>
                    {student.name}
                  </h3>
                </div>
              </div>

              {/* Stats */}
              <div className="space-y-3">
                <div>
                  <p className={`text-xs mb-1 ${isDark ? 'text-gray-500' : 'text-gray-500'}`}>
                    Quizzes Completed
                  </p>
                  <p className={`text-2xl font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                    {student.quizzesCompleted}
                  </p>
                </div>

                <div className={`p-3 rounded-lg ${getScoreBgColor(student.avgScore)}`}>
                  <div className="flex items-center justify-between">
                    <span className={`text-xs font-medium ${isDark ? 'text-gray-400' : 'text-gray-600'}`}>
                      Avg Score
                    </span>
                    <TrendingUp className={`w-4 h-4 ${getScoreColor(student.avgScore)}`} />
                  </div>
                  <p className={`text-2xl font-bold mt-1 ${getScoreColor(student.avgScore)}`}>
                    {student.avgScore}%
                  </p>
                </div>
              </div>

              <div className="mt-4 pt-4 border-t border-gray-700">
                <span className="text-blue-500 text-sm font-medium">View Quizzes →</span>
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TutorClassStudents;
