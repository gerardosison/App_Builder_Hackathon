import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/document_result.dart';

/// Latest document analysis (set after Document Upload succeeds).
final lastDocAnalysisProvider = StateProvider<DocumentResult?>((_) => null);
