# 검증 — 2026-09-22

앱 소스: `785cf93532ba9284991ccef985b68175d595587d` (기능 커밋 `0ea5125`, 마지막 lint-only 수정 `785cf93`). 기존 개인 마케팅 초안 변경은 이 작업에 포함하지 않았다.

| 확인 | 결과 |
| --- | --- |
| `flutter test --no-pub --reporter expanded` | 427 pass, 1 intentional skip (별도 Cloud/Billing on catalog command) |
| 마지막 수정 후 system_journal, system_scene, director_layout | 21 pass |
| `flutter analyze --no-pub` | No issues found |
| `flutter build web --release --dart-define=LIFEQUEST_QA_PREVIEW=true --output build/status-preview` | 성공 |
| 실제 브라우저 QA | 신규 0 XP, 추천 수락, 10+50 지급, 돌발 수락/재시작/마감 유지, +15 지급, 75 XP 재시작 유지, 기록 재열기 |
| 작은 화면/번역/접근성 | 320px, 글자 200%, KO/EN/JA/zh, 모션 감소, 레벨업 실제 능력 변화 검사 통과 |
| 데이터/오류 | 저장 실패 재시도, 중복 지급 방지, 거절 무페널티, 마감 경계, 일/주 제한, backup 왕복 검사 통과 |
| 디자인 비교 | `design-qa.md` — Web QA passed |

알려진 검증 한계:

- 연결된 Android 실기 없음. APK 빌드/서명 검증을 실기 실행 검증으로 표현하지 않는다.
- Web QA는 온디바이스 모델 추론이나 Android 소리/진동 성능을 검증하지 않는다.
- Android 빌드는 기존 AGP/Gradle의 향후 지원 경고, web 빌드는 기존 flutter_timezone의 Wasm dry-run 경고가 있다. 일반 JS web release와 Android release의 성공 여부와 별개다.
- 기본 monetization/cloud/ads off 정책 유지. Play Console 업로드나 심사 제출 없음.

## 최종 Android 검증

- ARM64 release 2.0.0+8 생성. 저장 위치: `build/review/life-quest-2.0.0-8-status-arm64.apk`.
- 공개 업로드 인증서 일치, applicationId/version/target API 36, 릴리스 플래그, ZIP/ELF 16KiB 정렬 검사 모두 통과.
- 새 raster/명조 폰트/OFL 라이선스 번들 확인.
- SHA-256: `160e209a4c2d6ec2c22c7a47c599e7a68fc389e6e90f4f2bb0060b1b0aa26b6f`. 자세한 결과: [apk-inspection.json](apk-inspection.json).
- Android 실기/에뮬레이터 실행은 미검증, Play 미업로드.
