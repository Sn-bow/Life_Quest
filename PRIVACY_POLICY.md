# Life Quest 개인정보처리방침 / Privacy Policy

**최종 업데이트:** 2026년 5월 19일
**시행일:** 2026년 5월 19일
**개발자:** Log_Ian
**문의:** logian621@gmail.com

Life Quest는 일상의 목표와 퀘스트를 RPG 방식으로 관리하는 Android 앱입니다. 이 문서는 실제 Android 배포 앱 기준으로 어떤 정보를 수집하고, 왜 사용하며, 어떻게 보호하는지 설명합니다. 웹 QA Preview는 테스터용 임시 미리보기이며 실제 배포 앱과 데이터 처리 방식이 다를 수 있습니다.

## 1. 수집하는 정보

### 계정 정보

- 이메일 주소: Firebase Authentication을 통한 회원가입과 로그인에 사용합니다.
- Google 로그인 정보: 사용자가 Google 로그인을 선택한 경우 Google 계정의 이름, 이메일 주소, 프로필 사진을 사용할 수 있습니다.
- 사용자 ID: Firebase UID 등 계정 식별자를 계정 관리와 데이터 동기화에 사용합니다.

### 앱 진행 데이터

- 캐릭터 이름, 레벨, 경험치, 스탯, 칭호, 업적, 인벤토리, 보상, 던전 진행 상황
- 사용자가 만든 퀘스트 이름, 완료 기록, 설정값, 알림 사용 여부
- 위 데이터는 Firestore에 저장되어 로그인한 사용자의 진행 상황을 동기화하고 복원하는 데 사용됩니다.

### 선택적으로 제공하는 사진

- 회원가입 중 사용자가 프로필 이미지를 선택한 경우 해당 사진을 Firebase Storage에 업로드할 수 있습니다.
- 프로필 사진 선택은 선택 사항입니다.

### 앱 정보 및 성능 데이터

- Firebase Crashlytics를 통해 크래시 로그, 스택 트레이스, 기기/OS 정보, 앱 진단 정보, 설치 식별자가 수집될 수 있습니다.
- Firebase App Check를 통해 앱 무결성 확인에 필요한 기기/앱 증명 정보와 토큰이 처리될 수 있습니다.
- 이 정보는 오류 분석, 보안, 부정 사용 방지, 서비스 안정성 개선에 사용됩니다.

### 로컬 기기 데이터

- 앱 설정, 사운드 설정, 위젯 표시 정보, 로컬 알림 예약 정보는 기기 안에 저장될 수 있습니다.
- 로컬 알림은 사용자가 설정에서 직접 켠 경우에만 사용합니다.
- Health Connect, Google Fit, 위치, 연락처, 캘린더, SMS, 마이크, 파일 문서 데이터는 현재 Android 앱에서 수집하지 않습니다.

### 광고와 결제

- 기본 Android 릴리스 빌드에서는 AdMob 광고와 Google Play Billing 초기화가 비활성화되어 있습니다.
- 향후 광고 또는 인앱 결제를 활성화하는 버전을 배포하는 경우, Google Mobile Ads 또는 Google Play Billing이 광고 식별자, 광고 상호작용, 구매 내역, 영수증/권한 정보를 처리할 수 있습니다. 이 경우 정책과 Google Play Data safety 답변을 배포 전에 갱신합니다.

## 2. 정보 사용 목적

수집한 정보는 다음 목적으로만 사용합니다.

- 계정 생성, 로그인, 인증, 계정 관리
- 퀘스트와 캐릭터 진행 상황 저장, 동기화, 복원
- 프로필 표시와 앱 개인화
- 로컬 알림, 홈 위젯, 설정 등 앱 기능 제공
- 오류 진단, 크래시 분석, 보안, 부정 사용 방지
- 법적 의무 준수

Life Quest는 사용자의 건강 상태, 의료 기록, 실제 운동 센서 데이터, 위치 정보를 기반으로 판단하거나 수집하지 않습니다. 앱의 "건강" 스탯은 게임 내 분류명일 뿐 의료 또는 피트니스 데이터가 아닙니다.

