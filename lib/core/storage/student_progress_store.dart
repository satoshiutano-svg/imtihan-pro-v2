import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/practice_models.dart';
import '../../data/models/student_models.dart';

/// Persists real student activity (completed chapters, bookmarks, downloads,
/// study minutes, MCQ stats, exam history, planner tasks, and app preferences).
@immutable
class StudentActivityState {
  const StudentActivityState({
    this.completedChapterIds = const {},
    this.bookmarkedChapterIds = const {},
    this.bookmarkedPaperIds = const {},
    this.downloadedChapterIds = const {},
    this.downloadedPaperIds = const {},
    this.studyMinutes = 0,
    this.mcqsAttempted = 0,
    this.mcqsCorrect = 0,
    this.lastChapterId,
    this.lastSubjectId,
    this.examHistory = const [],
    this.studyTasks = const [],
    this.notificationsEnabled = true,
    this.offlineModeEnabled = false,
  });

  final Set<String> completedChapterIds;
  final Set<String> bookmarkedChapterIds;
  final Set<String> bookmarkedPaperIds;
  final Set<String> downloadedChapterIds;
  final Set<String> downloadedPaperIds;
  final int studyMinutes;
  final int mcqsAttempted;
  final int mcqsCorrect;
  final String? lastChapterId;
  final String? lastSubjectId;
  final List<ExamAttemptSummary> examHistory;
  final List<StudyTask> studyTasks;
  final bool notificationsEnabled;
  final bool offlineModeEnabled;

  String get formattedStudyTime {
    final int hours = studyMinutes ~/ 60;
    final int mins = studyMinutes % 60;
    return '${hours}h ${mins}m';
  }

  int get averageExamPercentage {
    if (examHistory.isEmpty) return 0;
    final int sum = examHistory.fold(0, (acc, item) => acc + item.percentage);
    return (sum / examHistory.length).round();
  }

  double get mcqAccuracy =>
      mcqsAttempted == 0 ? 0.0 : mcqsCorrect / mcqsAttempted;

  StudentActivityState copyWith({
    Set<String>? completedChapterIds,
    Set<String>? bookmarkedChapterIds,
    Set<String>? bookmarkedPaperIds,
    Set<String>? downloadedChapterIds,
    Set<String>? downloadedPaperIds,
    int? studyMinutes,
    int? mcqsAttempted,
    int? mcqsCorrect,
    String? lastChapterId,
    String? lastSubjectId,
    List<ExamAttemptSummary>? examHistory,
    List<StudyTask>? studyTasks,
    bool? notificationsEnabled,
    bool? offlineModeEnabled,
  }) {
    return StudentActivityState(
      completedChapterIds: completedChapterIds ?? this.completedChapterIds,
      bookmarkedChapterIds: bookmarkedChapterIds ?? this.bookmarkedChapterIds,
      bookmarkedPaperIds: bookmarkedPaperIds ?? this.bookmarkedPaperIds,
      downloadedChapterIds: downloadedChapterIds ?? this.downloadedChapterIds,
      downloadedPaperIds: downloadedPaperIds ?? this.downloadedPaperIds,
      studyMinutes: studyMinutes ?? this.studyMinutes,
      mcqsAttempted: mcqsAttempted ?? this.mcqsAttempted,
      mcqsCorrect: mcqsCorrect ?? this.mcqsCorrect,
      lastChapterId: lastChapterId ?? this.lastChapterId,
      lastSubjectId: lastSubjectId ?? this.lastSubjectId,
      examHistory: examHistory ?? this.examHistory,
      studyTasks: studyTasks ?? this.studyTasks,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
    );
  }
}

class StudentActivityController extends Notifier<StudentActivityState> {
  static const String _keyCompletedChapters = 'imtihan_completed_chapters';
  static const String _keyBookmarkedChapters = 'imtihan_bookmarked_chapters';
  static const String _keyBookmarkedPapers = 'imtihan_bookmarked_papers';
  static const String _keyDownloadedChapters = 'imtihan_downloaded_chapters';
  static const String _keyDownloadedPapers = 'imtihan_downloaded_papers';
  static const String _keyStudyMinutes = 'imtihan_study_minutes';
  static const String _keyMcqsAttempted = 'imtihan_mcqs_attempted';
  static const String _keyMcqsCorrect = 'imtihan_mcqs_correct';
  static const String _keyLastChapter = 'imtihan_last_chapter';
  static const String _keyLastSubject = 'imtihan_last_subject';
  static const String _keyExamHistory = 'imtihan_exam_history';
  static const String _keyStudyTasks = 'imtihan_study_tasks';
  static const String _keyNotifications = 'imtihan_notifications';
  static const String _keyOfflineMode = 'imtihan_offline_mode';

