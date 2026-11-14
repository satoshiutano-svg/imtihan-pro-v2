import 'package:flutter/foundation.dart';

enum BookmarkType { chapter, paper }

@immutable
class StudyTask {
  const StudyTask({
    required this.id,
    required this.title,
    required this.subjectName,
    required this.timeSlot,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String subjectName;
  final String timeSlot;
  final bool isCompleted;

  StudyTask copyWith({
    String? id,
    String? title,
    String? subjectName,
    String? timeSlot,
    bool? isCompleted,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectName: subjectName ?? this.subjectName,
      timeSlot: timeSlot ?? this.timeSlot,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subjectName': subjectName,
        'timeSlot': timeSlot,
        'isCompleted': isCompleted,
      };

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

@immutable
class AchievementItem {
  const AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.progressText,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final String description;
  final String progressText;
  final bool isUnlocked;
}

@immutable
class ExamAttemptSummary {
  const ExamAttemptSummary({
    required this.id,
    required this.subjectId,
    required this.subjectTitle,
    required this.correctCount,
    required this.totalQuestions,
    required this.timestampIso,
  });

  final String id;
  final String subjectId;
  final String subjectTitle;
  final int correctCount;
  final int totalQuestions;
  final String timestampIso;

  int get percentage =>
      totalQuestions == 0 ? 0 : ((correctCount / totalQuestions) * 100).round();

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'subjectTitle': subjectTitle,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
        'timestampIso': timestampIso,
      };

  factory ExamAttemptSummary.fromJson(Map<String, dynamic> json) {
    return ExamAttemptSummary(
      id: json['id'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      subjectTitle: json['subjectTitle'] as String? ?? '',
      correctCount: json['correctCount'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      timestampIso: json['timestampIso'] as String? ?? '',
    );
  }
}