## 3. 제3자 서비스

앱은 다음 서비스를 사용합니다.

- Firebase Authentication: 회원가입, 로그인, 계정 관리
- Cloud Firestore: 앱 진행 데이터 저장과 동기화
- Firebase Storage: 선택적 프로필 이미지 저장
- Firebase Crashlytics: 크래시 및 오류 분석
- Firebase App Check: 앱 무결성 확인과 보안
- Google Sign-In: 사용자가 선택한 경우 Google 계정 로그인
- Google Play services: Android/Firebase 기능 제공
- Google Mobile Ads 및 Google Play Billing: 기본 릴리스에서는 비활성화되어 있으며, 향후 활성화 시 별도 고지와 Data safety 재검토 대상

Firebase 보안 및 개인정보 처리에 대한 자세한 내용은 [Firebase Privacy and Security](https://firebase.google.com/support/privacy)를 참고하십시오.

## 4. 정보 공유

Life Quest는 개인정보를 판매하지 않습니다. 다만 다음 경우에는 정보가 처리되거나 제공될 수 있습니다.

- 위 제3자 서비스 제공자가 앱 기능 제공을 위해 개발자를 대신해 처리하는 경우
- 사용자가 Google 로그인, 프로필 사진 업로드, 계정 삭제 요청 등 특정 기능을 직접 사용하는 경우
- 법령, 법원 명령, 정부기관 요청 등 법적 의무가 있는 경우

## 5. 보관 기간

- 계정 및 앱 진행 데이터: 계정 삭제 요청 처리 시까지 보관합니다.
- 선택적 프로필 사진: 계정 삭제 요청 처리 시까지 보관합니다.
- 크래시 및 진단 데이터: Firebase/Google 서비스 정책과 콘솔 설정에 따라 보관됩니다.
- 로컬 설정과 알림 정보: 사용자가 앱 데이터 삭제, 설정 변경, 로그아웃 또는 계정 삭제를 할 때까지 기기에 남을 수 있습니다.

## 6. 삭제 및 사용자 권리

사용자는 본인의 개인정보 열람, 수정, 삭제를 요청할 수 있습니다.

- 앱 내 설정의 계정 삭제 기능을 사용할 수 있습니다.
- 앱에서 처리가 어렵거나 추가 확인이 필요한 경우 `logian621@gmail.com`으로 요청할 수 있습니다.
- 계정 삭제 시 Firebase 계정과 Firestore에 저장된 주요 앱 진행 데이터 삭제를 처리합니다. 선택적 프로필 이미지 등 Storage 데이터는 삭제 범위 확인 후 함께 처리해야 합니다.
- 법적 의무나 보안상 필요한 일부 기록은 관련 법령 또는 서비스 제공자 정책에 따라 제한적으로 보관될 수 있습니다.

## 7. 아동 개인정보

Life Quest는 만 14세 미만 아동을 대상으로 하지 않습니다. 만 14세 미만 아동의 개인정보를 의도적으로 수집하지 않으며, 그러한 사실을 알게 되면 적절한 삭제 조치를 취합니다.

## 8. 보안

Firebase 서비스는 전송 중 암호화와 보안 인프라를 제공합니다. 앱은 App Check를 사용해 앱 무결성 검증을 적용합니다. 다만 인터넷 전송과 전자 저장 방식은 완전한 보안을 보장할 수 없으므로, 합리적인 범위에서 보호 조치를 계속 개선합니다.

## 9. 정책 변경

개인정보 처리 방식이 바뀌면 이 문서를 갱신합니다. 중요한 변경이 있는 경우 앱, 웹페이지, 스토어 등록정보 등 적절한 수단으로 알립니다.

---

# Life Quest Privacy Policy

**Last updated:** May 19, 2026
**Effective date:** May 19, 2026
**Developer:** Log_Ian
**Contact:** logian621@gmail.com

Life Quest is an Android app that helps users manage daily goals and quests through RPG-style progression. This policy explains what information the production Android app collects, why it is used, and how it is protected. The web QA Preview is a temporary tester preview and may use different data handling from the production Android app.

## 1. Information We Collect

### Account information

- Email address for Firebase Authentication sign-up and login.
- Google account profile information, such as name, email address, and profile photo, if the user chooses Google Sign-In.
- User identifiers such as Firebase UID for account management and data sync.

### App progress data

- Character name, level, XP, stats, titles, achievements, inventory, rewards, and dungeon progress.
- User-created quest names, completion history, settings, and notification preference.
- This data is stored in Cloud Firestore to sync and restore the user's app progress.

### Optional photos

- If the user selects a profile image during sign-up, the image may be uploaded to Firebase Storage.
- Providing a profile image is optional.

### App information and performance data

- Firebase Crashlytics may collect crash logs, stack traces, device/OS information, diagnostics, and installation identifiers.
- Firebase App Check may process app/device attestation material and tokens for app integrity checks.
- This data is used for debugging, security, fraud prevention, and service stability.

### Local device data

- App settings, sound settings, widget display values, and local notification schedules may be stored on the device.
- Local notifications are used only after the user enables them in settings.
- The current Android app does not collect Health Connect, Google Fit, location, contacts, calendar, SMS, microphone, or files/documents data.

### Ads and purchases

- In the default Android release build, AdMob ads and Google Play Billing startup are disabled.
- If a future version enables ads or in-app purchases, Google Mobile Ads or Google Play Billing may process advertising identifiers, ad interactions, purchase history, and receipt/entitlement data. The policy and Google Play Data safety answers will be reviewed before such a release.

## 2. How We Use Information

We use collected information only to:

- Create accounts, authenticate users, and manage accounts.
- Save, sync, and restore quest and character progress.
- Display profile information and personalize app features.
- Provide local notifications, home widgets, and user settings.
- Diagnose errors, analyze crashes, protect security, and prevent abuse.
- Comply with legal obligations.

Life Quest does not collect or infer medical records, real health conditions, fitness sensor data, or location data. The in-app "Health" stat is only a game category, not medical or fitness data.

## 3. Third-Party Services

The app uses:

- Firebase Authentication for sign-up, login, and account management.
- Cloud Firestore for app progress storage and sync.
- Firebase Storage for optional profile image storage.
- Firebase Crashlytics for crash and error analysis.
- Firebase App Check for app integrity and security.
- Google Sign-In when selected by the user.
- Google Play services for Android/Firebase functionality.
- Google Mobile Ads and Google Play Billing are disabled in the default release build and require separate notice and Data safety review before activation.

For more information, see [Firebase Privacy and Security](https://firebase.google.com/support/privacy).

## 4. Sharing

Life Quest does not sell personal information. Information may be processed or disclosed only:

- By the third-party service providers listed above when they process data on behalf of the developer.
- When the user directly uses features such as Google Sign-In, profile photo upload, or account deletion requests.
- When required by law, court order, or government request.

## 5. Retention

- Account and app progress data is retained until account deletion is requested and processed.
- Optional profile images are retained until account deletion is requested and processed.
- Crash and diagnostic data is retained according to Firebase/Google service policies and console settings.
- Local settings and notification data may remain on the device until the user clears app data, changes settings, logs out, or deletes the account.

## 6. Deletion and User Rights

Users may request access, correction, or deletion of their personal information.

- Users can use the account deletion feature in app settings.
- If additional help is needed, users can contact `logian621@gmail.com`.
- Account deletion removes the Firebase account and primary app progress data stored in Firestore. Optional profile images in Storage should be reviewed and deleted as part of the deletion process.
- Some records may be retained for a limited time if required by law, security, or service-provider policies.

## 7. Children's Privacy

Life Quest is not directed to children under 14. We do not knowingly collect personal information from children under 14. If we learn that such information has been collected, we will take appropriate deletion steps.

## 8. Security

Firebase services provide encryption in transit and security infrastructure. The app uses App Check for app integrity verification. No internet transmission or electronic storage method is completely secure, but we continue to apply reasonable safeguards.

## 9. Changes

We may update this policy when our data practices change. Material changes will be communicated through appropriate channels such as the app, web page, or store listing.
