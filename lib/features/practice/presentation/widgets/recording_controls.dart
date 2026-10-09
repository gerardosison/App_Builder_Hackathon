import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/pip_buttons.dart';

/// Bottom control dock for the live practice room: script toggle,
/// pause/resume and the red Stop button.
class RecordingControls extends StatelessWidget {
  const RecordingControls({
    super.key,
    required this.scriptVisible,
    required this.paused,
    required this.onToggleScript,
    required this.onTogglePause,
    required this.onStop,
  });

  final bool scriptVisible;
  final bool paused;
  final VoidCallback onToggleScript;
  final VoidCallback onTogglePause;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _DockButton(
          icon: scriptVisible
              ? Icons.subtitles
              : Icons.subtitles_off_outlined,
          label: 'Script',
          onTap: onToggleScript),
      const SizedBox(width: 8),
      _DockButton(
          icon: paused ? Icons.play_arrow : Icons.pause,
          label: paused ? 'Resume' : 'Pause',
          onTap: onTogglePause),
      const SizedBox(width: 8),
      Expanded(
        flex: 2,
        child: PrimaryButton(
          label: 'Stop',
          icon: Icons.stop_rounded,
          color: Theme.of(context).colorScheme.error,
          onPressed: onStop,
        ),
      ),
    ]);
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius:
                  BorderRadius.circular(AppTheme.pillRadius),
              border: Border.all(
                  color:
                      scheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child:
                Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 20, color: scheme.primary),
              const SizedBox(height: 2),
              Text(label,
                  style: text.labelSmall
                      ?.copyWith(color: scheme.primary)),
            ]),
          ),
        ),
      ),
    );
  }
}
