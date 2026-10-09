import 'package:flutter/material.dart';

/// Bundled Pip illustrations (exported from Stitch).
enum PipAsset {
  stage('assets/images/mascot/pip_stage.png', 'Pip presenting on stage'),
  stars('assets/images/mascot/pip_stars.png',
      'Pip celebrating with stars'),
  pacing('assets/images/mascot/pip_pacing.png',
      'Pip holding a pacing stopwatch'),
  camera('assets/images/mascot/pip_camera.png',
      'Pip holding a camera and mic'),
  analysis('assets/images/mascot/pip_analysis.png',
      'Pip inspecting data with a magnifier'),
  sad('assets/images/mascot/pip_sad.png',
      'Pip looking sad with a suitcase'),
  happy('assets/images/mascot/pip_happy.png', 'Pip flying happily');

  const PipAsset(this.path, this.semanticLabel);
  final String path;
  final String semanticLabel;
}

/// Mascot image with a soft circular pastel aura, matching the Stitch designs
/// where Pip sits inside a glowing pastel disc.
class PipMascot extends StatelessWidget {
  const PipMascot({
    super.key,
    required this.asset,
    this.size = 120,
    this.withAura = true,
    this.showBadge = false,
    this.badgeIcon = Icons.auto_awesome,
  });

  final PipAsset asset;
  final double size;
  final bool withAura;

  /// Small circular badge pinned to the bottom-right (sparkle / star / icon).
  final bool showBadge;
  final IconData badgeIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: asset.semanticLabel,
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (withAura) ...[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondaryContainer.withValues(alpha: 0.35),
                ),
              ),
              Container(
                width: size * 0.88,
                height: size * 0.88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surfaceContainerLowest,
                  border: Border.all(
                      color: scheme.secondaryContainer.withValues(alpha: 0.7),
                      width: 3),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.all(withAura ? size * 0.10 : 0),
              child: ClipOval(
                child: Image.asset(
                  asset.path,
                  width: size * (withAura ? 0.80 : 1),
                  height: size * (withAura ? 0.80 : 1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (showBadge)
              Positioned(
                right: size * 0.02,
                bottom: size * 0.02,
                child: Container(
                  width: size * 0.28,
                  height: size * 0.28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.tertiaryContainer,
                    border: Border.all(
                        color: scheme.surfaceContainerLowest, width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Icon(badgeIcon,
                      size: size * 0.15, color: scheme.onTertiaryContainer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