  late SharedPreferences _prefs;

  @override
  StudentActivityState build() {
    _prefs = ref.read(sharedPreferencesInstanceProvider);
    return _load();
  }

  StudentActivityState _load() {
    final List<String> rawHistory =
        _prefs.getStringList(_keyExamHistory) ?? const [];
    final List<ExamAttemptSummary> parsedHistory = [];
    for (final item in rawHistory) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        parsedHistory.add(ExamAttemptSummary.fromJson(decoded));
      } catch (_) {
        // Ignore malformed local entry safely.
      }
    }

    final List<String> rawTasks =
        _prefs.getStringList(_keyStudyTasks) ?? const [];
    final List<StudyTask> parsedTasks = [];
    for (final item in rawTasks) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        parsedTasks.add(StudyTask.fromJson(decoded));
      } catch (_) {
        // Ignore malformed local entry safely.
      }
    }

    return StudentActivityState(
      completedChapterIds:
          (_prefs.getStringList(_keyCompletedChapters) ?? const []).toSet(),
      bookmarkedChapterIds:
          (_prefs.getStringList(_keyBookmarkedChapters) ?? const []).toSet(),
      bookmarkedPaperIds:
          (_prefs.getStringList(_keyBookmarkedPapers) ?? const []).toSet(),
      downloadedChapterIds:
          (_prefs.getStringList(_keyDownloadedChapters) ?? const []).toSet(),
      downloadedPaperIds:
          (_prefs.getStringList(_keyDownloadedPapers) ?? const []).toSet(),
      studyMinutes: _prefs.getInt(_keyStudyMinutes) ?? 0,
      mcqsAttempted: _prefs.getInt(_keyMcqsAttempted) ?? 0,
      mcqsCorrect: _prefs.getInt(_keyMcqsCorrect) ?? 0,
      lastChapterId: _prefs.getString(_keyLastChapter),
      lastSubjectId: _prefs.getString(_keyLastSubject),
      examHistory: parsedHistory,
      studyTasks: parsedTasks,
      notificationsEnabled: _prefs.getBool(_keyNotifications) ?? true,
      offlineModeEnabled: _prefs.getBool(_keyOfflineMode) ?? false,
    );
  }

  Future<void> recordChapterOpened({
    required String subjectId,
    required String chapterId,
    int minutesSpent = 5,
  }) async {
    final int nextMinutes = state.studyMinutes + minutesSpent;
    state = state.copyWith(
      lastSubjectId: subjectId,
      lastChapterId: chapterId,
      studyMinutes: nextMinutes,
    );
    await _prefs.setString(_keyLastSubject, subjectId);
    await _prefs.setString(_keyLastChapter, chapterId);
    await _prefs.setInt(_keyStudyMinutes, nextMinutes);
  }

  Future<void> toggleChapterCompleted(String chapterId) async {
    final next = {...state.completedChapterIds};
    int nextMinutes = state.studyMinutes;
    if (next.contains(chapterId)) {
      next.remove(chapterId);
    } else {
      next.add(chapterId);
      nextMinutes += 15;
    }
    state = state.copyWith(
      completedChapterIds: next,
      studyMinutes: nextMinutes,
    );
    await _prefs.setStringList(_keyCompletedChapters, next.toList());
    await _prefs.setInt(_keyStudyMinutes, nextMinutes);
  }

  Future<void> toggleChapterBookmark(String chapterId) async {
    final next = {...state.bookmarkedChapterIds};
    if (next.contains(chapterId)) {
      next.remove(chapterId);
    } else {
      next.add(chapterId);
    }
    state = state.copyWith(bookmarkedChapterIds: next);
    await _prefs.setStringList(_keyBookmarkedChapters, next.toList());
  }

  Future<void> togglePaperBookmark(String paperId) async {
    final next = {...state.bookmarkedPaperIds};
    if (next.contains(paperId)) {
      next.remove(paperId);
    } else {
      next.add(paperId);
    }
    state = state.copyWith(bookmarkedPaperIds: next);
    await _prefs.setStringList(_keyBookmarkedPapers, next.toList());
  }

  Future<void> toggleChapterDownload(String chapterId) async {
    final next = {...state.downloadedChapterIds};
    if (next.contains(chapterId)) {
      next.remove(chapterId);
    } else {
      next.add(chapterId);
    }
    state = state.copyWith(downloadedChapterIds: next);
    await _prefs.setStringList(_keyDownloadedChapters, next.toList());
  }

  Future<void> togglePaperDownload(String paperId) async {
    final next = {...state.downloadedPaperIds};
    if (next.contains(paperId)) {
      next.remove(paperId);
    } else {
      next.add(paperId);
    }
    state = state.copyWith(downloadedPaperIds: next);
    await _prefs.setStringList(_keyDownloadedPapers, next.toList());
  }

  Future<void> recordMcqAnswer({required bool isCorrect}) async {
    final int attempted = state.mcqsAttempted + 1;
    final int correct = state.mcqsCorrect + (isCorrect ? 1 : 0);
    final int nextMinutes = state.studyMinutes + 1;
    state = state.copyWith(
      mcqsAttempted: attempted,
      mcqsCorrect: correct,
      studyMinutes: nextMinutes,
    );
    await _prefs.setInt(_keyMcqsAttempted, attempted);
    await _prefs.setInt(_keyMcqsCorrect, correct);
    await _prefs.setInt(_keyStudyMinutes, nextMinutes);
  }

  Future<void> recordMockExamResult(MockExamResult result) async {
    final summary = ExamAttemptSummary(
      id: result.id,
      subjectId: result.subjectId,
      subjectTitle: result.subjectTitle,
      correctCount: result.correctCount,
      totalQuestions: result.totalQuestions,
      timestampIso: result.completedAt.toIso8601String(),
    );
    final nextHistory = [summary, ...state.examHistory].take(20).toList();
    final int addedMinutes = (result.durationSecondsTaken / 60).ceil().clamp(1, 90);
    final int nextMinutes = state.studyMinutes + addedMinutes;
    final int nextAttempted = state.mcqsAttempted + result.totalQuestions;
    final int nextCorrect = state.mcqsCorrect + result.correctCount;

    state = state.copyWith(
      examHistory: nextHistory,
      studyMinutes: nextMinutes,
      mcqsAttempted: nextAttempted,
      mcqsCorrect: nextCorrect,
    );

    await _prefs.setStringList(
      _keyExamHistory,
      nextHistory.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await _prefs.setInt(_keyStudyMinutes, nextMinutes);
    await _prefs.setInt(_keyMcqsAttempted, nextAttempted);
    await _prefs.setInt(_keyMcqsCorrect, nextCorrect);
  }

  Future<void> addStudyTask({
    required String title,
    required String subjectName,
    required String timeSlot,
  }) async {
    final task = StudyTask(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      subjectName: subjectName.trim(),
      timeSlot: timeSlot.trim(),
      isCompleted: false,
    );
    final nextTasks = [task, ...state.studyTasks];
    state = state.copyWith(studyTasks: nextTasks);
    await _persistTasks(nextTasks);
  }

  Future<void> toggleStudyTask(String taskId) async {
    final nextTasks = state.studyTasks
        .map((t) => t.id == taskId ? t.copyWith(isCompleted: !t.isCompleted) : t)
        .toList();
    state = state.copyWith(studyTasks: nextTasks);
    await _persistTasks(nextTasks);
  }

  Future<void> deleteStudyTask(String taskId) async {
    final nextTasks = state.studyTasks.where((t) => t.id != taskId).toList();
    state = state.copyWith(studyTasks: nextTasks);
    await _persistTasks(nextTasks);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _prefs.setBool(_keyNotifications, enabled);
  }

  Future<void> setOfflineModeEnabled(bool enabled) async {
    state = state.copyWith(offlineModeEnabled: enabled);
    await _prefs.setBool(_keyOfflineMode, enabled);
  }

  Future<void> resetAllActivity() async {
    await _prefs.remove(_keyCompletedChapters);
    await _prefs.remove(_keyBookmarkedChapters);
    await _prefs.remove(_keyBookmarkedPapers);
    await _prefs.remove(_keyDownloadedChapters);
    await _prefs.remove(_keyDownloadedPapers);
    await _prefs.remove(_keyStudyMinutes);
    await _prefs.remove(_keyMcqsAttempted);
    await _prefs.remove(_keyMcqsCorrect);
    await _prefs.remove(_keyLastChapter);
    await _prefs.remove(_keyLastSubject);
    await _prefs.remove(_keyExamHistory);
    await _prefs.remove(_keyStudyTasks);
    state = const StudentActivityState();
  }

  Future<void> _persistTasks(List<StudyTask> tasks) async {
    await _prefs.setStringList(
      _keyStudyTasks,
      tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }
}

final sharedPreferencesInstanceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesInstanceProvider must be overridden in main.dart',
  );
});

final studentActivityProvider =
    NotifierProvider<StudentActivityController, StudentActivityState>(
  StudentActivityController.new,
);
