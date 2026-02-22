# 구글 플레이 콘솔 광고/결제 설정 가이드 (Word Guess)

## 1. 현재 수익화 상태

| 항목 | 현재 상태 | 비고 |
| --- | --- | --- |
| 배너 광고 | 적용됨 | 홈 화면 하단 + 결과 다이얼로그 하단 |
| 전면 광고 | 코드 준비됨 | 일일 도전/무한 모드 완료 시 노출 |
| 보상형 광고 | 코드 준비됨 | 힌트 버튼 탭 → 광고 시청 → 힌트 1개 해제 |
| 인앱 구매 | 미적용 | MVP 단계 비활성 |

## 2. 앱별 기준 정보

- 패키지명: `com.dangundad.wordguessgame`
- 플랫폼: Android 중심 운영
- 광고 단위 ID 정의 위치: `lib/app/admob/ads_helper.dart`

## 3. 출시 전 필수 작업

- [ ] `TODO_BANNER` 실제 배너 ID로 교체
- [ ] `TODO_INTERSTITIAL` 실제 전면 ID로 교체
- [ ] `TODO_REWARDED` 실제 보상형 ID로 교체
- [ ] 테스트 ID로 QA 완료 후 실광고 전환
- [ ] 데이터 보안 양식/개인정보 처리방침 최신화

## 4. 인앱 구매 정책

현재 버전은 광고 기반 무료 모델입니다.
- `in_app_purchase` 사용: 없음
- 추후 옵션: 광고 제거 평생권, 힌트 팩 구매 검토 가능

## 5. 권장 코드 상수 예시

```dart
abstract class AdConstants {
  static const String androidBannerId = 'ca-app-pub-xxx/banner';
  static const String androidInterstitialId = 'ca-app-pub-xxx/interstitial';
  static const String androidRewardedId = 'ca-app-pub-xxx/rewarded';
}

abstract class PurchaseConstants {
  static const bool enabled = false;
}
```
