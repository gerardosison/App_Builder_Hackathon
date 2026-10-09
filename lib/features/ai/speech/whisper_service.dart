import 'dart:io';
import 'package:flutter/services.dart';
import '../../../core/models/speech_metrics.dart';
import '../../../core/services/speech_recognition_service.dart';

/// Offline Android transcription through the bundled whisper.cpp JNI runtime.
class WhisperSpeechService implements SpeechRecognitionService {
  static const MethodChannel _channel = MethodChannel('com.hawkabuild.app/ai');
  bool _isLoaded = false;

  @override
  Future<bool> isModelLoaded() async {
    return _isLoaded;
  }

  Future<void> initializeModel() async {
    try {
      _isLoaded =
          await _channel.invokeMethod<bool>('initializeWhisper') ?? false;
    } on PlatformException catch (error) {
      _isLoaded = false;
      throw StateError(
        error.message ?? 'Could not initialize the local Whisper model.',
      );
    } on MissingPluginException {
      _isLoaded = false;
      throw StateError(
        'The Android AI method channel is not registered. Confirm the app launches com.hawkabuild.app.MainActivity.',
      );
    }
    if (!_isLoaded) {
      throw StateError('Could not initialize the local Whisper model.');
    }
  }

  @override
  Future<TranscriptionResult> transcribe(
    String audioPath, {
    String language = 'auto',
  }) async {
    if (audioPath.isEmpty) {
      return TranscriptionResult.failure('Audio file path is empty.');
    }
    if (!File(audioPath).existsSync()) {
      return TranscriptionResult.failure(
        'Audio file does not exist: $audioPath',
      );
    }

    try {
      if (!_isLoaded) await initializeModel();
      final response = await _channel.invokeMapMethod<String, dynamic>(
        'transcribe',
        {'audioPath': audioPath, 'language': language},
      );
      final text = response?['text'] as String? ?? '';
      final duration = (response?['durationSeconds'] as num?)?.toDouble() ?? 0;
      if (text.isEmpty) {
        return TranscriptionResult.failure('Whisper returned no speech text.');
      }
      return TranscriptionResult(
        text: text,
        durationSeconds: duration,
        detectedLanguage: response?['language'] as String? ?? language,
      );
    } on PlatformException catch (error) {
      return TranscriptionResult.failure(
        error.message ?? 'Offline Whisper transcription failed.',
      );
    } on MissingPluginException {
      return TranscriptionResult.failure(
        'The Android AI method channel is not registered. Confirm the app launches com.hawkabuild.app.MainActivity.',
      );
    } on StateError catch (error) {
      return TranscriptionResult.failure(error.message.toString());
    }
  }

  @override
  SpeechMetrics calculateMetrics({
    required TranscriptionResult transcription,
    required double durationSeconds,
  }) {
    if (!transcription.isSuccess || transcription.text.isEmpty) {
      return SpeechMetrics.empty();
    }

    final words = transcription.text.trim().split(RegExp(r'\s+'));
    final int wordCount = words.length;
    final double durationMin = durationSeconds > 0
        ? durationSeconds / 60.0
        : 0.5;
    final double wpm = durationMin > 0 ? wordCount / durationMin : 0.0;

    // Count filler words
    final lowerText = transcription.text.toLowerCase();
    final RegExp umRegex = RegExp(r'\bum\b');
    final RegExp uhRegex = RegExp(r'\buh\b');
    final RegExp likeRegex = RegExp(r'\blike\b');

    int umCount = umRegex.allMatches(lowerText).length;
    int uhCount = uhRegex.allMatches(lowerText).length;
    int likeCount = likeRegex.allMatches(lowerText).length;

    int totalFillers = umCount + uhCount + likeCount;

    return SpeechMetrics(
      transcript: transcription.text,
      wordCount: wordCount,
      speechDurationSeconds: durationSeconds,
      wordsPerMinute: double.parse(wpm.toStringAsFixed(1)),
      fillerOccurrences: {'um': umCount, 'uh': uhCount, 'like': likeCount},
      totalFillers: totalFillers,
      pauseCount: transcription.segments.length > 1
          ? transcription.segments.length - 1
          : 1,
      avgPauseDurationSeconds: 1.2,
    );
  }
}
