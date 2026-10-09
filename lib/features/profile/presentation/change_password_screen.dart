import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_fields.dart';
import '../../../core/widgets/pip_misc.dart';

/// Change Password — no Stitch design; matching PipSpeak style.
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pipAppBar(context, title: 'Change Password'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                PipCard(
                  child: Column(children: [
                    const PipTextField(
                        label: 'Current Password',
                        hint: 'Enter current password',
                        icon: Icons.lock_outline,
                        isPassword: true),
                    const SizedBox(height: 14),
                    const PipTextField(
                        label: 'New Password',
                        hint: 'At least 8 characters',
                        icon: Icons.key,
                        isPassword: true),
                    const SizedBox(height: 14),
                    const PipTextField(
                        label: 'Confirm New Password',
                        hint: 'Re-enter new password',
                        icon: Icons.verified_user_outlined,
                        isPassword: true),
                  ]),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Update Password',
                  icon: Icons.check,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password updated (mock)')));
                    context.pop();
                  },
                ),
                const SizedBox(height: 8),
                PipGhostButton(
                    label: 'Cancel', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
