import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/stats_controller.dart';
import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/pages/stats/stats_page.dart';
import 'package:word_guess_game/app/services/activity_log_service.dart';
import 'package:word_guess_game/app/services/hive_service.dart';
import 'package:word_guess_game/app/translate/translate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    Get.reset();
  });

  testWidgets('stats page renders game summary and guess distribution chart', (
    WidgetTester tester,
  ) async {
    Get.put<ActivityLogService>(_FakeActivityLogService());
    Get.put<HiveService>(
      _FakeHiveService(
        stats: StatsModel(
          totalGames: 8,
          totalWins: 6,
          currentStreak: 3,
          maxStreak: 5,
          guessDist: const [1, 2, 2, 1, 0, 0],
        ),
      ),
    );
    Get.put<StatsController>(StatsController());

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        child: GetMaterialApp(
          translations: Languages(),
          locale: const Locale('en'),
          home: const StatsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((widget) => widget.runtimeType.toString() == 'BarChart'),
      findsOneWidget,
    );
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Played'), findsWidgets);
  });

  testWidgets('stats page shows empty state when there are no games yet', (
    WidgetTester tester,
  ) async {
    Get.put<ActivityLogService>(_FakeActivityLogService());
    Get.put<HiveService>(
      _FakeHiveService(
        stats: StatsModel(),
      ),
    );
    Get.put<StatsController>(StatsController());

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        child: GetMaterialApp(
          translations: Languages(),
          locale: const Locale('en'),
          home: const StatsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No games yet'), findsOneWidget);
    expect(find.text('Finish a round to unlock your guess distribution.'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget.runtimeType.toString() == 'BarChart'), findsNothing);
  });
}

class _FakeActivityLogService extends ActivityLogService {
  @override
  Future<List<Map<String, dynamic>>> getEvents({
    int limit = 200,
    String? appId,
  }) async {
    return <Map<String, dynamic>>[];
  }
}

class _FakeHiveService extends HiveService {
  _FakeHiveService({required this.stats});

  final StatsModel stats;

  @override
  StatsModel getStats() => stats;
}
