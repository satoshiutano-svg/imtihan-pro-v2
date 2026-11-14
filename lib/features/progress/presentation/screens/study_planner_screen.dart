import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/student_progress_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/imtihan_app_bar.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../../../core/widgets/imtihan_state_views.dart';

/// Screen 24: Study Planner.
class StudyPlannerScreen extends ConsumerWidget {
  const StudyPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final tasks = ref.watch(
      studentActivityProvider.select((state) => state.studyTasks),
    );

    return ImtihanScaffold(
      appBar: const ImtihanAppBar(
        title: 'Study Planner',
        subtitle: 'Plan daily board revision blocks',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(context, ref),
        backgroundColor: palette.primary,
        foregroundColor: palette.textOnPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
      body: tasks.isEmpty
          ? ImtihanEmptyView(
              title: 'No Study Tasks Planned',
              subtitle:
                  'Create your daily revision schedule for Physics, Chemistry, Math, or Past Papers.',
              icon: Icons.event_note_rounded,
              actionLabel: 'Add Study Task',
              onAction: () => _showAddTaskSheet(context, ref),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                88,
              ),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ImtihanCard(
                  onTap: () => ref
                      .read(studentActivityProvider.notifier)
                      .toggleStudyTask(task.id),
                  padding: AppSpacing.compactCardPadding,
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        activeColor: palette.success,
                        onChanged: (_) => ref
                            .read(studentActivityProvider.notifier)
                            .toggleStudyTask(task.id),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: textTheme.titleSmall?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? palette.textMuted
                                    : palette.textPrimary,
                              ),
                            ),
                            Text(
                              '${task.subjectName} • ${task.timeSlot}',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete task',
                        onPressed: () => ref
                            .read(studentActivityProvider.notifier)
                            .deleteStudyTask(task.id),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showAddTaskSheet(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '5:00 PM – 6:00 PM');
    String subjectName = 'Physics';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl + bottomInset,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Study Task',
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'e.g. Revise Electromagnetism Formulas',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: subjectName,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    items: const [
                      'Physics',
                      'Chemistry',
                      'Mathematics',
                      'Biology',
                      'English',
                      'Past Papers',
                    ]
                        .map(
                          (s) => DropdownMenuItem(value: s, child: Text(s)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => subjectName = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time Slot',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ImtihanPrimaryButton(
                    label: 'Save Task',
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty) return;
                      await ref
                          .read(studentActivityProvider.notifier)
                          .addStudyTask(
                            title: titleController.text,
                            subjectName: subjectName,
                            timeSlot: timeController.text,
                          );
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    timeController.dispose();
  }
}
