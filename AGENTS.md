# Word Guess Game -- 프로젝트 가이드

> 최종 업데이트: 2026-03-06

## 프로젝트 개요

Wordle 스타일의 5글자 단어 추측 게임. 6번의 기회 안에 정답을 맞추는 게임으로, 일일 도전 모드와 무한 모드를 지원합니다. 4가지 카테고리(General, Animals, Food, Countries)로 단어 풀을 분리합니다.

- **패키지명**: com.dangundad.wordguessgame
- **버전**: 1.0.0+1
- **디자인 기준**: 375x812 (ScreenUtil)
- **테마**: FlexScheme.green, 시스템 모드 (`ThemeMode.system`)

## 기술 스택

| 분류 | 패키지 | 버전 |
|------|--------|------|
| 상태 관리 | get | ^4.7.3 |
| 로컬 저장 | hive_ce + hive_ce_flutter | ^2.19.3 / ^2.3.4 |
| UI 반응형 | flutter_screenutil | ^5.9.3 |
| 테마 | flex_color_scheme (green) | ^8.4.0 |
| 폰트 | google_fonts | ^6.3.2 |
| 아이콘 | lucide_icons_flutter | ^3.1.10 |
| 광고 | google_mobile_ads | ^6.0.0 |
| 광고 미디에이션 | gma_mediation_applovin, pangle, unity | ^2.5.1 / ^3.5.0 / ^1.6.2 |
| 인앱 구매 | in_app_purchase | ^3.2.3 |
| 애니메이션 | flutter_animate | ^4.5.2 |
| Firebase | firebase_core, analytics, crashlytics | ^4.4.0 / ^12.1.2 / ^5.0.7 |
| 유틸 | intl, share_plus, vibration, uuid | - |
| 앱 평가 | in_app_review, rate_my_app | ^2.0.11 / ^2.3.2 |

## 개발 명령어

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

## 아키텍처 (프로젝트 구조)

```
lib/
├── main.dart                        # AdMob -> Hive -> WordService -> 광고매니저
├── hive_registrar.g.dart
└── app/
    ├── admob/
    │   ├── ads_helper.dart          # 광고 ID 관리
    │   ├── ads_banner.dart          # 배너 광고 위젯
    │   ├── ads_interstitial.dart    # 전면 광고 매니저
    │   └── ads_rewarded.dart        # 보상형 광고 매니저 (힌트 해금)
    ├── bindings/
    │   └── app_binding.dart         # GetX 앱 바인딩
    ├── controllers/
    │   ├── game_controller.dart     # 핵심 게임 로직 (추측, 판정, 힌트)
    │   ├── home_controller.dart     # 홈 화면
    │   ├── history_controller.dart  # 게임 히스토리
    │   ├── premium_controller.dart  # 프리미엄 관리
    │   ├── setting_controller.dart  # 설정
    │   └── stats_controller.dart    # 통계 화면
    ├── data/
    │   ├── enums/
    │   │   ├── game_mode.dart       # daily / infinite
    │   │   ├── game_status.dart     # idle / playing / won / lost
    │   │   ├── letter_state.dart    # absent / present / correct
    │   │   └── word_category.dart   # general / animals / food / countries
    │   └── models/
    │       ├── game_state_model.dart    # @HiveType(typeId: 0) - 게임 상태
    │       └── stats_model.dart         # @HiveType(typeId: 1) - 통계
    ├── pages/
    │   ├── home/                    # 모드/카테고리 선택
    │   ├── game/                    # 게임 화면
    │   │   └── widgets/
    │   │       ├── keyboard_widget.dart  # 화면 키보드
    │   │       ├── letter_tile.dart      # 글자 타일 (색상 상태)
    │   │       └── result_dialog.dart    # 결과 다이얼로그
    │   ├── history/                 # 게임 히스토리
    │   ├── stats/                   # 통계 (추측 분포)
    │   ├── settings/                # 설정
    │   └── premium/                 # 프리미엄 구매
    ├── routes/
    │   ├── app_routes.dart          # HOME/GAME/SETTINGS/HISTORY/STATS/PREMIUM
    │   └── app_pages.dart
    ├── services/
    │   ├── hive_service.dart        # settings/app_data/game_states/stats 박스
    │   ├── word_service.dart        # 단어 로드, 일일/랜덤 단어, 유효성 검증
    │   ├── purchase_service.dart    # 인앱 구매
    │   ├── app_rating_service.dart  # 앱 평가
    │   └── activity_log_service.dart
    ├── theme/
    │   └── app_flex_theme.dart      # FlexScheme.green
    ├── translate/
    │   └── translate.dart           # GetX 다국어 (ko 기본)
    ├── utils/
    │   └── app_constants.dart       # HiveKeys, GameConstants, PurchaseConstants
    └── widgets/
        └── confetti_overlay.dart    # 승리 컨페티
```

## 데이터 모델

| 모델 | HiveType ID | 설명 |
|------|-------------|------|
| GameStateModel | 0 | 게임 상태 (날짜키, 정답, 추측 목록, 완료/승리 여부) |
| StatsModel | 1 | 통계 (총 게임, 승리, 연승, 추측 분포) |

## 개발 가이드라인

- `WordService`: 앱 시작 시 `assets/data/words_*.json`에서 카테고리별 단어 로드
- 일일 단어: `DateTime(2024,1,1)` 기준 경과 일수로 결정적 인덱스 계산
- `LetterState` 우선순위: correct > present > absent (키보드 색상 업데이트용)
- 힌트: 최대 3회, 보상형 광고로 추가 힌트 획득 가능
- 일일 모드: 카테고리별 `daily_game_{dateKey}_{category}` 키로 Hive 저장
- `GameConstants`: MAX_GUESSES=6, WORD_LENGTH=5, MAX_HINTS=3
