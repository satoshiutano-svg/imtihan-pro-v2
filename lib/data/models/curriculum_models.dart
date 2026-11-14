import 'package:flutter/material.dart';

import '../../core/constants/kpk_boards.dart';

enum SubjectVisualKind {
  physics,
  chemistry,
  mathematics,
  biology,
  computerScience,
  english,
  humanities,
  commerce,
}

@immutable
class SolvedExample {
  const SolvedExample({
    required this.title,
    required this.problem,
    required this.givenData,
    required this.formula,
    required this.solutionSteps,
    required this.answer,
  });

  final String title;
  final String problem;
  final List<String> givenData;
  final String formula;
  final List<String> solutionSteps;
  final String answer;
}

@immutable
class QuickRevisionData {
  const QuickRevisionData({
    required this.keyFormulas,
    required this.importantPoints,
    required this.examTips,
    required this.rememberHighlight,
  });

  final List<String> keyFormulas;
  final List<String> importantPoints;
  final List<String> examTips;
  final String rememberHighlight;
}

@immutable
class Chapter {
  const Chapter({
    required this.id,
    required this.subjectId,
    required this.number,
    required this.title,
    required this.summary,
    required this.estimatedMinutes,
    required this.keyConcepts,
    required this.keyPoints,
    required this.diagramTitle,
    required this.diagramCaption,
    required this.solvedExamples,
    required this.quickRevision,
    this.weightagePercent = 10,
  });

  final String id;
  final String subjectId;
  final int number;
  final String title;
  final String summary;
  final int estimatedMinutes;
  final List<String> keyConcepts;
  final List<String> keyPoints;
  final String diagramTitle;
  final String diagramCaption;
  final List<SolvedExample> solvedExamples;
  final QuickRevisionData quickRevision;
  final int weightagePercent;
}

@immutable
class Subject {
  const Subject({
    required this.id,
    required this.title,
    required this.description,
    required this.group,
    required this.visualKind,
    required this.totalChaptersCount,
    required this.chapters,
  });

  final String id;
  final String title;
  final String description;
  final AcademicGroup group;
  final SubjectVisualKind visualKind;
  final int totalChaptersCount;
  final List<Chapter> chapters;
}
