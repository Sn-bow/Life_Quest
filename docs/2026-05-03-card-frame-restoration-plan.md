# 카드 프레임 복원 + 핀포인트 수정 계획서
> 작성일: 2026-05-03
> 배경: 2026-05-02 Plan C-2(코드 기반 교체)가 26_04_25 세션의 디자인 의도를 훼손함 → 원본 PNG 복원 필요
> 대상 파일: `lib/screens/dungeon/card_battle_screen.dart`, `assets/images/cards/*.png`

---

## 1. 사고 경위 — 무엇이 잘못됐는가

### 1-1. 26_04_25 세션 (원본 작업)
이전 세션 transcript 분석 결과, 카드 프레임 4종은 **단순한 임시 에셋이 아니라 의도적으로 설계된 작업물**이었음:

**디자인 리서치 (Line 4728):**
- Slay the Spire 2 자료 조사 후 STS2 아트 스타일 채택
- 캐릭터별 색상 프레임 + 다크 판타지 금속/마법 재질
- Attack=빨강, Defense=파랑, Magic=보라, Tactical=초록 (시각적 구분)

**생성 방식 (Line 4793, 4929, 5036):**
- Codex MCP (GPT-image-2)로 1장씩 생성
- "투명 배경 프롬프트 핵심 공식" 명시적으로 설계됨
- Codex 세션 만료/Python 폴백 등 여러 차례 실패 끝에 성공
- 최종 4장 모두 `assets/images/cards/`에 저장 (Line 5208 설치 완료)

**GAME_DESIGN.md §11.2 명세:**
```
카드 프레임 색상:
- 🗡️ 공격: 빨간색 테두리
- 🔮 마법: 보라색 테두리
- 🛡️ 방어: 파란색 테두리
- ✨ 전술: 노란색 테두리
- 💀 저주: 검은색 테두리 (5번째, 향후 추가 예정)
```

### 1-2. 2026-05-02 Plan C-2 (잘못된 판단)
어제 세션에서 내가 한 잘못:
1. **이전 세션의 작업 의도를 모른 채** 카드 프레임 4종의 "스타일 불일치"를 문제로 진단
2. **하나의 에셋 문제(tactical 흰 배경)를 전체 교체 사유로 확대 해석**
3. PNG 4장 전부를 `Container + Border` 코드 기반 박스로 교체
4. 결과: STS2 스타일의 디테일한 일러스트 프레임 → 단조로운 색깔 박스

### 1-3. 실제 문제 재진단
PNG 에셋을 다시 직접 확인한 결과, 4종 중 **tactical 1종만 실제 문제**:

| 프레임 | 중앙 영역 | 카드 내용 가독성 | 실제 문제 여부 |
|--------|----------|----------------|---------------|
| `card_frame_attack.png` | 검은 배경 + 검 장식 | 흰 텍스트 + 검은 그림자 → OK | ❌ 문제 없음 |
| `card_frame_defense.png` | 어두운 돌 질감 | 흰 텍스트 + 검은 그림자 → OK | ❌ 문제 없음 |
| `card_frame_magic.png` | 투명 | 배경 위에 표시 → OK | ❌ 문제 없음 |
| `card_frame_tactical.png` | **흰색 배경** | 흰 텍스트 → **안 보임** | ✅ 핀포인트 수정 필요 |

**스타일 통일성 이슈는 본질적이지 않음** — 4종 모두 STS2 다크 판타지 카테고리에 속하고, 카테고리별로 다른 분위기인 게 오히려 의도된 디자인.

---

## 2. 복원 + 수정 계획

### 단계 1: 코드 복원 — PNG 프레임 다시 사용

**대상**: `card_battle_screen.dart` `_HandCard` 클래스

**되돌릴 변경:**
1. `_frameAsset` getter 복원 (Attack/Defense/Magic/Tactical → PNG 경로)
2. `_bgColor` / `_headerColor` getter 제거 (코드 기반 박스용 → 불필요)
3. `Positioned.fill` 안에 `Image.asset(_frameAsset, fit: BoxFit.fill)` 복원
4. PNG 로드 실패 시 fallback Container만 유지 (errorBuilder)

**유지할 변경 (어제 한 것 중 좋은 것):**
- 코스트 원에 카테고리 색상 적용 (border + glow) — 시각적 구분 강화에 도움
- 카테고리 아이콘 위치/크기 — 그대로 유지

### 단계 2: tactical 프레임 핀포인트 수정 — 3가지 옵션

#### Option A (권장): Codex로 tactical PNG 재생성
- Codex MCP `mcp__codex__codex` 1회 호출로 tactical 프레임만 재생성
- 프롬프트: 기존 attack/defense/magic 프레임 스타일과 통일, 중앙 완전 투명, 초록 스팀펑크 테마 유지
- 작업량: Codex 호출 1회 + APK 재빌드
- 전제: 사용자가 Codex 환경 사용 가능 상태

