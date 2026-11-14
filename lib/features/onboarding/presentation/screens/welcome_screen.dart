import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/imtihan_card.dart';
import '../../../../core/widgets/imtihan_icon_badge.dart';
import '../../../../core/widgets/imtihan_primary_button.dart';
import '../../../../core/widgets/imtihan_scaffold.dart';
import '../../state/onboarding_controller.dart';
import '../widgets/brand_emblem.dart';

/// Screen 2: Welcome Screen.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeControllerProvider);
    final bool isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return ImtihanScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - (AppSpacing.lg * 2),
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImtihanBrandHeader(
                      trailing: IconButton(
                        tooltip: isDark
                            ? 'Switch to Light Theme'
                            : 'Switch to Dark Theme',
                        constraints: const BoxConstraints(
                          minWidth: AppSpacing.minTouchTarget,
                          minHeight: AppSpacing.minTouchTarget,
                        ),
                        onPressed: () => ref
                            .read(themeControllerProvider.notifier)
                            .toggleLightDark(
                              MediaQuery.platformBrightnessOf(context),
                            ),
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: palette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Welcome to\nImtihan Pro!',
                      style: textTheme.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your KPK Board preparation starts here.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const _WelcomeStudyIllustration(),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.xxl),
                    ImtihanPrimaryButton(
                      label: 'Get Started',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.push(RouteNames.selectClass),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ImtihanSecondaryButton(
                      label: 'Sign In',
                      onPressed: () => _showLocalProfileSheet(context, ref),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: palette.surfaceElevated.withValues(alpha: 0.75),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                          border: Border.all(color: palette.borderSubtle),
                        ),
                        child: Text(
                          'Learn • Practice • Excel',
                          style: textTheme.labelMedium?.copyWith(
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showLocalProfileSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController(
      text: ref.read(onboardingControllerProvider).studentName,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
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
                'Student Profile',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your name to personalize your local study workspace. Cloud sync will be available in a future release.',
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'e.g. Hamza Khan',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ImtihanPrimaryButton(
                label: 'Save & Choose Class',
                onPressed: () async {
                  await ref
                      .read(onboardingControllerProvider.notifier)
                      .updateStudentName(controller.text);
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                  if (context.mounted) {
                    await context.push(RouteNames.selectClass);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
  }
}

class _WelcomeStudyIllustration extends StatelessWidget {
  const _WelcomeStudyIllustration();

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return ImtihanCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const ImtihanBrandEmblem(size: 108),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Built for KPK BISE Students',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Structured notes, solved board papers, and timed mock exams for Class 9 to 12.',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _HighlightTile(
                  icon: Icons.menu_book_rounded,
                  label: 'Notes',
                  color: palette.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _HighlightTile(
                  icon: Icons.description_rounded,
                  label: 'Papers',
                  color: palette.accentCyan,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _HighlightTile(
                  icon: Icons.task_alt_rounded,
                  label: 'MCQs',
                  color: palette.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusIconBadge),
        border: Border.all(color: palette.borderSubtle),
      ),
      child: Column(
        children: [
          ImtihanIconBadge(
            icon: icon,
            size: 36,
            iconSize: 18,
            accentColor: color,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
