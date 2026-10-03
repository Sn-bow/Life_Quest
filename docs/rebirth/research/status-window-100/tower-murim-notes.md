# 탑·무림·VR 게임: 상태창 참고 조사

2026-09-27. 30개 서로 다른 IP. **공식 페이지 50개 검토(`sources_reviewed: 50`)**. Exa 도구가 활성 목록에 없어 사용하지 않았고, 사용 가능한 웹 검색·페이지 열람과 공식 무료 회차의 브라우저 이미지 확인을 사용했다. 이 숫자는 고유한 페이지 수이며 Exa 검색 수나 완독 회차 수가 아니다. 구조화된 기록은 [tower-murim.json](tower-murim.json)에 있다.

이 배치는 한국 작품 29개와 중국 인접 비교 후보 1개(The Game That I Came From)를 포함한다. 소설·웹툰판과 영문 별칭은 같은 IP로 한 번만 셌다. 「Gourmet Gaming」과 「The Gourmet Gamer / 식사하고 가세요!」는 서로 다른 작품이다. 「마탄의 사수」는 Mystic Musketeer / Arcane Sniper 한 항목, 「천마육성」은 Murim RPG Simulation / Heavenly Demon Cultivation Simulation 한 항목이다.

## 확인 수준

- **panel 4개:** 무한 레벨업 in 무림, 나노마신, +99 Reinforced Wooden Stick, The Gourmet Gamer. 이 중 부분적인 캐릭터 상태 수치를 포함한 직접 관찰은 무한 레벨업 in 무림이다. 나노마신은 부팅 알림, +99는 강화 확률의 그림 속 설명이다. The Gourmet Gamer는 스킬 획득 알림과 상세 카드다. 네 개를 모두 완전한 개인 능력치표로 부르면 안 된다.
- **text 2개:** Ranker's Return 공식 소설 15화의 아이템·능력치 설명, Second Life Ranker 공식 소설 2화의 투명 상태창·세 탭·개인 속성과 스킬 본문.
- **official-system 20개:** 공식 소개에서 수치·등급·직업·스킬·선택창·게임 규칙을 확인했다. 외형이나 배치는 확인하지 않았다.
- **candidate 4개:** The Advanced Player of the Tutorial Tower, The Worn and Torn Newbie, The Game That I Came From, The Strongest Florist. 공식 존재와 설정은 확인했지만 구체적 상태창 근거가 부족하다.

무료 공식 회차 **9개**에서 일부 이미지를 직접 보았다. 긴 세로 회차의 모든 이미지를 완독한 것은 아니다. Tapas의 SSS-Class Revival Hunter 프롤로그는 이미지가 표시되지 않아 시각 검증에 포함하지 않는다. 나노마신은 텍스트 추출로는 열리지 않았지만 공식 브라우저 회차에서는 패널을 실제 확인했다. 실패·빈 응답, 검색 결과만 본 페이지, 반복 열람은 50개에 중복 합산하지 않았다.

## 패널·본문 위치 기록

