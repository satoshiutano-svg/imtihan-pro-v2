/// Typed route paths and names for all 27 Imtihan Pro screens.
abstract final class RouteNames {
  // Foundation / Onboarding (Screens 1-5)
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String selectClass = '/onboarding/class';
  static const String selectBoard = '/onboarding/board';
  static const String selectGroup = '/onboarding/group';

  // Five-Tab Root Destinations
  static const String home = '/home';
  static const String learn = '/learn';
  static const String papers = '/papers';
  static const String practice = '/practice';
  static const String progress = '/progress';

  // Learn Sub-routes (Screens 7-11)
  static const String chapterList = 'chapters/:subjectId';
  static const String chapterOverview = 'chapter/:chapterId';
  static const String notesReader = 'notes/:chapterId';
  static const String quickRevision = 'revision/:chapterId';

  // Papers Sub-routes (Screens 12-15)
  static const String paperLibrary = 'library';
  static const String solvedPaper = 'paper/:paperId';
  static const String paperAnalysis = 'analysis';

  // Practice Sub-routes (Screens 16-20)
  static const String mcqPractice = 'mcq';
  static const String mockExamSetup = 'mock-setup';
  static const String mockExamSession = 'mock-session';
  static const String examResults = 'results';
  static const String mistakeReview = 'mistakes';

  // Progress & Student Utility Sub-routes (Screens 21-27)
  static const String bookmarks = '/bookmarks';
  static const String downloads = '/downloads';
  static const String studyPlanner = '/planner';
  static const String achievements = '/achievements';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
