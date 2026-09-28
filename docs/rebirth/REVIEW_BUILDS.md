# 검토 파일 재현과 배포 구분

## 유료 비공개 테스트 대상 · 2.0.0+2013

`pubspec.yaml`의 versionCode2013에서 아래 네 플래그로 signed AAB를 만들었다. 최종 로컬 사본은 `build/review/life-quest-2.0.0-2013-paid-candidate.aab`(242,279,230bytes), SHA-256 `be65f4e7751d4f82c0e7b845da09eb20415f5a76bf1a472d048a16e2d58864ab`; 소스 커밋 `e6dd1ea`이다. [실제 +2013 검사](paid-candidate-2013-inspection.json)는 versionCode2013, 결제 권한, 광고 ID·Mobile Ads 부재, 공개 업로드 인증서, API36, 네이티브 ELF/표본 split ZIP 16KB 정렬, 표본 ARM64/API35/16KB 다운로드 149,179,287bytes를 확인한다. 표본 split은 검사 전용이며 업로드 파일이 아니다. **Android API35/420dpi 에뮬레이터 UI는 확인했지만 물리 기기·Play 게시·결제 작동·유료 수요는 검증되지 않았다.** 출시 범위와 순서는 [유료 후보 판단](market/PAID_RELEASE_CANDIDATE_20260928.md)을 따른다.

Android UI 확인용 universal signed APK는 `build/review/life-quest-2.0.0-2013-paid-review.apk`, SHA-256 `beabedbc176642d83fa8e8b80baeeec8429420a3a608bf9e27e8229fffa1ec90`이다. `aapt`에서 versionCode2013/min SDK26/target SDK36, `apksigner`에서 업로드 인증서와 APK v2 서명, `zipalign -c -P 16 4`에서 16KB 정렬을 확인했다. **이 APK는 Play 제출용 AAB가 아니다.** 새 3탭 구성의 Android 재검증은 [시각 QA 기록](design/status-system/FINAL_VISUAL_QA_20260928.md)을 따른다. 물리 기기 검증은 남아 있다.

```sh
flutter build appbundle --release \
  --dart-define=LIFEQUEST_CLOUD_ENABLED=true \
  --dart-define=LIFEQUEST_MONETIZATION_ENABLED=true \
  --dart-define=LIFEQUEST_ADS_ENABLED=false \
  --dart-define=LIFEQUEST_QA_PREVIEW=false
```

### 이전 +12 검사 기록

`build/review/life-quest-2.0.0-12-paid-candidate.aab`는 이전 signed 후보이며 SHA-256 `4d1eb1f7a987fa5858cbd081ad5f1802db060b01a71a7ac5fe208300f5b3de88`이다. [당시 실제 검사 결과](paid-candidate-12-inspection.json)는 결제 권한, 광고 ID 부재, 서명, API36, 16KB 정렬과 표본 ARM64 다운로드 149,169,238bytes를 확인한다. 이 결과를 +2013의 검사 통과로 간주하지 않는다. 당시 파일도 **Play 게시/결제 작동/유료 수요의 검증은 아니다.**

앱 코드를 커밋한 다음 그 커밋에서 빌드한다. 최신 v7 공개 APK/AAB는 같은 소스와 기본off 플래그를 사용한다. 아래 v6 연구용 파일은 과거 내부 산출물이다. 빌드·서명 검사는 공개 판매 승인이 아니다. [수익화 검증](REVENUE_VALIDATION.md)과 [출시 조건](RELEASE_GATES.md)을 먼저 따른다.

## 현재 공개 ARM64 APK · 2.0.0+7

소스 `d69aafbaef9b761198af29ac07c76dae5ddb0f24`. Cloud/Billing/Ads/Research 기본false.

```sh
flutter build apk --release --split-per-abi \
  --target-platform android-arm64 \
  -Pforce-version-code-ignoring-abi=true
```

