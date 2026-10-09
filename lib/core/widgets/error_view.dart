import 'package:flutter/material.dart';

import 'pip_mascot.dart';

/// Friendly error state: Pip illustration + title + message + retry CTA.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.title,
    required this.message,
    this.asset = PipAsset.sad,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final PipAsset asset;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          PipMascot(asset: asset, size: 130),
          const SizedBox(height: 18),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  text.headlineSmall?.copyWith(color: scheme.primary)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: text.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant)),
          if (actionLabel != null) ...[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel!),
            ),
          ],
        ]),
      ),
    );
  }
}
