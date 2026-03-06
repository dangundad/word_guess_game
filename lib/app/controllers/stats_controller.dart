import 'dart:math' as math;

import 'package:get/get.dart';

import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/services/hive_service.dart';

class StatsController extends GetxController {
  StatsController({HiveService? hiveService})
    : _hiveService = hiveService ?? HiveService.to;

  static StatsController get to => Get.find();

  final HiveService _hiveService;

  final RxBool hasGames = false.obs;
  final RxInt totalGames = 0.obs;
  final RxInt totalWins = 0.obs;
  final RxInt totalLosses = 0.obs;
  final RxInt winRate = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt maxStreak = 0.obs;
  final RxDouble averageWinningGuess = 0.0.obs;
  final RxInt mostCommonGuess = 0.obs;
  final RxList<int> guessDistribution = List<int>.filled(6, 0).obs;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  @override
  Future<void> refresh() async {
    final stats = _hiveService.getStats() ?? StatsModel();
    _applyStats(stats);
  }

  double get chartMaxY {
    final maxCount = guessDistribution.fold<int>(0, math.max);
    return maxCount <= 0 ? 1 : (maxCount + 1).toDouble();
  }

  double get chartInterval {
    final maxY = chartMaxY;
    return maxY <= 4 ? 1 : (maxY / 4).ceilToDouble();
  }

  void _applyStats(StatsModel stats) {
    final normalizedDistribution = _normalizeGuessDistribution(stats.guessDist);
    final games = stats.totalGames;
    final wins = stats.totalWins.clamp(0, games);
    final losses = math.max(0, games - wins);

    totalGames.value = games;
    totalWins.value = wins;
    totalLosses.value = losses;
    winRate.value = games > 0 ? ((wins / games) * 100).round() : 0;
    currentStreak.value = stats.currentStreak;
    maxStreak.value = stats.maxStreak;
    guessDistribution.assignAll(normalizedDistribution);
    averageWinningGuess.value = _calculateAverageWinningGuess(
      distribution: normalizedDistribution,
    );
    mostCommonGuess.value = _resolveMostCommonGuess(normalizedDistribution);
    hasGames.value = games > 0;
  }

  List<int> _normalizeGuessDistribution(List<int> raw) {
    final normalized = List<int>.filled(6, 0);
    for (int index = 0; index < raw.length && index < normalized.length; index++) {
      normalized[index] = math.max(0, raw[index]);
    }
    return normalized;
  }

  double _calculateAverageWinningGuess({
    required List<int> distribution,
  }) {
    final solvedGames = distribution.fold<int>(0, (sum, value) => sum + value);
    if (solvedGames <= 0) {
      return 0;
    }

    int weightedTotal = 0;
    for (int index = 0; index < distribution.length; index++) {
      weightedTotal += (index + 1) * distribution[index];
    }

    return weightedTotal / solvedGames;
  }

  int _resolveMostCommonGuess(List<int> distribution) {
    int maxCount = 0;
    int guessIndex = 0;

    for (int index = 0; index < distribution.length; index++) {
      if (distribution[index] > maxCount) {
        maxCount = distribution[index];
        guessIndex = index + 1;
      }
    }

    return guessIndex;
  }
}
