import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/student_progress_store.dart';
import '../../../data/models/practice_models.dart';
import '../../../data/repositories/app_repositories.dart';

@immutable
class ActiveMockExamState {
  const ActiveMockExamState({
    required this.config,
    required this.questions,
    required this.selectedAnswers,
    required this.flaggedIndices,
    required this.currentIndex,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.latestResult,
  });

  final MockExamConfig config;
  final List<McqQuestion> questions;
  final Map<int, int> selectedAnswers;
  final Set<int> flaggedIndices;
  final int currentIndex;
  final int remainingSeconds;
  final int totalSeconds;
  final MockExamResult? latestResult;

  ActiveMockExamState copyWith({
    Map<int, int>? selectedAnswers,
    Set<int>? flaggedIndices,
    int? currentIndex,
    int? remainingSeconds,
    MockExamResult? latestResult,
  }) {
    return ActiveMockExamState(
      config: config,
      questions: questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      flaggedIndices: flaggedIndices ?? this.flaggedIndices,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds,
      latestResult: latestResult ?? this.latestResult,
    );
  }
}

class MockExamSessionController extends Notifier<ActiveMockExamState?> {
  @override
  ActiveMockExamState? build() => null;

  void startExam(MockExamConfig config) {
    final questions = ref.read(practiceRepositoryProvider).buildMockExamQuestions(
          subjectId: config.subjectId,
          count: config.questionCount,
          chapterId: config.chapterId,
        );
    final int seconds = config.durationMinutes * 60;
    state = ActiveMockExamState(
      config: config,
      questions: questions,
      selectedAnswers: const {},
      flaggedIndices: const {},
      currentIndex: 0,
      remainingSeconds: seconds,
      totalSeconds: seconds,
    );
  }

  void selectAnswer(int optionIndex) {
    final current = state;
    if (current == null) return;
    final nextMap = {...current.selectedAnswers, current.currentIndex: optionIndex};
    state = current.copyWith(selectedAnswers: nextMap);
  }

  void toggleFlagCurrent() {
    final current = state;
    if (current == null) return;
    final nextFlags = {...current.flaggedIndices};
    if (nextFlags.contains(current.currentIndex)) {
      nextFlags.remove(current.currentIndex);
    } else {
      nextFlags.add(current.currentIndex);
    }
    state = current.copyWith(flaggedIndices: nextFlags);
  }

  void goToQuestion(int index) {
    final current = state;
    if (current == null) return;
    if (index < 0 || index >= current.questions.length) return;
    state = current.copyWith(currentIndex: index);
  }

  void tickOneSecond() {
    final current = state;
    if (current == null || current.remainingSeconds <= 0) return;
    state = current.copyWith(remainingSeconds: current.remainingSeconds - 1);
  }

  Future<MockExamResult?> submitExam() async {
    final current = state;
    if (current == null) return null;

    final List<MockExamAnswer> answers = List.generate(
      current.questions.length,
      (index) => MockExamAnswer(
        question: current.questions[index],
        selectedIndex: current.selectedAnswers[index],
        isFlagged: current.flaggedIndices.contains(index),
      ),
    );

    final int elapsed = (current.totalSeconds - current.remainingSeconds)
        .clamp(1, current.totalSeconds);

    final result = MockExamResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      subjectId: current.config.subjectId,
      subjectTitle: current.config.subjectTitle,
      completedAt: DateTime.now(),
      durationSecondsTaken: elapsed,
      answers: answers,
    );

    state = current.copyWith(latestResult: result);
    await ref.read(studentActivityProvider.notifier).recordMockExamResult(result);
    return result;
  }
}

final mockExamSessionProvider =
    NotifierProvider<MockExamSessionController, ActiveMockExamState?>(
  MockExamSessionController.new,
);
