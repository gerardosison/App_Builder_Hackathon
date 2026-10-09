import 'package:flutter/material.dart';

/// App-wide constants and option lists used by the frontend.

class LanguageOption {
  const LanguageOption(this.code, this.label, this.flag);
  final String code;
  final String label;
  final String flag;
}

class PracticeGoal {
  const PracticeGoal(this.id, this.label, this.description, this.icon);
  final String id;
  final String label;
  final String description;
  final IconData icon;
}

/// Warm-up drill card shown on the home screen.
class WarmupDrill {
  const WarmupDrill({
    required this.name,
    required this.minutes,
    required this.icon,
    required this.tint,
  });

  final String name;
  final int minutes;
  final IconData icon;
  final Color tint;
}

const kLanguages = [
  LanguageOption('en-US', 'English (US)', '🇺🇸'),
  LanguageOption('en-GB', 'English (UK)', '🇬🇧'),
  LanguageOption('es', 'Español', '🇪🇸'),
  LanguageOption('fr', 'Français', '🇫🇷'),
  LanguageOption('de', 'Deutsch', '🇩🇪'),
  LanguageOption('tl', 'Filipino', '🇵🇭'),
  LanguageOption('hi', 'हिन्दी', '🇮🇳'),
  LanguageOption('zh', '中文', '🇨🇳'),
];

const kGoals = [
  PracticeGoal('presentation', 'Class Presentation',
      'Nail your next in-class talk', Icons.school_rounded),
  PracticeGoal('debate', 'Debate & Argumentation',
      'Sharpen rebuttals and delivery', Icons.gavel_rounded),
  PracticeGoal('interview', 'Interview Prep',
      'Answer with calm confidence', Icons.work_rounded),
  PracticeGoal('competition', 'Speech Competition',
      'Win over judges and crowds', Icons.emoji_events_rounded),
  PracticeGoal('ceremony', 'Ceremony & Events',
      'Toasts, intros and emceeing', Icons.celebration_rounded),
  PracticeGoal('confidence', 'Everyday Confidence',
      'Speak up without the jitters', Icons.favorite_rounded),
];
