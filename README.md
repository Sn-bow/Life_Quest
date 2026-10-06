# Life Quest

내 일상의 작은 행동을 퀘스트로 실행하고 자신의 상태창에서 성장을 확인하는 Android 앱입니다. 첫 화면은 이름·레벨·경험치·능력치를 보여 주는 상태창입니다. 목표에 맞는 성장 루트를 고르고, 작은 미션을 실행하며 자기만의 기록과 도구를 남길 수 있습니다.

**2026-10-06 기준: 2.2.0 (2017), `com.logian.lifequest`.** 소유자 한 명의 Google Play 내부 검사를 진행하고 있습니다. 외부 테스터를 모집하는 비공개 배포는 사용자 지시로 보류 중입니다. 프로덕션 출시와 실제 매출은 아직 없습니다.

[제품·개인정보 안내](https://sn-bow.github.io/Life_Quest/) · [현재 체크포인트](docs/rebirth/CONTINUE.md) · [최종 빌드](docs/rebirth/product-2017-recovery-build.json) · [Play 검사 기록](docs/rebirth/play-owner-testing-2017.json)

## 제품 구성

- **내 상태창:** 실제 완료에 따라 경험치·성장 기록을 반영합니다. 새 프로필은 0XP에서 시작하며 쉬거나 제안을 거절했다고 경험치를 차감하지 않습니다.
- **네 성장 루트:** 학습·정리·가벼운 움직임·관계의 루트에 21개씩, 총 84개 미션이 있습니다. 각 첫 7개, 총 28개는 무료입니다. 선택형 타이머·메모와 더 작은 행동을 제공하며, 수락한 미션도 2분으로 줄여 이어갈 수 있습니다.
- **재사용 도구:** 관련 미션에서 복습 카드·정리 체크리스트·일상 루틴·재사용 문장을 작성합니다. 완료 후 도구함에서 다시 쓰고 고칠 수 있으며 재사용으로 XP를 추가 지급하지 않습니다. 완료 전 초안은 기기에 보관하고, 완료된 결과는 해당 프로필의 기록과 백업에 포함합니다.
- **기록과 무료 백업:** 루트 진도·회고·실행 결과를 보존하고 끝낸 루트는 새 목표로 다시 시작할 수 있습니다. 기기 프로필은 가입 없이 이용하며 비밀번호로 암호화한 진행 백업과 복원을 제공합니다. 구매 권한은 백업으로 이전하지 않습니다.
- **선택형 온디바이스 AI:** 공개 Apache-2.0 Gemma 4 E2B를 약 2.59GB 별도 다운로드합니다. 설치 후 생성은 기기에서 실행하며 목표·개인화 이력을 클라우드 LLM으로 보내지 않습니다. 미설치·미지원·출력 검증 실패 시 기본 추천을 사용합니다. 모델 없이도 핵심 미션과 유료 콘텐츠를 이용할 수 있습니다.
- **네 언어:** 한국어·영어·일본어·대만 번체 중국어를 지원합니다.

현재 주력은 상태창·현실 미션·기록·재사용 도구입니다. 이전 카드 전투와 이야기 팩은 개발 이력에 남아 있으며 현 판매 상품에 포함된다고 안내하지 않습니다. [상태창 디자인 기록](docs/rebirth/design/status-system/HUNTER_WINDOW_V9.md), [이미지 아트 출처](docs/rebirth/artwork/README.md).

## 일회 구매 Complete

무료 다운로드에 선택형 앱 내 일회 구매를 제공합니다. 구현된 유료 혜택은 각 루트 8–21번의 **56개 후속 미션**, 전체 루트의 새 목표 재사용, **상태창 외관 세 종류**, **30/90일 성장 보고서와 내보내기**입니다. 구매 전에 실제 유료 미션과 도구 예시를 조작할 수 있습니다.

기본 퀘스트·무료 첫 장·기본 AI·기존 기록·백업은 무료입니다. 환불로 Complete가 회수되어도 이미 만든 자기 기록과 도구를 유료 잠금으로 숨기지 않습니다. 새 유료 미션의 접근 권한은 회수합니다.

상품은 `quest_journeys_complete_01` / `complete-once`입니다. 10월 6일 Console에서 확인한 한국 표시 가격은 ₩6,500이며 실제 가격과 통화는 Google Play 상품 응답을 사용합니다. 정기결제·유료 XP 배율·강제 광고는 없습니다. [제품 결정](docs/rebirth/market/PRODUCT_DECISION_20261003.md), [수익 구조·운영비 검토](docs/rebirth/market/ECONOMICS_REVIEW_20261003.md). 비교 앱의 다운로드나 테스트 카드 성공은 Life Quest의 구매 수요·매출 실적이 아닙니다.

## 계정과 운영

기기 프로필과 구매용 Google 연결을 분리합니다. 구매 연결만으로 기기의 퀘스트나 AI 이력을 자동 업로드하지 않습니다. 별도로 선택한 클라우드 프로필은 Firebase Auth·Firestore를 사용합니다. 사진 업로드와 사용자 검토 후 AI 제안 신고는 선택 기능입니다.

구매 검증·권한 복원·RTDN 환불 처리·승인 복구 큐와 삭제 요청 서버는 배포되어 있습니다. App Check 보호를 유지합니다. [서버 운영 기록](docs/rebirth/store/FIREBASE_DEPLOYMENT_2016.md)의 배포 이력과 아래 실제 거래 검사를 구분합니다. 클라우드는 사용량 기반 Blaze이며 기존 함수 월 ₩5,000 상한과 결제 계정 월 ₩10,000 알림은 전체 비용의 하드캡을 뜻하지 않습니다.

## 확인한 범위

- **최종 앱 소스 `21380b0`:** 전체 Flutter 603개 통과·기본 설정의 의도적 1개 skip, Cloud/Billing 관련 37개 통과, analyze 문제 없음. 최종 AAB 40/40 검사와 APK 서명·16KB 정렬 확인. [저장 실패 수정](docs/rebirth/qa/route-save-recovery-20261004.md).
- **10월 6일 실제 Android 조작:** 최종2017 APK의 로컬 합성 프로필에서 0XP 시작, 미션 수락·2분 축소·카드 작성·프로세스 종료 후 초안 복구·완료·재사용·재실행 보존을 확인했습니다. 영어 전화 세로/가로 표본입니다. [원본 화면과 검사](docs/rebirth/qa/native-toolkit-20261006/README.md).
- **권한 회수 회귀 검사:** 도구 테스트 파일 14개 통과. Complete 회수 후 기존 유료 단계의 자기 카드·메모·XP 보존, 무료 수정·재실행·백업을 검사했습니다. 앱 소스 변경이나 전체604개 재실행을 뜻하지 않습니다.
- **Play 테스트 카드:** 본인이 휴대폰에서 구매·복원·환불·항상 거부 실패 안내를 확인했습니다. 서버도 구매 권한 부여와 환불 후 회수, Auth/App Check VALID를 확인했습니다. 실제 청구·매출은 0원입니다. 환불 후 휴대폰의 기존 무료 기록 보존은 본인이 ‘모름’으로 답해 미확인으로 남겼으며 보류 결제 전환도 별도 미확인입니다. [거래 기록](docs/rebirth/qa/play-test-purchase-20261006.md).
- **이전 화면·모델 검사:** 네 언어의 작은 화면/큰 글자 위젯과 웹 태블릿 검사, Android R8 모델·암호화 백업 probe 기록이 있습니다. [2017 제품 QA](docs/rebirth/qa/toolkit-20261004/README.md), [모델 선정·Android 측정](docs/rebirth/ON_DEVICE_AI_DECISION.md). 에뮬레이터 수치를 실물 기기의 성능·발열·배터리 보증으로 사용하지 않습니다.

인증된 앱의 계정 삭제·사진 업로드·AI 신고 등의 남은 운영 경로는 계속 확인 중입니다. 내부 검사 통과만으로 전체 제품 목표나 실제 수익이 달성됐다고 선언하지 않습니다. 외부 테스터 배포와 판매자 전달은 준비 상태를 보고한 뒤 사용자 지시를 기다립니다.

## 개발

Flutter 3.47.4 / Dart 3.13.3 / JDK 21 / Android SDK 36 / LiteRT-LM 0.17.0을 사용합니다. Android 전용입니다. 같은 checkout의 Flutter 명령은 직렬 실행합니다.

```sh
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release --target lib/main.dart \
  --dart-define=LIFEQUEST_CLOUD_ENABLED=true \
  --dart-define=LIFEQUEST_MONETIZATION_ENABLED=true \
  --dart-define=LIFEQUEST_ADS_ENABLED=false \
  --dart-define=LIFEQUEST_QA_PREVIEW=false
```

기본 빌드는 Cloud/Billing이 꺼진 개발 설정이므로 유료 제출 빌드와 구분합니다. 릴리스 서명에는 Git에서 제외한 업로드 키와 `android/key.properties`가 필요합니다. 비밀값을 문서·명령 인수·공개 로그에 넣지 않습니다. 산출물 검사는 `scripts/inspect_release_artifact.py`와 최종 빌드의 검사 기록을 따릅니다. `integration_test/`의 probe APK/AAB는 Play 제출용이 아닙니다.

## 공개판과 배포 자료

직접 다운로드 링크의 공개 프리뷰는 **2026-09-21의 2.0.0+7 / 이전 패키지 `com.lifequest.app`**입니다. 최신2017 내부 설치본과 다르며 새 패키지로 기기의 로컬 데이터가 자동 이전되지 않습니다. [과거 공개판 범위](docs/rebirth/PUBLIC_PREVIEW.md), [공개 APK 버전](https://github.com/Sn-bow/Life_Quest/releases/tag/v2.0.0-preview.1), [패키지 이전 기록](docs/rebirth/store/PACKAGE_MIGRATION_20260929.md).

[2017 테스터 사용 안내](docs/rebirth/store/TESTER_STEPS_2017.md) · [크몽 전달 준비·보류 범위](docs/rebirth/store/KMONG_HANDOFF_20261003.md) · [개인정보·삭제·약관](https://sn-bow.github.io/Life_Quest/#privacy)

지원: logian621@gmail.com.
