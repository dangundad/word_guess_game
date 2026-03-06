# Word Guess Game

Wordle 스타일의 5글자 단어 추측 게임. 6번의 기회 안에 정답 단어를 맞추세요.

## 주요 기능

- **게임 모드**: 일일 도전(Daily) + 무한 모드(Infinite)
- **카테고리**: General, Animals, Food, Countries (4가지 단어 풀)
- **글자 판정**: Correct(초록) / Present(노란) / Absent(회색) 3단계
- **화면 키보드**: 사용한 글자의 상태를 색상으로 표시
- **힌트 시스템**: 최대 3회, 보상형 광고로 추가 힌트 획득
- **통계**: 총 게임, 승률, 연속 기록, 추측 분포 차트
- **게임 저장**: 일일 모드 진행 상태 자동 저장/복원
- **결과 공유**: 게임 결과 텍스트 공유
- **광고**: 배너, 전면, 보상형 광고
- **프리미엄**: 인앱 구매를 통한 광고 제거

## 기술 스택

- **Flutter** (Android + iOS)
- **GetX** (상태 관리, 라우팅, 다국어)
- **Hive_CE** (로컬 저장소)
- **flutter_screenutil** (반응형 UI)
- **flex_color_scheme** (FlexScheme.green 테마)
- **google_mobile_ads** (AdMob 광고)
- **Firebase** (Analytics, Crashlytics)

## 프로젝트 구조

```
lib/
├── main.dart
├── hive_registrar.g.dart
└── app/
    ├── admob/           # 광고 (배너, 전면, 보상형)
    ├── bindings/        # GetX 바인딩
    ├── controllers/     # 게임(추측/판정/힌트), 홈, 설정, 통계, 히스토리
    ├── data/            # 모델 (GameStateModel, StatsModel), enum (GameMode, LetterState 등)
    ├── pages/           # 홈, 게임(키보드/타일/결과), 히스토리, 통계, 설정, 프리미엄
    ├── routes/          # 라우팅
    ├── services/        # HiveService, WordService, PurchaseService, AppRatingService
    ├── theme/           # FlexScheme.green 테마
    ├── translate/       # 다국어 (한국어 기본)
    ├── utils/           # 상수 (HiveKeys, GameConstants, PurchaseConstants)
    └── widgets/         # 컨페티 오버레이
```

## 설치 및 실행

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 라이선스

Proprietary - DangunDad (com.dangundad)
