# 무료 기기 백업 · 2026-09-14

기기 전용 기록을 사용자가 선택한 파일로 옮긴다. 핵심 개인화와 백업을 유료 구독에 묶지 않는 제품 원칙을 따른다. 목표/퀘스트를 개발자 서버에 업로드하지 않는다.

## 사용 흐름과 범위

성장 → 설정 → 백업과 복원. 12–128자의 비밀번호를 두 번 입력해 `.lqbackup` 파일을 만들고 저장 위치를 직접 고른다. 불러오기는 비밀번호 확인 → 이름/레벨/생성일 미리보기 → 교체 확인 순서다. 복원 직전 기기 기록 한 벌을 보관해 되돌릴 수 있다. 재시작 시 중단된 복원 journal을 완료한다.

포함: 표시 이름, 퀘스트·완료 기록, 능력치·인벤토리·완료한 던전, 이야기 선택, 개인화 프로필·피드백. 제외: Firebase 신원, 구매 토큰/권한, 프로필 사진 URL, AI 모델, 진행 중인 탐험. 알림은 복원 후 꺼진 상태로 시작한다. 유료 외형 권한은 파일에서 부여하지 않고 향후 연결된 구매 계정에서 재조회한다.

현재 던전 run은 메모리에만 있으며 앱 재시작을 넘겨 복구하지 않는다. 앱 안에서 지도에서 뒤로 나간 경우는 계속 진행할 수 있다. 새 프로필/백업 복원으로 메인 화면을 재생성할 때 이전 프로필의 run을 초기화한다. 전투 중 앱 종료 복구와 중복 보상 방지는 다음 구현 범위다.

## 형식과 신뢰 경계

- AES-256-GCM, 매번 새로운 128bit salt와 96bit nonce, 128bit 인증 태그.
- PBKDF2-HMAC-SHA256 600,000회, 256bit 키. UTF-8 비밀번호를 그대로 사용하므로 공백·대소문자·Unicode가 의미를 가진다. 버전과 알고리즘을 고정한 AAD로 인증한다.
- `cryptography` 2.9.0 / `cryptography_flutter` 2.3.4. Android에서는 등록된 FlutterCryptography 백엔드를 실제 release에서 확인했다. 자체 암호 프리미티브를 작성하지 않았다.
- 암호화 전에 허용한 필드만 직렬화하며, 복호화 뒤 크기·중첩·버전·값·중복 퀘스트·개인화 날짜를 검증한다. 파일 최대 8MiB, 평문 최대 4MiB. 파일에서 임의 작업 횟수를 받아들이지 않는다.
- 비밀번호/평문을 로그·분석·서버로 보내지 않는다. mutable 키와 평문 buffer는 사용 후 지우지만, Dart 문자열의 메모리 완전 소거를 보장하지 않는다. 비밀번호를 잊으면 복구할 수 없다.
- 자동 Android 클라우드/D2D 추출은 명시적으로 제외한다. 사용자가 파일 저장 위치로 외부 드라이브를 고르면 암호화된 파일이 그 제공자에게 전달된다.
- restore journal/undo는 원래 로컬 프로필과 같은 앱 전용 저장 공간의 기록이다. 로컬 프로필 삭제 시 함께 제거한다. 사용자가 내보낸 파일은 별도로 삭제해야 한다.

PBKDF2 수치는 [OWASP의 HMAC-SHA256 작업량 지침](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)을 참고했다. 네이티브 가속과 기기 간 이식성을 위해 선택했으며, 암호 제품의 FIPS 인증이나 독립 보안 감사를 주장하지 않는다. 패키지 출처: [cryptography](https://pub.dev/packages/cryptography), [cryptography_flutter](https://pub.dev/packages/cryptography_flutter), [file_picker](https://pub.dev/packages/file_picker).

## 검증 증거

- crypto/schema 8개, 장애 주입을 포함한 restore store 4개, 4언어 320px/200% UI 4개 통과.
- 순수 Dart에서 만든 합성 Unicode 파일을 Python cryptography로 독립 복호화 성공.
- 16KiB ARM64 Android 에뮬레이터에서 서명·R8 적용 release target으로 순수 Dart 파일을 복호화하고 네이티브로 재암호화/왕복 성공. 그 파일도 Python에서 복호화 성공. 두 방향에 같은 공개 합성 passphrase 사용. 최종 측정: 복호화 1,475ms, 암호화 1,460ms. 실물 휴대폰 성능 측정이 아니다.
- CUA 브라우저 실화면: 합성 파일 import → 교체 확인 → 이름/퀘스트 반영 → 재시작 유지 → undo로 기존 이름·퀘스트 복귀. 실제 UI export 파일도 Python으로 복호화해 XP 60, 이야기 선택 2개 유지 확인.
- 최초 네이티브 QA 로그 추출은 1,000자 chunk가 Android 로그에서 잘려 재조합에 실패했다. 500자 번호 붙인 chunk와 SHA-256/길이 검증으로 수정했고 암호 파일 자체의 오류가 아님을 확인했다.
- Android 네이티브 파일 선택/저장 UI는 아직 실기기 검증 전이다. 앱 번들 검사는 이 간극을 대체하지 않는다.

원시 QA 자료는 Git 제외 `qa_artifacts/rebirth/`에 보관한다. 요약은 `backup-validation.json`. QA entrypoint `integration_test/native_backup_probe.dart`는 opt-in이 필요하고, 번들 검사는 해당 probe 문자열을 포함한 제품을 거부한다.
