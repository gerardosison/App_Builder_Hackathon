/// Business rule: level n requires 10*n stars to level up.
class LevelService {
  const LevelService();

  /// Stars needed to reach the next level from [level].
  static int starsNeeded(int level) => 10 * level;

  /// Progress within the current level (0.0–1.0).
  static double progress(int level, int stars) =>
      (stars / starsNeeded(level)).clamp(0.0, 1.0);
}
