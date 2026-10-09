import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';

/// Document Analysis Result — metadata, section scores, strengths,
/// gaps, tips + "Practice this speech" CTA
/// (Stitch `speech_script_analysis`).
class ScriptAnalysisScreen extends ConsumerWidget {
  const ScriptAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final doc = ref.watch(lastDocAnalysisProvider);

    if (doc == null) {
      return Scaffold(
        appBar: pipAppBar(context, title: 'Script Analysis'),
        body: const PipEmptyState(
          title: 'No script analyzed',
          message: 'Upload a script first to see its breakdown here.',
          asset: PipAsset.analysis,
          actionLabel: 'Upload a script',
          actionIcon: Icons.upload_file,
        ),
      );
    }

    return Scaffold(
      appBar: pipAppBar(context, title: 'Script Analysis'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Metadata card
                PipCard(
                  child: Row(children: [
                    const IconDisc(
                        icon: Icons.description_outlined, size: 52),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.labelLarge?.copyWith(
                                    color: scheme.onSurface)),
                            const SizedBox(height: 2),
                            Text(
                                '${doc.wordCount} words • ~${doc.estimatedMinutes} min read',
                                style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 2),
                            Text(doc.readability,
                                style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                          ]),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.tertiaryFixed
                            .withValues(alpha: 0.6),
                      ),
                      child: Center(
                        child: Text('${doc.overallScore}',
                            style: text.headlineSmall?.copyWith(
                                color: AppColors.onTertiaryFixed)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                const CoachTipCard(
                  label: "Pip's read",
                  icon: Icons.auto_awesome,
                  message:
                      'Solid draft! Your structure is clear — polish '
                      'the ending and you\'re stage-ready.',
                ),
                const SizedBox(height: 16),

                const SectionHeader(title: 'Section scores'),
                const SizedBox(height: 8),
                for (final s in doc.sections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PipCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(s.name,
                                      style: text.labelLarge?.copyWith(
                                          color: scheme.onSurface)),
                                  Text('${s.score}/100',
                                      style: text.labelMedium?.copyWith(
                                          color: scheme.primary)),
                                ]),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: s.score / 100,
                                minHeight: 10,
                                backgroundColor:
                                    scheme.surfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation(
                                    s.score > 80
                                        ? AppColors.tertiaryFixed
                                        : s.score > 70
                                            ? AppColors.secondaryFixed
                                            : AppColors.errorContainer),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(s.note,
                                style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                          ]),
                    ),
                  ),
                const SizedBox(height: 8),

                const SectionHeader(title: 'What works'),
                const SizedBox(height: 8),
                PipCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    for (final s in doc.strengths)
                      _bulletRow(context, Icons.check_circle,
                          AppColors.tertiaryFixed, s),
                  ]),
                ),
                const SizedBox(height: 12),
                const SectionHeader(title: 'Gaps to fix'),
                const SizedBox(height: 8),
                PipCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    for (final s in doc.missingConcepts)
                      _bulletRow(context, Icons.lightbulb,
                          AppColors.secondaryFixed, s),
                    for (final s in doc.tips)
                      _bulletRow(context, Icons.tips_and_updates,
                          AppColors.secondaryContainer, s),
                  ]),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    label: 'Practice this speech',
                    icon: Icons.mic_external_on,
                    onPressed: () =>
                        context.push(AppRoutes.practiceSetup)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: PipSecondaryButton(
                        label: 'Re-analyze',
                        icon: Icons.refresh,
                        onPressed: () => context.pop()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PipGhostButton(
                        label: 'Export cue cards',
                        icon: Icons.style,
                        onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Cue cards coming soon (mock)')))),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bulletRow(
      BuildContext context, IconData icon, Color bg, String body) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 28,
          height: 28,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: bg),
          child: Icon(icon, size: 15, color: AppColors.navy),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(body,
                style: text.bodyMedium
                    ?.copyWith(color: scheme.onSurface)),
          ),
        ),
      ]),
    );
  }
}
