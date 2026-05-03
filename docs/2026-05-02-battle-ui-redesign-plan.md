# 전투 UI 재디자인 계획서
> 작성일: 2026-05-02  
> 기준 기기: SM A530N (Android 9)  
> 대상 파일: `lib/screens/dungeon/card_battle_screen.dart`

---

## 1. 현재 상태 진단 (스크린샷 + 에셋 직접 확인)

### 1-1. HP 바 (`ui_hp_bar.png`)

**에셋 실제 모습**: 완전한 검은색 둥근 직사각형 바  
**코드 의도**: 이 이미지를 "꽉 찬 HP 상태"로 깔고, 오른쪽에서부터 검은 오버레이로 덮어 HP 감소를 표현  
**실제 결과**: 이미지 자체가 검은색이라 HP가 100%여도 검은 막대로 보임 → HP 정보 전달 실패

```
현재 구조:
[ui_hp_bar.png (검은 바)] → 위에 검은 오버레이 덮음
= 화면에서는 그냥 검은 바로만 보임
```

**근본 원인**: 에셋이 "빈 HP 바 배경"으로 만들어졌는데, 코드는 "꽉 찬 HP 이미지"로 가정하고 구현됨 → 에셋과 코드 의도가 불일치

---

### 1-2. 턴 종료 버튼 (`ui_turn_end_button.png`)

**에셋 실제 모습**: 빨간 그라데이션 + 분홍 테두리의 둥근 버튼 이미지  
**코드 구조**: `Stack` 안에 이미지만 배치, 텍스트/아이콘 레이어 없음  
**실제 결과**: 빨간 이미지 버튼이 표시되나 어떤 기능인지 알 수 없음, "턴 종료" 텍스트 없음

```dart
// 현재 코드 (card_battle_screen.dart:1207)
Stack(
  alignment: Alignment.center,
  children: [
    Image.asset('assets/images/ui/ui_turn_end_button.png', ...),
    // ← 텍스트/아이콘 레이어가 없음
  ],
)
```

**문제**: 버튼 이미지 위에 텍스트("턴 종료")나 아이콘이 오버레이되지 않아 기능 불명확

---

### 1-3. 카드 프레임 4종 (구조적 불일치)

에셋을 직접 확인한 결과:

| 프레임 | 실제 이미지 구성 | 중앙 배경 | 스타일 |
|--------|----------------|----------|--------|
| `card_frame_attack.png` | 불꽃 + 검 장식 테두리 + **검정 배경 포함** | 검정 (불투명) | 어둠/화염 |
| `card_frame_defense.png` | 파란 보석 + 방패 + **돌 질감 배경 포함** | 어두운 돌 (불투명) | 판타지 파란계열 |
| `card_frame_magic.png` | 보라 달/별 장식 테두리 | 투명 | 마법 보라계열 |
| `card_frame_tactical.png` | 초록 스팀펑크 기어 테두리 | 흰색 (불투명) | 스팀펑크 초록계열 |

**문제 1 — 배경 불일치**: attack/defense는 배경이 이미지에 포함되어 있고, magic은 투명, tactical은 흰색 → 카드 내용이 올라갔을 때 tactical 카드는 흰 배경에 흰 텍스트로 가독성 0

**문제 2 — 스타일 통일성 없음**: 4종이 완전히 다른 아트 스타일 (불꽃 판타지 / 파란 판타지 / 보라 마법 / 스팀펑크)로 같은 게임 안에서 이질감

**문제 3 — 카드 내용 레이아웃 충돌**: 코드에서 카드 내용(코스트 원, 이름, 아이콘 56px, 설명, 레어도)을 `Padding(fromLTRB(10, 8, 10, 8))`로 올리는데, attack 프레임의 불꽃 장식이 카드 하단을 침범해 텍스트와 겹침

---

### 1-4. 플레이어 스프라이트 부재

**현재 상태**: 전투 화면에 플레이어 캐릭터가 표시되지 않음  
**이유**: `card_battle_screen.dart`에 플레이어 영역 위젯 자체가 없음  
`PlayerProfileSprite` 위젯은 존재하나 전투 화면에서 미사용  
**결과**: 전투가 "몬스터 vs 아무것도 없음" 구도 → 전투감 부재

---

## 2. 개선 계획

### Plan A — HP 바 재구현

**방향**: 에셋 방식 → 코드 기반 그라데이션 바로 교체  
에셋 의존을 끊고 Flutter `LinearProgressIndicator` 커스텀 또는 `CustomPainter`로 구현

```
[어두운 배경 바] + [초록→노랑→빨강 그라데이션 바 (HP 비율)] + [하트 아이콘] + [HP 텍스트]
```

구체적 UI:
- 배경: `Color(0xFF1A1A2E)` 둥근 바
- HP 그라데이션: HP > 60% → 초록(`#4CAF50`), 30~60% → 노랑(`#FFC107`), < 30% → 빨강(`#F44336`)
- 좌측에 하트 아이콘(`Icons.favorite`) + "80 / 80" 텍스트 오버레이
- 애니메이션: `AnimatedContainer` 300ms easeOut (기존 유지)

**변경 파일**: `card_battle_screen.dart` — `_PlayerHpBar` 위젯 교체  
**에셋 변경**: `ui_hp_bar.png` 미사용 (삭제 또는 보존)

---

### Plan B — 턴 종료 버튼 텍스트 추가

