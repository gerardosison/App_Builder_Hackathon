import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_misc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.location = AppRoutes.home,
    this.child,
  });

  final String location;
  final Widget? child;

  int get _selectedIndex {
    if (location.startsWith('/documents')) return 1;
    if (location.startsWith('/practice')) return 2;
    if (location == AppRoutes.progress ||
        location == AppRoutes.history ||
        location == AppRoutes.rehearsalAnalysis) {
      return 3;
    }
    if (location.startsWith('/profile') ||
        location.startsWith('/settings') ||
        location == AppRoutes.about) {
      return 4;
    }
    return 0;
  }

  static const _destinations = [
    AppRoutes.home,
    AppRoutes.documentUpload,
    AppRoutes.practice,
    AppRoutes.progress,
    AppRoutes.profile,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: KeyedSubtree(
            key: ValueKey(location),
            child: child ?? const HomeLandingScreen(),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
                const BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.55),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 70,
                child: Row(
                  children: [
                    _destination(context, 0, Icons.home_outlined, 'Home'),
                    _destination(
                        context, 1, Icons.description_outlined, 'Documents'),
                    _destination(context, 2, Icons.mic_rounded, 'Practice'),
                    _destination(context, 3, Icons.trending_up_rounded, 'Progress'),
                    _destination(context, 4, Icons.person_outline_rounded, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _destination(
      BuildContext context, int index, IconData icon, String label) {
    final selected = index == _selectedIndex;
    final colors = Theme.of(context).colorScheme;
    if (index == 2) {
      return Expanded(
        child: Transform.translate(
          offset: const Offset(0, -5),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go(_destinations[index]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: selected
                          ? [AppColors.sky, AppColors.secondary]
                          : [AppColors.primaryContainer, AppColors.navyDeep],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.85),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (selected ? AppColors.secondary : AppColors.navy)
                            .withValues(alpha: 0.24),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                Text(label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: selected
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        )),
              ],
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: InkWell(
        onTap: () => context.go(_destinations[index]),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 22,
                  color: selected ? colors.primary : colors.onSurfaceVariant),
              const SizedBox(height: 3),
              Text(label,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? colors.primary : colors.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeLandingScreen extends StatelessWidget {
  const HomeLandingScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You can come back anytime and continue your speaking journey.',
        ),
        actions: [
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Stay here', maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Log out', maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ]),
        ],
      ),
    );
    if (shouldLogout == true && context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: pipAppBar(
          context,
          title: 'PipSpeak',
          showBack: false,
          centerTitle: false,
          titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
          actions: [
            IconButton(
              tooltip: 'Log out',
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: const _HomeTabView(),
          ),
        ),
      );
}
// -----------------------------------------------------------------------------
// TAB 0: HOME
// -----------------------------------------------------------------------------
class _HomeTabView extends StatelessWidget {
  const _HomeTabView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Good morning, speaker!',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Ready for a small win today? Take on today’s speech exercise.',
          style: TextStyle(fontSize: 15, color: AppColors.navySoft),
        ),
        const SizedBox(height: 24),

        // Warm up card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1814213D),
                offset: Offset(4, 5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "TODAY'S WARM-UP",
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Tell a story in 60 seconds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Practice structuring a beginning, middle, and climax with natural pacing.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Stat cards
        const Row(
          children: [
            Expanded(
              child: _StatCard(
                title: '0',
                label: 'Day streak',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.sky,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '0',
                label: 'Sessions completed',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.mint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.offline_bolt_rounded),
            title: const Text('Ask your local AI coach'),
            subtitle: const Text('Chat with Qwen on this device, even offline.'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go(AppRoutes.aiCoach),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String title;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.navy, size: 24),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.navySoft),
          ),
        ],
      ),
    );
  }
}
