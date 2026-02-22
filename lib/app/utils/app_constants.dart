// ignore_for_file: constant_identifier_names

/// Hive 키 상수
abstract class HiveKeys {
  static const String IS_FIRST_LAUNCH = 'is_first_launch';
  static const String STATS = 'stats';
  static const String DAILY_GAME_PREFIX = 'daily_game_';
}

/// 앱 관련 URL
abstract class AppUrls {
  static const String GOOGLE_PLAY_MOREAPPS =
      'https://play.google.com/store/apps/developer?id=DangunDad';
  static const String PACKAGE_NAME = 'com.dangundad.wordguessgame';
}

/// 개발자 정보
abstract class DeveloperInfo {
  static const String DEVELOPER_EMAIL = 'dangundad@gmail.com';
}

/// Hive Box 이름 (HiveService와 동기화)
abstract class HiveBoxNames {
  static const String SETTINGS = 'settings';
  static const String APP_DATA = 'app_data';
  static const String GAME_STATES = 'game_states';
  static const String STATS = 'stats_box';
}

/// 게임 상수
abstract class GameConstants {
  static const int MAX_GUESSES = 6;
  static const int WORD_LENGTH = 5;
  static const int MAX_HINTS = 3;
}

/// 애니메이션 지속 시간
abstract class AnimationDurations {
  static const Duration FADE_IN = Duration(milliseconds: 300);
  static const Duration PAGE_TRANSITION = Duration(milliseconds: 500);
  static const Duration TILE_FLIP = Duration(milliseconds: 500);
  static const Duration TILE_FLIP_STAGGER = Duration(milliseconds: 150);
  static const Duration ROW_SHAKE = Duration(milliseconds: 500);
}
