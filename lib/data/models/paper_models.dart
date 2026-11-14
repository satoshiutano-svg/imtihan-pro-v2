import 'package:flutter/foundation.dart';

import '../../core/constants/kpk_boards.dart';

enum PaperSectionType {
  mcqs,
  shortQuestions,
  longQuestions,
}

@immutable
class PaperQuestion {
  const PaperQuestion({
    required this.id,
    required this.section,
    required this.questionNumber,
    required this.prompt,
    required this.marks,
    required this.solution,
    this.options = const [],
  });

  final String id;
  final PaperSectionType section;
  final String questionNumber;
  final String prompt;
  final int marks;
  final String solution;
  final List<String> options;
}

@immutable
class PastPaper {
  const PastPaper({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.year,
    required this.board,
    required this.classLevel,
    required this.totalMarks,
    required this.durationMinutes,
    required this.fileSizeLabel,
    required this.questions,
  });

  final String id;
  final String subjectId;
  final String subjectName;
  final int year;
  final KpkBoard board;
  final ClassLevel classLevel;
  final int totalMarks;
  final int durationMinutes;
  final String fileSizeLabel;
  final List<PaperQuestion> questions;
}

@immutable
class PaperTrendPoint {
  const PaperTrendPoint({
    required this.label,
    required this.chapterTitle,
    required this.marksWeightage,
    required this.frequencyYears,
  });

  final String label;
  final String chapterTitle;
  final int marksWeightage;
  final int frequencyYears;
}