#### Option B (코드 기반): 런타임에 흰 배경을 투명으로 처리
```dart
// tactical 카드일 때만 ColorFiltered 적용
ColorFiltered(
  colorFilter: const ColorFilter.matrix([
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    -1, -1, -1, 1, 255,  // 흰색 픽셀 → 알파 0
  ]),
  child: Image.asset(_frameAsset, fit: BoxFit.fill),
)
```
- 장점: 에셋 재생성 불필요, 즉시 적용
- 단점: ColorMatrix는 anti-aliased 가장자리에서 잔여 흰색 발생 가능 (테두리 주변 fringe)
- 작업량: tactical 한정 분기 처리 5줄

#### Option C (가장 단순): 어두운 오버레이로 흰 배경 덮기
```dart
// tactical 프레임 위에 dark overlay 추가
Stack(children: [
  Image.asset(_frameAsset, fit: BoxFit.fill),  // 프레임
  if (card.category == CardCategory.tactical)
    Positioned(
      left: 14, right: 14, top: 14, bottom: 14,  // 프레임 테두리 안쪽만
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1A0E).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
])
```
- 장점: 다른 3종에 영향 없음, 즉시 적용 가능, 잔여 흰색 없음
- 단점: tactical 프레임의 일부 일러스트 디테일이 가려질 수 있음 (테두리 안쪽 4px만 가리므로 영향 적음)
- 작업량: 5분 이내

**권장 순서**: **Option C → 결과 확인 → 마음에 안 들면 Option A 진행**

### 단계 3: 어제 수정의 다른 좋은 변경은 유지

| 항목 | 어제 수정 | 유지 여부 |
|------|----------|----------|
| 턴 종료 버튼 텍스트 | Stack에 Text 오버레이 추가 | ✅ 유지 |
| HP 바 그라데이션 (초록/노랑/빨강) | 코드 기반 그라데이션 | ✅ 유지 |
| 플레이어 스프라이트 | `_PlayerInfoBar` 좌측 | ✅ 유지 |
| 카드 프레임 코드 박스 | `Container + Border` | ❌ 제거 (이번 복원 대상) |

---

## 3. 작업 순서

| 순위 | 작업 | 예상 시간 | 의존성 |
|------|------|----------|--------|
| 1 | `_frameAsset` getter 복원 | 1분 | 없음 |
| 2 | `_bgColor`/`_headerColor` getter 제거 | 1분 | 없음 |
| 3 | `Image.asset(_frameAsset)` 렌더링 복원 | 3분 | #1 |
| 4 | tactical Option C 오버레이 추가 | 5분 | #3 |
| 5 | 코스트 원 색상 글로우 (어제 변경 유지) | 0분 | 없음 |
| 6 | flutter analyze | 30초 | #1~5 |
| 7 | APK 빌드 + 설치 | 3분 | #6 |
| 8 | 기기 스크린샷 검증 | 1분 | #7 |

**총 예상 시간**: 15분 이내 (Option C 기준)

---

## 4. 검증 체크리스트

복원 완료 후 확인할 항목:
- [ ] Attack 카드 — 검 + 불꽃 장식 프레임 다시 보임
- [ ] Defense 카드 — 방패 + 파란 보석 프레임 다시 보임
- [ ] Magic 카드 — 보라 별 장식 프레임 다시 보임
- [ ] Tactical 카드 — 초록 스팀펑크 프레임 + 흰 배경 가려짐 + 텍스트 가독성 확보
- [ ] 4종 모두 카드 이름/설명 텍스트 가독성 OK
- [ ] 코스트 원 색상이 카테고리별로 구분됨 (어제 변경 유지)
- [ ] 카드 사용 불가 시 어두워지는 효과 동작 (Opacity 0.45)

---

## 5. 재발 방지 — 디자인 의사결정 원칙

이번 사건의 교훈을 다음 원칙으로 정리:

1. **기존 에셋 교체 전 의도 확인 필수** — `git log --follow` 또는 이전 세션 transcript로 해당 에셋이 "임시"인지 "의도된 작품"인지 먼저 파악
2. **하나의 문제를 전체 교체 사유로 확대 금지** — 4종 중 1종 문제면 1종만 수정, 나머지 3종은 보존
3. **AI 생성 에셋은 코드로 대체 불가** — 일러스트 디테일은 코드 기반 `Container + Border`로 절대 복제 불가능
4. **GAME_DESIGN.md를 1차 참조** — 디자인 변경 전 명세 확인 (§11.2 카드 비주얼 디자인 등)
