import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/kpk_boards.dart';
import '../fixtures/curriculum_fixtures.dart';
import '../fixtures/mcq_fixtures.dart';
import '../fixtures/past_papers_fixtures.dart';
import '../models/curriculum_models.dart';
import '../models/paper_models.dart';
import '../models/practice_models.dart';

/// Clean repository interfaces enabling seamless replacement of local fixtures
/// with a live REST/GraphQL backend in future stages.

abstract interface class CurriculumRepository {
  List<Subject> getSubjectsForGroup(AcademicGroup group);
  Subject? getSubjectById(String subjectId);
  Chapter? getChapterById(String chapterId);
  List<Chapter> getAllChaptersForGroup(AcademicGroup group);
}

abstract interface class PastPaperRepository {
  List<PastPaper> getPastPapers({
    required KpkBoard preferredBoard,
    required ClassLevel classLevel,
    AcademicGroup? group,
  });
  PastPaper? getPaperById({
    required String paperId,
    required KpkBoard preferredBoard,
    required ClassLevel classLevel,
  });
  List<PaperTrendPoint> getExaminationTrends();
}

abstract interface class PracticeRepository {
  List<McqQuestion> getMcqs({
    String? subjectId,
    String? chapterId,
    AcademicGroup? group,
  });
  List<McqQuestion> buildMockExamQuestions({
    required String subjectId,
    required int count,
    String? chapterId,
  });
}

class LocalCurriculumRepository implements CurriculumRepository {
  const LocalCurriculumRepository();

  @override
  List<Subject> getSubjectsForGroup(AcademicGroup group) {
    final subjects = CurriculumFixtures.allSubjects()
        .where((s) => s.group == group)
        .toList();
    if (subjects.isEmpty) {
      return CurriculumFixtures.allSubjects()
          .where((s) => s.group == AcademicGroup.science)
          .toList();
    }
    return subjects;
  }

  @override
  Subject? getSubjectById(String subjectId) {
    for (final subject in CurriculumFixtures.allSubjects()) {
      if (subject.id == subjectId) return subject;
    }
    return null;
  }

  @override
  Chapter? getChapterById(String chapterId) {
    for (final subject in CurriculumFixtures.allSubjects()) {
      for (final chapter in subject.chapters) {
        if (chapter.id == chapterId) return chapter;
      }
    }
    return null;
  }

  @override
  List<Chapter> getAllChaptersForGroup(AcademicGroup group) {
    return getSubjectsForGroup(group)
        .expand((subject) => subject.chapters)
        .toList();
  }
}

class LocalPastPaperRepository implements PastPaperRepository {
  const LocalPastPaperRepository();

  @override
  List<PastPaper> getPastPapers({
    required KpkBoard preferredBoard,
    required ClassLevel classLevel,
    AcademicGroup? group,
  }) {
    return PastPapersFixtures.all(
      preferredBoard: preferredBoard,
      classLevel: classLevel,
      group: group,
    );
  }

  @override
  PastPaper? getPaperById({
    required String paperId,
    required KpkBoard preferredBoard,
    required ClassLevel classLevel,
  }) {
    for (final paper in getPastPapers(
      preferredBoard: preferredBoard,
      classLevel: classLevel,
    )) {
      if (paper.id == paperId) return paper;
    }
    return null;
  }

  @override
  List<PaperTrendPoint> getExaminationTrends() =>
      PastPapersFixtures.examinationTrends();
}

class LocalPracticeRepository implements PracticeRepository {
  const LocalPracticeRepository();

  @override
  List<McqQuestion> getMcqs({
    String? subjectId,
    String? chapterId,
    AcademicGroup? group,
  }) {
    Set<String>? groupSubjectIds;
    if (group != null) {
      groupSubjectIds = CurriculumFixtures.allSubjects()
          .where((s) => s.group == group)
          .map((s) => s.id)
          .toSet();
    }

    return McqFixtures.all.where((q) {
      final matchesSubject = subjectId == null || q.subjectId == subjectId;
      final matchesChapter = chapterId == null || q.chapterId == chapterId;
      final matchesGroup =
          groupSubjectIds == null || groupSubjectIds.contains(q.subjectId);
      return matchesSubject && matchesChapter && matchesGroup;
    }).toList();
  }

  @override
  List<McqQuestion> buildMockExamQuestions({
    required String subjectId,
    required int count,
    String? chapterId,
  }) {
    final List<McqQuestion> primary = getMcqs(
      subjectId: subjectId == 'all' ? null : subjectId,
      chapterId: chapterId,
    );

    final List<McqQuestion> selected = [...primary];
    final Set<String> seenIds = primary.map((q) => q.id).toSet();

    // Top up with distinct questions from the broader bank so mock exams never
    // duplicate identical question IDs when count exceeds a single subject pool.
    if (selected.length < count) {
      for (final q in McqFixtures.all) {
        if (!seenIds.contains(q.id)) {
          selected.add(q);
          seenIds.add(q.id);
          if (selected.length >= count) break;
        }
      }
    }

    return selected.take(count).toList();
  }
}

final curriculumRepositoryProvider = Provider<CurriculumRepository>(
  (ref) => const LocalCurriculumRepository(),
);

final pastPaperRepositoryProvider = Provider<PastPaperRepository>(
  (ref) => const LocalPastPaperRepository(),
);

final practiceRepositoryProvider = Provider<PracticeRepository>(
  (ref) => const LocalPracticeRepository(),
);
