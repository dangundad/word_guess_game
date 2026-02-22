import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // Common
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'share': 'Share',
      'reset': 'Reset',
      'done': 'Done',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'no_data': 'No data',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'version': 'Version',
      'rate_app': 'Rate App',
      'privacy_policy': 'Privacy Policy',
      'remove_ads': 'Remove Ads',
      'send_feedback': 'Send Feedback',
      'more_apps': 'More Apps',

      // App
      'app_name': 'Word Guess',

      // Home
      'mode_daily': 'Daily',
      'mode_infinite': 'Infinite',
      'home_title': 'Word Guess',
      'home_subtitle': 'Guess the 5-letter word in 6 tries!',
      'play_daily': 'Daily Challenge',
      'play_infinite': 'Infinite Mode',
      'category_label': 'Category',
      'cat_general': 'General',
      'cat_animals': 'Animals',
      'cat_food': 'Food',
      'cat_countries': 'Countries',
      'stats_title': 'Your Stats',

      // Game
      'hint': 'Hint',
      'new_game': 'New Game',
      'new_game_confirm': 'Start a new game? Current progress will be lost.',
      'word_too_short': 'Not enough letters',
      'not_in_word_list': 'Not in word list',
      'hint_letter': 'Position @{pos} is @{letter}',
      'no_hints_left': 'No hints left',

      // Result
      'result_win': '🎉 You Won!',
      'result_lose': '😢 Game Over',
      'result_win_sub': 'Solved in @{n}/6 guesses',
      'result_lose_sub': 'The word was @{word}',
      'play_again': 'Play Again',
      'next_word': 'Next word in',

      // Stats
      'stat_played': 'Played',
      'stat_winrate': 'Win %',
      'stat_streak': 'Streak',
      'stat_max_streak': 'Best',
    },
    'ko': {
      // 공통
      'settings': '설정',
      'save': '저장',
      'cancel': '취소',
      'delete': '삭제',
      'edit': '편집',
      'share': '공유',
      'reset': '초기화',
      'done': '완료',
      'ok': '확인',
      'yes': '예',
      'no': '아니오',
      'error': '오류',
      'success': '성공',
      'loading': '로딩 중...',
      'no_data': '데이터 없음',
      'dark_mode': '다크 모드',
      'language': '언어',
      'about': '앱 정보',
      'version': '버전',
      'rate_app': '앱 평가',
      'privacy_policy': '개인정보처리방침',
      'remove_ads': '광고 제거',
      'send_feedback': '피드백 보내기',
      'more_apps': '더 많은 앱',

      // 앱
      'app_name': '워드 게스',

      // 홈
      'mode_daily': '오늘의 단어',
      'mode_infinite': '무한 모드',
      'home_title': '워드 게스',
      'home_subtitle': '6번 안에 5글자 영단어를 맞춰보세요!',
      'play_daily': '오늘의 도전',
      'play_infinite': '무한 모드',
      'category_label': '카테고리',
      'cat_general': '일반',
      'cat_animals': '동물',
      'cat_food': '음식',
      'cat_countries': '나라',
      'stats_title': '내 통계',

      // 게임
      'hint': '힌트',
      'new_game': '새 게임',
      'new_game_confirm': '새 게임을 시작하시겠어요? 현재 진행 내용이 사라집니다.',
      'word_too_short': '글자 수가 부족합니다',
      'not_in_word_list': '단어 목록에 없습니다',
      'hint_letter': '@{pos}번째 자리는 @{letter}입니다',
      'no_hints_left': '힌트가 없습니다',

      // 결과
      'result_win': '🎉 정답!',
      'result_lose': '😢 아쉬워요',
      'result_win_sub': '@{n}/6번 만에 맞혔습니다',
      'result_lose_sub': '정답은 @{word}였습니다',
      'play_again': '다시 하기',
      'next_word': '다음 단어까지',

      // 통계
      'stat_played': '게임 수',
      'stat_winrate': '승률',
      'stat_streak': '연속 정답',
      'stat_max_streak': '최고 연속',
    },
  };
}
