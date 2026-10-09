import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../features/auth/services/local_auth_service.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_cards.dart';
import '../../../core/widgets/pip_fields.dart';
import '../../../core/widgets/pip_misc.dart';

/// Edit Profile — avatar, name/nickname/email fields, streak & sync
/// cards, save/cancel (Stitch `edit_profile`).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _nickname;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final u = ref.read(currentUserProvider) ?? LocalAuthService.mockUser;
    _name = TextEditingController(text: u.name);
    _nickname = TextEditingController(text: u.nickname);
    _email = TextEditingController(text: u.email);
  }

  @override
  void dispose() {
    for (final c in [_name, _nickname, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final user =
        ref.watch(currentUserProvider) ?? LocalAuthService.mockUser;

    return Scaffold(
      appBar: pipAppBar(context, title: 'Edit Profile'),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Avatar
                Center(
                  child: Stack(children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryFixed
                            .withValues(alpha: 0.5),
                        border: Border.all(
                            color: scheme.secondaryContainer, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          _name.text.isEmpty
                              ? '?'
                              : _name.text[0].toUpperCase(),
                          style: text.displayLarge?.copyWith(
                              fontSize: 40, color: scheme.primary),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: scheme.primary,
                          border: Border.all(
                              color: scheme.surfaceContainerLowest,
                              width: 2),
                        ),
                        child: const Icon(Icons.photo_camera,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text('Tap to change avatar',
                      style: text.labelSmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ),
                const SizedBox(height: 20),

                PipCard(
                  child: Column(children: [
                    PipTextField(
                        label: 'Full Name',
                        hint: 'Maya Chen',
                        icon: Icons.badge_outlined,
                        controller: _name),
                    const SizedBox(height: 14),
                    PipTextField(
                        label: 'Nickname',
                        hint: 'OratorMaya',
                        icon: Icons.alternate_email,
                        controller: _nickname),
                    const SizedBox(height: 14),
                    PipTextField(
                        label: 'Email',
                        hint: 'maya@school.edu',
                        icon: Icons.mail_outline,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress),
                  ]),
                ),
                const SizedBox(height: 16),

                PrimaryButton(
                  label: 'Save Changes',
                  icon: Icons.check,
                  onPressed: () {
                    ref.read(currentUserProvider.notifier).state =
                        user.copyWith(
                            name: _name.text.trim(),
                            nickname: _nickname.text.trim(),
                            email: _email.text.trim());
                    context.pop();
                  },
                ),
                const SizedBox(height: 8),
                PipGhostButton(
                    label: 'Cancel',
                    onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
