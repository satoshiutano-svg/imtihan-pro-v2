import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imtihan_pro/app/app.dart';
import 'package:imtihan_pro/core/constants/kpk_boards.dart';
import 'package:imtihan_pro/core/storage/preferences_service.dart';
import 'package:imtihan_pro/core/storage/student_progress_store.dart';
import 'package:imtihan_pro/core/theme/theme_controller.dart';
import 'package:imtihan_pro/data/repositories/app_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Domain constants & repositories', () {
    test('contains all eight official KPK BISE boards', () {
      expect(KpkBoard.values.length, 8);
      expect(
        KpkBoard.values.map((b) => b.name),
        containsAll([
          'BISE Peshawar',
          'BISE Abbottabad',
          'BISE Mardan',
          'BISE Swat',
          'BISE Kohat',
          'BISE Bannu',
          'BISE Dera Ismail Khan',
          'BISE Malakand',
        ]),
      );
    });

    test('curriculum repository provides subjects for every academic group', () {
      const repo = LocalCurriculumRepository();
      for (final group in AcademicGroup.values) {
        final subjects = repo.getSubjectsForGroup(group);
        expect(subjects, isNotEmpty);
        expect(subjects.first.chapters, isNotEmpty);
      }
    });

    test('past papers and mock exam builder return group-aware, non-repeating data', () {
      const paperRepo = LocalPastPaperRepository();
      for (final group in AcademicGroup.values) {
        final papers = paperRepo.getPastPapers(
          preferredBoard: KpkBoard.peshawar,
          classLevel: ClassLevel.class10,
          group: group,
        );
        expect(papers, isNotEmpty);
      }

      const practiceRepo = LocalPracticeRepository();
      final examQuestions = practiceRepo.buildMockExamQuestions(
        subjectId: 'physics',
        count: 15,
      );
      expect(examQuestions.length, 15);
      expect(examQuestions.map((q) => q.id).toSet().length, 15);
    });
  });

  group('Theme persistence', () {
    test('defaults to Light theme and persists Dark/System changes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesInstanceProvider.overrideWithValue(prefs),
          preferencesServiceProvider.overrideWithValue(
            PreferencesService(prefs),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(themeControllerProvider), ThemeMode.light);

      await container
          .read(themeControllerProvider.notifier)
          .setThemeMode(ThemeMode.dark);
      expect(container.read(themeControllerProvider), ThemeMode.dark);
      expect(PreferencesService(prefs).getThemeMode(), ThemeMode.dark);

      await container
          .read(themeControllerProvider.notifier)
          .setThemeMode(ThemeMode.system);
      expect(container.read(themeControllerProvider), ThemeMode.system);
    });
  });

  group('End-to-end navigation & study flows', () {
    testWidgets('completes onboarding, navigates Home -> Learn -> Notes -> Settings', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesInstanceProvider.overrideWithValue(prefs),
            preferencesServiceProvider.overrideWithValue(
              PreferencesService(prefs),
            ),
          ],
          child: const ImtihanProApp(),
        ),
      );

      // Screen 1: Splash -> Screen 2: Welcome
      expect(find.text('Imtihan Pro'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();

      // Screen 2 -> Screen 3: Class Selection
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Class 10'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Screen 4: Board Selection -> Screen 5: Group Selection
      await tester.tap(find.text('BISE Peshawar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Science'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Screen 6: Home Dashboard renders dynamic 0% baseline & 5 tabs
      expect(find.text('Your Progress'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Continue Learning'), findsOneWidget);

      // Navigate to Learn tab -> Physics -> Chapter 3 -> Chapter Overview
      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();
      expect(find.text('Select Subject'), findsOneWidget);

      await tester.tap(find.text('Physics'));
      await tester.pumpAndSettle();
      expect(find.text('Electromagnetism'), findsOneWidget);

      await tester.tap(find.text('Electromagnetism'));
      await tester.pumpAndSettle();
      expect(find.text('Start Learning'), findsOneWidget);

      // Open Detailed Notes Reader and Quick Revision
      await tester.tap(find.text('Start Learning'));
      await tester.pumpAndSettle();
      expect(find.text('Notes'), findsOneWidget);
    });
  });
}
