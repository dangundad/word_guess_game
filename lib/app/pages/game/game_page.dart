import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/pages/game/widgets/keyboard_widget.dart';
import 'package:word_guess_game/app/pages/game/widgets/letter_tile.dart';
import 'package:word_guess_game/app/pages/game/widgets/result_dialog.dart';
import 'package:word_guess_game/app/widgets/confetti_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameController controller;
  Worker? _completedWorker;

  @override
  void initState() {
    super.initState();
    controller = GameController.to;
    // Show result dialog after animation when game completes
    _completedWorker = ever(controller.isCompleted, (completed) {
      if (completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(const ResultDialog(), barrierDismissible: false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _completedWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr, style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        actions: [
          // Hint button
          Obx(() => IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.lightbulb_outline),
                if (controller.hintsUsed.value < GameController.maxHints)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'hint'.tr,
            onPressed: controller.isCompleted.value ? null : controller.useHint,
          )),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'new_game'.tr,
            onPressed: () => _confirmNewGame(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ─── Message Overlay ─────────────────────────────
                Obx(() {
                  final msg = controller.message.value;
                  return AnimatedOpacity(
                    opacity: msg.isEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: cs.inverseSurface,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: cs.onInverseSurface,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),

                // ─── Grid ────────────────────────────────────────
                Expanded(
                  child: Center(
                    child: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (rowIndex) {
                        return _buildRow(context, rowIndex);
                      }),
                    )),
                  ),
                ),

                // ─── Keyboard ────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                  child: const KeyboardWidget(),
                ),
              ],
            ),

            // ─── Confetti ────────────────────────────────────────
            Obx(() => controller.showConfetti.value
                ? IgnorePointer(
                    child: ConfettiOverlay(
                      onComplete: () => controller.showConfetti.value = false,
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int rowIndex) {
    return Obx(() {
      final guesses = controller.guesses;
      final flippedRows = controller.flippedRows;
      final currentInput = controller.currentInput.value;
      final shakeRow = controller.shakeRow.value;

      // Determine the content and state of each row
      List<String> letters;
      List<bool> flipped;
      bool isCurrentRow = false;

      if (rowIndex < guesses.length) {
        // Submitted row
        final guess = guesses[rowIndex];
        letters = guess.split('');
        flipped = List.generate(
          5,
          (_) => rowIndex < flippedRows.length && flippedRows[rowIndex],
        );
      } else if (rowIndex == guesses.length &&
          !controller.isCompleted.value) {
        // Current input row
        letters = List.generate(5, (i) {
          return i < currentInput.length ? currentInput[i] : '';
        });
        flipped = List.filled(5, false);
        isCurrentRow = true;
      } else {
        // Empty future rows
        letters = List.filled(5, '');
        flipped = List.filled(5, false);
      }

      final rowWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (colIndex) {
          final state = rowIndex < controller.guessStates.length
              ? controller.guessStates[rowIndex][colIndex]
              : null;
          return Padding(
            padding: EdgeInsets.all(3.r),
            child: LetterTile(
              key: ValueKey('tile_${rowIndex}_$colIndex'),
              letter: letters[colIndex],
              state: state,
              isActive: isCurrentRow,
              position: colIndex,
              flipped: flipped[colIndex],
            ),
          );
        }),
      );

      // Apply shake to current row if invalid word
      if (isCurrentRow && shakeRow) {
        return _ShakeWidget(child: rowWidget);
      }
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: rowWidget,
      );
    });
  }

  void _confirmNewGame(BuildContext context) {
    Get.defaultDialog(
      title: 'new_game'.tr,
      middleText: 'new_game_confirm'.tr,
      textConfirm: 'ok'.tr,
      textCancel: 'cancel'.tr,
      onConfirm: () {
        Get.back();
        controller.startNewGame();
      },
    );
  }
}

/// Shake animation widget for invalid word
class _ShakeWidget extends StatefulWidget {
  final Widget child;
  const _ShakeWidget({required this.child});

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_animation.value, 0),
        child: child,
      ),
      child: widget.child,
    );
  }
}
