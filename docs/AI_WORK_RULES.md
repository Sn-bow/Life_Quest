# AI 작업 규칙

작성일: 2026-05-04  
대상: Codex, Claude, 기타 프로젝트 작업 에이전트

---

## 1. 작업 착수 전 조사

모든 관련 작업은 착수 전에 조사한다.

필수 확인:

- 현재 코드 위치
- 관련 에셋 존재 여부
- 기존 문서와 공유 작업 로그
- 최신 정책/제품/레퍼런스가 필요한 경우 공식 자료
- 변경 후 검증 명령

조사 없이 감으로 구현하지 않는다.

---

## 2. 에셋 우선 규칙

게임 비주얼 작업은 반드시 에셋을 우선한다.

우선순위:

1. 프로젝트에 이미 있는 PNG/SFX/BGM
2. 이전 세션에서 생성된 이미지/자료
3. 공식 자료 조사 후 새로 생성한 이미지
4. 라이선스가 명확한 외부 에셋
5. 임시 placeholder

임시 placeholder를 쓰면 [SHARED_WORK_LOG.md](./SHARED_WORK_LOG.md)에 이유, 제거 조건, 대체 계획을 기록한다.

---

## 3. 도형 최종 비주얼 금지

정식 배포 대상 게임 화면에서 다음을 금지한다.

- 플레이어를 선/원/사각형 기반 `CustomPainter`로 최종 표시
- 몬스터를 선/원/사각형 기반 `CustomPainter`로 최종 표시
- 카드 프레임을 단순 Container/border/gradient로 최종 표시
- 공격/방어/마법/사망 이펙트를 그림판 선 긋기처럼 보이는 도형만으로 최종 표시
- 이미 존재하는 이미지 에셋을 무시하고 새 도형 비주얼을 만드는 것

예외:

- 디버그 오버레이
- 에셋 로딩 실패 방지용 fallback
- 보조 파티클

예외도 배포 화면에 보이면 안 된다.

---

## 4. 기록 규칙

작업자는 매 작업마다 [SHARED_WORK_LOG.md](./SHARED_WORK_LOG.md)에 기록한다.

필수 항목:

- 날짜/시간
- 작업자
- 착수 전 조사한 자료
- 변경 파일
- 실행한 검증
- 결과
- 남은 위험
- 다음 작업

---

## 5. 배포 품질 기준

정식 배포 작업에서는 다음을 통과해야 한다.

- P0 버그 없음
- `flutter analyze` 통과
- `flutter test` 통과
- release AAB 생성
- 실제 Android 기기 핵심 루프 검증
- Firebase/AdMob/IAP/Crashlytics 운영 설정 확인
- 개인정보/스토어 등록 필수 항목 확인

---

## 6. 프로젝트 주의사항

- 아바타/캐릭터 커스터마이징 기능은 의도적으로 제거되었으므로 다시 만들지 않는다.
- `image_picker`, `firebase_storage`, `firebase_app_check`는 pubspec에 유지한다.
- Android applicationId는 `com.lifequest.app`를 유지한다.
- Dart package name은 `life_quest_final_v2`를 유지한다.
- iOS는 지원하지 않는다.
- 사용자 변경사항을 임의로 되돌리지 않는다.
