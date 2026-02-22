import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/home_controller.dart';
import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/data/enums/game_mode.dart';
import 'package:word_guess_game/app/data/enums/word_category.dart';
import 'package:word_guess_game/app/routes/app_pages.dart';
import 'package:word_guess_game/app/services/hive_service.dart';
import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/admob/ads_banner.dart';
import 'package:word_guess_game/app/admob/ads_helper.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),

                    // ─── Logo & Title ─────────────────────────────
                    _buildHeader(cs),
                    SizedBox(height: 40.h),

                    // ─── Category Selection ───────────────────────
                    _CategorySelector(),
                    SizedBox(height: 32.h),

                    // ─── Mode Buttons ─────────────────────────────
                    _buildModeButtons(cs),
                    SizedBox(height: 40.h),

                    // ─── Stats ────────────────────────────────────
                    _StatsCard(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // ─── Banner Ad ────────────────────────────────────────
            BannerAdWidget(
              adUnitId: AdHelper.bannerAdUnitId,
              type: AdHelper.banner,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Column(
      children: [
        // Letter grid decoration
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['W', 'O', 'R', 'D', 'S'].asMap().entries.map((e) {
            final colors = [
              const Color(0xFF538D4E),
              const Color(0xFFB59F3B),
              cs.surfaceContainerHighest,
              const Color(0xFF538D4E),
              const Color(0xFFB59F3B),
            ];
            return Container(
              width: 48.r,
              height: 48.r,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: colors[e.key],
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
        Text(
          'home_title'.tr,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'home_subtitle'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: cs.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeButtons(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => _startGame(GameMode.daily),
          icon: const Icon(Icons.today),
          label: Text(
            'play_daily'.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () => _startGame(GameMode.infinite),
          icon: const Icon(Icons.all_inclusive),
          label: Text(
            'play_infinite'.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }

  void _startGame(GameMode mode) async {
    final gameController = Get.find<GameController>();
    final category = _CategorySelector.selectedCategory.value;
    await gameController.startNewGame(mode: mode, cat: category);
    Get.toNamed(Routes.GAME);
  }
}

class _CategorySelector extends StatelessWidget {
  static final Rx<WordCategory> selectedCategory = WordCategory.general.obs;

  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category_label'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() => Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: WordCategory.values.map((cat) {
            final selected = selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => selectedCategory.value = cat,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: selected ? cs.primaryContainer : cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: selected ? cs.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  cat.displayKey.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = HiveService.to.getStats() ?? StatsModel();
    final winRate = stats.totalGames > 0
        ? (stats.totalWins / stats.totalGames * 100).round()
        : 0;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'stats_title'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCell(label: 'stat_played'.tr, value: '${stats.totalGames}'),
              _StatCell(label: 'stat_winrate'.tr, value: '$winRate%'),
              _StatCell(label: 'stat_streak'.tr, value: '${stats.currentStreak}'),
              _StatCell(label: 'stat_max_streak'.tr, value: '${stats.maxStreak}'),
            ],
          ),
          if (stats.totalGames > 0) ...[
            SizedBox(height: 16.h),
            _GuessDistribution(stats: stats),
          ],
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _GuessDistribution extends StatelessWidget {
  final StatsModel stats;
  const _GuessDistribution({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxVal = stats.guessDist.fold(1, (a, b) => a > b ? a : b);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(6, (i) {
        final count = stats.guessDist[i];
        final fraction = count / maxVal;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              SizedBox(
                width: 14.w,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(fontSize: 11.sp, color: cs.onSurfaceVariant),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: fraction * 1 == 0
                        ? 24.w
                        : (Get.width - 120.w) * fraction,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? const Color(0xFF538D4E)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: count > 0
                                ? Colors.white
                                : cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
