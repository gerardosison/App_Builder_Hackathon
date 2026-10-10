/// Level rule: at level n you need 10 * n more stars to reach level n + 1.
/// Thresholds are cumulative: Level 2 at 10 stars, Level 3 at 30, Level 4
/// at 60 (total = 5 * n * (n - 1) for level n).
class LevelStatus {
  const LevelStatus({
    required this.level,
    required this.starsIntoLevel,
    required this.starsNeeded,
    required this.totalStars,
  });

  final int level;
  final int starsIntoLevel;
  final int starsNeeded;
  final int totalStars;

  int get starsRemaining => starsNeeded - starsIntoLevel;
  double get progress => (starsIntoLevel / starsNeeded).clamp(0.0, 1.0);
}

class LevelService {
  const LevelService();

  /// Stars needed to reach the next level from [level].
  static int starsNeeded(int level) => 10 * level;

  /// Total stars required to reach [level] from Level 1.
  static int totalStarsForLevel(int level) => 5 * level * (level - 1);

  static LevelStatus fromTotalStars(int totalStars) {
    final total = totalStars < 0 ? 0 : totalStars;
    var level = 1;
    while (total >= totalStarsForLevel(level + 1)) {
      level++;
    }
    return LevelStatus(
      level: level,
      starsIntoLevel: total - totalStarsForLevel(level),
      starsNeeded: starsNeeded(level),
      totalStars: total,
    );
  }

  /// Progress within the current level (0.0–1.0).
  static double progress(int level, int stars) =>
      (stars / starsNeeded(level)).clamp(0.0, 1.0);
}
