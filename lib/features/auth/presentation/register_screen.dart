import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_fields.dart';
import 'widgets/auth_shell.dart';

/// Register screen — the "Register" half of the Stitch
/// `login_register` design (the switcher navigates to /login).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _busy = false;
  final _name = TextEditingController();
  final _nickname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _nickname, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final user = await ref.read(authServiceProvider).register(
        _name.text, _nickname.text, _email.text, _password.text);
    if (!mounted) return;
    ref.read(currentUserProvider.notifier).state = user;
    setState(() => _busy = false);
    context.go(AppRoutes.tour);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return AuthShell(
      isLogin: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(children: [
              Stack(children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surfaceContainerLow,
                    border:
                        Border.all(color: AppColors.sky, width: 2),
                  ),
                  child: Icon(Icons.person,
                      size: 36, color: scheme.outlineVariant),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.tertiaryFixed,
                      border: Border.all(
                          color: scheme.surfaceContainerLowest,
                          width: 2),
                    ),
                    child: const Icon(Icons.photo_camera,
                        size: 16,
                        color: AppColors.onTertiaryFixed),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Text('Upload Speaker Avatar (Optional)',
                  style: text.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant)),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: PipTextField(
                  label: 'Full Name',
                  hint: 'Maya Lin',
                  controller: _name),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PipTextField(
                  label: 'Nickname',
                  hint: 'OratorMaya',
                  controller: _nickname),
            ),
          ]),
          const SizedBox(height: 16),
          PipTextField(
            label: 'Email or Student ID',
            hint: 'maya@school.edu',
            icon: Icons.mail_outline,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          PipTextField(
              label: 'Create Password',
              hint: 'At least 8 characters',
              icon: Icons.key,
              controller: _password,
              isPassword: true),
          const SizedBox(height: 16),
          const PipTextField(
              label: 'Confirm Password',
              hint: 'Re-enter password',
              icon: Icons.verified_user_outlined,
              isPassword: true),
          const SizedBox(height: 20),
          PrimaryButton(
            label: _busy ? 'Creating account…' : 'Create Account',
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
