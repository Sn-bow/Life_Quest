# Life Quest gateway art · 2026-09-17

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
