import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/pip_chips.dart';

/// REC / PAUSED badge with the elapsed clock for the live rooms.
/// The screen owns the ticker; this widget only renders state.
class PracticeTimer extends StatelessWidget {
  const PracticeTimer({
    super.key,
    required this.paused,
    required this.clock,
  });

  final bool paused;
  final String clock;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PipBadge(
      label: paused ? 'PAUSED' : 'REC $clock',
      icon: paused ? Icons.pause : Icons.fiber_manual_record,
      background: paused
          ? scheme.surfaceContainerHigh
          : AppColors.errorContainer,
      foreground: paused ? scheme.onSurfaceVariant : AppColors.error,
    );
  }
}
