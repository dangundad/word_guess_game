import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:word_guess_game/app/data/enums/letter_state.dart';

class LetterTile extends StatefulWidget {
  final String letter;

  /// null = not yet submitted (empty or current input)
  final LetterState? state;

  /// true = currently being typed in this row
  final bool isActive;

  /// stagger delay index (0-4)
  final int position;

  /// trigger flip animation
  final bool flipped;

  const LetterTile({
    super.key,
    required this.letter,
    this.state,
    this.isActive = false,
    this.position = 0,
    this.flipped = false,
  });

  @override
  State<LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<LetterTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _anim.addListener(() {
      if (_anim.value >= 0.5 && !_showBack) {
        setState(() => _showBack = true);
      }
    });

    // Restore if already flipped (game restored from save)
    if (widget.flipped) {
      _controller.value = 1.0;
      _showBack = true;
    }
  }

  @override
  void didUpdateWidget(LetterTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flipped && !oldWidget.flipped && widget.state != null) {
      // Stagger: each tile flips with a 150ms delay per position
      Future.delayed(Duration(milliseconds: widget.position * 150), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundColor(ColorScheme cs) {
    if (!_showBack) return Colors.transparent;
    switch (widget.state) {
      case LetterState.correct:
        return const Color(0xFF538D4E);
      case LetterState.present:
        return const Color(0xFFB59F3B);
      case LetterState.absent:
        return cs.surfaceContainerHighest;
      case null:
        return Colors.transparent;
    }
  }

  Color _borderColor(ColorScheme cs) {
    if (_showBack) return Colors.transparent;
    if (widget.letter.isNotEmpty) return cs.onSurface;
    return cs.outlineVariant;
  }

  Color _textColor(ColorScheme cs) {
    if (_showBack && widget.state != null) return Colors.white;
    return cs.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final angle = _anim.value * pi;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(angle),
          child: Transform(
            alignment: Alignment.center,
            transform: _showBack
                ? (Matrix4.identity()..rotateX(pi))
                : Matrix4.identity(),
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 58.r,
        height: 58.r,
        decoration: BoxDecoration(
          color: _backgroundColor(cs),
          border: Border.all(
            color: _borderColor(cs),
            width: widget.letter.isNotEmpty && !_showBack ? 2 : 1.5,
          ),
        ),
        child: Center(
          child: AnimatedScale(
            scale: widget.letter.isNotEmpty && !_showBack ? 1.0 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Text(
              widget.letter,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: _textColor(cs),
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
