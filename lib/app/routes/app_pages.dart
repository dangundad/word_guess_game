// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:word_guess_game/app/bindings/app_binding.dart';
import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/pages/game/game_page.dart';
import 'package:word_guess_game/app/pages/history/history_page.dart';
import 'package:word_guess_game/app/pages/home/home_page.dart';
import 'package:word_guess_game/app/pages/settings/settings_page.dart';
import 'package:word_guess_game/app/pages/stats/stats_page.dart';
import 'package:word_guess_game/app/pages/premium/premium_page.dart';
import 'package:word_guess_game/app/pages/premium/premium_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => const GamePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GameController(), fenix: true);
      }),
    ),
    GetPage(name: _Paths.SETTINGS, page: () => const SettingsPage()),
    GetPage(name: _Paths.HISTORY, page: () => const HistoryPage()),
    GetPage(name: _Paths.STATS, page: () => const StatsPage()),
    GetPage(
      name: _Paths.PREMIUM,
      page: () => const PremiumPage(),
      binding: PremiumBinding(),
    ),
];
}

