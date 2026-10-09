import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/pip_mascot.dart';
import '../../../../core/widgets/pip_misc.dart';

/// Shared auth chrome: ambient blobs, mascot header, Log In / Register
/// segmented switcher, and the white form card.
class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.isLogin,
    required this.child,
  });

  /// True when the Login tab is active (Register when false). Switching
  /// navigates between the /login and /register routes.
  final bool isLogin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(children: [
        const AmbientBlobs(),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                children: [
                  const SizedBox(height: 8),
                  Column(children: [
                    const PipMascot(
                        asset: PipAsset.happy,
                        size: 128,
                        showBadge: true),
                    const SizedBox(height: 12),
                    Text('PipSpeak',
                        style: text.headlineLarge
                            ?.copyWith(color: scheme.primary)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                            AppTheme.pillRadius),
                        border: Border.all(
                            color: scheme.secondaryContainer
                                .withValues(alpha: 0.6)),
                        boxShadow: AppColors.cardShadow(1),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.campaign,
                                size: 16,
                                color: AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                                'Welcome to your speaking journey!',
                                style: text.labelMedium?.copyWith(
                                    color: AppColors.secondary)),
                          ]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Train your voice, conquer anxiety, and unlock effortless confidence.',
                      textAlign: TextAlign.center,
                      style: text.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  // Segmented pill switcher
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLow,
                      borderRadius:
                          BorderRadius.circular(AppTheme.pillRadius),
                    ),
                    child: Row(children: [
                      _tab(context, 'Log In', Icons.login, isLogin,
                          () => context.go(AppRoutes.login)),
                      _tab(context, 'Register', Icons.person_add,
                          !isLogin,
                          () => context.go(AppRoutes.register)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius:
                          BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(
                          color: scheme.surfaceContainerLow),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(27, 42, 107, 0.08),
                            blurRadius: 24,
                            offset: Offset(0, 8)),
                        BoxShadow(
                            color: Color.fromRGBO(27, 42, 107, 0.04),
                            blurRadius: 6,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _tab(BuildContext context, String label, IconData icon,
      bool active, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Semantics(
        selected: active,
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: active ? scheme.primary : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(AppTheme.pillRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 18,
                    color: active
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(label,
                    style: text.labelLarge?.copyWith(
                        color: active
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// OR-continue-with divider + Google/Apple mock buttons.
class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    Widget btn(String label, IconData icon) => Expanded(
          child: OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              backgroundColor: scheme.surfaceContainerLow,
              side: BorderSide(
                  color:
                      scheme.outlineVariant.withValues(alpha: 0.3)),
              textStyle: text.labelMedium,
            ),
          ),
        );
    return Column(children: [
      Row(children: [
        Expanded(child: Divider(color: scheme.surfaceContainerHigh)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR CONTINUE WITH',
              style: text.labelSmall?.copyWith(
                  color: scheme.outline, letterSpacing: 1.2)),
        ),
        Expanded(child: Divider(color: scheme.surfaceContainerHigh)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        btn('Google', Icons.g_mobiledata),
        const SizedBox(width: 12),
        btn('Apple', Icons.apple),
      ]),
    ]);
  }
}
