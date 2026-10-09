import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_fields.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';

/// No Stitch design — built in the same design language.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: pipAppBar(context, title: 'Reset Password'),
      body: Stack(children: [
        const AmbientBlobs(),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Center(
                    child: PipMascot(
                        asset: PipAsset.sad, size: 120, showBadge: false)),
                const SizedBox(height: 12),
                Text('Forgot your password?',
                    textAlign: TextAlign.center,
                    style: text.headlineMedium
                        ?.copyWith(color: scheme.primary)),
                const SizedBox(height: 8),
                Text(
                  "No worries! Enter your email and Pip will send a reset link your way.",
                  textAlign: TextAlign.center,
                  style: text.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(27, 42, 107, 0.08),
                          blurRadius: 24,
                          offset: Offset(0, 8))
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const PipTextField(
                          label: 'Email Address',
                          hint: 'maya@school.edu',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: 'Send Reset Link',
                          icon: Icons.send,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Reset link sent! (mock)')));
                            context.pop();
                          },
                        ),
                        const SizedBox(height: 10),
                        PipGhostButton(
                            label: 'Back to Log In',
                            onPressed: () => context.pop()),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
