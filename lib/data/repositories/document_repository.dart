import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/models/document_result.dart';
import '../codecs/analysis_codec.dart';
import '../local/app_database.dart';

/// Device-local document analysis history. Raw documents and extracted
/// text are never uploaded.
class DocumentRepository {
  DocumentRepository(this.database);

  final AppDatabase database;

  Future<DocumentResult> save(String userId, DocumentResult result) async {
    if (userId.isEmpty) throw ArgumentError('Sign in to save documents.');
    final id = result.documentId.isEmpty
        ? const Uuid().v4()
        : result.documentId;
    final stored = DocumentResult(
      documentId: id,
      title: result.title,
      extractedText: result.extractedText,
      keySections: result.keySections,
      coveredTopics: result.coveredTopics,
      missingOrWeakTopics: result.missingOrWeakTopics,
      speechImprovements: result.speechImprovements,
      wordCount: result.wordCount,
      estimatedMinutes: result.estimatedMinutes,
    );
    await database
        .into(database.localDocuments)
        .insertOnConflictUpdate(
          LocalDocumentsCompanion.insert(
            id: id,
            userId: userId,
            title: result.title,
            wordCount: Value(result.wordCount),
            resultJson: AnalysisCodec.encodeDocument(stored),
            createdAt: DateTime.now().toUtc(),
          ),
        );
    return stored;
  }

  Stream<List<LocalDocument>> watch(String userId) {
    return (database.select(database.localDocuments)
          ..where((row) => row.userId.equals(userId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
        .watch();
  }

  Future<void> remove(String userId, String id) async {
    await (database.delete(
      database.localDocuments,
    )..where((row) => row.userId.equals(userId) & row.id.equals(id))).go();
  }
}
