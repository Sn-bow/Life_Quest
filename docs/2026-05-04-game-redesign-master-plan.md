# Life Quest 전투 시스템 전면 재설계 마스터 플랜

> 작성일: 2026-05-04
> 작성 배경: 26_04_25 → 26_05_02 → 26_05_03 누적 세션에서 STS2 스타일 작업이 누차 실패. PNG 복원/오버레이 같은 미봉책으로는 해결 불가능 — **처음부터 STS2 디자인 언어를 정확히 이해하고 재설계 필요**.
> 참조: `docs/2026-05-04-sts2-research.md` (자료조사 1차)

---

## 0. 이 문서의 위치 (Source of Truth)

| 문서 | 역할 | 상태 |
|------|------|-----|
| `2026-05-04-sts2-research.md` | STS2 정확한 자료조사 | ✅ 완료 |
| **`2026-05-04-game-redesign-master-plan.md`** (본 문서) | **재설계 마스터 플랜** | ✅ 작성 중 |
| `2026-05-02-battle-ui-redesign-plan.md` | 어제 잘못된 계획 | ❌ **폐기** |
| `2026-05-03-card-frame-restoration-plan.md` | 어제 미봉책 계획 | ❌ **폐기** |
| GAME_DESIGN.md §11.2 | 카드 비주얼 명세 | 🔄 **본 문서 기준으로 갱신 예정** |

---

## 1. 실패의 근본 원인 분석 (3세션 누적)

### 1-1. 26_04_25 세션 (Codex 에셋 생성)
- ✅ STS2 자료조사 시도 → 일부 정보(캐릭터별 색상 4종) 확보
- ❌ 자료조사가 얕음 — STS의 진짜 시각 언어인 "**타입별 프레임 하단 모양 + 레어도별 배너 색**"을 놓침
- ❌ 카드 프레임 4종을 "카테고리별 색"으로만 디자인 → 4종이 서로 다른 일러스트 컨셉으로 따로따로 생성됨
- ❌ tactical 프레임의 "흰 배경" 같은 명백한 결함도 검수 없이 통과

### 1-2. 26_05_02 세션 (코드 기반 박스 교체)
- ❌ 26_04_25 세션 작업물 의도를 모른 채 PNG 4종 전부 폐기
- ❌ Container + Border 코드로 교체 → 일러스트 디테일 0
- 사용자 반응: "진짜 조잡하다"

### 1-3. 26_05_03 세션 (PNG 복원 + 오버레이)
- ✅ 이전 세션 transcript 분석으로 의도 파악
- ❌ **근본 문제 회피**: 4종 PNG가 처음부터 STS2 시각 언어를 따르지 않은 것이 진짜 문제. 이걸 그대로 복원하면 또 같은 결과
- ❌ tactical 흰 배경에 오버레이만 덮음 → 전체 통일성은 여전히 없음
- 사용자 반응: "캐릭터는 뭐고 카드 프레임이 진짜 최악"

### 1-4. 진짜 문제 (이번에 정직하게 진단)
**이전 작업들의 공통 결함:**

| 문제 | 현황 | STS2의 정답 |
|------|------|------------|
| **카드 프레임이 4종 모두 다른 컨셉** | 검+불 / 방패+돌 / 보라별 / 초록기어 | 4종이 **동일한 프레임 구조** + 타입별 하단 모양만 다름 |
| **레어도 시각 표현 없음** | rarity 텍스트만 표시 | 배너/프레임 색이 **회색→파랑→금색→프리즘** |
| **카드 일러스트 영역 없음** | 카테고리 아이콘 1개로 대체 | 카드마다 **고유 일러스트** (이게 STS의 핵심 자산) |
| **플레이어 캐릭터가 막대인형** | 32px 픽셀 스프라이트 | 풀바디 일러스트, 또렷한 라인워크 |
| **전투 화면 레이아웃 임시방편** | 박쥐가 카드처럼 프레임 처리됨 | 적은 배경 위에 직접 배치, 프레임 없음 |
| **HP 바, 턴 종료 버튼 비균형** | 코드 그라데이션 + 빨간 박스 | 일관된 UI 키트 (테마 색 + 다크 베이스) |

---

## 2. STS2 핵심 시각 언어 (반드시 준수할 4가지 규칙)