**방향**: 버튼 이미지 유지, `Stack`에 텍스트 레이어 추가  
이미지 버튼은 유지하되 위에 "턴 종료" 텍스트를 오버레이

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Image.asset('assets/images/ui/ui_turn_end_button.png', ...),
    Text(
      l10n.battleEndTurn,  // 기존 l10n 키 활용
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
      ),
    ),
  ],
)
```

**변경 파일**: `card_battle_screen.dart` — `_TurnEndButton.build()` 내 Stack에 Text 추가  
**에셋 변경 없음**

---

### Plan C — 카드 프레임 재설계

**방향 선택지 2가지:**

#### Option C-1: 에셋 교체 (권장)
4종 프레임을 새로 생성. 요구사항:
- 모두 **중앙 투명** (PNG 알파 채널)
- 테두리 장식만 있고 내부는 비워둠
- 통일된 아트 스타일 유지하되 카테고리 색상으로 구분
- 권장 크기: 가로 세로 비율 110:160 (실제 카드 위젯 비율)

신규 에셋 스펙:
```
card_frame_attack.png   → 빨간/주황 테두리, 검 문양, 중앙 투명
card_frame_defense.png  → 파란/청록 테두리, 방패 문양, 중앙 투명
card_frame_magic.png    → 보라/자주 테두리, 별 문양, 중앙 투명 (현재 것 재활용 가능)
card_frame_tactical.png → 초록/금 테두리, 나침반 문양, 중앙 투명
```

코드 변경: 없음 (프레임 이미지만 교체)

#### Option C-2: 코드 기반 프레임 (에셋 교체 없이 즉시 적용 가능)
이미지 의존 제거, `CustomPainter` 또는 `Container` + `Border`로 카테고리별 프레임 구현

```dart
// 카테고리별 카드 배경 색상 + 테두리로 구분
attack   → 배경 Color(0xFF1A0A0A), 테두리 Colors.red.shade600
defense  → 배경 Color(0xFF0A0A1A), 테두리 Colors.blue.shade500
magic    → 배경 Color(0xFF120A1A), 테두리 Colors.purple.shade400
tactical → 배경 Color(0xFF0A1A0A), 테두리 Colors.green.shade500
```

카드 내부 레이아웃도 함께 정리:
- 상단 코스트 원 + 카드 이름
- 중앙 카테고리 아이콘 (56px, 현재 유지)
- 하단 설명 + 레어도

**권장**: Option C-1 (에셋 교체) — 하지만 에셋 생성 리소스가 없으면 C-2로 즉시 진행

---

### Plan D — 플레이어 스프라이트 추가

**방향**: 전투 화면 상단 플레이어 영역에 `PlayerProfileSprite` 위젯 삽입

현재 전투 화면 레이아웃:
```
[상단 HUD: EP + 드로우버튼 + 턴/상태]
[몬스터 영역 (중앙 큰 영역)]
[플레이어 HP 바]
[카드 핸드]
```

변경 후:
```
[상단 HUD: EP + 드로우버튼 + 턴/상태]
[몬스터 영역 (좌측 60%)] | [플레이어 스프라이트 (우측 40%)]
[플레이어 HP 바]
[카드 핸드]
```

또는 심플하게:
```
[상단 HUD]
[몬스터 영역]
[플레이어 HP 바 + 플레이어 스프라이트 (작게, HP 바 좌측)]
[카드 핸드]
```

`PlayerProfileSprite`는 `CharacterState`의 `character` 필드에서 gender/skinTone/hairStyle 등을 읽어 렌더링 가능.

**변경 파일**: `card_battle_screen.dart` — 플레이어 HP 바 영역 위젯 수정

---

## 3. 작업 우선순위

| 순위 | 항목 | 난이도 | 효과 | 에셋 필요 |
|------|------|--------|------|----------|
| **1** | Plan B — 턴 종료 버튼 텍스트 | 쉬움 (10분) | 즉시 UX 개선 | 없음 |
| **2** | Plan A — HP 바 재구현 | 보통 (30분) | 핵심 정보 가독성 | 없음 |
| **3** | Plan C-2 — 카드 프레임 코드 기반 | 보통 (1시간) | 카드 일관성 개선 | 없음 |
| **4** | Plan D — 플레이어 스프라이트 | 보통 (1시간) | 전투감 향상 | 없음 |
| **5** | Plan C-1 — 카드 프레임 에셋 교체 | 어려움 (에셋 생성 필요) | 최고 품질 | 신규 4종 PNG |

---

## 4. 구현 시 주의사항

- `card_battle_screen.dart`는 1700줄 이상의 대형 파일 → 수정 범위를 위젯 단위로 한정
- `_PlayerHpBar`, `_TurnEndButton`, `_HandCard`는 독립 클래스로 분리되어 있어 수정 용이
- l10n 텍스트 추가 시 4개 언어(ko/en/ja/zh) ARB 파일 동시 수정 필요
- 플레이어 스프라이트 삽입 시 `Consumer<CharacterState>`로 감싸야 캐릭터 데이터 접근 가능
- 전투 화면 레이아웃 변경 시 `MediaQuery`로 화면 크기 분기 (SM A530N 기준 360x740dp)

---

## 5. 검증 방법

각 변경 후 ADB로 스크린샷 확인:
```powershell
& "C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe" -s 520034bafe9225db shell screencap -p /sdcard/screen.png
& "C:\Users\wjd54\AppData\Local\Android\Sdk\platform-tools\adb.exe" -s 520034bafe9225db pull /sdcard/screen.png "C:\Users\wjd54\OneDrive\Desktop\screen.png"
```

확인 체크리스트:
- [ ] HP 바에서 현재 HP 비율이 색상으로 명확히 표시됨
- [ ] 턴 종료 버튼에 텍스트가 표시되고 탭 가능함
- [ ] 카드 4종이 배경 일관성 있게 렌더링됨
- [ ] 플레이어 스프라이트가 전투 화면에 표시됨
- [ ] HP 50% 이하 시 바 색상이 변화함
- [ ] 턴 종료 버튼 비활성화 시 텍스트도 흐려짐 (Opacity 0.45)