실제 versionCode7을 검사했고 `LifeQuest-2.0.0-preview.1-arm64.apk`로 [공개했다](https://github.com/Sn-bow/Life_Quest/releases/tag/v2.0.0-preview.1). [APK 검사](public-preview-apk.json), [외부 다운로드 검증](public-distribution.json). 검사 명령의 `--version-code 7`, `--source-commit` 및 APK 경로를 이 파일과 맞춘다.

같은 소스의 기본 AAB도 빌드·서명·16KiB 검사를 통과했다. versionCode7, 221,661,496bytes, 표본 ARM64/API35 다운로드130,435,164bytes. [AAB 검사](artifact-inspection.json). Play Console에는 아직 업로드되지 않았다.

## 과거 내부 연구용 ARM64 APK · v6


```sh
flutter build apk --release --split-per-abi \
  --target-platform android-arm64 \
  --dart-define=LIFEQUEST_RESEARCH_ENABLED=true \
  -Pforce-version-code-ignoring-abi=true
```

결과는 `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`다. 설치 전달용 사본은 `qa_artifacts/rebirth/LifeQuest-2.0.0-6-research-arm64.apk`다. 현재 Flutter의 ABI 분리 빌드는 기본적으로 Android versionCode에 ABI 접두 숫자를 더한다. 마지막 옵션으로 pubspec의 versionCode6을 유지한 뒤 실제 manifest에서6인지 검사했다. 기기별 라이브러리 분리로 사용하지 않는 아키텍처의 JNI를 제외했다. 앱 권한을 줄이기 위해 검사나 서명 검증을 생략하지 않는다.

`LIFEQUEST_CLOUD_ENABLED`, `LIFEQUEST_MONETIZATION_ENABLED`, 광고 플래그는 기본false다. 참여 메뉴가 있다고 자동 수집하지 않으며 별도 직접 참여가 필요하다. 처음 두 장면 무료 체험은 가능하지만 유료 팩 소유권을 우회하는 기능은 없다.

실제 산출물 검사는 공개 인증서 지문·실제 versionCode·빌드 소스 커밋을 전달한다. 비밀키를 인수로 넣지 않는다.

```sh
python3 scripts/inspect_review_apk.py \
  --apk qa_artifacts/rebirth/LifeQuest-2.0.0-6-research-arm64.apk \
  --build-tools "$ANDROID_SDK_ROOT/build-tools/36.0.0" \
  --certificate-sha256 <PUBLIC_UPLOAD_CERTIFICATE_SHA256> \
  --version-code 6 --source-commit <BUILD_SOURCE_COMMIT> \
  --output docs/rebirth/apk-inspection.json
```

경로·버전·소스 값은 다음 빌드 때 실제 값으로 바꾼다. 업로드 키 서명이 Play 앱 서명과 다르면 Play 버전 전환 시 백업 후 재설치가 필요할 수 있다. 설치 자체가 Play 비공개 테스트 참여로 인정되는 것은 아니다.

## 기본 기능 플래그의 AAB

```sh
flutter build appbundle --release
python3 scripts/inspect_release_artifact.py \
  --certificate-sha256 <PUBLIC_UPLOAD_CERTIFICATE_SHA256> \
  --output docs/rebirth/artifact-inspection.json
```

연구/Cloud/결제/광고가 기본off인 AAB를 만든다. 기기별 다운로드 크기와 ZIP 정렬까지 확인하려면 이 AAB로 bundletool의 기기별 검사 `apks`를 만든 뒤 `--device-apks`와 `--device-spec`을 함께 전달한다. 그 검사split은 debug서명이므로 사용자에게 배포하지 않는다. `integration_test` probe 진입점의 파일도 배포하지 않는다.

현재 도구는 Flutter3.47.4/Dart3.13.3/JDK21/SDK36이다. Gradle8.14.3/AGP8.13.2 향후 지원 경고는 별도 업그레이드 과제이며, 현재 빌드가 통과했다고 경고를 숨기거나 무검증으로 AGP9로 바꾸지 않는다. 같은 checkout의 Flutter 작업은 직렬로 실행한다.

공식 Firebase CLI와 실제 artifact 검사 도구를 사용한다. Firebase MCP도 같은CLI 인증을 쓰므로 프로젝트/계정/권한의 선행 문제를 해결하지 않는다. fastlane supply의 업로드 자동화는 프로젝트·Play API 접근·상품·실물/수익 검증이 준비된 뒤 연결한다. 키 발급이나 자동 공개 배포는 이 문서의 명령에 포함되지 않는다.
