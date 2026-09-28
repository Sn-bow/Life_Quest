# 카드 탐험의 출시 범위 결정 · 2026-09-28

## 결론

**새 카드·몬스터·보스·전투 콘텐츠 개발을 보류한다.** 이 결정은 게임을 좋아할 사용자가 없다는 뜻이 아니다. 기존 시장 조사와 9월 28일 재확인으로는 **전투를 추가하면 Life Quest의 현실 퀘스트 완료율, 7일 유지율 또는 유료 확장팩 구매가 개선된다**는 근거가 없다. [상태창 확장팩 벤치마크](STATUS_PACK_BENCHMARK_20260928.md)는 일회 구매 상품 형태를 비교한 것이며 게임 확장의 수익성 검증이 아니다.

초기 Play 후보에서는 이미 만든 카드 탐험과 저장 기록을 보존하되 **보조 진입**으로 둔다. 하단의 핵심 이동은 상태창 → 현실 퀘스트 → 성장 기록에 집중한다. 유료 `status_window_plus_01`은 이 핵심 기록의 외관·30/90일 분석·기기 저장 기능이고 전투 진행이나 능력치 보너스를 팔지 않는다. 기존 탐험을 숨기거나 데이터를 삭제하지 않으며, 새 게임 콘텐츠에 출시 시간을 쓰지 않는다.

이 범위는 `ef71ea0`의 하단 3탭 변경과 `e6dd1ea`의 일본어 화면 현지화에 반영됐다. [최종 Android 현장 QA](../design/status-system/FINAL_VISUAL_QA_20260928.md)에서 상태창·현실 퀘스트·상세 상태의 표시를 확인했지만, 이 결과는 게임의 수익 효과나 실제 사용자 수요를 입증하지 않는다.

## 공개 자료에서 알 수 있는 것과 없는 것

| 공식 등록정보 | 관찰 가능한 것 | 판단의 한계 |
| --- | --- | --- |
| [Habitica](https://play.google.com/store/apps/details?hl=ja&id=com.habitrpg.android.habitica), [Habit Hunter](https://play.google.com/store/apps/details?id=co.au.goalhero) | 현실 과제와 게임 전투를 결합한 앱이 존재한다. 조회 시 Play의 누적 설치 표시는 각각 500만+, 10만+였다. | 이 앱들의 설치·결제·유지가 **전투 덕분인지** 확인할 수 없다. |
| [Do It Now](https://play.google.com/store/apps/details?hl=en_US&id=com.levor.liferpgtasks), [LifeUp](https://play.google.com/store/apps/details?id=net.sarasarasa.lifeup) | 상태·능력치·퀘스트·보상 중심 앱도 존재한다. 조회 시 누적 설치 100만+, 10만+였다. LifeUp은 유료 일회 구매 앱이다. | 이 수치도 Life Quest의 판매량이나 전투를 제거했을 때의 성과를 예측하지 않는다. |
| 일본어 [HibaQuest](https://play.google.com/store/apps/details?hl=ja&id=quest.hiba.melon), [Solo Mode](https://play.google.com/store/apps/details?id=com.solomode.solomode), [Taskoria](https://play.google.com/store/apps/details?hl=ja&id=com.vladyem.taskoria) | 현실 행동을 RPG 진행과 묶은 작은 규모의 가까운 사례다. 조회 시 각각 5천+, 1천+, 100+ 설치로 표시됐다. | 장르가 비슷하다는 이유만으로 일본의 넓은 수요, 전투의 효과나 구매 의사를 단정할 수 없다. |

Play 설치 표시는 누적·구간화된 공개 숫자다. 활성 사용자·7일 유지·결제 전환·순매출이 아니다. Life Quest는 Play 설치 사용자 0인 초안 상태이고, 공개 APK의 다운로드도 내부 검증 다운로드와 섞여 있어 게임의 수요 근거로 사용할 수 없다. 현재 실제 이용 코호트와 유료 거래 자료가 없다.

## 이 앱에서 특히 중요한 이유

- [현재 이동 구조](../../../lib/screens/main_screen.dart)는 상태창·현실 퀘스트·성장 기록을 하단 3탭에 두고, 기존 탐험은 보조 화면에서 연다. 이전 4탭 구조에서는 검증되지 않은 게임 루프가 핵심 자리 하나를 사용했으므로 `ef71ea0`에서 위치를 바꿨다.
- [던전 결과 처리](../../../lib/state/character_state.dart)는 게임 결과 XP를 현실 퀘스트와 같은 캐릭터 XP·레벨에 합산한다. 따라서 `Lv.`의 모든 상승을 현실 행동의 결과라고 설명하면 틀리다. 유료 30/90일 보고서는 **기록된 현실 퀘스트 완료**를 계산하며 던전 XP를 현실 행동으로 재분류하지 않는다.
- 게임은 기존 사용자 저장·진행과 연결되어 있다. 데이터를 유지한 채 진입 위치만 보조로 내리는 편이, 코드를 급히 삭제하거나 보상 규칙을 바꾸는 것보다 출시 전 위험이 작다. 일본어 전투에 한국어 몬스터명이 보였던 QA 이슈처럼, 게임 표면을 계속 늘릴수록 현지화·등급·화면 검수 범위도 커진다.

## 이후 확장 여부를 결정하는 조건

초기 유입 뒤 상태창을 열고 현실 퀘스트를 실제로 완료하는 비율, 7일 재방문, 성장 기록 조회, Plus 상세 진입과 실구매·환불을 먼저 측정한다. [Google Play의 유지율 정의](https://support.google.com/googleplay/android-developer/answer/16394358?hl=en)를 기준으로 하되 Play 집계만으로 탐험의 인과 효과를 추정하지 않는다. 사용자 동의와 데이터 보안 고지에 맞는 측정 방법을 정한 다음, 충분한 표본에서 탐험 노출 여부를 비교한다. **현실 퀘스트 완료와 7일 유지가 개선되고 Plus 구매가 악화되지 않을 때만** 새 게임 콘텐츠를 검토한다. 12명의 필수 비공개 테스트, 경쟁 앱 다운로드 또는 합성 QA 데이터로 이 결론을 대신하지 않는다.
