# 경계의 서가 아트 · 2026-09-20

기존 게이트 중심 브랜드를 열린 기록장과 세 세계로 교체했다. 새 자산8개 모두 내장 **image_gen**으로 생성·편집했다. SVG/HTML/Canvas 아트를 새로 만들지 않았다. sips는 출력 크기·포맷 변환에만 사용했다. 다른 작품의 이미지·로고·인물은 자산으로 복사하지 않았다.

레퍼런스 조사와 해석: [CONCEPT_AND_REVENUE.md](../CONCEPT_AND_REVENUE.md). 도시의 게이트는 무료 단편 한 권에만 유지한다. 아래 이전 기록은 제작 이력이며 현재 브랜드 기준이 아니다.

| 생성 원본 | 현재 사용 | image_gen 결과 식별자 |
|---|---|---|
| tide-postoffice-master.png | 「조수 우체국」표지1200px JPEG | exec-8bc8fb03-9823-4774-85e5-9ee4204b5661 |
| tide-mark-master.png | 종이배 완독 표식256px alpha PNG | exec-5596ac0a-ff44-48c0-ab86-de91b7dd4aec |
| courtyard-master.png | 수련 표지 courtyard.jpg | exec-6a236eb8-7e58-4a74-afd6-01495773dcb8 |
| atlas-master.png | 탐사 표지 atlas.jpg | exec-88b0aadd-9216-4883-896b-b92c939d3246 |
| journal_worlds-master.png | 첫 화면·미선택 이야기 배너 | exec-9162cfcb-525d-4a1a-9cdc-c1fdd159bf25 |
| journal-icon-foreground-master.png | alpha adaptive foreground·스플래시·로그인 마크 | exec-f4a02b54-687c-43de-b7e5-cf83bdb7e609 |
| journal-icon-master.png | 런처·512px Play 아이콘 | exec-836f3e8d-d070-43cc-8122-17cba709210b |
| journal-feature-master.png | 1024×500 Play 피처 그래픽 | exec-66e621d8-4398-4257-8729-c576b75ef14a |

프롬프트 의도 기록: ① 옥색 산중 수련 마당·목조 정자·빗자루와 낡은 연습검·아침빛, 전투 인물이나 원작 문양 없음 ② 황동 관측소·지도 수선 작업대·호박색 조명과 달빛, 텍스트 없음 ③ 현대 책상의 열린 기록장 위에 도시 역·수련 정자·관측소를 동등한 종이 풍경으로 표현 ④ 투명 배경 위 아이보리 기록장·옥색과 호박색 책 모서리·황동 나침반 책갈피, 작은 크기에서 읽히는 아이콘 ⑤ 같은 아이콘에 먹색 불투명 배경 추가 ⑥ 기록장 장면을 오른쪽에 두고 왼쪽에 정확한 문구 ‘LIFE QUEST / Your day. Your unfolding story.’를 이미지 생성으로 렌더링.

원본은 docs에 보존되어 앱에 포함되지 않는다. 런타임 표지는1280px JPEG, foreground는1024px alpha PNG다. Play 아이콘512×512와 피처1024×500는 알파가 없음을 sips로 확인했다. Flutter 공식 icon/splash 생성기로 밀도별 자산을 출력했다. 완전한 법적 독점성·상표 등록 가능성을 보증하지 않는다.

## 이전 게이트 아트 제작 이력 (2026-09-17)


사용자 지시: SVG/HTML/Canvas로 일러스트나 홍보 이미지를 직접 만들지 않는다. 내장 **image_gen**으로 원본 아트를 생성했다. CLI 이미지 생성/API 키/유료 스톡은 사용하지 않았다. Flutter의 버튼·레이아웃·지도 연결선 등 기능 UI와 이미지 아트를 구별한다.

## 참고와 사용 범위

