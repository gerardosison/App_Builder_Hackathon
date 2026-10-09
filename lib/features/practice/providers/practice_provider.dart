import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/practice_controller.dart';
import '../../../core/models/pose_metrics.dart';
import '../../../core/models/speech_metrics.dart';

/// Practice provider instance
final practiceController = PracticeController();

final lastSpeechMetricsProvider = StateProvider<SpeechMetrics?>((ref) => null);
final lastPoseMetricsProvider = StateProvider<PoseMetrics?>((ref) => null);
