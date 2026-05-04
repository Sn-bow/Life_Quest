# Slay the Spire 2 종합 자료조사

조사일: 2026-05-04
조사 목적: Life Quest 모바일 RPG에 STS2 스타일 카드 전투 시스템 적용을 위한 정확한 레퍼런스 확보
원칙: 검증되지 않은 정보는 "확인 필요"로 표기. 추측 금지.

---

## 1. 게임 개요

### 출시 정보 (확인됨)
- **개발/배급**: Mega Crit (1편과 동일)
- **얼리 액세스 출시일**: 2026년 3월 5일 (목)
  - 원래 2025년 말 예정이었으나, 2025년 9월 품질 사유로 연기
- **정식 출시 예정**: 1~2년 얼리 액세스 후 (2027년 추정)
- **가격**: $19.99 ~ $24.99 USD / ₩27,000 KRW (얼리 액세스 가격, 정식 출시 시 인상 예정)
- **플랫폼**: Windows, macOS, SteamOS/Linux (모바일 미지원, Switch 미지원)
- **엔진**: Godot (1편 Unity → 2편 Godot 전환. Unity 2023년 라이선스 사태 영향)
- **지원 언어**: 14개 언어 (영어, 프랑스어, 일본어, **한국어**, 중국어 간체 등)

### 1편과의 차이점 (확인됨)
- **장르 정체성 유지**: 로그라이크 덱빌더, 턴제 전투, 절차적 생성 — 핵심은 동일
- **새 캐릭터 2명 추가**: Necrobinder, Regent (총 5명)
- **협동 모드(Co-op)**: 최대 4인. 적 인카운터는 공유, 체력/카드/자원은 개인
- **Alternate Acts**: 각 막(Act)마다 두 가지 버전 중 하나가 무작위 선택
- **Timeline/Epoch 시스템**: 진행도에 따라 서사 콘텐츠와 신규 캐릭터 잠금 해제
- **Runes 시스템**: 신규 패시브 장비 레이어 (1편의 카드/렐릭/포션 구조에 추가)
- **시각적 전면 개편**: 모든 캐릭터/카드 아트 재제작 (3장 참고)

### 평가 (얼리 액세스 직후~1차 패치 시점)
- 출시 첫날 동시 접속자 17만+, 2일차 40만+
- 첫 주 판매량 300만+
- Steam 전체 평가 "매우 긍정적" (93%, 54,189건 기준)
- **최근 평가는 "복합적"** (38%, 30일 기준 56,575건) — 밸런스 패치(특히 Ironclad/Regent 너프) 관련 리뷰 폭격 발생

출처:
- https://en.wikipedia.org/wiki/Slay_the_Spire_II
- https://store.steampowered.com/app/2868840/Slay_the_Spire_2/
- https://www.megacrit.com/news/2026-02-19-release-date-trailer/
- https://ixbt.games/en/news/2025/09/12/mega-crit-perenesla-rannii-dostup-slay-the-spire-2-na-mart-2026-goda.html
- https://www.pcgamesn.com/slay-the-spire-2/guide

---

## 2. 캐릭터 (Heroes)

총 5명. 1편 4명 캐릭터 중 Watcher는 **현재 미등장** (얼리 액세스 시점 기준 — 추후 추가 가능성 있음).

