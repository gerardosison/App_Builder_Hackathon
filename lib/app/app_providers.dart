import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/permissions/permission_service.dart';
import '../core/services/document_service.dart';
import '../core/services/feedback_service.dart';
import '../core/services/mock/mock_document_service.dart';
import '../core/services/mock/mock_feedback_service.dart';
import '../core/services/mock/mock_permission_service.dart';
import '../core/services/mock/mock_pose_analysis_service.dart';
import '../core/services/mock/mock_speech_recognition_service.dart';
import '../core/services/pose_analysis_service.dart';
import '../core/services/speech_recognition_service.dart';
import '../features/auth/services/local_auth_service.dart';

// Re-export feature-scoped providers + shared option lists so screens
// can keep a single app-level import.
export '../core/constants/app_constants.dart';
export '../features/onboarding/providers/onboarding_provider.dart';
export '../features/practice/providers/practice_provider.dart';
export '../features/feedback/providers/feedback_provider.dart';
export '../features/documents/providers/document_provider.dart';
export '../features/progress/providers/progress_provider.dart';
export '../features/profile/providers/profile_provider.dart';

// ------------------------------------------------------------------ Theme
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

enum PermissionState { notSet, granted, denied }

final permissionStateProvider =
    StateProvider<PermissionState>((ref) => PermissionState.notSet);

// --------------------------------------------------------------- Services
// Swap these mock implementations for real backends; the UI only knows
// the interfaces.
final authServiceProvider = Provider<AuthService>((_) => LocalAuthService());
final permissionServiceProvider =
    Provider<PermissionService>((_) => MockPermissionService());
final speechRecognitionProvider = Provider<SpeechRecognitionService>(
    (_) => MockSpeechRecognitionService());
final poseAnalysisProvider =
    Provider<PoseAnalysisService>((_) => MockPoseAnalysisService());
final feedbackServiceProvider =
    Provider<FeedbackService>((_) => MockFeedbackService());
final documentServiceProvider =
    Provider<DocumentService>((_) => MockDocumentService());

// ------------------------------------------------------------------- Auth
/// Simple onboarding/auth gate for the router redirect.
final authStateProvider = StateProvider<AuthStage>((_) => AuthStage.splash);

enum AuthStage { splash, signedOut, onboarding, personalization, signedIn }
