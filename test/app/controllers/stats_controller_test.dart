import 'package:flutter_test/flutter_test.dart';

import 'package:word_guess_game/app/controllers/stats_controller.dart';
import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/services/hive_service.dart';

void main() {
  test('refresh derives summary metrics from stored stats', () async {
    final controller = StatsController(
      hiveService: _FakeHiveService(
        stats: StatsModel(
          totalGames: 8,
          totalWins: 6,
          currentStreak: 3,
          maxStreak: 5,
          guessDist: const [1, 2, 2, 1, 0, 0],
        ),
      ),
    );

    await controller.refresh();

    expect(controller.hasGames.value, isTrue);
    expect(controller.totalGames.value, 8);
    expect(controller.totalWins.value, 6);
    expect(controller.totalLosses.value, 2);
    expect(controller.winRate.value, 75);
    expect(controller.currentStreak.value, 3);
    expect(controller.maxStreak.value, 5);
    expect(controller.guessDistribution, const [1, 2, 2, 1, 0, 0]);
    expect(controller.averageWinningGuess.value, closeTo(2.5, 0.001));
    expect(controller.mostCommonGuess.value, 2);
  });

  test('refresh keeps empty state when there is no saved stats model', () async {
    final controller = StatsController(
      hiveService: _FakeHiveService(stats: null),
    );

    await controller.refresh();

    expect(controller.hasGames.value, isFalse);
    expect(controller.totalGames.value, 0);
    expect(controller.totalWins.value, 0);
    expect(controller.totalLosses.value, 0);
    expect(controller.winRate.value, 0);
    expect(controller.guessDistribution, const [0, 0, 0, 0, 0, 0]);
    expect(controller.averageWinningGuess.value, 0);
    expect(controller.mostCommonGuess.value, 0);
    expect(controller.chartMaxY, 1);
    expect(controller.chartInterval, 1);
  });

  test('refresh clamps invalid wins and normalizes guess distribution', () async {
    final controller = StatsController(
      hiveService: _FakeHiveService(
        stats: StatsModel(
          totalGames: 3,
          totalWins: 7,
          guessDist: const [-1, 2, 4],
        ),
      ),
    );

    await controller.refresh();

    expect(controller.totalGames.value, 3);
    expect(controller.totalWins.value, 3);
    expect(controller.totalLosses.value, 0);
    expect(controller.guessDistribution, const [0, 2, 4, 0, 0, 0]);
    expect(controller.averageWinningGuess.value, closeTo(8 / 3, 0.001));
    expect(controller.mostCommonGuess.value, 3);
  });
}

class _FakeHiveService extends HiveService {
  _FakeHiveService({required this.stats});

  final StatsModel? stats;

  @override
  StatsModel? getStats() => stats;
}
