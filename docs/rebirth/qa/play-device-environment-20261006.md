# 실제 Play 설치용 검사 환경 · 2026-10-06

## 목적과 현재 상태

구매·복원·환불·항상 거부는 이미 본인 휴대폰과 서버에서 확인한 범위대로 기록했다. 이번 환경은 남은 앱/서버 운영 경로를 직접 확인하기 위한 **별도 소유자 내부 QA 기기**다. 외부 테스터 목록·비공개 트랙·프로덕션·상품·서버 설정은 변경하지 않았다. 최종 앱 소스와2017 아티팩트도 그대로다.

Google 계정 **이메일 로그인 화면까지 준비**했고, 지정 소유자 계정의 로그인은 사용자에게 요청했다. 아직 로그인 완료·Play 앱 설치·새 기기의 App Check 성공 증거는 없다. 앱 전체 완성이나 실제 수익이 달성됐다는 기록이 아니다.

## 확인한 환경

- 전용 AVD: `LifeQuest_Play_API35_16KB`, 새 빈 Pixel 7a 검사 기기. 기존 AVD를 덮어쓰거나 데이터를 지우지 않았다.
- Google SDK의 공식 `system-images;android-35;google_apis_playstore_ps16k;arm64-v8a`, revision5를 설치했다. 공식 다운로드는 `https://dl.google.com/android/repository/sys-img/google_apis_playstore/arm64-v8a-playstore-ps16k-35_r05.zip`이다. 설치 중 새 약관 동의 입력은 없었다.
- `package.xml`의 Google Play/16KB 표기와 런타임의 `/product/priv-app/Phonesky`, 실제 Google Play 로그인 화면을 확인했다. 검사 당시 Play 스토어는41.3.25/84132530이다. 일부 AVD 기본 표기 `PlayStore.enabled=no`나 `source.properties`의 Google APIs 명칭만으로 스토어 유무를 판단하지 않는다.
- 초기 기본 설정은 GPU disabled·CPU4cores였고 소프트웨어 렌더링/메모리 압박 경고와 첫 부팅의 System UI 응답 지연이 있었다. **Life Quest 설치 전 OS 환경**에서 발생한 현상이다. 이전 Life Quest 검사 기기를 저장 상태를 유지한 채 종료하고, 새 AVD만 host GPU·CPU2cores로 재시작했다. 실제 `hardware-qemu.ini`에 반영됐으며 부팅 완료와 로그인 화면 도달을 확인했다. 원인 전체를 입증했다거나 앱 결함을 수정했다는 뜻은 아니다.
- 기기 식별자는 첫 실행5556에서 재시작 후5554로 바뀌었다. 이어서 작업할 때 `adb devices`와 `adb -s <serial> emu avd name`으로 이름을 맞춘다. serial5554를 이전 로컬 `QA toolkit` 프로필의 기기로 가정하지 않는다.
- 기존 `LifeQuest_API35_16KB` 이미지의 `com.android.vending`은 실제 스토어가 아닌 `LicenseChecker`였다. 그 기기에서 확인한 로컬 미션·저장은 유지하지만 실제 Play 설치/App Check 증거로 확대하지 않는다.

## 재개 지점

Android Studio의 `Running Devices - android` 별도 창에 **LifeQuest Play API35 16KB**를 띄웠다. 전화번호를 조회하는 선택 안내는 건너뛰었고 필기 입력 튜토리얼은 취소했다. Google 이메일 로그인 폼에서 사용자 입력을 기다린다. 비밀번호·인증 코드·인증 저장소를 읽거나 기록하지 않는다. 준비 화면만 ignored `build/review/play-device-login-20261006.png`에 저장했다.

로그인 뒤에는 기존 **소유자 한 명의 내부 트랙**에서2017을 설치한다. 앱 기능·서버 응답·App Check 결과는 실제 요청을 관측한 뒤에만 성공으로 기록한다. [Firebase Play Integrity 안내](https://firebase.google.com/docs/app-check/android/play-integrity-provider)상 에뮬레이터/설치 경로의 제한이 있을 수 있으므로, 스토어 실행만으로 무결성 통과를 추정하지 않는다. 검사 편의를 위해 운영 App Check를 완화하거나 수동 유료 권한을 부여하지 않는다.

실제 소유자 계정·기록을 계정 삭제 검사에 사용하지 않는다. 필요한 삭제 검사는 별도의 합성 검사 신원과 데이터 범위를 준비하고 최종 삭제 조작의 사용자 확인을 따른다. 이번 환경 준비에서 클라우드 계정/사진/신고/주문을 만들거나 삭제하지 않았다. 외부 테스터 비공개 배포 보류는 계속 유지한다.