### 2.1 Ironclad (아이언클래드) — 빨강
- **컨셉**: "마지막 남은 Ironclad 부대 병사. 검과 화염으로 자신의 의지에 반하여 적을 분쇄한다."
- **STS2 신규 서사**: 영혼을 팔아 악마의 힘을 얻은 전사. 저주받았고, 조종당하고 있으며, 자신이 손에 쥔 힘에 삼켜졌을 가능성 있음. "자신을 몰아붙이는 악마적 영향에 발버둥치는 절박하게 몰린 짐승"
- **시각 테마**: 화염, 피, 군인/갑옷, 악마/지옥 (관련 렐릭: Burning Blood, Charon's Ashes, Brimstone, Demon Tongue)
- **카드 색상**: 빨강/진홍 (1편과 동일 계열 유지)
- **시작 HP**: 80 (전 캐릭터 중 최고)
- **시작 렐릭**: Burning Blood (전투 종료 시 6 HP 회복)
- **빌드 방향**: Vulnerable, Body Slam, Exhaust 3종 (1편의 Strength 빌드는 Vulnerable 빌드로 대체)

#### Ironclad 디자인 변화 — 커뮤니티 반응 (중요)
- **공식 입장 (Casey Yano)**: 1편 Ironclad 디자인은 "내가 포기한 캐릭터"였다고 인정. 휴머노이드 캐릭터 작화 경험 부족이 원인
- **2편 디자인 평가**: PCGamesN 등 매체는 "진짜로 새롭게 느껴지는 디자인 리프레시" 호평
- **커뮤니티 반응 분기**:
  - 긍정: 대부분의 매체와 유저가 환영
  - 부정: Steam에서 "전체적인 그래픽/아트스타일은 여전히 좀 진흙탕같고 칙칙(muddy and washed out)" 의견 존재
  - 주의: **공식적으로 일부 카드 아트는 베타 아트이며 정식 출시 시 교체 예정** (이를 모르고 흉내내면 위험)
- **밸런스 측면 백래시**: 1차 밸런스 패치(Ironclad 너프) → Steam 리뷰 폭격 → Mega Crit 공식 대응. 이후 Regent 너프로 1만+ 부정 리뷰, 결국 너프 철회

### 2.2 Silent (사일런트) — 초록
- **컨셉**: "스파이어 외부 출신 사냥꾼. 길을 막는 모든 것을 찌르고 독을 풀 준비가 됐다."
- **시각 테마**: 가벼운 가죽 장비, 후드, 단검(Shiv)
- **카드 색상**: 초록 (1편과 동일)
- **신규 키워드**: **Sly** — 패에서 카드를 버려 카드를 플레이하는 메커니즘
- **빌드 방향**: 독(Poison), 시브(Shiv) 양산, 빠른 타격

### 2.3 Defect (디펙트) — 파랑
- **컨셉**: 자아를 가진 전투 자동인형. 고대 기술로 원소 Orb 조작
- **시각 테마**: 메카닉/오토마톤. (서스코뮤니티 의견상 STS2에서 1편보다 개발 시간을 덜 받아 1편만큼 폴리시되지 않았다는 평)
- **카드 색상**: 파랑
- **핵심 메커니즘**: Orb (4종 — Lightning/Frost/Dark/Plasma 1편 기준, 2편에서도 Orb 시스템 유지)

### 2.4 Necrobinder (네크로바인더) — 신규 캐릭터, 색상은 보라/회색 계열로 추정 (확인 필요)
- **컨셉**: "건방진 리치(sassy lich)". 거대한 부활 해골 손 'Osty'를 부려 더러운 일을 시킴
- **시각 테마**: 본/네크로맨시. **Osty는 거대한 손 형태로 시각화** — 필드에 실제로 등장하여 탱킹/공격 수행
- **시작 HP**: 66 (전 캐릭터 중 최저)
- **시작 렐릭**: Osty's Binding (Osty 소환)
- **고유 메커니즘**:
  - **Doom**: 적 HP가 Doom 스택 이하면 즉사 처리(execute)
  - **듀오 유닛 운영**: 자신의 자원과 동반자 Osty의 물리적 위치/HP를 동시에 관리
- **대표 카드**: Pull Aggro, Snap, High Five, Rattle

### 2.5 Regent (리젠트) — 신규 캐릭터
- **컨셉**: "고압적이고 불쾌한 군주적 존재"
- **시각 테마**: 왕족/위엄. 별자리(Constellation) UI를 캐릭터 선택 화면에서 사용
- **고유 메커니즘**:
  - **Stars**: Mana 외 두 번째 자원
  - **Forge**: 전투 중 영구 무기 "Sovereign Blade" 강화
  - 관리만 잘하면 게임을 깨뜨리는 수준의 데미지 가능

출처:
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Ironclad
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Silent
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Necrobinder
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Regent
- https://www.sts2companion.com/characters
- https://slaythespire-2.com/blog/20260330-ironclad-lore
- https://www.pcgamesn.com/slay-the-spire-2/art-direction
- https://www.gamesradar.com/games/roguelike/slay-the-spire-2-players-surprised-by-patch-that-actually-makes-the-game-easier-with-big-ironclad-buffs-and-nerfs-to-infuriating-enemies-f-that-guy/

### 캐릭터 일러스트 스타일 (확인됨)
- **아트 디렉터**: Marlowe Dobbe (이전 Dicey Dungeons 작업)
- **카드/이벤트 일러스트**: Anailis Dorta (1편에서도 카드 일러스트 담당)
- **풀타임 애니메이터**: Chris Gortz
- **스타일 방향**: 1편의 페인터리(painterly) 스타일에서 **"crisp(또렷한) 디자인"** 으로 이동. 어두운 테마는 유지하되 **더 "playful(유쾌한)"** 톤. **더 화려한 색감**, **풀스크린 아트 비중 증가**, **애니메이션과 트랜지션 대폭 증가**
- **유지하려는 정체성**: "creepy but kind of fun (소름끼치지만 묘하게 재밌는)" 에너지, "숨은 얼굴들(hidden faces)", "충분히 기괴한(weird enough)" 몬스터 디자인

---

## 3. 카드 시스템 ⭐ 최우선

### 3.1 카드 프레임 영역 분할 (확인됨)

위에서 아래로:
1. **상단**:
   - 좌측 상단: **에너지 코스트 오브** (캐릭터별 고유 색/디자인. 콜로러스 카드는 게임 내에서 현재 캐릭터의 에너지 아이콘으로 자동 치환됨)
   - 상단 배너: **카드 이름** (배너 색상 = 레어도)
2. **중앙**: **카드 일러스트** (대형 영역, 캐릭터/카드 세계관과 직결되는 비주얼)
3. **하단**: **카드 설명 텍스트** (효과 설명, 키워드)
4. **프레임 형태가 카드 타입을 표현** (3.2 참조)

### 3.2 카드 타입 5종 (확인됨)

타입별 **프레임 하단 모양**이 다름 — 시각적으로 즉시 구분 가능:

| 타입 | 프레임 하단 모양 | 설명 |
|------|----------------|------|
| **Attack** (공격) | 직사각형 + 하단이 **사다리꼴(trapezoid)** 로 좁아짐 | 직접 데미지 + 부가 효과 |
| **Skill** (스킬) | **직사각형** (그대로) | 블록/유틸리티/버프/디버프 등 다양한 효과 |
| **Power** (파워) | 직사각형 + 하단이 **타원(oval)** 으로 둥글어짐 | 전투 동안 지속되는 패시브. 1전투 1회 발동 |
| **Status** (상태) | (확인 필요) | 적이나 특정 카드(Defect/Regent)가 임시로 덱에 추가. 전투 종료 시 제거 |
| **Curse** (저주) | (확인 필요) | 이벤트로 영구 추가. 보통 플레이 불가. 일부는 "Eternal"로 제거 불가. HP/골드 손실, Weak/Frail 부여 등 강력한 페널티 |

### 3.3 레어도 시각 구분 (확인됨, 매우 중요)

**배너(이름이 적힌 띠)와 프레임 색으로 표현**:

| 레어도 | 배너 색 | 비고 |
|-------|--------|-----|
| **Basic** | 회색 | 시작 덱 전용 |
| **Common** | 회색 | 일반 |
| **Uncommon** | **파랑** (배너 + 프레임) | |
| **Rare** | **금색** (배너 + 프레임) | |
| **Event** | **초록** (배너 + 프레임) | 이벤트로 획득 |
| **Ancient** | **희미한 프리즘(faint-prismatic)** + **상단 푸른 불꽃(blue flame)** | 풀아트(full-art) 형태, 보이지 않는 테두리 |

### 3.4 카드 일러스트 스타일 (확인됨)
- 1편 대비 **덜 페인터리, 더 또렷(crisp)**
- 카드 아트는 **캐릭터와 세계관에 직접 연결** — 시각적 스토리텔링으로 메커니즘 학습 보조
- 일부 STS2 카드 아트는 **베타 아트**로 정식 출시 전 교체 예정 (공식 발표)

### 3.5 코스트 표시 (확인됨)
- **에너지 오브**: 좌측 상단에 **원형(orb) 아이콘**
- **캐릭터별 고유 디자인**: Ironclad, Silent, Defect, Necrobinder, Regent 모두 다른 에너지 오브
- 콜로러스 카드는 게임이 자동으로 현재 캐릭터 오브로 교체

### 3.6 STS1 vs STS2 카드 프레임 차이 (확인된 부분)
- **공통**: 5종 카드 타입 분류, 타입별 프레임 하단 모양 차이, 레어도별 배너/프레임 색상 코딩 — 대부분 1편 규칙 계승
- **차이**:
  - 일러스트가 **덜 페인터리**, 더 또렷한 라인워크/명암
  - 더 풍부한 색감
  - **신규 레어도 "Ancient"** 추가 (풀아트 + 푸른 불꽃, 1편에 없던 시각 표현)
  - 캐릭터별 에너지 오브 디자인 차별화 강화 (확인 필요 — 1편도 일부 차이는 있었음)

출처:
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Cards
- https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Cards_List
- https://sts2.untapped.gg/en/cards
- https://github.com/elliotttate/sts2-card-exporter (전 카드 SVG/PSD 추출 가능 — 시각 레퍼런스로 매우 유용)
- https://mobalytics.gg/slay-the-spire-2/guides/keywords

---

## 4. UI/UX 디자인

### 4.1 전투 화면 레이아웃 (확인된 부분)
- **적**: 화면 상단~중앙. 머리 위에 **Intent 아이콘** 표시
- **플레이어**: 1편과 동일하게 화면 좌측에 위치 추정 (확인 필요 — 명시적 자료 없음)
- **카드 손패**: 화면 **하단**. 부채꼴 또는 일렬로 배열
- **에너지**: 좌측 (정확한 위치는 확인 필요. Steam 토론에서 "특정 카드 효과의 cancel 프롬프트가 좌하단에 떠서 에너지 표시를 가린다"는 불만 → 에너지가 **좌하단 또는 그 근처**에 있음을 시사)
- **턴 종료 버튼**: 우측 (관행적 위치, 명시 자료 없음)
- **블록**: 캐릭터 옆 방패 아이콘 (1편과 동일 추정)

### 4.2 Intent (적 의도) 시스템 — STS1과의 차이 (확인됨)
- **공통**: 적 머리 위 아이콘. **빨간 무기 + 숫자** = 공격 의도와 데미지
- **무기 5단계 스케일링**: 데미지가 높을수록 무기 아이콘이 위협적으로 변함 (단검 → 낫까지 5단계)
- **STS2 신규**: 적이 **여러 행동을 동시에 할 때**, 1편은 아이콘을 **위아래로 겹쳐 표시**했지만 **2편은 옆으로 나란히 배치** (가독성 개선)
- 동적 인텐트: 일부 적은 플레이어 행동에 따라 인텐트가 동적으로 바뀜

### 4.3 컬러 팔레트 (확인된 범위)
- **전체 톤**: 다크 판타지 유지하되 1편보다 **더 화려/콘트라스트 증가**
- **레어도 코딩**: 회색(Common), 파랑(Uncommon), 금색(Rare), 초록(Event), 프리즘(Ancient)
- **인텐트 색**: 빨강(공격), (방어/디버프 색은 1편 관행 — 확인 필요)
- **캐릭터별 색**: 빨강(Ironclad), 초록(Silent), 파랑(Defect), Necrobinder/Regent 색은 명시 자료 없음 (확인 필요)
- 정확한 헥스 코드는 공식 발표 없음 — 시각 레퍼런스(스크린샷, sts2-card-exporter PSD)에서 직접 추출 권장

### 4.4 타이포그래피
- **명시된 폰트 정보 없음**. 시각 레퍼런스에서 직접 확인 필요
- 1편은 영문 세리프 계열 + 굵은 본문 폰트 사용 — 2편도 큰 틀에서 유사 추정

### 4.5 아이콘 스타일 (확인된 범위)
- **인텐트 무기 아이콘**: 빨간색, 5단계 스케일
- **상태 효과(디버프)**: "전략적 언어"로 기능 — 단순 장식 아닌 게임플레이 정보. 일부는 카드 플레이 수 제한, 일부는 상태 카드를 덱에 셔플
- 정확한 디자인은 시각 레퍼런스 필요

출처:
- https://medium.com/@wlexi/why-we-cant-stop-playing-slay-the-spire-2-a-ux-breakdown-37ebe1881219
- https://sts2.untapped.gg/en/guides/how-to-read-enemy-intent
- https://slaythespire-2.com/guides/combat-mechanics-guide
- https://interfaceingame.com/games/slay-the-spire-2/ (※ 직접 fetch는 403으로 실패 — 브라우저로 직접 방문 권장)

---

## 5. 아트 디렉션

### 5.1 한 줄 요약
**"덜 페인터리하고 더 또렷한, 더 화려하고 더 유쾌한 다크 판타지" — 1편의 creepy-but-fun 정체성을 유지한 채 폴리시와 애니메이션을 대폭 강화한 진화형 리브랜딩.**

### 5.2 다크 판타지 수위
- **유지**: 어두운 테마, 악마/저주/네크로맨시 등 1편의 음울한 세계관
- **완화**: 1편 대비 **더 playful(유쾌한)** 톤. **숨은 얼굴, 기괴한 몬스터** 등 "creepy but fun" 결을 의도적으로 살림
- 결론: **헤비 다크 판타지(예: Diablo, Darkest Dungeon)가 아니라 "유쾌한 다크 판타지"** — 무거움보다 위트가 우선

### 5.3 매체 (일러스트 vs 픽셀 vs 3D)
- **2D 일러스트 기반** (1편 동일)
- 픽셀 아트 아님, 3D 아님
- 라인이 또렷하고 셰이딩이 명확한 **벡터/디지털 페인팅 혼합 스타일**
- **풀스크린 아트 비중 증가** — "더 친밀(intimate)에서 더 서사적(epic)으로" (공식 표현)

### 5.4 라이팅/셰이딩
- 1편: 페인터리, 부드러운 그라데이션
- 2편: **명확한 명암 대비, 더 또렷한 라인**
- 애니메이션과 VFX(이펙트) **대폭 증가**

출처:
- https://www.pcgamesn.com/slay-the-spire-2/art-direction
- https://steamcommunity.com/app/2868840/discussions/0/4338734405124897285/

---

## 6. 모바일 카드게임 적용 시 참고

### 6.1 Marvel Snap 비교 (모바일 퍼스트 디자인 사례)
- **출발점**: Marvel Snap은 **모바일 퍼스트** → PC. Hearthstone은 PC → 모바일 이식
- **카드 정보량**: Snap은 **카드 텍스트 최소화, 일러스트 강조**. 캐릭터 이미지로 즉각 인식
- **읽기 부담**: Hearthstone은 카드 텍스트가 길고 메커니즘이 복잡 → 모바일 진입 장벽 높음
- **STS2 → 모바일 이식 시사점**:
  - STS2 카드는 **상단 코스트, 중앙 일러스트, 하단 텍스트** 구조 → 모바일에서는 **하단 텍스트 영역이 가장 큰 가독성 부담**
  - 텍스트를 **아이콘화하거나 키워드 단축**하는 것이 모바일에서 유리 (Snap 방식)

### 6.2 작은 화면에서 카드 가독성 확보 방식 (관행 + 검색 결과 종합)
- **타입을 색/모양으로 즉각 구분**: STS2 방식(프레임 하단 모양 + 배너 색) 그대로 가져오면 **세로 모바일 화면에서도 작동**. 이 방식은 모바일 카드게임 베스트 프랙티스
- **레어도 색 코딩**: STS2 방식(회색→파랑→금색→프리즘) 동일 적용 가능 — 모바일에서 **컬러 코딩이 텍스트보다 빠르게 인식됨**
- **풀텍스트 vs 키워드 토글**: 카드를 탭하면 확대 + 키워드 정의 표시 (Hearthstone Battlegrounds 방식)
- **에너지 오브 좌상단**: 모바일에서도 자연스러움. 대부분 모바일 TCG가 채택

### 6.3 터치 UI 베스트 프랙티스 (일반론)
- **카드 드래그**: 손패에서 카드를 위로 드래그 → 적 또는 자신에게 드롭 (Hearthstone, Marvel Snap, STS Mod 방식)
- **터치 영역 최소 44x44pt** (Apple HIG) — 카드 손패가 화면 하단 1/3을 차지해도 무방
- **손패 부채꼴 vs 일렬**: 부채꼴은 시각적이지만 모바일 좁은 화면에서 카드 가장자리 잘림. **일렬 슬라이드** 또는 **3~5장 부채꼴** 권장
- **스와이프로 손패 스크롤**: 카드 7장 이상이면 좌우 스와이프 도입
- **인텐트 아이콘은 적 머리 위 충분히 크게**: 모바일 시야에서 가장 자주 보는 정보

출처:
- https://www.thegamer.com/marvel-snap-hearthstone-which-game-is-better/
- https://kotaku.com/marvel-snap-review-hearthstone-ios-android-spider-man-1849679570
- https://blizzardwatch.com/2022/10/14/marvel-snap-hearthstone-compare/

---

## 부록 A. 시각 레퍼런스 추천

코드/디자인 작업 시 **반드시 실물 이미지를 직접 확인**할 것. 텍스트 설명만으로 따라 만들면 또 실패함.

| 리소스 | 용도 | URL |
|-------|-----|-----|
| **sts2-card-exporter** | 모든 STS2 카드를 **고해상도 SVG/PSD로 추출** (셰이더 효과, 편집 가능 텍스트 포함) | https://github.com/elliotttate/sts2-card-exporter |
| **slaythespire.wiki.gg** | 캐릭터별 카드 풀 + 카드 아이콘 이미지 | https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Cards_List |
| **Untapped.gg 카드 갤러리** | 카드 + 일러스트 갤러리 | https://sts2.untapped.gg/en/cards |
| **Steam 페이지 스크린샷** | 공식 게임 스크린샷 | https://store.steampowered.com/app/2868840/Slay_the_Spire_2/ |
| **interfaceingame.com** | 전투 UI 캡처 모음 (직접 방문) | https://interfaceingame.com/games/slay-the-spire-2/ |
| **RPGFan 갤러리** | 공식 아트워크 | https://www.rpgfan.com/gallery/slay-the-spire-2-artwork/ |
| **Mega Crit 공식 발표 트레일러** | 출시 트레일러 (애니메이션 톤 확인) | https://www.megacrit.com/news/2026-02-19-release-date-trailer/ |

---

## 부록 B. 확인 필요 항목 (미해결)

이번 조사에서 **확정 짓지 못한 사항**. 디자인 작업 전에 시각 레퍼런스로 직접 확인 필요:

1. Necrobinder, Regent의 **카드 색상** (각 캐릭터 시그니처 컬러)
2. Status / Curse 카드의 **프레임 하단 모양** (Attack=사다리꼴, Skill=직사각형, Power=타원은 확인됨)
3. **정확한 헥스 컬러 코드** (각 레어도 배너, 캐릭터 색)
4. 사용 폰트 (영문 + 한국어)
5. 전투 화면 **플레이어 위치** (좌측 추정이지만 명시 자료 없음)
6. 1편 → 2편 **에너지 오브 디자인 변화** 정확한 차이
7. 디버프/버프/블록 아이콘의 정확한 디자인

---

## 부록 C. Life Quest 적용 시 권장 사항 요약

이전 시도가 실패한 원인을 고려한 가이드:

1. **카드 프레임은 STS2의 "타입별 하단 모양 + 레어도별 배너 색" 두 축을 그대로 가져갈 것** — 이게 STS 시리즈의 핵심 시각 언어
2. **레어도 색 코딩 (회색/파랑/금색)을 일관되게 적용**. 추가 레어도가 필요하면 초록(Event) 또는 프리즘(Ancient) 차용
3. **일러스트는 "또렷한 라인 + 명확한 명암 + 풍부한 색감"** — 1편 페인터리 스타일 흉내내지 말 것
4. **다크 판타지는 유지하되 "유쾌한" 톤** — Diablo 풍 무거움 금지. STS2는 "creepy but fun"
5. **에너지 오브를 캐릭터별로 차별화** — Life Quest의 캐릭터/직업별 시그니처 색을 오브에 반영
6. **모바일 가독성 최우선**: 카드 텍스트 줄이고 키워드 + 아이콘으로 압축. 탭 시 확대 툴팁
7. **베타 아트는 흉내내지 말 것** — STS2의 일부 카드 아트는 정식 출시 시 교체 예정. 정식 아트만 참조
8. **Ironclad 디자인 변화는 Casey Yano 본인이 1편을 "포기한 캐릭터"라고 인정한 만큼** 1편 디자인이 아닌 2편 디자인을 기준으로 삼을 것
