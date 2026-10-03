# 소설·일본 IP·국제 LitRPG 상태창 조사

## 추가 검증: 원작 무료 본문 5개

원본 30개를 보존하고 `novel-backups.json`에 NB-001~NB-005로 5개를 추가했다. Azarinth Healer, Salvos, Industrial Strength Magic, Chrysalis, Super Supportive는 모두 기존 30개와 다른 IP이며, 원작자 공개 본문을 읽은 `text` 등급이다. 별도 만화 패널 검증은 하지 않았다. SAO는 원작 상태창 근거가 미확인인 `candidate`로 하향했다.

- 기존 파일: text 28 / official-system 1 / candidate 1 / panel 0.
- 추가 파일: text 5 / 그 외 0.
- 합계 35개 IP: text 33 / official-system 1 / candidate 1. SAO를 제외하면 직접 본문 또는 공식 시스템 설정을 확인한 IP는 34개이며, 34개 모두 시각적 패널을 확인했다는 의미는 아니다.
- 추가 sources_reviewed: 14. 아래 고유 URL을 실제 open/click으로 열었다. 기존 50개와 중복되지 않아 이번 분담의 누적 실제 열람 URL은 64개다. 검색 결과 수·Exa 측정치가 아니다.
- Royal Road 독자 리뷰는 제외하고 원작 본문·작가 소개·작가 주석만 근거에 사용했다. 일부 작품은 과거 회차가 유료화됐지만 공개로 남아 있는 회차만 읽었다.

가장 유용한 새 근거는 **Chrysalis의 정보 과부하 묘사**, **Industrial Strength Magic의 능력치 뜻 확인→직업 비교→선택→상태 갱신 흐름**, **Super Supportive의 실제 시야 오버레이와 닫기 동작**이다. Azarinth Healer와 Salvos는 이 대목에서 머릿속 정보로 인식하므로 공중에 떠 있는 창으로 설명하면 안 된다. Super Supportive 작가가 대괄호·글꼴 변화와 파란 상자를 비교한 주석은 문학적 시스템 표현과 시각적 UI 형태를 구분하는 데 유용하다.

