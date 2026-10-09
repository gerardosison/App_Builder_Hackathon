import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_misc.dart';
import '../../settings/presentation/settings_screen.dart';

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
        body: child ?? const HomeLandingScreen(),
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay here'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
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
                title: '7',
                label: 'Day streak',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.sky,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatCard(
                title: '12',
                label: 'Sessions completed',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.mint,
              ),
            ),
          ],
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

// -----------------------------------------------------------------------------
// TAB 1: PROGRESS
// -----------------------------------------------------------------------------
class _ProgressTabView extends StatelessWidget {
  const _ProgressTabView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Progress', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        const Text(
          'Track your speech metrics, pacing trends, and consistency.',
          style: TextStyle(color: AppColors.navySoft),
        ),
        const SizedBox(height: 24),

        // Fluency score card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '88%',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: AppColors.navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Fluency Score',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+5% improvement since last week. Excellent pacing consistency.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.navySoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Metrics breakdown
        const _MetricRow(label: 'Clarity & Articulation', score: '91%'),
        const SizedBox(height: 10),
        const _MetricRow(label: 'Pacing (135 words/min)', score: '88%'),
        const SizedBox(height: 10),
        const _MetricRow(label: 'Minimal Filler Words', score: '85%'),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.score});

  final String label;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            score,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: PRACTICE (EMPHASIZED MIDDLE ITEM)
// -----------------------------------------------------------------------------
class _PracticeTabView extends StatelessWidget {
  const _PracticeTabView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: (MediaQuery.sizeOf(context).height - 180).clamp(
      320.0,
      double.infinity,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Practice', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        const Text(
          'Build your speaking skills with AI-powered coaching and feedback.',
          style: TextStyle(color: AppColors.navySoft),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onStart,
            child: const Text('Start Live Practice'),
          ),
        ),
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// TAB 3: PROFILE
// -----------------------------------------------------------------------------
class _ProfileTabView extends StatelessWidget {
  const _ProfileTabView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Profile', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        const Text('Your speaker stats, rank, and achievements.'),
        const SizedBox(height: 24),

        // User badge card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.sky,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.navy, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speaker Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Level 4: Eloquent Speaker',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navySoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Badges container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.line),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BADGES & MILESTONES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Badge(icon: '🏅', name: '7-Day Streak'),
                  _Badge(icon: '🎙️', name: '10+ Speeches'),
                  _Badge(icon: '⭐', name: '90% Clarity'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.name});
  final String icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 26)),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: SETTINGS (WITH ABOUT SECTION)
// -----------------------------------------------------------------------------
class _SettingsTabView extends StatelessWidget {
  const _SettingsTabView();

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}
