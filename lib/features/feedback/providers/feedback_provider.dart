import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/feedback_report.dart';

/// Latest generated report (set by the processing screen).
final lastReportProvider = StateProvider<FeedbackReport?>((_) => null);
