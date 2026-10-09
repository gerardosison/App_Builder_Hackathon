import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_mascot.dart';

/// Branded splash — navy gradient, Pip, tagline. Routes to Login after a beat.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryContainer, AppColors.navyDeep],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border:
                        Border.all(color: AppColors.secondaryFixed, width: 4),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(142, 201, 245, 0.35),
                          blurRadius: 36,
                          spreadRadius: 4)
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(PipAsset.happy.path,
                        fit: BoxFit.cover,
                        semanticLabel: PipAsset.happy.semanticLabel),
                  ),
                ),
                const SizedBox(height: 24),
                Text('PipSpeak',
                    style: text.displayLarge
                        ?.copyWith(color: Colors.white, fontSize: 40)),
                const SizedBox(height: 8),
                Text('Your friendly speech coach',
                    style: text.bodyLarge
                        ?.copyWith(color: AppColors.secondaryFixed)),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: AppColors.secondaryFixed),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