자료조사에서 확립된 **타협 불가** 원칙:

### 규칙 1: 카드 타입은 프레임 하단 모양으로 구분
| 타입 | 하단 모양 | Life Quest 매핑 |
|------|----------|----------------|
| Attack | **사다리꼴** (좁아짐) | Attack |
| Skill | **직사각형** (그대로) | Defense, Tactical |
| Power | **타원** (둥글어짐) | Magic |

→ 4종 프레임이 **상단/중앙은 동일**, **하단 모양만 다름**.

### 규칙 2: 레어도는 배너/프레임 색으로 구분
| 레어도 | 배너 색 |
|-------|--------|
| Common | 회색 (#8B8B8B) |
| Uncommon | **파랑** (#4A90E2) |
| Rare | **금색** (#F0B43C) |
| Legendary | **프리즘** + 푸른 불꽃 (Ancient 차용) |

→ 같은 카드라도 레어도에 따라 배너 색이 변함.

### 규칙 3: 일러스트가 또렷한 라인워크 + 풍부한 색감
- 1편의 페인터리 X, 2편의 crisp 디자인 ○
- 카툰풍 X, 다크 판타지 일러스트 ○
- "creepy but FUN" 톤 — Diablo/Darkest Dungeon 같은 무거움 X

### 규칙 4: 카드는 "한 장의 작은 그림책"
- 상단: 코스트 오브 + 카드 이름 배너
- **중앙: 카드 일러스트 (가장 큰 영역)** ← 이게 빠지면 STS가 아님
- 하단: 효과 설명 텍스트 (키워드 위주, 짧게)

---

## 3. 재설계 범위 (Scope)

### 3-1. 본 플랜에서 다루는 것
- 카드 프레임 시스템 (4 타입 × 4 레어도 = 16종 가변 프레임)
- 카드 일러스트 (207장 중 우선순위 카드 ~30장)
- 전투 화면 UI 레이아웃 (적 배치, 플레이어, 손패, HP/에너지/턴 종료)
- 플레이어 캐릭터 일러스트 (hero_idle 재생성)
- 카드 카테고리 아이콘 (icon_attack/defense/magic/tactical)
- 컬러 팔레트 표준화

### 3-2. 본 플랜에서 다루지 않는 것 (별도 작업)
- 몬스터 31종 (이미 STS2 스타일로 생성됨, 그대로 유지)
- 렐릭 21종 (이미 STS2 스타일, 그대로 유지)
- 배경 5종 (이미 양호)
- 게임 로직/밸런스 (시각 작업과 분리)

---

## 4. 작업 단계 (Phase)

### Phase 1: 프레임 시스템 설계 (코드 + 1장 샘플 PNG)
**목표**: 4타입 × 4레어도 = 16종을 **2장의 PNG + 코드 합성**으로 처리하는 시스템

**아이디어**: 모든 카드 PNG는 타입별로 만들지 않음 — 대신 다음 레이어 합성:
1. **Base Frame**: 카드 외곽 (4 타입별 모양)
2. **Banner**: 상단 띠 (4 레어도 색)
3. **Illustration Slot**: 중앙 일러스트 (카드별 고유 PNG, 207장 중 우선 30장)
4. **Cost Orb**: 좌상단 (카테고리 색)
5. **Type Badge**: 하단 (Attack/Skill/Power 라벨, 색)

**산출물:**
- `assets/images/cards/frames/frame_attack.png` (사다리꼴 하단)
- `assets/images/cards/frames/frame_skill.png` (직사각형 하단)
- `assets/images/cards/frames/frame_power.png` (타원 하단)
- `assets/images/cards/banners/banner_common.png` (회색)
- `assets/images/cards/banners/banner_uncommon.png` (파랑)
- `assets/images/cards/banners/banner_rare.png` (금색)
- `assets/images/cards/banners/banner_legendary.png` (프리즘)
- `lib/widgets/cards/card_frame_widget.dart` (Stack 기반 합성 위젯)

**작업 시간**: Codex 에셋 생성 7회 + Flutter 위젯 1시간

### Phase 2: 카드 일러스트 30장 우선 생성
**우선순위 결정 기준**: 시작 덱(15장) + 자주 등장하는 보상 카드(15장)

**Codex 프롬프트 표준 템플릿 (자료조사 5번 항목 기반):**
```
[카드 이름] illustration for a card game inspired by Slay the Spire 2 art style:
- Crisp digital painting, NOT painterly
- Bold dark outlines (3-4px)
- Vibrant saturated colors with strong contrast
- Dark fantasy theme with playful "creepy but fun" energy
- Top-left lighting, clear shadow definition
- Character/object centered, fills most of the frame
- PURE TRANSPARENT background — no environment, no floor, no shadow beneath
- Designed to be readable at 200×280 pixel display size

Card subject: [카드별 구체 묘사]
```

**산출물:**
- `assets/images/cards/illustrations/atk_c01.png` (200×280, 투명 배경)
- ... (총 30장)

**작업 시간**: Codex 30회 호출 → 약 90분 (3분/장)

### Phase 3: 플레이어 캐릭터 + 카테고리 아이콘 재생성
**플레이어 (hero_idle.png):**
- 풀바디, 256×384, 투명 배경
- 가면형 얼굴 (몰입감) — 26_04_25 세션 사용자 요청 유지
- 일상 모험가 컨셉 (Life Quest는 일상 RPG)
- STS2 또렷한 라인워크 + 풍부한 색감

**카테고리 아이콘 (icon_attack/defense/magic/tactical.png):**
- 64×64, 투명 배경
- 검 / 방패 / 마법서 / 톱니바퀴 등 즉시 식별 가능한 실루엣
- 카테고리 색 (빨강/파랑/보라/노랑) 메인

**작업 시간**: Codex 5회

### Phase 4: 전투 화면 UI 재구축 (Flutter 코드)
**레이아웃 변경:**
```
┌──────────────────────────────────┐
│ ← 뒤로  [EP 3]    턴 1  카드 5/0 │  상단 정보바
├──────────────────────────────────┤
│                                  │
│      [몬스터 일러스트]            │  배경 위 직접 배치
│      ▼ Intent: ⚔ 6              │  (프레임 없음)
│      HP ████████ 15/15           │
│                                  │
│                                  │
├──────────────────────────────────┤
│  [플레이어]    HP/Block          │  중간 정보바
│   초상화      ████ 80/80  3 EP   │
├──────────────────────────────────┤
│  [카드1] [카드2] [카드3]  [턴종료]│  손패 + 턴 종료
└──────────────────────────────────┘
```

**변경 사항:**
- 적: Container 프레임 제거, 배경 위 직접 배치
- 플레이어: 좌측 초상화 + 우측 정보 (HP/Block/EP 한 줄)
- 손패: 부채꼴 X, **하단 일렬 슬라이드**
- 턴 종료: 우측 별도 버튼 (카드 라인 밖)

### Phase 5: 컬러 팔레트 표준화 + 디자인 토큰
**`lib/theme/sts2_colors.dart` 신규:**
```dart
class STS2Colors {
  // 카테고리
  static const attack    = Color(0xFFE53935);  // 빨강
  static const defense   = Color(0xFF1E88E5);  // 파랑
  static const magic     = Color(0xFFAB47BC);  // 보라
  static const tactical  = Color(0xFFF0B43C);  // 노랑(STS2 풍)

  // 레어도
  static const common    = Color(0xFF8B8B8B);
  static const uncommon  = Color(0xFF4A90E2);
  static const rare      = Color(0xFFF0B43C);
  static const legendary = Color(0xFF9C27B0);  // 프리즘 대체

  // 베이스
  static const bgDark    = Color(0xFF1A1A2E);
  static const bgPanel   = Color(0xFF16213E);
  static const textMain  = Color(0xFFE8E8E8);
  static const textSub   = Color(0xFFB0B0B0);
}
```

---

## 5. 작업 순서 + 예상 시간

| 순위 | Phase | 산출물 | 시간 | 검증 방법 |
|------|------|-------|-----|----------|
| 1 | Phase 1 | 프레임 합성 위젯 + 7장 PNG | 2시간 | 더미 카드 1장 화면 표시 |
| 2 | Phase 5 | sts2_colors.dart | 30분 | 코드 컴파일 |
| 3 | Phase 4 | 전투 화면 레이아웃 | 1.5시간 | 기기 스크린샷 |
| 4 | Phase 3 | 플레이어 + 아이콘 | 30분 (Codex) | 화면 표시 |
| 5 | Phase 2 | 카드 일러스트 30장 | 1.5시간 (Codex) | 카드 30장 화면 표시 |
| 6 | 통합 | APK 빌드 + 기기 검증 | 30분 | 사용자 확인 |

**총 예상**: 약 6시간 (Codex 호출 시간 포함)

---

## 6. 검증 체크리스트

각 Phase 완료 시 사용자 확인:

### Phase 1 완료 시
- [ ] Attack 카드: 하단이 사다리꼴 모양
- [ ] Skill 카드(Defense/Tactical): 하단이 직사각형
- [ ] Power 카드(Magic): 하단이 타원형
- [ ] 4종 프레임의 **상단 영역(코스트+이름)이 동일한 디자인**
- [ ] 레어도가 다른 같은 카드 = 배너 색만 다름

### Phase 2 완료 시
- [ ] 카드 30장이 각각 고유 일러스트 표시
- [ ] 일러스트 스타일이 31종 몬스터와 통일성 있음 (같은 STS2 톤)
- [ ] 200×280 크기에서 가독성 OK

### Phase 3 완료 시
- [ ] 플레이어가 막대인형이 아닌 풀바디 일러스트
- [ ] 가면 얼굴 (몰입감)
- [ ] 카테고리 아이콘 4종이 즉시 식별 가능

### Phase 4 완료 시
- [ ] 적이 카드처럼 프레임 안에 갇혀있지 않음
- [ ] 손패가 하단 일렬, 잘림 없음
- [ ] 턴 종료가 카드와 분리된 별도 영역
- [ ] HP/EP/Block 정보가 한눈에 들어옴

### 통합 완료 시
- [ ] STS2 스크린샷과 비교했을 때 "같은 종류 게임으로 인식되는" 정도

---

## 7. 재발 방지 — 이번에는 다르게

### 7-1. "선 자료조사, 후 작업" 원칙
- ✅ 이번에 자료조사 문서 먼저 작성 (`2026-05-04-sts2-research.md`)
- ✅ 자료조사가 부족한 항목은 "확인 필요"로 명시
- 작업 중 의문이 생기면 자료조사 문서로 돌아가서 확인

### 7-2. "한 번에 다 하지 않기"
- 16종 프레임을 16장 PNG로 만들지 않음 → **3타입 + 4배너 = 7장으로 합성**
- 207장 카드 일러스트를 한 번에 안 함 → **우선순위 30장만 먼저**

### 7-3. "Phase별 사용자 검증"
- 각 Phase 완료 시 기기 스크린샷 → 사용자 확인 후 다음 진행
- "전부 다 완성한 다음 보여주기" 금지 — 도중 방향 수정 가능하게

### 7-4. "에셋 폐기 신중"
- 몬스터 31종, 렐릭 21종은 이미 STS2 스타일 검증됨 → **건드리지 않음**
- 카드 프레임 4종 PNG는 STS2 시각 언어를 따르지 않으므로 **폐기 정당함**

### 7-5. "디자인 의사결정 트레일"
- 변경 결정 시 본 문서에 사유 추가
- "사용자가 시각적으로 보고 결정"한 사항은 별도 표시 (`✅ 사용자 확인 2026-05-04`)

---

## 8. 즉시 다음 액션

본 문서 사용자 검토 → 승인 시 Phase 1부터 시작:

1. Codex MCP로 `frame_attack/skill/power.png` 3장 생성 (사다리꼴/직사각형/타원 하단)
2. Codex MCP로 `banner_common/uncommon/rare/legendary.png` 4장 생성
3. `lib/widgets/cards/card_frame_widget.dart` 작성 (5레이어 Stack 합성)
4. 더미 카드 1장 화면에 표시 → 스크린샷 → 사용자 확인

**사용자 승인 대기 항목:**
- [ ] 본 문서 전체 방향성 동의?
- [ ] Phase 우선순위 (1→5→4→3→2→통합) 동의?
- [ ] 카드 일러스트 30장 우선이 적정? (모든 207장은 너무 많음)
- [ ] 플레이어 캐릭터 가면 컨셉 유지?