- [LifeUp](https://www.lifeupapp.fun/en/): 일상 행동과 성장의 연결, 읽기 쉬운 우선순위.
- [Solo Leveling: ARISE 공식 갤러리](https://sololeveling.netmarble.com/en/gallery): 짙은 남색과 절제된 차가운 빛의 대비 원칙만 참고. 캐릭터/로고/배경을 추출하거나 재배포하지 않았다.
- [Google Play 아이콘 규격](https://developer.android.com/distribute/google-play/resources/icon-design-specifications): 512px 정사각형 PNG, 1MB 이하, 외곽 모서리·그림자는 Play가 처리.

무료 프롤로그 ‘0번 출구’의 현대 도시와 판타지 사이에 놓인 문을 고유 브랜드 모티프로 선택했다. 사진·스톡 템플릿의 라이선스를 잘못 전용한 자산은 없다. 생성 아트의 완전한 법적 독점성이나 상표 등록 가능성을 주장하지 않는다.

## 원본과 제품 적용

| 원본 파일 | 적용 |
|---|---|
| gate-icon-master.png | `assets/images/app_icon.png`, Android/웹 런처, `../store/app-icon-512.png` |
| gate-foreground-master.png | 알파가 있는 adaptive foreground와 스플래시. Flutter 공식 자산 생성 도구로 밀도별 크기 출력, foreground inset 14%. 오래된 Android 13 monochrome 별도 오버라이드 제거 |
| exit-zero-master.png | `assets/images/backgrounds/exit_zero_gateway.jpg`: 가입 없는 시작, 오늘의 이야기 배너, 4언어 프롤로그 |
| feature-en-master.png | `../store/feature-graphic-1024x500.png`: Play 기본 언어 그래픽 초안 |

`image_gen` 결과를 작업 폴더로 복사했다. macOS sips로 규격에 맞는 크기/포맷만 내보냈고, 아트·문구·로고를 코드로 그리거나 합성하지 않았다. 스토어 배너의 문구도 이미지 생성 도구가 렌더링했다. 512px 아이콘 약472KiB, 1024×500 배너 약772KiB. 고해상도 원본은 docs 아래에 있어 앱에 포함되지 않는다.

## 최종 프롬프트 세트

1. **logo-brand / gate-icon-master**: One finished square raster app icon for Life Quest, a Korean modern-fantasy daily-habit RPG. A single striking dimensional open gateway, brushed silver-blue mineral, a warm white-to-cyan slit of light inside, small ascending angular notch suggesting personal growth. Strong asymmetrical silhouette readable at 48px, mature restrained shading/material depth. Centered, generous circular-mask space, subtle 3/4 perspective. Full-bleed midnight navy #090F1C, glacier cyan, silver, tiny champagne reflection. No existing game IP, characters, weapons, letters, numbers, watermark, outer rounded corners, border or outer shadow. Painted/3D raster, square at least1024px.
2. **illustration-story / exit-zero-master**: Use the gate icon only as a brand reference. New original wide cinematic Exit Zero background: empty contemporary Seoul-inspired underground station after the last train, tiled concourse and wet reflections, subtle teal architecture, the silver-blue doorway at72% width revealing pale dawn. Hopeful everyday modern fantasy, no people or horror. High-end painted concept art, atmospheric perspective, realistic architecture.2.048:1, quiet dark left42% for app text, broad crop safety, no signage/text/UI/watermark or existing webtoon/game art.
3. **ads-marketing / feature-en-master**: Edit the selected environment; preserve painting, architecture, doorway and colors. Add only refined silver-white geometric sans-serif typography on the dark left: two-line exact title ‘LIFE’ / ‘QUEST’; smaller ice-blue exact tagline ‘Make today your next chapter.’ Spacious editorial composition, keep doorway unobscured, within safe margins. No badges, fake UI, phone frame or store ranking.1024×500 or larger same ratio.
4. **background-extraction / gate-foreground-master**: Edit selected icon, preserving silver-blue gate/material and luminous interior. Remove surrounding navy background/fog/reflections/loose rocks. Isolate doorway and integral two-step threshold on genuine alpha transparency, with generous clear margins. Interior stays opaque; no new objects, checkerboard, text, rounded outer icon or mockup.

## 스토어 상태

Play Console 초안 업로드 시도는 Chrome 확장 ‘파일 URL에 대한 액세스 허용’이 꺼져 `fileChooser.setFiles: Not allowed`로 실패했다. 사용자에게 설정을 안내하고 답변을 기다린다. 실제 업로드/저장 완료로 기록하지 않는다. 필수 Android 스크린샷도 아직 미등록이다.

조수 우체국 표지는 비 오는 현대 해안 거리와 물에 비친 옥색 문·황동 우편함·따뜻한 작업실을 오리지널 회화로 생성했다. 표식은 파도 위 종이배를 담은 황동 메달로 투명 배경을 요청했다. 기존 작품 캐릭터/로고/작가 지정 없이 생성했고, 변환은 sips의 크기·포맷 출력만 사용했다.
