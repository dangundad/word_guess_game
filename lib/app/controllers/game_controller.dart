import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import 'package:word_guess_game/app/controllers/setting_controller.dart';
import 'package:word_guess_game/app/data/enums/game_mode.dart';
import 'package:word_guess_game/app/data/enums/letter_state.dart';
import 'package:word_guess_game/app/data/enums/word_category.dart';
import 'package:word_guess_game/app/data/models/game_state_model.dart';
import 'package:word_guess_game/app/data/models/stats_model.dart';
import 'package:word_guess_game/app/services/hive_service.dart';
import 'package:word_guess_game/app/services/word_service.dart';

class GameController extends GetxController {
  static GameController get to => Get.find();

  // ─── Game State ────────────────────────────────────────────────
  final RxString targetWord = ''.obs;
  final RxList<String> guesses = <String>[].obs;
  final RxList<List<LetterState>> guessStates = <List<LetterState>>[].obs;
  final RxString currentInput = ''.obs;
  final RxBool isCompleted = false.obs;
  final RxBool isWon = false.obs;

  // ─── Mode & Category ───────────────────────────────────────────
  final Rx<GameMode> gameMode = GameMode.daily.obs;
  final Rx<WordCategory> category = WordCategory.general.obs;

  // ─── Keyboard State ────────────────────────────────────────────
  final RxMap<String, LetterState> keyStates = <String, LetterState>{}.obs;

  // ─── Animation Triggers ────────────────────────────────────────
  final RxBool shakeRow = false.obs;
  final RxList<bool> flippedRows = <bool>[].obs;

  // ─── Message Overlay ───────────────────────────────────────────
  final RxString message = ''.obs;

  // ─── Confetti ──────────────────────────────────────────────────
  final RxBool showConfetti = false.obs;

  // ─── Hints ─────────────────────────────────────────────────────
  final RxInt hintsUsed = 0.obs;
  static const int maxHints = 3;

  // ─── Stats ─────────────────────────────────────────────────────
  late StatsModel stats;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  void _loadStats() {
    stats = HiveService.to.getStats() ?? StatsModel();
  }

  Future<void> startNewGame({GameMode? mode, WordCategory? cat}) async {
    if (mode != null) gameMode.value = mode;
    if (cat != null) category.value = cat;

    guesses.clear();
    guessStates.clear();
    currentInput.value = '';
    isCompleted.value = false;
    isWon.value = false;
    keyStates.clear();
    hintsUsed.value = 0;
    shakeRow.value = false;
    flippedRows.clear();
    message.value = '';

    if (gameMode.value == GameMode.daily) {
      final dateKey = WordService.to.getDateKey();
      final saved = HiveService.to.getDailyGameState(dateKey, category.value.name);

      if (saved != null) {
        targetWord.value = saved.targetWord;
        for (final guess in saved.guesses) {
          final states = evaluateGuess(guess, saved.targetWord);
          guesses.add(guess);
          guessStates.add(states);
          flippedRows.add(true);
          _updateKeyStates(guess, states);
        }
        isCompleted.value = saved.isCompleted;
        isWon.value = saved.isWon;
        return;
      }

      targetWord.value = WordService.to.getDailyWord(category.value);
    } else {
      targetWord.value = WordService.to.getRandomWord(category.value);
    }

    await _saveGameState();
  }

  // ─── Key Input ─────────────────────────────────────────────────

  void onKeyTap(String key) {
    if (isCompleted.value) return;
    if (key == '⌫') {
      deleteLetter();
    } else if (key == 'ENTER') {
      submitGuess();
    } else {
      addLetter(key);
    }
  }

  void addLetter(String letter) {
    if (currentInput.value.length < 5) {
      currentInput.value += letter.toUpperCase();
    }
  }

  void deleteLetter() {
    if (currentInput.value.isNotEmpty) {
      currentInput.value =
          currentInput.value.substring(0, currentInput.value.length - 1);
    }
  }

  Future<void> submitGuess() async {
    final input = currentInput.value;

    if (input.length != 5) {
      _showMessage('word_too_short'.tr);
      return;
    }

    if (!WordService.to.isValidWord(input)) {
      _showMessage('not_in_word_list'.tr);
      if (SettingController.to.hapticEnabled.value) {
        HapticFeedback.heavyImpact();
      }
      _triggerShake();
      return;
    }

    final guess = input.toUpperCase();
    final states = evaluateGuess(guess, targetWord.value);

    guesses.add(guess);
    guessStates.add(states);
    flippedRows.add(false);
    currentInput.value = '';

    // Trigger flip animation (staggered 150ms per tile = 750ms total)
    await Future.delayed(const Duration(milliseconds: 50));
    flippedRows[flippedRows.length - 1] = true;
    flippedRows.refresh();

    // Wait for flip to finish before updating keyboard colors
    await Future.delayed(const Duration(milliseconds: 800));
    _updateKeyStates(guess, states);
    keyStates.refresh();

    if (guess == targetWord.value) {
      if (SettingController.to.hapticEnabled.value) {
        HapticFeedback.mediumImpact();
      }
      isWon.value = true;
      isCompleted.value = true;
      showConfetti.value = true;
      _updateStats(won: true, guessCount: guesses.length);
    } else if (guesses.length >= 6) {
      if (SettingController.to.hapticEnabled.value) {
        HapticFeedback.heavyImpact();
      }
      isCompleted.value = true;
      _updateStats(won: false, guessCount: 0);
    } else {
      if (SettingController.to.hapticEnabled.value) {
        HapticFeedback.lightImpact();
      }
    }

    await _saveGameState();
  }

