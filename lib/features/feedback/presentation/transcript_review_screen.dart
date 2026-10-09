import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/models.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_misc.dart';

/// Transcript review — Whisper output with highlighted fillers and
/// pauses (no Stitch design — matching style).
class TranscriptReviewScreen extends ConsumerWidget {
  const TranscriptReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final report = ref.watch(lastReportProvider);
    final segments = report?.transcript ??
        const [
          TranscriptSegment(
              text: 'Finish a practice session to see a transcript.'),
        ];

    return Scaffold(
      appBar: pipAppBar(context, title: 'Transcript'),
      body: PipPageBody(children: [
        Row(children: [
          SkyBadge(
              label: '${report?.fillerCount ?? 0} fillers',
              icon: Icons.bubble_chart),
          const SizedBox(width: 8),
          const MintBadge(label: 'On-device', icon: Icons.lock),
        ]),
        PipCard(
          child: RichText(
            text: TextSpan(
              style: text.bodyLarge
                  ?.copyWith(color: scheme.onSurface, height: 1.6),
              children: [
                for (final s in segments)
                  TextSpan(
                    text: s.text,
                    style: s.isFiller
                        ? const TextStyle(
                            backgroundColor: AppColors.errorContainer,
                            color: AppColors.error,
                            fontWeight: FontWeight.w700)
                        : s.isPause
                            ? TextStyle(
                                backgroundColor:
                                    AppColors.secondaryFixed,
                                color:
                                    AppColors.onSecondaryFixedVariant,
                                fontStyle: FontStyle.italic)
                            : null,
                  ),
              ],
            ),
          ),
        ),
        const CoachTipCard(
          label: 'How to read this',
          icon: Icons.palette,
          message:
              'Red highlights = filler words to swap for silent beats. '
              'Blue italic = a pause longer than 2 seconds.',
        ),
      ]),
    );
  }
}
