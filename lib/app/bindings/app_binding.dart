import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/controllers/home_controller.dart';
import 'package:word_guess_game/app/controllers/setting_controller.dart';
import 'package:word_guess_game/app/services/hive_service.dart';
import 'package:word_guess_game/app/services/word_service.dart';
import 'package:word_guess_game/app/services/activity_log_service.dart';
import 'package:word_guess_game/app/controllers/history_controller.dart';
import 'package:word_guess_game/app/controllers/stats_controller.dart';

import 'package:word_guess_game/app/services/purchase_service.dart';
import 'package:word_guess_game/app/controllers/premium_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PurchaseService>()) {
      Get.put(PurchaseService(), permanent: true);
    }

    if (!Get.isRegistered<PremiumController>()) {
      Get.lazyPut(() => PremiumController());
    }

    // HiveService (main.dart에서 init 요청)
    if (!Get.isRegistered<HiveService>()) {
      Get.put(HiveService(), permanent: true);
    }

    // WordService
    if (!Get.isRegistered<WordService>()) {
      Get.put(WordService(), permanent: true);
    }

    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }

    // Home/Game
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut(() => HomeController(), fenix: true);
    }

    if (!Get.isRegistered<GameController>()) {
      Get.lazyPut(() => GameController(), fenix: true);
    }

    if (!Get.isRegistered<ActivityLogService>()) {
      Get.put(ActivityLogService(), permanent: true);
    }

    if (!Get.isRegistered<HistoryController>()) {
      Get.lazyPut(() => HistoryController());
    }

    if (!Get.isRegistered<StatsController>()) {
      Get.lazyPut(() => StatsController());
    }
  }
}
