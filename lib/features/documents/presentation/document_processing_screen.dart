import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/errors/analysis_failure.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';
import '../../ai/feedback/local_llm_service.dart';

class DocumentAnalysisRequest {
  const DocumentAnalysisRequest({
    required this.fileName,
    required this.readBytes,
    required this.readLength,
  });

  final String fileName;
  final Future<Uint8List> Function() readBytes;
  final Future<int?> Function() readLength;
}

enum DocumentProcessingOutcome { unreadable, failed }

class DocumentProcessingScreen extends ConsumerStatefulWidget {
  const DocumentProcessingScreen({
    super.key,
    required this.request,
  });

  final DocumentAnalysisRequest request;

  @override
  ConsumerState<DocumentProcessingScreen> createState() =>
      _DocumentProcessingScreenState();
}

class _DocumentProcessingScreenState
    extends ConsumerState<DocumentProcessingScreen> {
  static const _maxFileBytes = 40 * 1024 * 1024;

  String _status = 'Opening your document…';
  String? _error;
  bool _settled = false;
  DocumentProcessingOutcome _outcome = DocumentProcessingOutcome.failed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_analyze()));
  }

  void _updateStatus(String status) {
    if (mounted) setState(() => _status = status);
  }

  Future<void> _analyze() async {
    try {
      final fileLength = await widget.request.readLength();
      if (fileLength != null && fileLength > _maxFileBytes) {
        throw const AnalysisFailure(
          'Please choose a document smaller than 40 MB to keep local analysis responsive.',
        );
      }
      _updateStatus('Reading ${widget.request.fileName}…');
      final bytes = await widget.request.readBytes();
      if (bytes.lengthInBytes > _maxFileBytes) {
        throw const AnalysisFailure(
          'Please choose a document smaller than 40 MB to keep local analysis responsive.',
        );
      }

      final result = await ref
          .read(documentServiceProvider)
          .analyze(widget.request.fileName, bytes, onProgress: _updateStatus);
      final uid = ref.read(currentUidProvider);
      final saved = uid == null
          ? result
          : await ref.read(documentRepositoryProvider).save(uid, result);
      if (!mounted) return;
      ref.read(lastDocAnalysisProvider.notifier).state = saved;
      _settled = true;
      context.go(AppRoutes.scriptAnalysis);
    } on DocumentUnreadableException catch (error) {
      _showError(
        error.message,
        DocumentProcessingOutcome.unreadable,
      );
    } catch (error) {
      _showError(error.toString(), DocumentProcessingOutcome.failed);
    }
  }

  void _showError(String error, DocumentProcessingOutcome outcome) {
    if (!mounted) return;
    _settled = true;
    setState(() {
      _error = error;
      _outcome = outcome;
    });
  }

  @override
  void dispose() {
    if (!_settled) unawaited(LocalLlmService().stopGeneration());
    super.dispose();
  }

  void _returnToUpload() {
    if (_error == null) {
      unawaited(LocalLlmService().stopGeneration());
    }
    context.pop(_outcome);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final failed = _error != null;
    return Scaffold(
      appBar: pipAppBar(context, title: 'Analyzing script', showBack: false),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: PipCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (failed)
                      Icon(
                        Icons.error_outline_rounded,
                        size: 72,
                        color: scheme.error,
                      )
                    else
                      PipMascot(
                        asset: PipAsset.analysis,
                        size: 104,
                        showBadge: false,
                      ),
                    const SizedBox(height: 18),
                    Text(
                      failed
                          ? (_outcome == DocumentProcessingOutcome.unreadable
                              ? 'We couldn’t read that script'
                              : 'Analysis couldn’t finish')
                          : 'Your AI Coach is reviewing the script',
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(
                        color: failed ? scheme.error : scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      failed
                          ? _error!
                          : _status,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    if (!failed) ...[
                      const SizedBox(height: 26),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const LinearProgressIndicator(minHeight: 8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your file stays on this device while it is processed.',
                        textAlign: TextAlign.center,
                        style: text.bodySmall?.copyWith(
                          color: AppColors.secondaryText(context),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed: _returnToUpload,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Back to upload'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
