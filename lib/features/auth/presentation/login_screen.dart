import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../onboarding/presentation/welcome_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final username = _usernameController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WelcomeScreen(nickname: username.isNotEmpty ? username : 'Speaker'),
      ),
    );
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: AppColors.blue),
            SizedBox(width: 10),
            Text('Reset Password', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your username or email address and we will send you instructions to recover your account.',
              style: TextStyle(fontSize: 14, color: AppColors.navySoft),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
                hintText: 'e.g. speaker@voicemate.app',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password recovery instructions sent to your email.',
                  ),
                  backgroundColor: AppColors.navy,
                ),
              );
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportHeight = constraints.maxHeight;
            // Top 1/3 of the screen for landing area
            final topHeight = viewportHeight * (1.0 / 3.0);
            // Bottom 2/3 of the screen for form area
            final bottomHeight = viewportHeight * (2.0 / 3.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewportHeight),
                child: SizedBox(
                  height: viewportHeight,
                  child: Column(
                    children: [
                      // --- LANDING AREA (TOP 1/3 OF THE SCREEN) ---
                      SizedBox(
                        height: topHeight,
                        width: double.infinity,
                        child: const Center(
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              child: _LandingHero(),
                            ),
                          ),
                        ),
                      ),

                      // --- FORM AREA (OCCUPIES BOTTOM 2/3 OF THE SCREEN) ---
                      SizedBox(
                        height: bottomHeight,
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            border: const Border(
                              top: BorderSide(color: AppColors.line),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0C14213D),
                                blurRadius: 16,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Spacer anchors the form content to the bottom before the Login button
                              const Spacer(),

                              // Form Header
                              Text(
                                'Welcome back',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),

                              // Form Subtitle
                              const Text(
                                'Enter your credentials to continue your practice.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navySoft,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Username input field
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'Enter username',
                                  prefixIcon: Icon(Icons.person_outline_rounded),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Password input field (with visibility icon)
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter password',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
                                    onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                              ),

                              // Forgot password UI
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _showForgotPasswordDialog,
                                  child: const Text('Forgot password?'),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Login button
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _onLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.navy,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Register button
                              SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: _onRegister,
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Landing area hero: Blank rounded square logo, placeholder text & slogan
class _LandingHero extends StatelessWidget {
  const _LandingHero();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Blank rounded square logo
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.sky, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1414213D),
                  offset: Offset(3, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.line),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'VOICE MATE',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 2),
          const Text(
            '[ Logo Placeholder ]',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.8,
              color: AppColors.navySoft,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your companion app towards better public speaking and confidence.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.navySoft,
              height: 1.3,
            ),
          ),
        ],
      );
}
