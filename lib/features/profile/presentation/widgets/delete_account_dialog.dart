import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../app/app_providers.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/pip_buttons.dart';
import '../../../../core/widgets/pip_mascot.dart';

/// Delete-account confirmation — typed "DELETE" safeguard
/// (Stitch `delete_account_confirmation_dialog`).
Future<void> showDeleteAccountDialog(
    BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DeleteSheet(),
  );
}

class _DeleteSheet extends ConsumerStatefulWidget {
  const _DeleteSheet();

  @override
  ConsumerState<_DeleteSheet> createState() => _DeleteSheetState();
}

class _DeleteSheetState extends ConsumerState<_DeleteSheet> {
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    final confirmed = _confirm.text.trim().toUpperCase() == 'DELETE';

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppTheme.sheetRadius),
          boxShadow: AppColors.cardShadow(3),
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: scheme.outlineVariant.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            const PipMascot(
                asset: PipAsset.sad,
                size: 110,
                showBadge: true,
                badgeIcon: Icons.sentiment_very_dissatisfied),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.report,
                    size: 15, color: scheme.onErrorContainer),
                const SizedBox(width: 4),
                Text('Permanent Action',
                    style: text.labelMedium
                        ?.copyWith(color: scheme.onErrorContainer)),
              ]),
            ),
            const SizedBox(height: 10),
            Text("We're sad to see you go!",
                style: text.headlineMedium
                    ?.copyWith(color: scheme.primary)),
            const SizedBox(height: 8),
            Text(
              'Deleting your account is permanent. You will lose:',
              style: text.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.errorContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.errorContainer),
              ),
              child: Column(children: [
                _lossRow('⭐',
                    '${user?.stars ?? 0} Banked Stars & Level ${user?.level ?? 1} Status'),
                const SizedBox(height: 8),
                _lossRow('🔥',
                    '${user?.streakDays ?? 0}-Day Practice Streak'),
                const SizedBox(height: 8),
                _lossRow('📊',
                    'All speech recordings & AI analysis logs'),
              ]),
            ),
            const SizedBox(height: 16),
            Text(
              'To proceed, type DELETE below:',
              style: text.labelMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirm,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintText: "Type 'DELETE' to confirm"),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Never mind, Keep My Account',
              icon: Icons.shield,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: confirmed ? 1 : 0.5,
              child: PrimaryButton(
                label: 'Delete Forever',
                icon: Icons.delete_forever,
                color: AppColors.error,
                onPressed: confirmed
                    ? () {
                        ref.read(currentUserProvider.notifier).state =
                            null;
                        Navigator.of(context).pop();
                        context.go(AppRoutes.login);
                      }
                    : null,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _lossRow(String emoji, String label) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: text.labelMedium
                  ?.copyWith(color: scheme.primary)),
        ),
      ]),
    );
  }
}
