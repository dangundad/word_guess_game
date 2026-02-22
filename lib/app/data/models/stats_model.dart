import 'package:hive_ce/hive_ce.dart';

part 'stats_model.g.dart';

@HiveType(typeId: 1)
class StatsModel extends HiveObject {
  @HiveField(0)
  int totalGames;

  @HiveField(1)
  int totalWins;

  @HiveField(2)
  int currentStreak;

  @HiveField(3)
  int maxStreak;

  /// index 0-5 corresponds to winning on guess 1-6
  @HiveField(4)
  List<int> guessDist;

  @HiveField(5)
  String lastPlayedDate;

  StatsModel({
    this.totalGames = 0,
    this.totalWins = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    List<int>? guessDist,
    this.lastPlayedDate = '',
  }) : guessDist = guessDist ?? List.filled(6, 0);
}