1. [Azarinth Healer 작품·공식 게시처 안내](https://www.royalroad.com/fiction/16946/azarinth-healer)
2. [Azarinth Healer 2화 상태 목록](https://www.royalroad.com/fiction/16946/azarinth-healer/chapter/198148/chapter-2-generic-wolves-who-wouldve-guessed)
3. [Salvos 작품](https://www.royalroad.com/fiction/37438/salvos)
4. [Salvos 0화 작가 안내](https://www.royalroad.com/fiction/37438/salvos-stubbed/chapter/580224/0-advent)
5. [Salvos 1화 자기 정보](https://www.royalroad.com/fiction/37438/salvos-stubbed/chapter/581008/1-rocks)
6. [Industrial Strength Magic 작품](https://www.royalroad.com/fiction/57011/industrial-strength-magic)
7. [Industrial Strength Magic 2화 HP·XP 정의](https://www.royalroad.com/fiction/57011/industrial-strength-magic/chapter/957932/chapter-2-the-quest)
8. [Industrial Strength Magic 3화 직업·상태](https://www.royalroad.com/fiction/57011/industrial-strength-magic/chapter/957944/chapter-3-class-selection)
9. [Chrysalis 작품](https://www.royalroad.com/fiction/22518/chrysalis)
10. [Chrysalis 1396화 메뉴·스킬 합성](https://www.royalroad.com/fiction/22518/chrysalis/chapter/1776045/chapter-1396-power-up)
11. [Chrysalis 1862화 자기 상태](https://www.royalroad.com/fiction/22518/chrysalis/chapter/3965306/chapter-1862-anthonys-status)
12. [Super Supportive 작품](https://www.royalroad.com/fiction/63759/super-supportive)
13. [Super Supportive 12화 오버레이·작가 주석](https://www.royalroad.com/fiction/63759/super-supportive/chapter/1116121/twelve-one-oclock-on-a-thursday)
14. [Super Supportive 15화 직업 갱신](https://www.royalroad.com/fiction/63759/super-supportive/chapter/1118061/fifteen-class-trader-part-two)


기준일: 2026-09-27. 이 파일은 일본 25개 IP와 영어권 5개 IP, 합계 30개를 한국 헌터물의 **인접 참고(adjacent)** 자료로 구분한다. 작품별 상세 기록은 `novel-manga.json`의 NM-001~NM-030에 있다.

## 검증 범위와 수량

- text 28: 작가가 공식 연재한 원문을 실제 열어 읽었다. 이 등급에는 실제 호출되는 상태창, 상태 목록, 시스템 알림, 상태를 확인하는 서술이 포함되므로 28개 모두가 같은 종류의 창이라는 뜻이 아니다.
- official-system 1: Berserk of Gluttony는 공식 캐릭터 소개의 스킬·상태 흡수 설정이다.
- panel 0: 이 분담에서는 만화의 실제 컷을 시각적으로 확인하지 않았다.
- candidate 1: Sword Art Online은 공식 파생 배터리 앱만 확인했으므로 원작 상태창의 직접 근거가 없는 후보로 낮췄다. 원작 상태창 유효 수량에는 포함하지 않는다. The New Gate 대신 실제 상태표·진화 결과를 읽을 수 있는 Reincarnated as a Dragon Hatchling을 채택했다.
- sources_reviewed: 50. **web 도구의 open/click으로 열기에 성공한 고유 URL 수**이며 Exa 검색 품질 점수·검색 결과 수가 아니다. 2개의 J-Novel Club 미리보기 렌더링 껍데기와 1개의 The Wandering Inn 구판 접근 제한 페이지도 접근 상태를 확인한 페이지로 포함했다. 읽지 못한 본문은 증거에 사용하지 않았다.
- Exa 전용 도구는 활성 도구 목록에서 호출할 수 없어 web 도구와 공식 원작·출판사·IP 사이트를 사용했다. 인증 실패로 단정하지 않는다.
- 한국어 정식 발매명은 이번 분담에서 별도 확인하지 않아 title_ko에도 영어 식별명을 넣었다. 부모 카탈로그에서 검증된 한국어명이 있으면 병합 가능하다.
- 모든 요약은 의역이다. 작품의 원문 문장·표를 대량 전재하지 않았다. 댓글·팬 위키·독자 리뷰는 시스템 증거로 사용하지 않았다.

## 구현 방향에 가장 유용한 직접 근거

1. **[Delve 004: Statistics](https://www.royalroad.com/fiction/25225/delve/chapter/368068/004-statistics)**: 자기 Attributes/Skills/Statistics/Options, 시야에 붙는 자원 HUD, 숫자→바 전환, 창 드래그·분리·잠금, 색·투명도 설정, 포인트 +/-의 적용 전 미리보기와 Apply, 활동으로 얻은 XP 알림을 직접 서술한다. Life Quest의 최상위 방향인 “사용자가 헌터이고 앱이 그 헌터의 상태창”과 가장 구체적으로 맞는다.
2. **[Death March 1-2](https://ncode.syosetu.com/n9902bn/2/)**: 상태·마법·스킬과 시각이 붙은 로그를 분리한다. 로그를 기본 표시로 추가할 수 있고, 성장 결과의 순서를 추적한다. 퀘스트 완료 후 달라진 내용과 원인을 보여 주는 데 적합하다.
3. **[Black Summoner 1화](https://ncode.syosetu.com/n1222ci/1/)**와 **[The Great Cleric 프롤로그](https://ncode.syosetu.com/n8697cx/1/)**: 인물의 기본 신원→직업·레벨→자원→능력→스킬→칭호의 읽기 구조가 분명하다. 후자의 청백색 테두리·반투명 묘사는 실제 소설에 있지만 만화 패널 관찰로 전환해서는 안 된다.
4. **[Failure Frame 6화](https://ncode.syosetu.com/n1785ek/6/)**: 플릭하는 상태창·스킬 트리, 총능력과 보정치를 구분하는 규칙이 직접 나온다. 모호한 숫자를 그럴듯하게 노출하지 않도록 해 준다.
5. **[He Who Fights With Monsters 1화](https://www.royalroad.com/fiction/26294/he-who-fights-with-monsters/chapter/386590/chapter-1-strange-business)**: 자기 상태, 퀘스트, 인벤토리, 지도가 같은 인물에게 연결된다. 인벤토리 격자·통화·미확인 정보까지 실제 서술한다.
6. **[Defiance of the Fall 5화](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359143/chapter-5-stranded)**: 목표·기한·희귀도·보상·현재/목표 횟수가 본인을 따라오는 창에 등장한다. 앞선 4화에는 아직 상시 HP바가 없다는 말도 있으므로 항상 모든 정보를 띄우는 작품이라고 일반화하지 않는다.

## 소설이 보여 주는 UI 표현의 차이

| 유형 | 직접 확인된 사례 | Life Quest 적용은 추론/권고 |
|---|---|---|
| 호출 | Black Summoner의 버튼, Assassin/Great Cleric의 생각 명령, Hell Mode의 책 호출 | 앱을 여는 즉시 자기 상태가 보이도록 구성 |
| 현재 상태 | Spider의 현재/최대 자원과 상세 능력, Primal Hunter의 종족·직업·전문직 | 자원과 장기 성장을 구별 |
| 결과 통지 | TWI의 직업→레벨→생활 스킬 알림, Dragon Hatchling의 진화 전후 변화 | 활동 완료 뒤 변화 결과를 짧게 묶음 |
| 변화의 근거 | Death March의 시각이 붙은 로그, Slime의 획득 출처별 스킬 | 성과가 어떤 기록에서 왔는지 연결 |
| 능동 조작 | Delve의 적용 전 스탯 미리보기, BOFURI의 빌드 선택 | 투자 결과를 이해하고 확정하게 함 |
| 생활 성장 | Tamer의 요리·농경·채집, Campfire의 비전투 고유 스킬 | 전투 수치가 아닌 생활 능력도 동등하게 취급 |
| 복잡도 관리 | Sword의 유형 정렬, TRPG Build의 검색·분류 | 상세는 펼치고 홈은 핵심 항목 중심 |
| 한계 표현 | Black Summoner의 감정 불가, HWFWM의 미확인 아이템, Instant Death의 무효화 상태 | 미확인·중단을 0이나 정상값으로 오해하지 않게 표시 |
| 숫자 없는 상태 | Land Mines의 건강·스킬 목록, TWI의 성장 알림 | 객관적인 근거 없는 정신·건강 수치를 만들어 내지 않음 |

## 범위를 오해하지 말아야 할 항목

- **The Wandering Inn**: 이 조사 근거는 대괄호로 적힌 성장 알림이다. 물리적 창, 스탯 표, 상시 HUD의 증거가 아니다. 공개된 개정 1.00을 사용했으며 구판 접근 제한 본문은 열지 않았다.
- **That Time I Got Reincarnated as a Slime**: 상태 목록은 읽었지만, 그 목록 자체가 인물에게 보이는 UI인지 서술용 정리인지 해당 장면으로 확정하지 않는다.
- **A Late-Start Tamer's Laid-Back Life**: 상태 표는 회차 말 요약이 섞여 있다. 실제 만화 화면 구조의 증거가 아니다.
- **Log Horizon / Campfire Cooking**: 실제 상태 확인 서술은 읽었지만 해당 대목에 완전한 능력치 창 배치가 있는 것은 아니다.
- **Sword Art Online**: 공식 배터리 앱의 HP 게이지는 현실 지표를 세계관 UI로 대응시킨 선례다. 원작 상태창 시각 분석을 대체하지 않으며 오래된 앱의 현재 이용 가능성을 보증하지 않는다.
- **Berserk of Gluttony**: 실제 본문·패널을 읽은 등급이 아니다.
- 모든 만화·애니 시각, 폰트, 색, 전환 속도는 이 파일의 원문 명시 범위를 넘어 추정하지 않는다. 실제 웹툰 패널 분석은 다른 분담의 근거와 합쳐야 한다.

## 직접 연 고유 페이지 목록 (50)

1. [작가 원작 01](https://ncode.syosetu.com/n7975cr/51/)
2. [작가 원작 02](https://ncode.syosetu.com/n6316bn/16/)
3. [작가 원작 03](https://ncode.syosetu.com/n9902bn/2/)
4. [작가 원작 04](https://ncode.syosetu.com/n8611bv/3/)
5. [작가 원작 05](https://ncode.syosetu.com/n6006cw/16/)
6. [작가 원작 06](https://ncode.syosetu.com/n1785ek/6/)
7. [작가 원작 07](https://ncode.syosetu.com/n1222ci/1/)
8. [작가 원작 08](https://ncode.syosetu.com/n7707dt/3/)
9. [작가 원작 09](https://ncode.syosetu.com/n3669fw/3/)
10. [IP·출판사 공식 10](https://bousyoku-anime.com/character)
11. [작가 원작 11](https://ncode.syosetu.com/n0043lg/249/)
12. [작가 원작 12](https://ncode.syosetu.com/n2211cx/19/)
13. [작가 원작 13](https://ncode.syosetu.com/n4698cv/4/)
14. [작가 원작 14](https://ncode.syosetu.com/n6169dz/81/)
15. [작가 원작 15](https://ncode.syosetu.com/n0358dh/7/)
16. [IP·출판사 공식 16](https://www.swordart-online.net/sp/news/?mode=moviep%3D4&p=106)
17. [작가 원작 17](https://ncode.syosetu.com/n8725k/4/)
18. [작가 원작 18](https://ncode.syosetu.com/n8206dh/154/)
19. [작가 원작 19](https://ncode.syosetu.com/n0350em/3/)
20. [작가 원작 20](https://ncode.syosetu.com/n4811fg/3/)
21. [작가 원작 21](https://ncode.syosetu.com/n3976gk/103/)
22. [작가 원작 22](https://ncode.syosetu.com/n2224dv/28/)
23. [작가 원작 23](https://ncode.syosetu.com/n2710db/1/)
24. [작가 원작 24](https://ncode.syosetu.com/n7583de/3/)
25. [작가 원작 25](https://ncode.syosetu.com/n8697cx/1/)
26. [작가 사이트 26](https://wanderinginn.com/2017/03/03/rw1-00/)
27. [작가 공식 연재 27](https://www.royalroad.com/fiction/25225/delve/chapter/368068/004-statistics)
28. [작가 공식 연재 28](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359143/chapter-5-stranded)
29. [작가 공식 연재 29](https://www.royalroad.com/fiction/36049/the-primal-hunter/chapter/557071/chapter-2-introduction)
30. [작가 공식 연재 30](https://www.royalroad.com/fiction/26294/he-who-fights-with-monsters/chapter/386590/chapter-1-strange-business)
31. [출판사 31](https://j-novel.club/series/hell-mode)
32. [출판사 32](https://j-novel.club/series/black-summoner)
33. [출판사 33](https://j-novel.club/series/min-maxing-my-trpg-build-in-another-world)
34. [출판사 34](https://j-novel.club/series/arifureta-from-commonplace-to-world-s-strongest)
35. [출판사 35](https://j-novel.club/read/hell-mode-volume-1-part-1)
36. [출판사 36](https://j-novel.club/read/black-summoner-volume-1-part-1)
37. [작가 원작 37](https://ncode.syosetu.com/n6458eg/46/)
38. [작가 공식 연재 38](https://www.royalroad.com/fiction/25225/delve)
39. [작가 공식 연재 39](https://www.royalroad.com/fiction/36049/the-primal-hunter)
40. [작가 공식 연재 40](https://www.royalroad.com/fiction/24709/defiance-of-the-fall)
41. [작가 공식 연재 41](https://www.royalroad.com/fiction/26294/he-who-fights-with-monsters)
42. [작가 공식 연재 42](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359118/prologue-welcome-to-the-multi-verse)
43. [작가 공식 연재 43](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359137/chapter-1-roll-for-survival)
44. [작가 공식 연재 44](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359138/chapter-2-a-new-world)
45. [작가 공식 연재 45](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359140/chapter-3-battle-tactics)
46. [작가 공식 연재 46](https://www.royalroad.com/fiction/24709/defiance-of-the-fall/chapter/359142/chapter-4-alone)
47. [작가 공식 연재 47](https://www.royalroad.com/fiction/36049/the-primal-hunter/chapter/557051/chapter-1-another-monday-morning)
48. [작가 사이트 48](https://wanderinginn.com/2016/07/27/1-00/)
49. [IP·출판사 공식 49](https://yenpress.com/titles/9780316371247-sword-art-online-1-aincrad-light-novel)
50. [작가 원작 50](https://ncode.syosetu.com/n3976gk/166/)

## 접근 제한과 제외

- `https://wanderinginn.com/2023/03/04/1-00/`: 잘못된/접근 불가 주소로 도구가 열지 못함. 위 수량 제외.
- `https://ncode.syosetu.com/n3976gk/1/`: 403 응답. 위 수량 제외. 공개적으로 열린 103화·166화로 검증.
- A Wild Last Boss Appeared! 19화는 한 차례 403 후 정상적인 기본 open 요청에서 성공했고, 성공적으로 읽은 동일 URL 한 개만 집계했다.
- J-Novel Club의 두 미리보기는 도구에서 본문이 렌더링되지 않아 소설 내용 증거로 쓰지 않았다. 작가가 공개한 일본 원작으로 전환했다.
