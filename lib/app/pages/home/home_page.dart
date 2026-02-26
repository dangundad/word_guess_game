import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
      appBar: AppBar(
        title: Text(
          'app_name'.tr,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.surface,
                cs.surfaceContainerLowest.withValues(alpha: 0.93),
                cs.surfaceContainerLow.withValues(alpha: 0.88),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 28.h),
                      _buildHeroSection(cs),
                      SizedBox(height: 24.h),
                      _buildWordTiles(cs),
                      SizedBox(height: 24.h),
                      const _CategorySelector(),
                      SizedBox(height: 24.h),
                      _buildModeButtons(cs),
                      SizedBox(height: 28.h),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        builder: (ctx, v, child) => Opacity(
                          opacity: v,
                          child: Transform.translate(
                            offset: Offset(0, (1 - v) * 12),
                            child: child,
                          ),
                        ),
                        child: const _StatsCard(),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              BannerAdWidget(
                adUnitId: AdHelper.bannerAdUnitId,
                type: AdHelper.banner,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ColorScheme cs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (ctx, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 16),
          child: child,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 110.r,
            height: 110.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cs.primaryContainer,
                  cs.primaryContainer.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                LucideIcons.wholeWord,
                size: 60.r,
                color: cs.primary,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'home_title'.tr,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'home_subtitle'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: cs.onSurfaceVariant,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWordTiles(ColorScheme cs) {
    final letters = ['W', 'O', 'R', 'D', 'S'];
    final colors = [
      const Color(0xFF538D4E),
      const Color(0xFFB59F3B),
      cs.surfaceContainerHighest,
      const Color(0xFF538D4E),
      const Color(0xFFB59F3B),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.asMap().entries.map((e) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 280 + e.key * 80),
          curve: Curves.easeOutBack,
          builder: (ctx, v, child) => Transform.scale(
            scale: v,
            child: Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: child,
            ),
          ),
          child: Container(
            width: 48.r,
            height: 48.r,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: colors[e.key],
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: colors[e.key].withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModeButtons(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GradientButton(
          label: 'play_daily'.tr,
          icon: LucideIcons.calendar1,
          onTap: () => _startGame(GameMode.daily),
        ),
        SizedBox(height: 12.h),
        _OutlinedActionButton(
          label: 'play_infinite'.tr,
          icon: LucideIcons.infinity,
          onTap: () => _startGame(GameMode.infinite),
        ),
      ],
    );
  }

  void _startGame(GameMode mode) async {
    final gameController = GameController.to;
    final category = _CategorySelector.selectedCategory.value;
    await gameController.startNewGame(mode: mode, cat: category);
    Get.toNamed(Routes.GAME);
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22.r, color: cs.onPrimary),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlinedActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20.r, color: cs.primary),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: WordCategory.values.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final cat = entry.value;
                  final selected = selectedCategory.value == cat;
                  final isLast = idx == WordCategory.values.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 8.w),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: selected
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: selected
                              ? cs.primary
                              : cs.outline.withValues(alpha: 0.45),
                          width: selected ? 1.4 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => selectedCategory.value = cat,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Text(
                            cat.displayKey.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color:
                                  selected ? cs.primary : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.chartBar, size: 18.r, color: cs.primary),
              SizedBox(width: 8.w),
              Text(
                'stats_title'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
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
                    width: fraction * 1 == 0 ? 24.w : (Get.width - 128.w) * fraction,
                    height: 18.h,
                    decoration: BoxDecoration(
                      gradient: count > 0
                          ? const LinearGradient(
                              colors: [Color(0xFF538D4E), Color(0xFF2D5016)],
                            )
                          : null,
                      color: count > 0 ? null : cs.surfaceContainerHighest,
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
                            color: count > 0 ? Colors.white : cs.onSurfaceVariant,
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
