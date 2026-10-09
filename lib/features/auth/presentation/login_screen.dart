import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_fields.dart';
import 'widgets/auth_shell.dart';

/// Login screen — the "Log In" half of the Stitch `login_register`
/// design (the switcher navigates to /register).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _busy = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final user = await ref
        .read(authServiceProvider)
        .login(_email.text, _password.text);
    if (!mounted) return;
    ref.read(currentUserProvider.notifier).state = user;
    setState(() => _busy = false);
    context.go(AppRoutes.tour);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AuthShell(
      isLogin: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PipTextField(
            label: 'Username or Email',
            hint: 'e.g. orator_maya@pipspeak.org',
            icon: Icons.mail_outline,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          PipTextField(
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            controller: _password,
            isPassword: true,
            trailingLabel: 'Forgot password?',
            onTrailingLabelTap: () =>
                context.push(AppRoutes.forgotPassword),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryFixed.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondaryFixed),
            ),
            child: Row(children: [
              const Icon(Icons.celebration,
                  color: AppColors.secondary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ready to beat stage fright? 3 minutes of warm-ups awaits inside!',
                  style: text.bodySmall?.copyWith(
                      color: AppColors.onSecondaryFixedVariant),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: _busy ? 'Logging in…' : 'Log In',
            icon: _busy ? null : Icons.arrow_forward,
            onPressed: _busy ? null : _submit,
          ),
          const SizedBox(height: 16),
          SocialAuthRow(onPressed: _submit),
        ],
      ),
    );
  }
}
