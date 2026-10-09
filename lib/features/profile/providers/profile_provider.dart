import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_profile.dart';

/// Currently signed-in user (mock-backed).
final currentUserProvider = StateProvider<UserProfile?>((_) => null);
