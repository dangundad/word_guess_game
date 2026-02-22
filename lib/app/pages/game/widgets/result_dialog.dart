import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:word_guess_game/app/admob/ads_banner.dart';
import 'package:word_guess_game/app/admob/ads_helper.dart';
import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/data/enums/game_mode.dart';
import 'package:word_guess_game/app/data/enums/letter_state.dart';

class ResultDialog extends GetView<GameController> {
  const ResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final won = controller.isWon.value;
      final target = controller.targetWord.value;
      final guessCount = controller.guesses.length;

      return Dialog(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Header ─────────────────────────────────────
              Text(
                won ? 'result_win'.tr : 'result_lose'.tr,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: won ? const Color(0xFF538D4E) : cs.error,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                won
                    ? 'result_win_sub'.trParams({'n': '$guessCount'})
                    : 'result_lose_sub'.trParams({'word': target}),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),

              // ─── Emoji Grid ─────────────────────────────────
              _EmojiGrid(
                guessStates: controller.guessStates,
              ),
              SizedBox(height: 20.h),

              // ─── Stats ──────────────────────────────────────
              _StatsRow(controller: controller),
              SizedBox(height: 20.h),

              // ─── Countdown (daily mode only) ─────────────────
              if (controller.gameMode.value == GameMode.daily) ...[
                _CountdownTimer(),
                SizedBox(height: 16.h),
              ],

              // ─── Buttons ────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.shareResult,
                      icon: const Icon(Icons.share, size: 18),
                      label: Text('share'.tr),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  if (controller.gameMode.value == GameMode.infinite)
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.back();
                          controller.startNewGame();
                        },
                        child: Text('play_again'.tr),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),

              // ─── Banner Ad ──────────────────────────────────
              BannerAdWidget(
                adUnitId: AdHelper.bannerAdUnitId,
                type: AdHelper.banner,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _EmojiGrid extends StatelessWidget {
  final RxList<List<LetterState>> guessStates;
  const _EmojiGrid({required this.guessStates});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: guessStates.map((row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: row.map((s) {
              String emoji;
              switch (s) {
                case LetterState.correct:
                  emoji = '🟩';
                case LetterState.present:
                  emoji = '🟨';
                case LetterState.absent:
                  emoji = '⬜';
              }
              return Padding(
                padding: EdgeInsets.all(1.r),
                child: Text(emoji, style: TextStyle(fontSize: 20.sp)),
              );
            }).toList(),
          );
        }).toList(),
      );
    });
  }
}

class _StatsRow extends StatelessWidget {
  final GameController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = controller.stats;

    final winRate = stats.totalGames > 0
        ? (stats.totalWins / stats.totalGames * 100).round()
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(label: 'stat_played'.tr, value: '${stats.totalGames}', cs: cs),
        _StatItem(label: 'stat_winrate'.tr, value: '$winRate%', cs: cs),
        _StatItem(label: 'stat_streak'.tr, value: '${stats.currentStreak}', cs: cs),
        _StatItem(label: 'stat_max_streak'.tr, value: '${stats.maxStreak}', cs: cs),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  const _StatItem({required this.label, required this.value, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
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

class _CountdownTimer extends StatefulWidget {
  const _CountdownTimer();

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calcRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_calcRemaining);
    });
  }

  void _calcRemaining() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _remaining = tomorrow.difference(now);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'next_word'.tr,
          style: TextStyle(fontSize: 12.sp, color: cs.onSurfaceVariant),
        ),
        Text(
          '$h:$m:$s',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}
