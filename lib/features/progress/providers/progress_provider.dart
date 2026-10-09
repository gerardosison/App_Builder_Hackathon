import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../core/models/practice_session.dart';

/// Session history fed to Progress/Home (mock until data layer lands).
final sessionHistoryProvider = Provider<List<PracticeSession>>(
    (ref) => ref.watch(feedbackServiceProvider).history());
