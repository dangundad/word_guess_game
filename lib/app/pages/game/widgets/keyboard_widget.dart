import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:word_guess_game/app/controllers/game_controller.dart';
import 'package:word_guess_game/app/controllers/setting_controller.dart';
import 'package:word_guess_game/app/data/enums/letter_state.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({super.key});

  static const List<String> _row1 = [
    'Q','W','E','R','T','Y','U','I','O','P'
  ];
  static const List<String> _row2 = [
    'A','S','D','F','G','H','J','K','L'
  ];
  static const List<String> _row3 = [
    'ENTER','Z','X','C','V','B','N','M','⌫'
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (c) => Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(context, _row1, c),
            SizedBox(height: 6.h),
            _buildRow(context, _row2, c),
            SizedBox(height: 6.h),
            _buildRow(context, _row3, c),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<String> keys,
    GameController c,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) => _buildKey(context, key, c)).toList(),
    );
  }

  Widget _buildKey(
    BuildContext context,
    String key,
    GameController c,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isWide = key == 'ENTER' || key == '⌫';
    final state = c.keyStates[key];

    Color bgColor;
    Color textColor = Colors.white;

    switch (state) {
      case LetterState.correct:
        bgColor = const Color(0xFF538D4E);
      case LetterState.present:
        bgColor = const Color(0xFFB59F3B);
      case LetterState.absent:
        bgColor = cs.surfaceContainerHighest;
        textColor = cs.onSurfaceVariant;
      case null:
        bgColor = cs.surfaceContainerHigh;
        textColor = cs.onSurface;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
      child: GestureDetector(
        onTap: () {
          if (SettingController.to.hapticEnabled.value) {
            HapticFeedback.lightImpact();
          }
          c.onKeyTap(key);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isWide ? 56.w : 34.w,
          height: 54.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              key,
              style: TextStyle(
                fontSize: isWide ? 11.sp : 15.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
