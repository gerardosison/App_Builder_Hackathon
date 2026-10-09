import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/analysis_failure.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_fields.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';

/// Document Upload — dashed drop zone, purpose chips, target pace,
/// analyze CTA (Stitch `document_upload_speech_script`).
/// Parsing is mocked via DocumentService. The unreadable-file error
/// (Stitch `document_upload_unreadable_file_error`) is a state of this
/// screen, not a separate route.
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState
    extends ConsumerState<DocumentUploadScreen> {
  String? _fileName;
  int _targetWpm = 140;
  bool _busy = false;
  bool _unreadable = false;

  Future<void> _pickFile() async {
    // Mock picker — pretend the user chose a file.
    setState(() => _fileName = 'industrial_revolution_draft.pdf');
  }

  Future<void> _analyze() async {
    if (_fileName == null) return;
    setState(() => _busy = true);
    try {
      final result =
          await ref.read(documentServiceProvider).analyze(_fileName!);
      if (!mounted) return;
      ref.read(lastDocAnalysisProvider.notifier).state = result;
      context.push(AppRoutes.scriptAnalysis);
    } on DocumentUnreadableException {
      if (mounted) setState(() => _unreadable = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final goal = ref.watch(selectedGoalProvider);

    if (_unreadable) return _buildUnreadable(context, text, scheme);

    return Scaffold(
      appBar: pipAppBar(context, title: 'Upload Script'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Dashed drop zone
                Semantics(
                  button: true,
                  label: 'Choose a file to upload',
                  child: InkWell(
                    onTap: _pickFile,
                    borderRadius:
                        BorderRadius.circular(AppTheme.cardRadius),
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                          color: AppColors.secondary,
                          radius: AppTheme.cardRadius),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 36, horizontal: 24),
                        child: Column(children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondaryFixed
                                  .withValues(alpha: 0.5),
                            ),
                            child: const Icon(
                                Icons.upload_file_rounded,
                                size: 30,
                                color: AppColors.secondary),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _fileName ??
                                'Tap to choose a file',
                            textAlign: TextAlign.center,
                            style: text.labelLarge?.copyWith(
                                color: scheme.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _fileName == null
                                ? 'PDF, DOCX or TXT — analyzed on-device'
                                : 'Tap to change file',
                            style: text.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_fileName != null)
                  PipCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      const IconDisc(
                          icon: Icons.description_outlined,
                          size: 40),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(_fileName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.labelLarge?.copyWith(
                                      color: scheme.onSurface)),
                              Text('Ready to analyze',
                                  style: text.bodySmall?.copyWith(
                                      color:
                                          scheme.onSurfaceVariant)),
                            ]),
                      ),
                      IconButton(
                        tooltip: 'Remove file',
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => _fileName = null),
                      ),
                    ]),
                  ),
                const SizedBox(height: 16),

                // Purpose chips
                Text('Practicing for',
                    style: text.labelMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final g in kGoals)
                    PipOptionChip(
                        label: g.label,
                        icon: g.icon,
                        selected: goal == g.id,
                        onTap: () => ref
                            .read(selectedGoalProvider.notifier)
                            .state = g.id),
                ]),
                const SizedBox(height: 16),

                // Target pace
                PipCard(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Target pace',
                                  style: text.labelLarge?.copyWith(
                                      color: scheme.onSurface)),
                              PipBadge(
                                  label: '$_targetWpm wpm',
                                  icon: Icons.speed),
                            ]),
                        Slider(
                          value: _targetWpm.toDouble(),
                          min: 100,
                          max: 180,
                          divisions: 8,
                          label: '$_targetWpm wpm',
                          onChanged: (v) =>
                              setState(() => _targetWpm = v.round()),
                        ),
                        Text(
                          'Classroom sweet spot: 130–150 wpm',
                          style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant),
                        ),
                      ]),
                ),
                const SizedBox(height: 20),

                PrimaryButton(
                  label: _busy ? 'Analyzing…' : 'Analyze Script',
                  icon: _busy ? null : Icons.auto_awesome,
                  onPressed:
                      (_fileName == null || _busy) ? null : _analyze,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Unreadable-file error state — puzzled Pip, troubleshooting
  /// checklist, choose-another-file + paste-text fallback.
  Widget _buildUnreadable(
      BuildContext context, TextTheme text, ColorScheme scheme) {
    return Scaffold(
      appBar: pipAppBar(context, title: 'Upload Script'),
      body: PipPageBody(children: [
        const Center(
            child: PipMascot(
                asset: PipAsset.sad, size: 130, showBadge: false)),
        const SizedBox(height: 4),
        Text('Hmm… I can\'t read that file',
            textAlign: TextAlign.center,
            style: text.headlineMedium?.copyWith(color: scheme.primary)),
        const SizedBox(height: 8),
        Text(
          'It looks like a scanned image or a corrupted document, '
          'so Pip couldn\'t pull out the text.',
          textAlign: TextAlign.center,
          style:
              text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        PipCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Try this checklist',
                  style:
                      text.labelLarge?.copyWith(color: scheme.primary)),
              const SizedBox(height: 10),
              for (final tip in [
                'Export the file as a real PDF (not a photo of one)',
                'DOCX and TXT files work best',
                'Make sure the file isn\'t password protected',
              ])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 18,
                            color: AppColors.onTertiaryFixedVariant),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(tip,
                              style: text.bodyMedium?.copyWith(
                                  color: scheme.onSurface)),
                        ),
                      ]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PipTextField(
          label: 'Or paste your script text',
          hint: 'Paste your speech draft here…',
          icon: Icons.content_paste,
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Choose another file',
          icon: Icons.upload_file,
          onPressed: () {
            setState(() {
              _unreadable = false;
              _fileName = null;
            });
          },
        ),
        const SizedBox(height: 6),
        PipGhostButton(
            label: 'Back to upload',
            onPressed: () => setState(() => _unreadable = false)),
      ]),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rect = Offset.zero & size;
    final rrect =
        RRect.fromRectAndRadius(rect.deflate(1), Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 8.0;
      const gap = 6.0;
      while (distance < metric.length) {
        canvas.drawPath(
            metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
