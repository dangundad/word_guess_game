// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:word_guess_game/app/bindings/app_binding.dart';
import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/pages/game/game_page.dart';
import 'package:word_guess_game/app/pages/home/home_page.dart';

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
  ];
}
