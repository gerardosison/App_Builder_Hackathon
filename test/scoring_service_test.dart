import 'package:app_builder_hackathon/features/progress/services/level_service.dart';
import 'package:app_builder_hackathon/features/progress/services/scoring_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const scoring = ScoringService();

  test('first compatible session is a baseline with no stars', () {
    final award = scoring.award(score: 90, previousCompatible: const []);
    expect(award.stars, 0);
    expect(award.isBaseline, isTrue);
  });

  test('stars follow improvement over recent compatible mean', () {
    const previous = [
      ScoredSession(id: 'c', score: 60),
      ScoredSession(id: 'b', score: 70),
      ScoredSession(id: 'a', score: 80),
      ScoredSession(id: 'base', score: 10),
    ];
    // Mean of the 3 most recent = 70.
    expect(scoring.award(score: 71, previousCompatible: previous).stars, 0);
    expect(scoring.award(score: 72, previousCompatible: previous).stars, 1);
    expect(scoring.award(score: 75, previousCompatible: previous).stars, 2);
    final best = scoring.award(score: 80, previousCompatible: previous);
    expect(best.stars, 3);
    expect(best.baselineSessionId, 'base');
  });

  test('cumulative level thresholds use 10 * n', () {
    expect(LevelService.fromTotalStars(0).level, 1);
    expect(LevelService.fromTotalStars(9).level, 1);
    expect(LevelService.fromTotalStars(10).level, 2);
    expect(LevelService.fromTotalStars(29).level, 2);
    final l3 = LevelService.fromTotalStars(30);
    expect(l3.level, 3);
    expect(l3.starsIntoLevel, 0);
    expect(l3.starsNeeded, 30);
    expect(LevelService.fromTotalStars(60).level, 4);
  });
}
