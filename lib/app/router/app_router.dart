import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/learn/presentation/screens/chapter_list_screen.dart';
import '../../features/learn/presentation/screens/chapter_overview_screen.dart';
import '../../features/learn/presentation/screens/detailed_notes_screen.dart';
import '../../features/learn/presentation/screens/quick_revision_screen.dart';
import '../../features/learn/presentation/screens/subject_selection_screen.dart';
import '../../features/onboarding/presentation/screens/board_selection_screen.dart';
import '../../features/onboarding/presentation/screens/class_selection_screen.dart';
import '../../features/onboarding/presentation/screens/group_selection_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/papers/presentation/screens/paper_analysis_screen.dart';
import '../../features/papers/presentation/screens/past_paper_library_screen.dart';
import '../../features/papers/presentation/screens/past_papers_dashboard_screen.dart';
import '../../features/papers/presentation/screens/solved_paper_screen.dart';
import '../../features/practice/presentation/screens/exam_results_screen.dart';
import '../../features/practice/presentation/screens/mcq_practice_screen.dart';
import '../../features/practice/presentation/screens/mistake_review_screen.dart';
import '../../features/practice/presentation/screens/mock_exam_screen.dart';
import '../../features/practice/presentation/screens/mock_exam_setup_screen.dart';
import '../../features/progress/presentation/screens/achievements_screen.dart';
import '../../features/progress/presentation/screens/progress_dashboard_screen.dart';
import '../../features/progress/presentation/screens/study_planner_screen.dart';
import '../../features/student/presentation/screens/bookmarks_screen.dart';
import '../../features/student/presentation/screens/downloads_screen.dart';
import '../../features/student/presentation/screens/profile_screen.dart';
import '../../features/student/presentation/screens/settings_screen.dart';
import 'main_navigation_shell.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      // Foundation & Onboarding (Screens 1-5)
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.selectClass,
        builder: (context, state) => const ClassSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.selectBoard,
        builder: (context, state) => const BoardSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.selectGroup,
        builder: (context, state) => const GroupSelectionScreen(),
      ),

      // Top-level Student Utility Routes (Screens 22-27)
      GoRoute(
        path: RouteNames.bookmarks,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: RouteNames.downloads,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DownloadsScreen(),
      ),
      GoRoute(
        path: RouteNames.studyPlanner,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StudyPlannerScreen(),
      ),
      GoRoute(
        path: RouteNames.achievements,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Five-Tab Application Shell (Screens 6-21)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeDashboardScreen(),
              ),
            ],
          ),

          // Tab 2: Learn
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.learn,
                builder: (context, state) => const SubjectSelectionScreen(),
                routes: [
                  GoRoute(
                    path: RouteNames.chapterList,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ChapterListScreen(
                      subjectId: state.pathParameters['subjectId'] ?? 'physics',
                    ),
                  ),
                  GoRoute(
                    path: RouteNames.chapterOverview,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => ChapterOverviewScreen(
                      chapterId: state.pathParameters['chapterId'] ?? 'phy_ch3',
                    ),
                  ),
                  GoRoute(
                    path: RouteNames.notesReader,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => DetailedNotesScreen(
                      chapterId: state.pathParameters['chapterId'] ?? 'phy_ch3',
                    ),
                  ),
                  GoRoute(
                    path: RouteNames.quickRevision,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => QuickRevisionScreen(
                      chapterId: state.pathParameters['chapterId'] ?? 'phy_ch3',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Papers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.papers,
                builder: (context, state) => const PastPapersDashboardScreen(),
                routes: [
                  GoRoute(
                    path: RouteNames.paperLibrary,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const PastPaperLibraryScreen(),
                  ),
                  GoRoute(
                    path: RouteNames.solvedPaper,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => SolvedPaperScreen(
                      paperId:
                          state.pathParameters['paperId'] ?? 'paper_phy_2025',
                    ),
                  ),
                  GoRoute(
                    path: RouteNames.paperAnalysis,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const PaperAnalysisScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 4: Practice
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.practice,
                builder: (context, state) => const McqPracticeScreen(),
                routes: [
                  GoRoute(
                    path: RouteNames.mockExamSetup,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const MockExamSetupScreen(),
                  ),
                  GoRoute(
                    path: RouteNames.mockExamSession,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const MockExamScreen(),
                  ),
                  GoRoute(
                    path: RouteNames.examResults,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ExamResultsScreen(),
                  ),
                  GoRoute(
                    path: RouteNames.mistakeReview,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const MistakeReviewScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 5: Progress
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.progress,
                builder: (context, state) => const ProgressDashboardScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
