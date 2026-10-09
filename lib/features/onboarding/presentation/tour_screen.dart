import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_misc.dart';
import 'personalization_screen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  int _page = 0;

  final List<_TourPageData> _pages = const [
    _TourPageData(
      title: 'Home',
      icon: Icons.home_rounded,
      tagline: 'Your daily speaking launchpad',
      function:
          'Start each day with quick warm-ups and track your ongoing practice streak.',
      features: [
        'Daily 60-second impromptu speech warm-ups',
        'Habit streak counter & weekly session totals',
        'Quick-start button to jump into live practice',
      ],
      previewType: _PreviewType.home,
    ),
    _TourPageData(
      title: 'Practice',
      icon: Icons.mic_rounded,
      tagline: 'Interactive speech training studio',
      function:
          'Record your talks, receive live coaching hints, and conquer stage fright.',
      features: [
        'Speech audio & video capture with live visualizer',
        'Instant detection of filler words and pacing errors',
        'Dynamic speaking prompts across multiple formats',
      ],
      previewType: _PreviewType.practice,
    ),
    _TourPageData(
      title: 'Progress',
      icon: Icons.insights_rounded,
      tagline: 'Analytics & growth insights',
      function:
          'Visualize your delivery metrics, confidence trends, and score history over time.',
      features: [
        'Fluency, clarity, and pacing performance scores',
        'Weekly practice frequency charts & consistency logs',
        'Detailed audio transcripts with actionable feedback',
      ],
      previewType: _PreviewType.progress,
    ),
    _TourPageData(
      title: 'Profile',
      icon: Icons.person_rounded,
      tagline: 'Your speaker identity & achievements',
      function:
          'Celebrate your growth, view unlocked speech badges, and manage your level.',
      features: [
        'Speaker level progression (Level 1 Novice to Level 5 Master)',
        'Milestone badges (e.g. 7-day Streak, Clarity Champion)',
        'Custom speaking goals and personalized preferences',
      ],
      previewType: _PreviewType.profile,
    ),
    _TourPageData(
      title: 'Settings',
      icon: Icons.tune_rounded,
      tagline: 'Customization, privacy & app information',
      function:
          'Fine-tune microphone inputs, toggle dark mode, and learn about the PipSpeak mission in the About Section.',
      features: [
        'Dark mode and visual appearance controls',
        'Microphone sensitivity calibration and privacy controls',
        'About Section detailing PipSpeak story, version & mission',
      ],
      previewType: _PreviewType.settings,
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      setState(() => _page++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PersonalizationScreen()),
      );
    }
  }

  void _previous() {
    if (_page > 0) {
      setState(() => _page--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[_page];

    return Scaffold(
      appBar: pipAppBar(
        context,
        title: 'Preview ${_page + 1} of ${_pages.length}',
        showBack: _page > 0,
        onBack: _previous,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PersonalizationScreen()),
            ),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              Row(
                children: List.generate(
                  _pages.length,
                  (index) => Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 5,
                      margin: EdgeInsets.only(
                        right: index == _pages.length - 1 ? 0 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _page
                            ? AppColors.blue
                            : AppColors.sky,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Page Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.sky,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line, width: 1.5),
                    ),
                    child: Icon(
                      currentPage.icon,
                      color: AppColors.navy,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPage.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          currentPage.tagline,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.navySoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Screen Preview + Tooltip Container
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Interactive Preview Mockup Card
                      _PagePreviewMockup(previewType: currentPage.previewType),
                      const SizedBox(height: 32),

                      // Tooltip Callout Box: Function & Features
                      _TooltipCallout(data: currentPage),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Bottom Navigation Button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _page == _pages.length - 1
                        ? 'Personalize my journey'
                        : 'Next: ${_pages[_page + 1].title}',
                    style: const TextStyle(
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
    );
  }
}

enum _PreviewType { home, practice, progress, profile, settings }

class _TourPageData {
  const _TourPageData({
    required this.title,
    required this.icon,
    required this.tagline,
    required this.function,
    required this.features,
    required this.previewType,
  });

  final String title;
  final IconData icon;
  final String tagline;
  final String function;
  final List<String> features;
  final _PreviewType previewType;
}

/// Info section highlighting the page function and features.
class _TooltipCallout extends StatelessWidget {
  const _TooltipCallout({required this.data});

  final _TourPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 24,
              color: AppColors.blue,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${data.title} function & features',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Function statement
        const Text(
          'FUNCTION:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data.function,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.4,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),

        // Features statement
        const Text(
          'KEY FEATURES:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.blue,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        ...data.features.map(
          (feat) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feat,
                    style: const TextStyle(fontSize: 13, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Visual UI preview card for each page
class _PagePreviewMockup extends StatelessWidget {
  const _PagePreviewMockup({required this.previewType});

  final _PreviewType previewType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1414213D),
            offset: Offset(4, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: switch (previewType) {
        _PreviewType.home => const _HomePreview(),
        _PreviewType.practice => const _PracticePreview(),
        _PreviewType.progress => const _ProgressPreview(),
        _PreviewType.profile => const _ProfilePreview(),
        _PreviewType.settings => const _SettingsPreview(),
      },
    );
  }
}

class _HomePreview extends StatelessWidget {
  const _HomePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // App top bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PipSpeak • Home',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            Tooltip(
              message: 'Quick streak count',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '🔥 7 Days',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Warm up card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TODAY'S WARM-UP",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tell a story in 60 seconds',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Quick exercise for a clearer, firmer vocal tone.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      '12',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text('Sessions', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      '88%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text('Fluency', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PracticePreview extends StatelessWidget {
  const _PracticePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Live Speech Training Studio',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: const Text(
            'Prompt: Explain your favorite hobby in 2 mins',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 14),
        // Mic circle
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: AppColors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x334F7CFF),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.graphic_eq_rounded, color: AppColors.coral, size: 20),
            SizedBox(width: 6),
            Text(
              'Real-time Pacing & Filler Word Detection',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.navySoft,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressPreview extends StatelessWidget {
  const _ProgressPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Speech Trends & Performance',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Confidence', style: TextStyle(fontSize: 10)),
                    Text(
                      '92/100',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Clarity', style: TextStyle(fontSize: 10)),
                    Text(
                      '89%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Mini graph bars
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar('Mon', 40),
                _bar('Tue', 65),
                _bar('Wed', 85),
                _bar('Thu', 70),
                _bar('Fri', 90),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bar(String day, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: height * 0.4,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 9)),
      ],
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.sky,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 28,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Speaker',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Level 4: Eloquent Speaker',
                  style: TextStyle(fontSize: 11, color: AppColors.blue),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BADGES & ACHIEVEMENTS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('🏅 7-Day Streak', style: TextStyle(fontSize: 11)),
                  Text('🎙️ 10+ Speeches', style: TextStyle(fontSize: 11)),
                  Text('⭐ 90% Clarity', style: TextStyle(fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsPreview extends StatelessWidget {
  const _SettingsPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Settings & Controls',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.line),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    size: 16,
                    color: AppColors.blue,
                  ),
                  SizedBox(width: 8),
                  Text('Dark mode', style: TextStyle(fontSize: 11)),
                ],
              ),
              Icon(Icons.toggle_on_rounded, color: AppColors.blue, size: 26),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // About Section Highlight
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.sky,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line, width: 1.2),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.navy,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'About PipSpeak Section',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Your companion app towards better public speaking and confidence.',
                  style: TextStyle(fontSize: 11, color: AppColors.navySoft),
                ),
                SizedBox(height: 2),
                Text(
                  'Version 1.0.0 • Hackathon Edition',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
