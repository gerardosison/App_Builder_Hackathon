import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/models.dart';
import '../../../features/auth/services/local_auth_service.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/star_level.dart';
import '../../../core/widgets/pip_buttons.dart';

/// Home / Practice tab — greeting, streak, level, CTAs, warm-up drills,
/// recent sessions (Stitch `practice_home`).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _drills = [
    WarmupDrill(
        name: 'Tongue Twisters',
        minutes: 3,
        icon: Icons.record_voice_over,
        tint: AppColors.secondaryFixed),
    WarmupDrill(
        name: 'Breath Control',
        minutes: 2,
        icon: Icons.air,
        tint: AppColors.tertiaryFixed),
    WarmupDrill(
        name: 'Pace Trainer',
        minutes: 4,
        icon: Icons.speed,
        tint: AppColors.secondaryContainer),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider) ?? LocalAuthService.mockUser;
    final history = ref.watch(sessionHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Header
                Row(children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good morning,',
                              style: text.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant)),
                          Text(user.name.split(' ').first,
                              style: text.headlineMedium
                                  ?.copyWith(color: scheme.primary)),
                        ]),
                  ),
                  StarChip(label: '${user.stars}'),
                  const SizedBox(width: 8),
                  PipBadge(
                      label: '${user.streakDays}d',
                      icon: Icons.local_fire_department,
                      background: AppColors.tertiaryFixed,
                      foreground: AppColors.onTertiaryFixed),
                ]),
                const SizedBox(height: 16),
                // Level progress card
                PipCard(
                  child: Column(children: [
                    LevelProgress(level: user.level, stars: user.stars),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(children: [
                      const PipMascot(
                          asset: PipAsset.stars,
                          size: 76,
                          showBadge: false),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ready for today's spotlight?",
                                  style: text.labelLarge
                                      ?.copyWith(color: scheme.primary)),
                              const SizedBox(height: 4),
                              Text(
                                user.stars == 0
                                    ? 'Complete one more speech to start earning stars.'
                                    : 'One great speech today keeps your ${user.streakDays}-day streak glowing.',
                                style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                            ]),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    PrimaryButton(
                        label: 'Start Practicing',
                        icon: Icons.mic_external_on,
                        onPressed: () =>
                            context.push(AppRoutes.practiceSetup)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: PipSecondaryButton(
                            label: 'Upload Script',
                            icon: Icons.upload_file,
                            onPressed: () =>
                                context.push(AppRoutes.documentUpload)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PipGhostButton(
                            label: 'View History',
                            icon: Icons.history,
                            onPressed: () =>
                                context.push(AppRoutes.history)),
                      ),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),
                const SectionHeader(title: 'Warm-Up Drills'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 118,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _drills.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final d = _drills[i];
                      return Semantics(
                        button: true,
                        label: '${d.name}, ${d.minutes} minute drill',
                        child: InkWell(
                          onTap: () =>
                              context.push(AppRoutes.practiceSetup),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.cardShadow(1),
                            ),
                            child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  IconDisc(
                                      icon: d.icon,
                                      size: 36,
                                      background: d.tint
                                          .withValues(alpha: 0.5)),
                                  const Spacer(),
                                  Text(d.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.labelLarge?.copyWith(
                                          color: scheme.onSurface)),
                                  Text('${d.minutes} min',
                                      style: text.bodySmall?.copyWith(
                                          color:
                                              scheme.onSurfaceVariant)),
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SectionHeader(
                    title: 'Recent Sessions',
                    action: 'View All',
                    onAction: () => context.push(AppRoutes.history)),
                const SizedBox(height: 10),
                if (history.isEmpty)
                  const PipCard(
                      child: Text('No sessions yet — your first speech '
                          'will appear here.'))
                else
                  ...history.take(3).map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SessionTile(session: s),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact session list row (title, date, duration, WPM, stars).
class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final mins = session.duration.inMinutes;
    final secs = session.duration.inSeconds % 60;
    return PipCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () =>
          context.push(AppRoutes.rehearsalAnalysis, extra: session),
      child: Row(children: [
        IconDisc(
            icon: session.improved ? Icons.trending_up : Icons.trending_flat,
            size: 42,
            background: session.improved
                ? AppColors.tertiaryFixed.withValues(alpha: 0.6)
                : scheme.surfaceContainerHigh),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(session.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelLarge?.copyWith(color: scheme.onSurface)),
            const SizedBox(height: 2),
            Text(
              '${DateFormat.MMMd().format(session.date)} • '
              '$mins:${secs.toString().padLeft(2, '0')} • '
              '${session.avgWpm} wpm',
              style: text.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        session.starsEarned > 0
            ? StarChip(label: '+${session.starsEarned}')
            : PipBadge(
                label: '—',
                background: scheme.surfaceContainerHigh,
                foreground: scheme.onSurfaceVariant),
      ]),
    );
  }
}
