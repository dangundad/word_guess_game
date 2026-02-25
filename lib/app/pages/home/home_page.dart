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
                      SizedBox(height: 36.h),
                      _buildHeader(cs),
                      SizedBox(height: 26.h),
                      const _CategorySelector(),
                      SizedBox(height: 28.h),
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

  Widget _buildHeader(ColorScheme cs) {
    final letters = ['W', 'O', 'R', 'D', 'S'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: letters.asMap().entries.map((e) {
            final colors = [
              const Color(0xFF538D4E),
              const Color(0xFFB59F3B),
              cs.surfaceContainerHighest,
              const Color(0xFF538D4E),
              const Color(0xFFB59F3B),
            ];

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
        ),
        SizedBox(height: 16.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (ctx, v, child) => Opacity(opacity: v, child: child),
          child: Text(
            'home_title'.tr,
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              letterSpacing: -0.6,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          builder: (ctx, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
              offset: Offset(0, (1 - v) * 8),
              child: child,
            ),
          ),
          child: Text(
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
        ),
      ],
    );
  }

  Widget _buildModeButtons(ColorScheme cs) {
    return Column(
      children: [
        Text(
          'mode_daily'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                label: 'play_daily'.tr,
                subtitle: 'play_once_per_day'.tr,
                icon: LucideIcons.calendar1,
                color: const Color(0xFF538D4E),
                onTap: () => _startGame(GameMode.daily),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionCard(
                label: 'play_infinite'.tr,
                subtitle: 'keep_playing'.tr,
                icon: LucideIcons.infinity,
                color: const Color(0xFFB59F3B),
                onTap: () => _startGame(GameMode.infinite),
                outlined: true,
              ),
            ),
          ],
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

class _ActionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool outlined;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
        decoration: BoxDecoration(
          gradient: outlined
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.24),
                    color.withValues(alpha: 0.10),
                  ],
                ),
          color: outlined ? cs.surfaceContainerHighest : null,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: outlined ? cs.outline : color.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: outlined
              ? [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 22.r, color: cs.primary),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: cs.onSurfaceVariant,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
        Obx(() => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: WordCategory.values.map((cat) {
                final selected = selectedCategory.value == cat;
                return AnimatedContainer(
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
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                        ),
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
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
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
                    width: fraction * 1 == 0 ? 24.w : (Get.width - 128.w) * fraction,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color:
                          count > 0 ? const Color(0xFF538D4E) : cs.surfaceContainerHighest,
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
                            color:
                                count > 0 ? Colors.white : cs.onSurfaceVariant,
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
