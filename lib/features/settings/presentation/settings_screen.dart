import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'VOICE MATE',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 38),
        Text('Settings', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 10),
        const Text('Shape your practice space.'),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.dark_mode_outlined, color: AppColors.blue),
              const SizedBox(width: 14),
              const Expanded(child: Text('Dark mode')),
              Switch(
                value: isDark,
                onChanged: (value) => appThemeMode.value = value
                    ? ThemeMode.dark
                    : ThemeMode.light,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.sky,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.navy),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Voice Mate',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'A friendly practice companion for clearer, more confident speaking.',
                      style: TextStyle(color: AppColors.navySoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
