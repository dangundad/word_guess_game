// ignore_for_file: constant_identifier_names

/// Hive ???곸닔
abstract class HiveKeys {
  static const String IS_FIRST_LAUNCH = 'is_first_launch';
  static const String IS_PREMIUM = 'is_premium';
  static const String STATS = 'stats';
  static const String DAILY_GAME_PREFIX = 'daily_game_';
}

/// ??愿??URL
abstract class AppUrls {
  static const String GOOGLE_PLAY_MOREAPPS =
      'https://play.google.com/store/apps/developer?id=DangunDad';
  static const String PACKAGE_NAME = 'com.dangundad.wordguessgame';
}

/// 媛쒕컻???뺣낫
abstract class DeveloperInfo {
  static const String DEVELOPER_EMAIL = 'dangundad@gmail.com';
}

/// Hive Box ?대쫫 (HiveService? ?숆린??
abstract class HiveBoxNames {
  static const String SETTINGS = 'settings';
  static const String APP_DATA = 'app_data';
  static const String GAME_STATES = 'game_states';
  static const String STATS = 'stats_box';
}

/// 寃뚯엫 ?곸닔
abstract class GameConstants {
  static const int MAX_GUESSES = 6;
  static const int WORD_LENGTH = 5;
  static const int MAX_HINTS = 3;
}

/// ?좊땲硫붿씠??吏???쒓컙
abstract class AnimationDurations {
  static const Duration FADE_IN = Duration(milliseconds: 300);
  static const Duration PAGE_TRANSITION = Duration(milliseconds: 500);
  static const Duration TILE_FLIP = Duration(milliseconds: 500);
  static const Duration TILE_FLIP_STAGGER = Duration(milliseconds: 150);
  static const Duration ROW_SHAKE = Duration(milliseconds: 500);
}

/// IAP 상품 ID
abstract class PurchaseConstants {
  static const String PREMIUM_WEEKLY_ANDROID =
      '${AppUrls.PACKAGE_NAME}.premium_weekly';
  static const String PREMIUM_MONTHLY_ANDROID =
      '${AppUrls.PACKAGE_NAME}.premium_monthly';
  static const String PREMIUM_YEARLY_ANDROID =
      '${AppUrls.PACKAGE_NAME}.premium_yearly';

  static const List<String> ANDROID_PRODUCT_IDS = [
    PREMIUM_WEEKLY_ANDROID,
    PREMIUM_MONTHLY_ANDROID,
    PREMIUM_YEARLY_ANDROID,
  ];
}

/// 앱 평가 설정
abstract class RateMyAppConfig {
  static const String PREFIX = 'wordGuessGame_rateMyApp_';
  static const int MIN_DAYS = 3;
  static const int MIN_LAUNCHES = 5;
  static const int REMIND_DAYS = 7;
  static const int REMIND_LAUNCHES = 10;
  static const String APP_STORE_ID = '0000000000'; // TODO: App Store Connect ID
}
