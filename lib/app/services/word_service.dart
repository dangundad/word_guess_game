import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:word_guess_game/app/data/enums/word_category.dart';

class WordService extends GetxService {
  static WordService get to => Get.find();

  final Map<WordCategory, List<String>> _wordLists = {};
  Set<String> _allWords = {};

  bool get isLoaded => _wordLists.isNotEmpty;

  Future<void> loadWords() async {
    for (final category in WordCategory.values) {
      try {
        final jsonStr = await rootBundle.loadString(category.assetPath);
        final raw = List<String>.from(jsonDecode(jsonStr) as List);
        _wordLists[category] = raw.map((w) => w.toUpperCase()).toList();
      } catch (e) {
        Get.log('Failed to load words for ${category.name}: $e');
        _wordLists[category] = ['CRANE', 'SLATE', 'TRACE', 'AUDIO', 'RAISE'];
      }
    }
    _allWords = _wordLists.values.expand((l) => l).toSet();
    Get.log('Words loaded: ${_allWords.length} total');
  }

  List<String> getWordsForCategory(WordCategory category) {
    return _wordLists[category] ?? ['CRANE'];
  }

  String getDailyWord(WordCategory category) {
    final now = DateTime.now();
    // Stable daily index: days elapsed since epoch base date (consistent across runs)
    final base = DateTime(2024, 1, 1);
    final dayIndex = now.difference(base).inDays.abs();
    final words = getWordsForCategory(category);
    return words[dayIndex % words.length];
  }

  String getRandomWord(WordCategory category) {
    final words = getWordsForCategory(category);
    return words[Random().nextInt(words.length)];
  }

  bool isValidWord(String word) {
    return _allWords.contains(word.toUpperCase());
  }

  String getDateKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String getYesterdayKey() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(yesterday);
  }
}