| 작품 | 공식 회차 / 위치 | 실제 확인한 내용 | 확인하지 못한 내용 |
|---|---|---|---|
| 무한 레벨업 in 무림 | [32화 Physical Modification](https://www.webtoons.com/en/action/infinite-leveling-murim/ep-32-physical-modification/viewer?episode_no=32&title_no=2676), 이미지 0-based 90 및 아래 상태 일부 | 탁한 적색 알림 면, 가는 옅은 금색 이중 테두리, 작은 사각 모서리. 능력 변화에 맞춘 인터페이스 외형 갱신 안내. Lv.16 / Yuseong Dan / Physical modification Level 1 | 전체 스탯 표, 변화 전 화면; 추가 확인한 두 수평 바는 라벨이 없어 의미 미확정 |
| 나노마신 | [1화 / 프롤로그](https://www.webtoons.com/en/action/nano-machine/episode-1/viewer?title_no=4344&episode_no=1), 이미지 139–140 | 기업명과 7세대 기계의 작동 개시. 흰 바탕·검은 외곽선·각진 홈의 기계 발화 상자. 어긋난 두 상자와 사선 연결 | 신체 분석 HUD, 속성 수치, 훈련·복제 UI |
| +99 Reinforced Wooden Stick | [1화](https://www.webtoons.com/en/comedy/99-reinforced-wooden-stick/ep-1-99-reinforced-wooden-stick/viewer?episode_no=1&title_no=4286), 이미지 300 | +10에서 다음 강화 성공률이 5% 미만이라는 숫자 설명 | 장비 카드와 강화 조작 UI |
| 천마육성 | [1화](https://www.webtoons.com/en/action/murim-rpg-simulation/episode-1/viewer?episode_no=1&title_no=3779), 여러 구간 샘플 | 인물·전투 등 실제 이미지가 표시됨을 확인 | 상태창 위치 특정 실패. UI 근거는 [한국 공식 소개](https://m.comic.naver.com/webtoon/list?titleId=776255)의 상태창·선택창 언급에 한정 |
| 열렙전사 | [1화](https://www.webtoons.com/en/action/hardcore-leveling-warrior/ep-1/viewer?episode_no=1&title_no=1221), 이미지 25·40·83·95 부근 | 금화·전투·대사 등 일부 실제 그림 | 전체 상태 UI와 리셋 창. 공식 소개의 1위→레벨 1 설정만 시스템 근거로 채택 |
| Ranker's Return | [공식 소설 Chapter 15](https://tapas.io/episode/2068782), Dakan 관련 아이템 설명 | 아이템 이름·등급·제한·효과, 힘/체격 보너스, 다른 검의 장착 조건·내구도·공격력, 직접 배분할 수 없는 전투 특수 속성 | 같은 장면의 웹툰 디자인 |

이미지 인덱스는 조사 시점의 `img` 대체 텍스트 `image` 목록을 0부터 센 위치다. 플랫폼의 이미지 분할 변경으로 이동할 수 있으므로 회차명과 관찰 문구를 함께 기록했다. 작품 이미지는 저장·복제·커밋하지 않았다. 필요 시 출처 회차를 다시 열어 확인해야 한다. 일시적인 토큰이 들어간 Tapas CDN URL은 기록하지 않는다.

무한 레벨업 패널의 추가 재확인 위치는 공개 이미지 URL [16351906874742676327.jpg](https://webtoon-phinf.pstatic.net/20211026_27/1635190691978km4pW_JPEG/16351906874742676327.jpg?type=q90)이다. 나노마신 부팅 안내는 [이미지 139](https://webtoon-phinf.pstatic.net/20220613_47/1655105530601KP8XY_JPEG/1655105530597434415.jpg?type=q90), [이미지 140](https://webtoon-phinf.pstatic.net/20220613_37/1655105530604uqYcy_JPEG/1655105530600434413.jpg?type=q90)에서 확인했다. 이 링크는 재현 위치이며 제품 자산으로 사용할 권한을 뜻하지 않는다.

## Life Quest에 적용할 설계 제안

상태창의 주체는 사용자 자신이어야 한다. 작품에서 중요한 정보는 배경 풍경보다 **내가 누구인지, 어떤 능력을 가졌는지, 방금 무엇이 변했는지**다. 처음 열린 패널 안에서 이름·레벨·실제 칭호·능력치·보유 스킬이 읽히고, 퀘스트는 그 상태를 바꾸는 명령으로 이어지게 하는 것이 이 조사와 기존 상태창 우선 요구를 연결하는 방향이다.

1. **변화의 원인을 보여 준다.** Gourmet Gaming의 힘 증가 메시지와 Ranker's Return의 아이템 보너스처럼 행동·출처와 수치 변화가 연결되어야 한다. 실제 보상 저장 → 결과 메시지 → 갱신된 본체라는 흐름을 유지한다. 이 작품들의 숫자를 앱의 성장 공식으로 복사하는 제안은 아니다.
2. **다른 축을 같은 점수로 합치지 않는다.** Pick Me Up의 성 등급, Taming Master의 레벨·숨겨진 직업, Overgeared의 전설 직업·제작물, 열렙전사의 순위·레벨은 서로 다른 의미다. Life Quest에서도 이미 구현된 레벨·칭호·스킬·배분 포인트의 의미를 분명히 하고, 검증되지 않은 직업·헌터 등급·현실 HP/MP를 장식으로 채우지 않는다.
3. **얻은 결과가 정체성에 남게 한다.** Slumbering Ranker는 누적 행동의 문턱이 직업 해금으로 연결되고, 무한 레벨업은 능력 변화가 인터페이스 변화로 연결된다는 실제 알림을 보여 준다. 작은 성장 기록과 분명한 획득 이력이 고정된 판타지 배경보다 사용자 고유의 상태창을 만드는 데 적합하다는 설계 제안이다.
4. **알림과 본체의 역할을 구분한다.** 나노마신의 부팅 알림은 작동 상태를 알려 준다. 이를 전체 프로필 레이아웃의 근거로 확대하지 말고, 짧은 호출 응답·획득 알림의 참고로만 사용한다. 반복 사용을 방해하는 긴 연출은 별도 근거가 없다.
5. **다양한 성장 경로를 허용한다.** 제작·조각·테이밍·요리·도움이라는 인접 자료는 성장 판타지가 전투력에만 한정되지 않음을 보여 준다. 이 중 상태 규칙 미확인 후보는 생활 스킬의 구체적인 계산식 근거로 사용하지 않는다. 현대 헌터 상태창의 중심 방향도 유지한다.

색상에 대한 직접 근거는 제한적이다. 무한 레벨업의 적색·옅은 금색 알림과 나노마신의 흰색·검은 선 상자는 실제 관찰했지만, The Gourmet Gamer의 청보라 계열 스킬 알림·카드와 밝은 픽셀 형태 글자도 직접 확인했다. 그 밖의 작품의 파란 네온 창·투명도·폰트·배치를 추정하지 않았다. 작품의 인물·문장·로고·프레임을 제품에 복제하지 않고 정보 순서와 원인→결과의 문법을 추출한다. 기존의 무벌점 수락·거절, 사실에 맞는 XP·능력치, 모션 감소 원칙은 그대로 설계 제약이다.

## 범위와 후속 확인

제안 목록의 The Wailing Perversion은 적합한 상태 시스템 근거를 확보하지 못해 채택하지 않았다. The Max Level Hero Has Returned와 Logging 10,000 Years Into the Future도 이 배치에 넣지 않았고, 대신 공식 근거가 확보된 Surviving the Game as a Barbarian, The Gourmet Gamer, +99 Reinforced Wooden Stick을 채택했다. 후보 4개를 확정된 시각 레퍼런스로 승격하려면 실제 상태·스킬·획득 창이 나오는 회차를 추가 확인해야 한다.

한국어 원제가 확인되지 않은 항목은 JSON에서 `null`로 남겼다. 영어권 공식 유통 제목은 모두 실제 연 공식 페이지에 연결했다. `official-system`은 시각 검증 완료를 뜻하지 않으며, 넓은 시스템 메커니즘까지 포함한다. 최종 100개 통합본에서도 후보 수와 실제 패널 수를 따로 표시해야 한다.

## 추가 심층 확인

- [Second Life Ranker 공식 소설 2화](https://www.wuxiaworld.com/novel/second-life-ranker/slr-chapter-2): 각성 진행 5% → 특성·스킬 등록 → 개인 수치표 → 특성·능력치·스킬 세 탭 설명을 실제 본문에서 확인했다. 초기 힘 10·민첩 15·건강 12·마력 21. 투명 패널이라는 서술은 있지만 색상·아이콘은 나오지 않아 추정하지 않는다. 특성과 개인 환경·소중한 물건에 따라 스킬이 달라진다는 설명은 사용자 고유 상태창의 정보 구조를 생각하는 데 유용하다. [공식 작품 페이지](https://www.wuxiaworld.com/novel/second-life-ranker)는 Dream Books (Samyang C&C) 라이선스를 표시한다.
- [The Gourmet Gamer 무료 3화](https://www.tappytoon.com/en/chapters/882918027?): 짧은 스킬 획득 알림 뒤 상세 카드가 등장한다. 이름·F 등급·패시브가 상단 한 줄, 눈 아이콘이 왼쪽, 효과가 오른쪽이다. 효과는 1성 몬스터의 약점 식별에 관한 것이다. 실제 확인한 카드 이미지의 재현 위치는 chapter 882918027, asset 경로 `high/30b7cf5a-101d-4f77-89cf-b7aa8e27d8fd/5.jpeg`이다. 요리 능력치표로 오인하지 않는다. [무료 2화](https://www.tappytoon.com/en/chapters/567399338?)에서는 떠 있는 청색 창과 닫기·화살표 조작을 보았지만 창의 종류는 확정하지 않았다.
- 무한 레벨업 32화의 이름·레벨 아래 두 수평 바를 추가로 모두 확인했다. 상단은 적색·노랑·어두운 구간, 하단은 청보라색이다. HP/MP 라벨이나 값이 없으므로 이 기록에서는 두 바의 용도를 지정하지 않는다.

조사 종료 시 사용자 사용량 하한이 잔여 70%로 변경되었다는 전달을 받아 신규 탐색을 즉시 중단했다. 마지막으로 The Advanced Player of the Tutorial Tower 공식 무료 1·2화의 일부 이미지를 보았지만 2화의 청색 창 내용을 충분히 확인하지 못했으므로 후보 등급을 유지했다. 이 두 회차를 포함해 고유 검토 페이지는 50개다. 2화는 1화의 공식 Episode 2 링크로 이동했고 회차 제목을 확인했으나 중단 전에 정확한 최종 URL을 별도로 기록하지 못했다. JSON의 별도 페이지 원장에 이를 명시했으며 URL을 추측해 만들지 않았다.

## tm-04 한 작품 한정 보강

검색 1회와 공식 무료 [2화](https://www.webtoons.com/en/action/the-advanced-player-of-the-tutorial-tower/episode-2/viewer?episode_no=2&title_no=2409)·[3화](https://www.webtoons.com/en/action/the-advanced-player-of-the-tutorial-tower/episode-3/viewer?episode_no=3&title_no=2409) 페이지 2개만 확인하고 종료했다. 이번에는 CUA 브라우저를 사용할 수 없었고 웹 페이지 추출은 회차 제목과 반복되는 이미지 자리표시자만 반환했다. 새 패널·개인 상태표·수치표를 읽은 것으로 기록하지 않으며 **candidate를 유지**한다. 이전에 빠졌던 2화의 정확한 공식 URL은 검증해 원장에 보완했다. 3화는 본문을 확인하지 못한 시도여서 실질 근거 페이지 수 50에 더하지 않았다. 최종 근거 분포는 panel 4 / text 2 / official-system 20 / candidate 4로 동일하다.
