import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:word_guess_game/app/controllers/stats_controller.dart';

class StatsPage extends GetView<StatsController> {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerLowest.withValues(alpha: 0.94),
                colorScheme.surfaceContainerLow.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 8.h, 14.w, 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'stats_title'.tr,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.refresh(),
                      tooltip: 'refresh'.tr,
                      icon: Icon(
                        LucideIcons.refreshCw,
                        color: colorScheme.primary,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refresh(),
                  color: colorScheme.primary,
                  child: Obx(
                    () => ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(18.w, 4.h, 18.w, 24.h),
                      children: [
                        _OverviewCard(
                          colorScheme: colorScheme,
                          totalGames: controller.totalGames.value,
                          winRate: controller.winRate.value,
                          currentStreak: controller.currentStreak.value,
                          maxStreak: controller.maxStreak.value,
                        ),
                        SizedBox(height: 16.h),
                        if (!controller.hasGames.value)
                          _EmptyStateCard(colorScheme: colorScheme)
                        else
                          _DistributionSection(
                            colorScheme: colorScheme,
                            wins: controller.totalWins.value,
                            losses: controller.totalLosses.value,
                            averageWinningGuess:
                                controller.averageWinningGuess.value,
                            mostCommonGuess: controller.mostCommonGuess.value,
                            distribution: controller.guessDistribution.toList(),
                            chartMaxY: controller.chartMaxY,
                            chartInterval: controller.chartInterval,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.colorScheme,
    required this.totalGames,
    required this.winRate,
    required this.currentStreak,
    required this.maxStreak,
  });

  final ColorScheme colorScheme;
  final int totalGames;
  final int winRate;
  final int currentStreak;
  final int maxStreak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.12),
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
              Icon(LucideIcons.chartBar, size: 18.r, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Text(
                'stats_title'.tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _MetricTile(
                colorScheme: colorScheme,
                label: 'stat_played'.tr,
                value: '$totalGames',
              ),
              _MetricTile(
                colorScheme: colorScheme,
                label: 'stat_winrate'.tr,
                value: '$winRate%',
              ),
              _MetricTile(
                colorScheme: colorScheme,
                label: 'stat_streak'.tr,
                value: '$currentStreak',
              ),
              _MetricTile(
                colorScheme: colorScheme,
                label: 'stat_max_streak'.tr,
                value: '$maxStreak',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributionSection extends StatelessWidget {
  const _DistributionSection({
    required this.colorScheme,
    required this.wins,
    required this.losses,
    required this.averageWinningGuess,
    required this.mostCommonGuess,
    required this.distribution,
    required this.chartMaxY,
    required this.chartInterval,
  });

  final ColorScheme colorScheme;
  final int wins;
  final int losses;
  final double averageWinningGuess;
  final int mostCommonGuess;
  final List<int> distribution;
  final double chartMaxY;
  final double chartInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'guess_distribution'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (mostCommonGuess > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${'best_try'.tr} $mostCommonGuess',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _StatChip(
                colorScheme: colorScheme,
                icon: LucideIcons.badgeCheck,
                label: 'stat_wins'.tr,
                value: '$wins',
              ),
              _StatChip(
                colorScheme: colorScheme,
                icon: LucideIcons.circleX,
                label: 'stat_losses'.tr,
                value: '$losses',
              ),
              _StatChip(
                colorScheme: colorScheme,
                icon: LucideIcons.binary,
                label: 'stat_average_guess'.tr,
                value: _formatAverageGuess(averageWinningGuess),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 240.h,
            child: BarChart(
              BarChartData(
                maxY: chartMaxY,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartInterval,
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.w,
                      interval: chartInterval,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 ||
                            index >= distribution.length ||
                            value != index.toDouble()) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List<BarChartGroupData>.generate(distribution.length, (
                  index,
                ) {
                  final count = distribution[index];
                  final isPeak = mostCommonGuess == index + 1 && count > 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        width: 22.w,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isPeak
                              ? [
                                  colorScheme.primary,
                                  colorScheme.tertiary,
                                ]
                              : [
                                  colorScheme.secondary,
                                  colorScheme.secondary.withValues(alpha: 0.55),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: chartMaxY,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAverageGuess(double value) {
    if (value <= 0) {
      return '0.0';
    }
    return value.toStringAsFixed(1);
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.colorScheme,
    required this.label,
    required this.value,
  });

  final ColorScheme colorScheme;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (Get.width - 62.w) / 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.colorScheme,
    required this.icon,
    required this.label,
    required this.value,
  });

  final ColorScheme colorScheme;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.28)),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.chartColumnIncreasing,
            size: 34.r,
            color: colorScheme.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'stats_empty_title'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'stats_empty_body'.tr,
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
