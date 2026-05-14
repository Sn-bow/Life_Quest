# Life Quest 피드백 반영 계획

작성일: 2026-05-14 KST

## 목적

Threads 테스터 모집 직후 받은 Web QA Preview 피드백을 코드 기준으로 검증하고, 실제 테스터가 다시 눌러볼 때 막히는 문제를 우선 제거한다.

## 우선순위

### P0: 즉시 수정

1. 이벤트 결과의 `계속` 후 빈 화면
   - 원인 후보: 이벤트 화면 pop 이후 던전 맵에서 노드를 완료 처리하면서 event state가 비워지는 흐름이 불명확하다.
   - 조치: 이벤트 화면은 `true` 결과로 명시 pop하고, 맵은 `true`일 때만 node complete를 수행한다. event null fallback은 자동으로 맵에 복귀하게 만든다.

2. 던전 노드 진입 시 로딩 피드백 없음
   - 원인: 노드 탭 즉시 visual busy state가 없고, Web에서 route/asset 로딩이 걸리면 멈춘 것처럼 보인다.
   - 조치: 선택한 노드 id를 pending state로 잡고, 맵 위에 반투명 progress overlay를 표시한다.

3. Web 스크롤/드래그 불편
   - 원인: Flutter Web 기본 ScrollBehavior가 마우스 드래그 스크롤을 사용자가 기대하는 방식으로 처리하지 않는다.
   - 조치: 앱 전역 ScrollBehavior에 mouse/stylus/unknown drag device를 추가한다.

### P1: 이번 회차에서 함께 수정

4. 카드 팩 첫 진입 이미지 지연
   - 조치: 카드 팩에서 뽑힌 카드의 full-body/card-art asset을 즉시 precache한다.

5. 던전 상점 구매 확인 없음
   - 조치: 카드/유물 구매 전 확인 다이얼로그를 띄운다.

6. 업적 진행 바가 너무 작아 안 보임
   - 조치: 낮은 진행률도 4% 이상으로 보이게 최소 표시값을 둔다. 숫자는 실제 값을 유지한다.

7. 퀘스트 탭 잘림
   - 현재 `isScrollable: true`는 적용되어 있다.
   - 조치: tabAlignment/start, label padding/font size를 조정해 가로 스크롤 가능성을 더 분명히 한다.

## 별도 설계 필요

- HP/체력 용어 혼선: 생활 HP, 던전 HP, 건강 스탯 용어를 분리해야 한다.
  - 권장 명칭:
    - 생활 관리 체력: `생활 HP`
    - 던전 전투 체력: `전투 HP`
    - 캐릭터 능력치: `건강`
  - UI에서는 세 값을 같은 줄에 비교 노출하지 않는다.
- 카드명/아트 불일치: 현재 공통 category body art 구조의 한계다. 카드별 또는 속성별 body art가 필요하다.
  - 1차: 기본/공통 카드 11장 개별 art를 full-body 카드로 승격.
  - 2차: 속성 키워드(서리/화염/독/빛/암흑/방패/검 등) 기준 body set 추가.
  - 3차: 전체 207장 카드별 art audit.
- 타이머 접근성: 상태창의 보조 액션이 아니라 퀘스트/하단 내비게이션과의 관계를 다시 설계해야 한다.

## 검증 기준

- `flutter analyze --no-pub`
- 관련 단위 테스트 또는 전체 `flutter test`
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none`
- Firebase Hosting 재배포
- 공개 URL smoke QA

## 반영 결과

### 완료된 코드 수정

- 이벤트 화면
  - `계속` 버튼이 `Navigator.pop(true)`로 완료 여부를 명시 반환.
  - 이벤트 데이터가 비어 있으면 화면에 고립되지 않고 자동으로 이전 화면에 `false` 반환.
- 던전 맵
  - 노드 탭 중 `_pendingNodeId`를 잡아 중복 탭을 차단.
  - 진입 중 overlay + spinner 표시.
  - 이벤트 노드는 `true` 반환일 때만 완료 처리.
- 앱 전역
  - `LifeQuestScrollBehavior` 추가.
  - Web/desktop에서 mouse, stylus drag scroll 허용.
- 카드 팩
  - 뽑힌 카드의 full-body/card-art asset을 `precacheImage`로 미리 로드.
- 던전 상점
  - 카드/유물 구매 전 확인 다이얼로그 추가.
- 업적
  - 낮은 진행률도 최소 4%로 보이게 표시. 실제 숫자는 그대로 유지.
- 퀘스트
  - 탭 바 `tabAlignment`, padding, font size 조정으로 긴 탭 라벨의 잘림 체감 완화.
- Web shell
  - 사용되지 않는 splash picture 제거. CSP inline script 제거 이후 splash가 앱을 덮을 위험 차단.

### 검증 결과

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 공개 URL smoke QA:
  - page title `Life Quest`
  - `flutter-view` mount 확인
  - `#splash` DOM 제거 확인
  - Google Sign-In web script는 CSP가 차단 중. QA Preview에서는 로그인 미사용이므로 허용하지 않음.

### 남은 후속 작업

- HP/체력/건강 용어 통합 정리.
  - 상태창 라벨: `생활 HP`
  - 던전/전투 라벨: `전투 HP`
  - 인벤토리 파생값 라벨: `건강 보정`
- 카드별/속성별 full-body art 매칭.
  - `CardBodyAssets`에 카드별 full-body override 구조 추가.
  - 세부 생성/등록 계획은 `docs/card-full-body-generation-plan.md` 섹션 10에 기록.
- 타이머 접근 경로 재설계.
  - 퀘스트 화면 AppBar에 집중 타이머 진입 버튼 추가.
- 던전 맵 범례/현재 위치 강조.
  - 맵 상단에 노드 타입 범례 추가.
  - 선택 중인 노드는 `현재` 배지와 흰색 강조 테두리로 표시.
  - 진행 가능한 노드는 작은 컬러 점으로 표시.

### P2 추가 검증 결과

- `flutter analyze --no-pub` -> No issues found.
- `flutter test --no-pub` -> 96개 전체 통과.
- `flutter build web --dart-define=LIFEQUEST_QA_PREVIEW=true --pwa-strategy=none` -> 성공.
- Firebase Hosting 재배포 -> 성공.
- 공개 URL smoke QA -> `Life Quest` title, Flutter Web view mount, splash 제거 확인.
- Google Sign-In web script CSP 차단은 의도된 상태로 유지한다. QA Preview는 게스트 테스트 전용이며 외부 로그인 스크립트를 허용하지 않는다.
