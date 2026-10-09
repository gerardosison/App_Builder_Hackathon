import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'live_account_tabs.dart';
import '../../practice/presentation/setup_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected = 0;

  final _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.insights_rounded, label: 'Progress'),
    _NavItem(icon: Icons.mic_rounded, label: 'Practice'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    _NavItem(icon: Icons.tune_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Content area with bottom padding so floating nav bar does not overlap
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                child: _buildCurrentTab(context),
              ),
            ),

            // Bottom-anchored floating rounded navigation bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _FloatingNavBar(
                items: _navItems,
                selectedIndex: _selected,
                onSelected: (index) => setState(() => _selected = index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTab(BuildContext context) {
    late final Widget content;
    switch (_selected) {
      case 0:
        content = const LiveHomeTab();
        break;
      case 1:
        content = const LiveProgressTab();
        break;
      case 2:
        content = _PracticeTabView(
          onStart: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SetupScreen()),
            );
          },
        );
        break;
      case 3:
        content = const LiveProfileTab();
        break;
      case 4:
        content = const _SettingsTabView();
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HomeHeaderOnly(onLogout: _showLogoutPrompt),
        if (_selected != 0) const SizedBox(height: 28),
        content,
      ],
    );
  }

  Future<void> _showLogoutPrompt() async {
    final shouldLogout = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close logout confirmation',
      barrierColor: AppColors.navy.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Signing in again requires internet. Unsynced progress remains on this device for this account.',
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
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await FirebaseAuth.instance.signOut();
    }
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _HomeHeaderOnly extends StatelessWidget {
  const _HomeHeaderOnly({required this.onLogout});
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'VOICE MATE',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          letterSpacing: 1.8,
          fontWeight: FontWeight.w900,
        ),
      ),
      IconButton(
        onPressed: onLogout,
        tooltip: 'Log out',
        style: IconButton.styleFrom(
          foregroundColor: AppColors.navy,
          backgroundColor: AppColors.sky,
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
      ),
    ],
  );
}

/// Bottom-anchored floating rounded navigation bar
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.line, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2214213D),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedIndex == index;
          final isPractice = index == 2; // Middle item: Practice

          if (isPractice) {
            // Reserve the same horizontal slot as the other items, then lift
            // the large control above the bar without changing its layout.
            return Expanded(
              child: Transform.translate(
                offset: const Offset(0, 0),
                child: GestureDetector(
                  onTap: () => onSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blue : AppColors.navy,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isSelected ? AppColors.blue : AppColors.navy)
                                      .withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 34),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Other 4 navigation items: Home, Progress, Profile, Settings
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.sky : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      size: 22,
                      color: isSelected ? AppColors.navy : AppColors.navySoft,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: isSelected ? AppColors.navy : AppColors.navySoft,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 0: HOME
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// TAB 1: PROGRESS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// TAB 2: PRACTICE (EMPHASIZED MIDDLE ITEM)
// -----------------------------------------------------------------------------
class _PracticeTabView extends StatelessWidget {
  const _PracticeTabView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Practice Studio',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Select a format and start recording your speech session.',
          style: TextStyle(color: AppColors.navySoft),
        ),
        const SizedBox(height: 28),

        // Mic recording centerpiece
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x404F7CFF),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ready to Record',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'AI real-time coaching will analyze your tempo & clarity.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.navySoft),
              ),
              const SizedBox(height: 22),
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
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: PROFILE
// -----------------------------------------------------------------------------

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
