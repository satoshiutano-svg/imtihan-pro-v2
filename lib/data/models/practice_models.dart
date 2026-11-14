import 'package:flutter/foundation.dart';

@immutable
class McqQuestion {
  const McqQuestion({
    required this.id,
    required this.subjectId,
    required this.chapterId,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.boardTag,
  });

  final String id;
  final String subjectId;
  final String chapterId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? boardTag;
}

@immutable
class MockExamConfig {
  const MockExamConfig({
    required this.subjectId,
    required this.subjectTitle,
    required this.questionCount,
    required this.durationMinutes,
    this.chapterId,
  });

  final String subjectId;
  final String subjectTitle;
  final int questionCount;
  final int durationMinutes;
  final String? chapterId;
}

@immutable
class MockExamAnswer {
  const MockExamAnswer({
    required this.question,
    required this.selectedIndex,
    required this.isFlagged,
  });

  final McqQuestion question;
  final int? selectedIndex;
  final bool isFlagged;

  bool get isAnswered => selectedIndex != null;
  bool get isCorrect => selectedIndex == question.correctIndex;
}

@immutable
class MockExamResult {
  const MockExamResult({
    required this.id,
    required this.subjectId,
    required this.subjectTitle,
    required this.completedAt,
    required this.durationSecondsTaken,
    required this.answers,
  });

  final String id;
  final String subjectId;
  final String subjectTitle;
  final DateTime completedAt;
  final int durationSecondsTaken;
  final List<MockExamAnswer> answers;

  int get totalQuestions => answers.length;
  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount =>
      answers.where((a) => a.isAnswered && !a.isCorrect).length;
  int get unansweredCount => answers.where((a) => !a.isAnswered).length;

  double get accuracy =>
      totalQuestions == 0 ? 0.0 : correctCount / totalQuestions;

  int get percentage => (accuracy * 100).round();

  String get gradeLabel {
    final int pct = percentage;
    if (pct >= 85) return 'A+ (Distinction)';
    if (pct >= 75) return 'A (Excellent)';
    if (pct >= 60) return 'B (Good)';
    if (pct >= 45) return 'C (Pass)';
    return 'Needs Revision';
  }
}
