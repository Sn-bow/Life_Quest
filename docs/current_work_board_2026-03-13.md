# Life Quest 현황판 작업지시서

작성일: 2026-03-13  
기준 프로젝트: `life_quest_final_v2`

## 1. 현재 상태 요약

- GitHub 연동 완료
  - 원격 저장소: `https://github.com/Sn-bow/Life_Quest.git`
- macOS 기준 Flutter/Android 빌드 가능
- Android debug/release/apk/aab 빌드 검증 완료 이력 있음
- 광고 중심 수익화 방향으로 구조 정리 완료
- 상세 리포트 확장, 광고 해금, 퀘스트 달력, 카테고리 기반 성장, 월간/연간 퀘스트, 레이드 보상, HP 자연 회복 등은 1차 구현 완료
- 현재 가장 큰 미완료 영역은 `캐릭터/전투/도트 자산 퀄리티`임

## 2. 캐릭터 관련 현재 상태

- 기존 상태창 도트 캐릭터는 사용자 기준 미달로 판단
- 사용자가 원한 기준:
  - 한국/모바일 시장에서 통할 수준의 귀엽고 정돈된 도트 캐릭터
  - 사용자가 제공한 샘플 이미지 수준
  - 단순히 머리만 큰 캐릭터가 아니라, 머리-몸-다리 비율이 균형 잡힌 치비형 캐릭터
- 현재 앱에서는 기존 캐릭터를 제거함
  - 상태창: `캐릭터 리빌드 중` placeholder 표시
  - 가입 화면: `캐릭터 재작업 중` placeholder 표시
- 최신 확인 화면:
  - [tmp_profile_removed.png](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/tmp_profile_removed.png)

## 3. 사용자가 명시한 핵심 지시사항

### 캐릭터/아트 방향

- 현재 캐릭터는 폐기하고 처음부터 다시 시작
- 사용자가 제공한 샘플 캐릭터를 기준으로 작업
- “비슷한 느낌”이 아니라, 최대한 그 기준에 맞추는 것을 목표로 할 것
- 머리만 키우는 식으로 접근하지 말 것
- 캐릭터는 현실의 나를 투영하는 느낌이어야 함
- 직업형 캐릭터처럼 보이면 안 됨
- 최종적으로는 사냥 화면에서 내 캐릭터가 보여야 함

### 도트 전투 확장 방향

사용자가 원하는 최종 범위:

1. 캐릭터 구현
2. 사냥 몬스터 각각의 디자인 구현
3. 인벤토리 무기 / 방어구 / 장신구 디자인 구현
4. 스킬 / 공격 / 방어 / 도망 이펙트 구현

추가로 이미 조사해서 포함해야 한다고 정리된 범위:

- 전투 애니메이션 상태
  - `idle`, `attack`, `hit`, `defend`, `run`, `victory`, `defeat`
- 전투 피드백
  - 데미지 숫자, 크리티컬, 회피, 회복, 버프/디버프
- 장비 오버레이
  - 무기/방어구/장신구 외형 반영
- 몬스터 티어 구분
  - 일반, 엘리트, 보스
- 드랍/전리품 연출
- 전투 배경/바닥/분위기 레이어

### 작업 방식 관련 지시

- 단순 설명만 하지 말고 실제 구현할 것
- 에뮬레이터에서 직접 확인하면서 진행할 것
- 현황과 작업 방향을 문서로 남길 것

## 4. 현재까지 완료된 주요 기능 작업

### 수익화/광고

- 광고 중심 수익화 구조로 정리
- 인앱결제 중심 노출 축소
- 보상형 광고 흐름 1차 검증
- 상세 리포트 광고 해금 구현

### 리포트/성장

- 광고로 여는 확장 리포트
- 퀘스트 달력
- 카테고리 기반 성장 반영
- 자동 성장/성향 분석
- HP 자연 회복 로직
- 월간/연간 퀘스트
- 레이드 보상 1차

### 전투/아바타 구조

- 전투용 플레이어/몬스터 스프라이트 구조 1차 연결
- 상태창/가입 화면의 캐릭터 미리보기 구조를 여러 번 시도했으나 현재 폐기
- 현재는 새 캐릭터를 다시 만들기 위한 placeholder 상태

## 5. 현재 미완료 / 재작업 필요 항목

### 최우선

1. 상태창용 새 도트 캐릭터 베이스 제작
2. 가입 화면용 동일 캐릭터 베이스 적용
3. 샘플 기준으로 최소 1개 기본 프리셋 완성
4. 에뮬레이터 직접 확인

### 그 다음

5. 같은 스타일로 프리셋 4종 확장
6. 전투용 풀바디 캐릭터 재설계
7. 몬스터 3종 이상 스타일 통일
8. 장비 아이콘/오버레이 자산 구축
9. 공격/방어/도망/피격 이펙트 구축

## 6. 캐릭터 리빌드 작업 원칙

- 현재 placeholder를 기준으로 새 캐릭터를 별도 제작
- 기존 실패한 캐릭터 도형을 억지로 재사용하지 말 것
- 우선 1개 “기준 캐릭터”를 제대로 만든 뒤 파생형을 만들 것
- 샘플 기준으로 다음을 우선 맞출 것
  - 얼굴형
  - 앞머리/헤어 실루엣
  - 눈 가독성
  - 상체/다리 비율
  - 의상 읽힘
- 상태창 카드 안에서 캐릭터가 충분히 눈에 띄어야 함

## 7. 즉시 다음 작업

### 작업명

`상태창 기본 도트 캐릭터 리빌드 1차`

### 목표

- placeholder를 제거하고
- 사용자 샘플 기준의 새 기본 캐릭터 1종을 상태창에 반영
- 에뮬레이터 캡처로 직접 확인

### 완료 조건

- 상태창에서 새 캐릭터가 표시됨
- 사용자가 봤을 때 기존 실패 버전과 명확히 다름
- 얼굴/앞머리/몸 비율이 샘플 기준으로 개선됨
- `flutter analyze` 통과
- `flutter build apk --debug` 통과
- 에뮬레이터 직접 캡처 완료

## 8. 현재 관련 파일

### 상태창 / 가입 화면

- [status_screen.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/screens/status_screen.dart)
- [signup_screen.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/screens/signup_screen.dart)

### 캐릭터 렌더링 관련

- [player_profile_sprite.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/widgets/player_profile_sprite.dart)
- [player_avatar_view.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/widgets/player_avatar_view.dart)

### 전투 관련

- [player_battle_sprite.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/widgets/combat/player_battle_sprite.dart)
- [monster_battle_sprite.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/widgets/combat/monster_battle_sprite.dart)
- [combat_arena_view.dart](/Users/jeonghyeonseok/Desktop/ai_workspace/life_quest_final_v2/lib/widgets/combat/combat_arena_view.dart)

## 9. 주의사항

- 현재 앱에 보이던 실패한 캐릭터는 제거된 상태이므로, 이 placeholder 위에 새 캐릭터를 올려야 함
- 다시 이전 실패 버전을 복원하지 말 것
- 현재 워크트리는 여러 변경이 섞여 있으므로 관련 없는 변경은 건드리지 말 것