  // ─── Core Algorithm ────────────────────────────────────────────

  List<LetterState> evaluateGuess(String guess, String target) {
    final result = List.filled(5, LetterState.absent);
    final targetChars = target.toUpperCase().split('');
    final guessChars = guess.toUpperCase().split('');

    // Pass 1: correct position
    for (int i = 0; i < 5; i++) {
      if (guessChars[i] == targetChars[i]) {
        result[i] = LetterState.correct;
        targetChars[i] = '#';
        guessChars[i] = '*';
      }
    }

    // Pass 2: present but wrong position
    for (int i = 0; i < 5; i++) {
      if (guessChars[i] == '*') continue;
      final idx = targetChars.indexOf(guessChars[i]);
      if (idx != -1) {
        result[i] = LetterState.present;
        targetChars[idx] = '#';
      }
    }

    return result;
  }

  // ─── Hint System ───────────────────────────────────────────────

  void useHint() {
    if (hintsUsed.value >= maxHints) {
      _showMessage('no_hints_left'.tr);
      return;
    }
    if (isCompleted.value) return;

    // Find positions not yet correctly guessed
    final revealed = <int>{};
    for (int gi = 0; gi < guesses.length; gi++) {
      for (int i = 0; i < 5; i++) {
        if (guessStates[gi][i] == LetterState.correct) revealed.add(i);
      }
    }

    final unrevealed =
        List.generate(5, (i) => i).where((i) => !revealed.contains(i)).toList();

    if (unrevealed.isEmpty) {
      _showMessage('no_hints_left'.tr);
      return;
    }

    final idx = unrevealed.first;
    final hintLetter = targetWord.value[idx];
    _showMessage(
      'hint_letter'
          .trParams({'pos': '${idx + 1}', 'letter': hintLetter}),
    );
    hintsUsed.value++;

    keyStates[hintLetter] = LetterState.correct;
    keyStates.refresh();
  }

  // ─── Share ─────────────────────────────────────────────────────

  String getShareText() {
    final dateKey = WordService.to.getDateKey();
    final modeStr = gameMode.value == GameMode.daily ? 'Daily' : 'Infinite';
    final result = isWon.value ? '${guesses.length}/6' : 'X/6';
    final rows = guessStates.map((states) {
      return states.map((s) {
        switch (s) {
          case LetterState.correct:
            return '🟩';
          case LetterState.present:
            return '🟨';
          case LetterState.absent:
            return '⬜';
        }
      }).join();
    }).join('\n');
    return 'Word Guess ($modeStr)\n$dateKey $result\n\n$rows\n\n#WordGuess #DangunDad';
  }

  void shareResult() {
    SharePlus.instance.share(ShareParams(text: getShareText()));
  }

  // ─── Private Helpers ───────────────────────────────────────────

  void _updateKeyStates(String guess, List<LetterState> states) {
    for (int i = 0; i < 5; i++) {
      final letter = guess[i];
      final existing = keyStates[letter] ?? LetterState.absent;
      if (states[i].priority > existing.priority) {
        keyStates[letter] = states[i];
      }
    }
  }

  Future<void> _triggerShake() async {
    shakeRow.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    shakeRow.value = false;
  }

  void _showMessage(String msg) {
    message.value = msg;
    Future.delayed(const Duration(seconds: 2), () {
      if (message.value == msg) message.value = '';
    });
  }

  void _updateStats({required bool won, required int guessCount}) {
    stats.totalGames++;
    final today = WordService.to.getDateKey();
    final yesterday = WordService.to.getYesterdayKey();

    if (won) {
      stats.totalWins++;
      if (stats.lastPlayedDate == yesterday || stats.lastPlayedDate == today) {
        stats.currentStreak++;
      } else {
        stats.currentStreak = 1;
      }
      if (stats.currentStreak > stats.maxStreak) {
        stats.maxStreak = stats.currentStreak;
      }
      if (guessCount >= 1 && guessCount <= 6) {
        stats.guessDist[guessCount - 1]++;
      }
    } else {
      stats.currentStreak = 0;
    }

    stats.lastPlayedDate = today;
    HiveService.to.saveStats(stats);
    _loadStats();
  }

  Future<void> _saveGameState() async {
    if (gameMode.value != GameMode.daily) return;

    final state = GameStateModel(
      dateKey: WordService.to.getDateKey(),
      targetWord: targetWord.value,
      gameMode: gameMode.value.name,
      category: category.value.name,
      guesses: List.from(guesses),
      isCompleted: isCompleted.value,
      isWon: isWon.value,
      createdAt: DateTime.now(),
    );
    await HiveService.to.saveDailyGameState(state);
  }
}
