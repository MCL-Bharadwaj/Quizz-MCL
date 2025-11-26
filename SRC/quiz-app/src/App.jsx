import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Sidebar from './components/Sidebar';

// Player Pages
import PlayerDashboard from './pages/Player/PlayerDashboard';
import PlayerQuizzes from './pages/Player/PlayerQuizzes';
import TakeQuiz from './pages/Player/TakeQuiz';
import PlayerAttempts from './pages/Player/PlayerAttempts';
import AttemptDetails from './pages/Player/AttemptDetails';

// Content Creator Pages
import CreatorDashboard from './pages/ContentCreator/CreatorDashboard';
import CreatorQuizzes from './pages/ContentCreator/CreatorQuizzes';
import CreatorCreateQuiz from './pages/ContentCreator/CreatorCreateQuiz';
import CreatorManageQuestions from './pages/ContentCreator/CreatorManageQuestions';

// Landing Page
import RoleSelector from './pages/RoleSelector';

import './index.css';

function App() {
  const [isDark, setIsDark] = useState(() => {
    const saved = localStorage.getItem('darkMode');
    return saved ? JSON.parse(saved) : false;
  });

  useEffect(() => {
    localStorage.setItem('darkMode', JSON.stringify(isDark));
    if (isDark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, [isDark]);

  const toggleTheme = () => setIsDark(!isDark);

  return (
    <Router>
      <Routes>
        {/* Landing Page - Role Selection */}
        <Route path="/" element={<RoleSelector isDark={isDark} toggleTheme={toggleTheme} />} />

        {/* Player ROUTES */}
        <Route path="/Player/*" element={
          <div className={`flex h-screen ${isDark ? 'bg-gray-950' : 'bg-gray-50'}`}>
            <Sidebar isDark={isDark} toggleTheme={toggleTheme} role="Player" />
            <main className="flex-1 overflow-auto">
              <Routes>
                <Route path="/" element={<Navigate to="/Player/dashboard" replace />} />
                <Route path="/dashboard" element={<PlayerDashboard isDark={isDark} />} />
                <Route path="/quizzes" element={<PlayerQuizzes isDark={isDark} />} />
                <Route path="/quiz/:quizId" element={<TakeQuiz isDark={isDark} />} />
                <Route path="/attempts" element={<PlayerAttempts isDark={isDark} />} />
                <Route path="/attempt/:attemptId" element={<AttemptDetails isDark={isDark} />} />
              </Routes>
            </main>
          </div>
        } />

        {/* Content Creator ROUTES */}
        <Route path="/creator/*" element={
          <div className={`flex h-screen ${isDark ? 'bg-gray-950' : 'bg-gray-50'}`}>
            <Sidebar isDark={isDark} toggleTheme={toggleTheme} role="creator" />
            <main className="flex-1 overflow-auto">
              <Routes>
                <Route path="/" element={<Navigate to="/creator/dashboard" replace />} />
                <Route path="/dashboard" element={<CreatorDashboard isDark={isDark} />} />
                <Route path="/quizzes" element={<CreatorQuizzes isDark={isDark} />} />
                <Route path="/quiz/create" element={<CreatorCreateQuiz isDark={isDark} />} />
                <Route path="/quiz/:quizId/questions" element={<CreatorManageQuestions isDark={isDark} />} />
              </Routes>
            </main>
          </div>
        } />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
