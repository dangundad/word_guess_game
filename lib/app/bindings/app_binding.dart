import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/controllers/home_controller.dart';
import 'package:word_guess_game/app/controllers/setting_controller.dart';
import 'package:word_guess_game/app/services/hive_service.dart';
import 'package:word_guess_game/app/services/word_service.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    // HiveService (main.dart에서 이미 등록됨, 체크만 수행)
    if (!Get.isRegistered<HiveService>()) {
      Get.put(HiveService(), permanent: true);
    }

    // WordService (앱 전역 영구 서비스)
    if (!Get.isRegistered<WordService>()) {
      Get.put(WordService(), permanent: true);
    }

    // 영구 컨트롤러
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }

    // 지연 초기화 컨트롤러
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => GameController(), fenix: true);
  }
}
