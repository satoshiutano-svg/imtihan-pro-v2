import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/kpk_boards.dart';
import '../../../core/storage/preferences_service.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    required this.isComplete,
    this.selectedClass,
    this.selectedBoard,
    this.selectedGroup,
    this.studentName = 'Student',
  });

  final bool isComplete;
  final ClassLevel? selectedClass;
  final KpkBoard? selectedBoard;
  final AcademicGroup? selectedGroup;
  final String studentName;

  bool get hasValidSelections =>
      selectedClass != null && selectedBoard != null && selectedGroup != null;

  OnboardingState copyWith({
    bool? isComplete,
    ClassLevel? selectedClass,
    KpkBoard? selectedBoard,
    AcademicGroup? selectedGroup,
    String? studentName,
  }) {
    return OnboardingState(
      isComplete: isComplete ?? this.isComplete,
      selectedClass: selectedClass ?? this.selectedClass,
      selectedBoard: selectedBoard ?? this.selectedBoard,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      studentName: studentName ?? this.studentName,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    final prefs = ref.read(preferencesServiceProvider);
    return OnboardingState(
      isComplete: prefs.isOnboardingComplete(),
      selectedClass: prefs.getSelectedClass(),
      selectedBoard: prefs.getSelectedBoard(),
      selectedGroup: prefs.getSelectedGroup(),
      studentName: prefs.getStudentName(),
    );
  }

  Future<void> selectClass(ClassLevel level) async {
    state = state.copyWith(selectedClass: level);
    await ref.read(preferencesServiceProvider).setSelectedClass(level);
  }

  Future<void> selectBoard(KpkBoard board) async {
    state = state.copyWith(selectedBoard: board);
    await ref.read(preferencesServiceProvider).setSelectedBoard(board);
  }

  Future<void> selectGroup(AcademicGroup group) async {
    state = state.copyWith(selectedGroup: group);
    await ref.read(preferencesServiceProvider).setSelectedGroup(group);
  }

  Future<void> updateStudentName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(studentName: trimmed);
    await ref.read(preferencesServiceProvider).setStudentName(trimmed);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isComplete: true);
    await ref.read(preferencesServiceProvider).setOnboardingComplete(true);
  }

  Future<void> resetOnboarding() async {
    await ref.read(preferencesServiceProvider).clearOnboarding();
    state = const OnboardingState(isComplete: false);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);
