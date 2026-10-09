import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_misc.dart';

/// Settings — appearance 3-way switcher, language, reminders,
/// permissions, privacy & data (Stitch `settings`).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final permission = ref.watch(permissionStateProvider);

    return Scaffold(
      appBar: pipAppBar(context,
          title: 'Settings',
          trailingChip: const SkyBadge(
              label: 'Live Sync', icon: Icons.verified)),
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
                      'Pip calibrates to your preferences. Changes apply '
                      'instantly across practice rooms.',
                ),
                const SizedBox(height: 20),

                const _Label('PREFERENCES'),
                PipCard(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Icon(Icons.palette,
                                    size: 20,
                                    color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Text('Appearance',
                                    style: text.labelLarge?.copyWith(
                                        color: scheme.onSurface)),
                              ]),
                              Text('Theme Mode',
                                  style: text.labelSmall?.copyWith(
                                      color: scheme.outline)),
                            ]),
                        const SizedBox(height: 10),
                        // 3-way segmented control
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(
                                AppTheme.pillRadius),
                          ),
                          child: Row(children: [
                            _mode(context, ref, 'Light', Icons.light_mode,
                                ThemeMode.light, themeMode),
                            _mode(context, ref, 'Dark', Icons.dark_mode,
                                ThemeMode.dark, themeMode),
                            _mode(context, ref, 'System',
                                Icons.settings_brightness,
                                ThemeMode.system, themeMode),
                          ]),
                        ),
                        const SizedBox(height: 14),
                        Divider(color: scheme.surfaceContainerHigh),
                        _navRow(context, Icons.public, 'Language',
                            'Speech pronunciation dialect',
                            value: 'English (US)',
                            onTap: () => context
                                .push(AppRoutes.personalize)),
                      ]),
                ),
                const SizedBox(height: 16),

                const _Label('SYSTEM & HARDWARE'),
                PipCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const IconDisc(
                          icon: Icons.notifications_active,
                          size: 36),
                      title: Text('Practice Reminders',
                          style: text.labelLarge
                              ?.copyWith(color: scheme.onSurface)),
                      subtitle: Text(
                        'Daily gentle nudge from Pip at 6:00 PM',
                        style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant),
                      ),
                      value: true,
                      onChanged: (_) {},
                    ),
                    Divider(color: scheme.surfaceContainerHigh),
                    _navRow(context, Icons.mic, 'Camera & Mic Permissions',
                        'Live posture & audio feedback',
                        value: permission == PermissionState.granted
                            ? 'Granted'
                            : 'Not set',
                        onTap: () => context.push(AppRoutes.practiceDenied)),
                  ]),
                ),
                const SizedBox(height: 16),

                const _Label('PRIVACY & SECURITY'),
                PipCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const IconDisc(
                          icon: Icons.security, size: 36),
                      title: Wrap(spacing: 8, children: [
                        Text('Privacy First',
                            style: text.labelLarge
                                ?.copyWith(color: scheme.onSurface)),
                        const MintBadge(
                            label: '100% On-Device',
                            icon: Icons.lock),
                      ]),
                      subtitle: Text(
                        'Audio and video analyzed locally. Rehearsals '
                        'are never uploaded to cloud servers.',
                        style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant),
                      ),
                      value: true,
                      onChanged: (_) {},
                    ),
                    Divider(color: scheme.surfaceContainerHigh),
                    _navRow(context, Icons.history_toggle_off,
                        'Recording Cache',
                        'Auto-clears local practice recordings',
                        value: 'Keep 30 days',
                        onTap: () => context.push(AppRoutes.privacy)),
                    _navRow(context, Icons.info_outline, 'About PipSpeak',
                        'Version, team & credits',
                        onTap: () => context.push(AppRoutes.about)),
                  ]),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text('PipSpeak v2.4 • HawkaBuild Edition',
                      style: text.labelSmall
                          ?.copyWith(color: scheme.outline)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mode(BuildContext context, WidgetRef ref, String label,
      IconData icon, ThemeMode mode, ThemeMode current) {
    final sel = mode == current;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Semantics(
        selected: sel,
        button: true,
        label: '$label theme',
        child: InkWell(
          onTap: () =>
              ref.read(themeModeProvider.notifier).state = mode,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: sel ? scheme.surfaceContainerLowest : null,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              boxShadow: sel ? AppColors.cardShadow(1) : null,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      size: 18,
                      color: sel
                          ? scheme.primary
                          : scheme.onSurfaceVariant),
                  const SizedBox(width: 5),
                  Text(label,
                      style: text.labelMedium?.copyWith(
                          color: sel
                              ? scheme.primary
                              : scheme.onSurfaceVariant)),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _navRow(BuildContext context, IconData icon, String title,
      String subtitle,
      {String? value, VoidCallback? onTap}) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(children: [
            IconDisc(icon: icon, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: text.labelLarge
                            ?.copyWith(color: scheme.onSurface)),
                    Text(subtitle,
                        style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant)),
                  ]),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(value,
                    style: text.labelMedium
                        ?.copyWith(color: scheme.primary)),
              ),
            Icon(Icons.chevron_right,
                size: 20, color: scheme.outline),
          ]),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.outline)),
    );
  }
}
