import '../../errors/analysis_failure.dart';
import '../../models/document_result.dart';
import '../document_service.dart';

/// TODO(backend): replace with real PDF/DOCX parsing + analysis.
class MockDocumentService implements DocumentService {
  @override
  Future<DocumentResult> analyze(String fileName) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (fileName.toLowerCase().contains('scan') ||
        fileName.toLowerCase().contains('image')) {
      throw const DocumentUnreadableException();
    }
    return DocumentResult(
      fileName: fileName,
      overallScore: 82,
      readability: 'Grade 8 — clear for classmates',
      estimatedMinutes: 4.5,
      wordCount: 640,
      sections: const [
        DocSection('Introduction', 90, 'Strong hook and clear thesis.'),
        DocSection('Body / Evidence', 78, 'Good flow; add one more example.'),
        DocSection('Conclusion', 74, 'Ends a bit abruptly — add a callback.'),
      ],
      strengths: const [
        'Clear thesis in the first paragraph',
        'Logical section ordering',
        'Confident, active voice throughout',
      ],
      missingConcepts: const [
        'No definition of "industrialization" before first use',
        'Missing a transition between sections 2 and 3',
      ],
      tips: const [
        'Read the intro aloud — it runs 2 sentences too long.',
        'Mark 3 natural pause points for the teleprompter.',
      ],
    );
  }
}
