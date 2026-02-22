import 'package:hive_ce/hive_ce.dart';

part 'game_state_model.g.dart';

@HiveType(typeId: 0)
class GameStateModel extends HiveObject {
  @HiveField(0)
  late String dateKey;

  @HiveField(1)
  late String targetWord;

  @HiveField(2)
  late String gameMode;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late List<String> guesses;

  @HiveField(5)
  late bool isCompleted;

  @HiveField(6)
  late bool isWon;

  @HiveField(7)
  late DateTime createdAt;

  GameStateModel({
    required this.dateKey,
    required this.targetWord,
    required this.gameMode,
    required this.category,
    required this.guesses,
    required this.isCompleted,
    required this.isWon,
    required this.createdAt,
  });
}
