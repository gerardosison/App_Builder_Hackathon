import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';

/// Bottom-navigation shell hosting the Practice / Progress / Profile tabs.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(27, 42, 107, 0.08),
                blurRadius: 20,
                offset: Offset(0, -4))
          ],
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.cardRadius)),
        ),
        child: SafeArea(
          child: NavigationBar(
            height: 72,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (i) => shell.goBranch(
              i,
              initialLocation: i == shell.currentIndex,
            ),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.mic_none_rounded),
                  selectedIcon: Icon(Icons.mic_rounded),
                  label: 'Practice'),
              NavigationDestination(
                  icon: Icon(Icons.trending_up_rounded),
                  selectedIcon: Icon(Icons.trending_up_rounded),
                  label: 'Progress'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
