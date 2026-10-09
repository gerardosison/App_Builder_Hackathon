import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';
import 'widgets/permission_sheet.dart';

/// Practice Hub / Setup — teleprompter, audience, duration & purpose options
/// before entering the live room (Stitch `practice_hub`).
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() =>
      _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  int _durationMin = 3;
  String _audience = 'Small (8–12)';
  bool _teleprompter = true;

  Future<void> _enterRoom() async {
    final granted = await showPipPermissionSheet(context);
    if (!mounted) return;
    ref.read(permissionStateProvider.notifier).state =
        granted ? PermissionState.granted : PermissionState.denied;
    if (granted) {
      context.push(_teleprompter
          ? AppRoutes.practiceLive
          : AppRoutes.practiceRehearsal);
    } else {
      context.push(AppRoutes.practiceDenied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final goal = ref.watch(selectedGoalProvider);
    final outcome = ref.watch(practiceOutcomeProvider);
    final goalLabel = kGoals
        .firstWhere((g) => g.id == goal,
            orElse: () => kGoals.first)
        .label;

    return Scaffold(
      appBar: pipAppBar(context, title: 'Practice Hub'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const CoachTipCard(
                  label: 'Coach Pip',
                  icon: Icons.auto_awesome,
                  message:
                      'Pick your room, set the vibe, and let\'s make this your best take yet.',
                ),
                const SizedBox(height: 16),

                // Hero — Live Practice Room
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryContainer, AppColors.navy],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(27, 42, 107, 0.25),
                          blurRadius: 28,
                          offset: Offset(0, 10))
                    ],
                  ),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PipBadge(
                                  label: 'LIVE ROOM',
                                  icon: Icons.videocam,
                                  background: AppColors.secondaryFixed,
                                  foreground: AppColors.navy),
                              const SizedBox(height: 10),
                              Text('Virtual Stage',
                                  style: text.headlineMedium
                                      ?.copyWith(color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(
                                'Cartoon audience • live pace & filler meters • teleprompter',
                                style: text.bodySmall?.copyWith(
                                    color: AppColors.secondaryFixed),
                              ),
                            ]),
                      ),
                      const PipMascot(
                          asset: PipAsset.camera,
                          size: 84,
                          showBadge: false),
                    ]),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Enter Room',
                      icon: Icons.arrow_forward,
                      color: AppColors.secondaryFixed,
                      foreground: AppColors.navy,
                      onPressed: _enterRoom,
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                const SectionHeader(title: 'Session Setup'),
                const SizedBox(height: 10),
                PipCard(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _settingRow('Practicing for', goalLabel,
                            Icons.flag_rounded),
                        const SizedBox(height: 16),
                        Text('Speech length',
                            style: text.labelMedium?.copyWith(
                                color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, children: [
                          for (final m in [2, 3, 5, 8])
                            PipOptionChip(
                                label: '$m min',
                                selected: _durationMin == m,
                                onTap: () =>
                                    setState(() => _durationMin = m)),
                        ]),
                        const SizedBox(height: 16),
                        Text('Audience size',
                            style: text.labelMedium?.copyWith(
                                color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final a in [
                            'Solo',
                            'Small (8–12)',
                            'Classroom (30)',
                            'Auditorium'
                          ])
                            PipOptionChip(
                                label: a,
                                selected: _audience == a,
                                onTap: () =>
                                    setState(() => _audience = a)),
                        ]),
                        const SizedBox(height: 16),
                        Divider(color: scheme.surfaceContainerHigh),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Teleprompter script',
                              style: text.labelLarge
                                  ?.copyWith(color: scheme.onSurface)),
                          subtitle: Text(
                            'Show your outline while you speak',
                            style: text.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant),
                          ),
                          value: _teleprompter,
                          onChanged: (v) =>
                              setState(() => _teleprompter = v),
                        ),
                      ]),
                ),
                const SizedBox(height: 12),

                // Upload script shortcut
                PipCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () => context.push(AppRoutes.documentUpload),
                  child: Row(children: [
                    const IconDisc(icon: Icons.upload_file),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Upload a script',
                                style: text.labelLarge?.copyWith(
                                    color: scheme.onSurface)),
                            Text('Pip analyzes structure & pacing cues',
                                style: text.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant)),
                          ]),
                    ),
                    Icon(Icons.chevron_right, color: scheme.outline),
                  ]),
                ),
                const SizedBox(height: 12),

                // Mock-only demo control
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: scheme.outlineVariant
                            .withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    Icon(Icons.science_outlined,
                        size: 18, color: scheme.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Demo feedback outcome (mock)',
                          style: text.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant)),
                    ),
                    Semantics(
                      selected: outcome == PracticeOutcome.improved,
                      button: true,
                      label: 'Toggle improved speech outcome',
                      child: InkWell(
                        onTap: () => ref
                            .read(practiceOutcomeProvider.notifier)
                            .state = outcome == PracticeOutcome.improved
                                ? PracticeOutcome.noImprovement
                                : PracticeOutcome.improved,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: outcome == PracticeOutcome.improved
                                ? AppColors.tertiaryFixed
                                : scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            outcome == PracticeOutcome.improved
                                ? 'Improved'
                                : 'No improvement',
                            style: text.labelMedium?.copyWith(
                                color:
                                    outcome == PracticeOutcome.improved
                                        ? AppColors.onTertiaryFixed
                                        : scheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingRow(String label, String value, IconData icon) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      IconDisc(icon: icon, size: 36),
      const SizedBox(width: 10),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: text.labelMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          Text(value,
              style: text.labelLarge?.copyWith(color: scheme.onSurface)),
        ]),
      ),
      PipGhostButton(
          label: 'Change',
          onPressed: () => context.push(AppRoutes.personalize)),
    ]);
  }
}
