import 'app_exception.dart';

/// Thrown when speech or document analysis can't produce a result
/// (e.g. unreadable/scanned file, empty transcript).
class AnalysisFailure extends AppException {
  const AnalysisFailure(super.message, {super.cause});
}

/// The picked document could not be parsed (scanned image, corrupt file).
class DocumentUnreadableException extends AnalysisFailure {
  const DocumentUnreadableException()
      : super('Document could not be read');
}
