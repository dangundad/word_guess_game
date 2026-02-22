// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:word_guess_game/hive_registrar.g.dart';

import 'package:word_guess_game/app/data/models/game_state_model.dart';
import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/utils/app_constants.dart';

class HiveService extends GetxService {
  static HiveService get to => Get.find();

  // Box 이름 상수
  static const String SETTINGS_BOX = 'settings';
  static const String APP_DATA_BOX = 'app_data';
  static const String GAME_STATES_BOX = 'game_states';
  static const String STATS_BOX = 'stats_box';

  // Box Getters
  Box get settingsBox => Hive.box(SETTINGS_BOX);
  Box get appDataBox => Hive.box(APP_DATA_BOX);
  Box<GameStateModel> get gameStatesBox =>
      Hive.box<GameStateModel>(GAME_STATES_BOX);
  Box<StatsModel> get statsBox => Hive.box<StatsModel>(STATS_BOX);

  /// Hive 초기화 (main.dart에서 await 호출)
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    await Future.wait([
      Hive.openBox(SETTINGS_BOX),
      Hive.openBox(APP_DATA_BOX),
      Hive.openBox<GameStateModel>(GAME_STATES_BOX),
      Hive.openBox<StatsModel>(STATS_BOX),
    ]);

    Get.log('Hive 초기화 완료');
  }

  // ============================================
  // 설정 관리
  // ============================================

  T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  // ============================================
  // 게임 상태 관리 (일일 모드 저장)
  // ============================================

  GameStateModel? getDailyGameState(String dateKey, String category) {
    final key = '${HiveKeys.DAILY_GAME_PREFIX}${dateKey}_$category';
    return gameStatesBox.get(key);
  }

  Future<void> saveDailyGameState(GameStateModel state) async {
    final key =
        '${HiveKeys.DAILY_GAME_PREFIX}${state.dateKey}_${state.category}';
    await gameStatesBox.put(key, state);
  }

  Future<void> clearOldGameStates() async {
    // Keep only last 7 days of saves
    final now = DateTime.now();
    final keysToDelete = <dynamic>[];
    for (final key in gameStatesBox.keys) {
      final model = gameStatesBox.get(key);
      if (model != null) {
        final daysDiff = now.difference(model.createdAt).inDays;
        if (daysDiff > 7) keysToDelete.add(key);
      }
    }
    await gameStatesBox.deleteAll(keysToDelete);
  }

  // ============================================
  // 통계 관리
  // ============================================

  StatsModel? getStats() {
    return statsBox.get(HiveKeys.STATS);
  }

  Future<void> saveStats(StatsModel stats) async {
    await statsBox.put(HiveKeys.STATS, stats);
  }

  // ============================================
  // 데이터 관리
  // ============================================

  T? getAppData<T>(String key, {T? defaultValue}) {
    return appDataBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setAppData(String key, dynamic value) async {
    await appDataBox.put(key, value);
  }

  Future<void> clearAllData() async {
    await Future.wait([
      settingsBox.clear(),
      appDataBox.clear(),
      gameStatesBox.clear(),
      statsBox.clear(),
    ]);
    Get.log('모든 데이터 삭제 완료');
  }
}
