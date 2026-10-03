# 해외 배포 범위와 대체 Android 스토어 · 2026-09-21

> **후속 사용자 결정:** 초기에는 Google Play 중심 현지화와 Threads 유입에 집중한다. 아래 Uptodown/Galaxy 우선순위는 이전 대체 스토어 조사 당시 판단이며, 현재 추가 입점을 먼저 진행하지 않는다. 최신 실행 방향은 `PLAY_GLOBAL_LAUNCH.md`.

## 이번에 완료한 변경

사용자가 대만·일본·미국·캐나다·프랑스 추가와 지역별 대체 스토어 조사를 요청했다. Google Play **비공개 테스트 Alpha**의 국가 설정에 다섯 곳을 추가하고 저장했다. 페이지를 새로 열어 `타겟팅됨(6개)`와 아래 여섯 국가 행을 확인했다.

- 대한민국, 대만, 일본, 미국, 캐나다, 프랑스.
- [Alpha 국가 설정](https://play.google.com/console/u/1/developers/8167226228602257815/app/4972166589004992203/tracks/4698525131707810433?tab=countryAvailability)
- 로컬 화면 근거: `qa_artifacts/rebirth/closed-test/regions-six.png` (Git 제외).

**대상 국가 저장 완료이며 테스트 활성화/정식 출시 완료는 아니다.** AAB 업로드·Play Console 오류·최종 선언 검토와 심사 제출은 `CLOSED_TEST.md`의 기존 미완료 상태다. 프로덕션 국가를 변경하지 않았다. 다른 스토어에 계정을 만들거나 앱을 제출하거나 비용을 지출하지 않았다.

## 국가별 현실적인 경로

| 지역 | Google Play 외 후보 | 현재 언어 준비 상태 |
| --- | --- | --- |
| 대만 | Uptodown, Galaxy Store, ONE store/Enjoy Store | 중국어는 간체 기반. 번체 및 대만 용어 검수 필요 |
| 일본 | Uptodown, Galaxy Store | 일본어 리소스 존재. 현지 등록정보/기기 검수 필요 |
| 미국 | Uptodown, Galaxy Store, ONE store의 DT One 채널 | 영어 리소스 존재 |
| 캐나다 | Uptodown, Galaxy Store | 영어 존재. 프랑스어 추가 필요 |
| 프랑스 | Uptodown, Galaxy Store | 프랑스어 추가 필요 |

각국에서 이용 가능한 공통 글로벌 스토어와 확인된 지역 채널을 구분했다. 모든 나라에 별도의 국가 전용 스토어가 있다고 가정하지 않는다. 현지 스토어 노출은 앱 언어, 설치 수 또는 매출을 보장하지 않는다.

소스의 지원 언어는 `lib/l10n/app_localizations.dart`의 `en`, `ja`, `ko`, `zh` 네 개다. `app_zh.arb`는 간체이며 별도 `fr`/`zh_Hant` 리소스는 없다. 이번 국가 설정 변경에서 앱 번역이나 바이너리를 바꾸지 않았다.

## 스토어별 확인 결과

### 1. Uptodown — 무료 프리뷰 배포 우선 후보

개인 개발자도 무료 등록·게시가 가능하고 기본적으로 전 세계에 배포한다. 앱 내 결제를 포함하는 앱은 허용하지만 유료 다운로드 앱은 지원하지 않는다. 계정, 개발자 정보와 앱 심사가 필요하다. [공식 기본 안내](https://support.uptodown.com/hc/en-us/articles/4424141383181-Basic-guide-to-register-and-publish-apps-on-Uptodown)

APK 직접 URL로 파일을 등록하는 공식 경로가 있다. 따라서 현재 공개 APK를 등록 후보로 쓸 수 있다. 이 경로를 실제 실행하거나 심사 통과를 확인한 것은 아니다. [공식 등록 절차](https://support.uptodown.com/hc/en-us/articles/360053260491-How-to-publish-an-app-on-Uptodown)

- 후보 파일: [LifeQuest 2.0.0-preview.1 ARM64 APK](https://github.com/Sn-bow/Life_Quest/releases/download/v2.0.0-preview.1/LifeQuest-2.0.0-preview.1-arm64.apk)
- Android 8+/ARM64 무료 프리뷰, Cloud/Billing/Ads/Research 비활성.
- 판단: 비용 없이 현재 무료판의 설치 경로를 늘리기 적합하다. 등록정보·권리·개인정보 안내·서명·업데이트 책임은 별도 검토한다.

### 2. Samsung Galaxy Store — 판매자 인증 후 유력

등록·연회비가 없으며 무료 앱도 **commercial seller** 승인이 필요하다. 개인 판매자 경로가 있으므로 법인만 가능하다고 해석하지 않는다. 신원/판매자 검증이 필요하고, D-U-N-S를 이용하기 어려우면 공식 대체 서류 경로를 확인한다. [비용 FAQ](https://developer.samsung.com/galaxy-store/faq.html), [판매자 준비 안내](https://developer.samsung.com/galaxy-store/prepare.html)

공식 배포 국가 코드에 `TWN`, `JPN`, `USA`, `CAN`, `FRA`, `KOR`가 있다. Galaxy 기기용 채널이며 실제 앱·기기별 배포는 심사 결과에 따른다. [공식 국가 코드](https://developer.samsung.com/galaxy-store/galaxy-store-developer-api/content-publish-api/reference.html)

판단: 무료판 배포의 두 번째 후보다. 추후 결제는 Samsung IAP 및 구매 복원·서버 검증을 맞춰야 한다. 서로 다른 스토어 버전의 서명/패키지/업데이트 충돌도 등록 전에 결정한다. 현재 Play 결제 설계가 그대로 작동한다고 가정하지 않는다.

### 3. ONE store — 대만 지역 채널, 수익화는 조건부

회사 공식 페이지는 대만·싱가포르·미국 파트너 확장을 설명한다. 120여 개국은 확장 계획이며 현재 전부 서비스 중이라는 의미로 쓰지 않는다. 개인/기업 개발자 등록은 무료이고 앱과 게임을 받는다. [글로벌 사업 안내](https://www.onestorecorp.com/about/global/), [개발자 안내](https://onestore-dev.gitbook.io/dev/eng)

대만 **Enjoy Store**에서는 FUN, Lifestyle/Location, Language/Education 분류의 유료 앱, 인앱결제 앱, 외부 결제 앱을 배포할 수 없다고 명시한다. Life Quest가 생활 앱으로 분류될 가능성이 있으므로 현재 무료판의 입점 가능성과 미래 이야기 판매 가능성을 별도로 확인해야 한다. 결제 제한을 피하려고 실제 용도와 다른 게임 분류를 선택하지 않는다. 미국은 DT One의 추가 심사/정산 절차가 있다. [공식 글로벌 FAQ](https://onestore-dev.gitbook.io/dev/eng/help/faq/global)

판단: 대만 무료판 후보로 검토하되 유료 콘텐츠 판매의 주력 채널로 확정하지 않는다. 일본·캐나다·프랑스에서 이 채널이 동일하게 제공된다고 확인하지 않았다.

### 4. Aptoide Connect — 유료이므로 후순위

공식 안내상 연간 **US$69 또는 €69** 구독이 필요하며 자동 갱신된다. 신규 앱 심사에는 활성 구독이 필요하다. 수익화에는 별도 결제 연동/배포 조건 검토가 필요하다. [구독 요건](https://docs.connect.aptoide.com/docs/subscription), [배포 정책](https://connect.aptoide.com/developers-distribution-policy)

판단: 무료 배포 채널을 먼저 진행하고 이용자 반응이 생긴 뒤 비용 대비 가치를 판단한다. 구독하거나 결제하지 않았다.

### 제외/보류

- **Amazon Appstore:** 일반 Android 휴대폰 지원이 2025-08-20 종료됐다. Fire 태블릿/TV는 별도 대상이므로 현재 휴대폰 배포 대안으로 추천하지 않는다. [Amazon 공식 공지](https://developer.amazon.com/ja/apps-and-games/blogs/2025/02/upcoming-changes-to-amazon-appstore-for-android-devices-and-coins-program)
- **Huawei AppGallery:** 공식 글로벌 배포 경로는 존재하지만 이번 조사에서는 요청한 각국의 현재 입점 조건과 이 빌드의 기기 호환성까지 검증하지 않았다. 즉시 등록 가능한 후보로 확정하지 않는다. [공식 배포 안내](https://developer.huawei.com/consumer/en/distribute/)

## 이어서 진행할 순서

1. Google Play Alpha의 기존 업로드/선언/심사 문제를 해결한다. 다른 스토어 설치는 Google의 비공개 테스트 참여 수에 포함되지 않는다.
2. 번체 중국어와 프랑스어를 앱 UI·이야기·퀘스트·AI fallback·스토어 설명까지 일관되게 추가한다. 언어 코드만 늘려 번역 완료로 보고하지 않는다.
3. Uptodown 무료판 등록을 우선 준비하고 Galaxy Store 판매자 자격을 확인한다. 필요한 계정 약관, 본인 인증이나 비용은 실제 단계에서 구체적으로 다룬다.
4. 무료판 반응을 보고 유료 콘텐츠를 검증한다. 결제를 켜기 전 채널별 구매·취소·환불·복원·권한 검증을 구현한다. 대만 ONE store의 카테고리 제한은 먼저 해결한다.

이는 공식 배포 조건을 근거로 한 우선순위 판단이며, 실제 이용자 수요나 수익성 검증 결과가 아니다.
