import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/practice_session.dart';

/// Completed sessions will populate this after the session repository saves them.
final sessionHistoryProvider = Provider<List<PracticeSession>>((ref) => const []);
