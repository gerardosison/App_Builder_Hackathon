import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';
import '../../practice/presentation/widgets/audience_character.dart';
import 'widgets/coaching_tip_card.dart';
import 'widgets/pose_feedback_card.dart';
import 'widgets/speech_metric_card.dart';

/// Post-session "Speech Report" — score hero, metric cards, strengths &
/// tips, audience reaction, collect-stars CTA
/// (Stitch `post_session_speech_feedback_analysis`).
class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    
    final report = ref.watch(lastReportProvider);
    final firstName =
        (ref.watch(currentUserProvider)?.name ?? 'Maya').split(' ').first;

    if (report == null) {
      return Scaffold(
        appBar: pipAppBar(context, title: 'Session Report'),
        body: const PipEmptyState(
          title: 'No report yet',
          message: 'Finish a practice session to see your feedback here.',
          asset: PipAsset.analysis,
        ),
      );
    }

    return Scaffold(
      appBar: pipAppBar(context, title: 'Session Report', showBack: false),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Score hero
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryContainer,
                        AppColors.navyDeep
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: Column(children: [
                    PipMascot(
                        asset: report.improved
                            ? PipAsset.happy
                            : PipAsset.pacing,
                        size: 96,
                        showBadge: false),
                    const SizedBox(height: 8),
                    Text(
                        report.improved
                            ? 'Great take, $firstName!'
                            : 'Keep going, $firstName!',
                        style: text.headlineMedium
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      report.improved
                          ? 'You beat your last score by 12 points.'
                          : 'Not your best take — but every rep counts.',
                      style: text.bodySmall
                          ?.copyWith(color: AppColors.secondaryFixed),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(AppTheme.pillRadius),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('${report.overallScore}',
                            style: text.displayLarge?.copyWith(
                                color: Colors.white, fontSize: 44)),
                        const SizedBox(width: 8),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Overall',
                                  style: text.labelMedium?.copyWith(
                                      color: AppColors.secondaryFixed)),
                              Text(report.improved ? '▲ +12' : '▼ −9',
                                  style: text.labelMedium?.copyWith(
                                      color: report.improved
                                          ? AppColors.tertiaryFixed
                                          : AppColors.gold)),
                            ]),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Metric cards
                Row(children: [
                  Expanded(
                      child: SpeechMetricCard(
                          icon: Icons.speed,
                          value: '${report.wpm}',
                          label: 'WPM pace',
                          tint: AppColors.secondaryFixed)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: SpeechMetricCard(
                          icon: Icons.bubble_chart,
                          value: '${report.fillerCount}',
                          label: 'Fillers',
                          tint: report.fillerCount > 6
                              ? AppColors.errorContainer
                              : AppColors.tertiaryFixed)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: SpeechMetricCard(
                          icon: Icons.visibility,
                          value: '${report.eyeContactPct}%',
                          label: 'Eye contact',
                          tint: AppColors.secondaryContainer
                              .withValues(alpha: 0.6))),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      child: SpeechMetricCard(
                          icon: Icons.pause_circle_outline,
                          value: '${report.pausesScore}',
                          label: 'Pause control',
                          tint: AppColors.tertiaryFixed
                              .withValues(alpha: 0.6))),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: PoseFeedbackCard(
                          members: mockAudience(9))),
                ]),
                const SizedBox(height: 16),

                // Strengths
                const SectionHeader(title: 'What landed'),
                const SizedBox(height: 8),
                PipCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (final s in report.strengths)
                        CoachingTipCard(
                            body: s,
                            icon: Icons.check_circle,
                            iconTint: AppColors.tertiaryFixed,
                            iconForeground:
                                AppColors.onTertiaryFixedVariant),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tips
                const SectionHeader(title: "Pip's tips"),
                const SizedBox(height: 8),
                PipCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (final t in report.tips)
                        CoachingTipCard(
                            body: t,
                            icon: Icons.lightbulb,
                            iconTint: AppColors.secondaryFixed,
                            iconForeground:
                                AppColors.onSecondaryFixedVariant),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                PipSecondaryButton(
                    label: 'Review transcript',
                    icon: Icons.notes,
                    onPressed: () =>
                        context.push(AppRoutes.transcript)),
                const SizedBox(height: 10),
                if (report.improved)
                  PrimaryButton(
                    label: 'Collect ${report.starsEarned} Stars',
                    icon: Icons.star,
                    color: AppColors.gold,
                    foreground: AppColors.navy,
                    onPressed: () =>
                        context.push(AppRoutes.starsReward),
                  )
                else
                  PrimaryButton(
                    label: 'Keep going',
                    icon: Icons.favorite,
                    onPressed: () =>
                        context.push(AppRoutes.keepGoing),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
