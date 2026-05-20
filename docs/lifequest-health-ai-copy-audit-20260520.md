# Life Quest Health/AI Copy Audit - 2026-05-20

This audit closes the repository-side release checklist item for overclaiming Health or AI behavior in the real Android app.

## Scope

- Runtime app code and localization strings under `lib/`
- Android manifest and dependency declarations
- Public release/privacy docs:
  - `PRIVACY_POLICY.md`
  - `docs/index.html`
  - `docs/lifequest-data-safety-inventory-20260519.md`
  - remake and feedback planning docs

## Official References

- Google Play Health Content and Services policy: https://support.google.com/googleplay/android-developer/answer/16528695
- Google Play Health apps declaration form help: https://support.google.com/googleplay/android-developer/answer/14738291
- Android Health Connect Play declaration guidance: https://developer.android.com/health-and-fitness/health-connect/declare-access
- Google Play AI-Generated Content policy overview: https://support.google.com/googleplay/android-developer/answer/14094294
- Google Play AI-Generated Content policy: https://support.google.com/googleplay/android-developer/answer/13985936

## Findings

| Area | Evidence | Release assessment |
| --- | --- | --- |
| Health Connect / Google Fit access | `rg` found no Health Connect package, Google Fit package, `ACTIVITY_RECOGNITION`, `BODY_SENSORS`, location, microphone, camera, or external media permission in app code/manifest. | Current Android app does not access health platform data. |
| Health data collection claim | `PRIVACY_POLICY.md` and `docs/index.html` state that Health Connect, Google Fit, medical, fitness sensor, and location data are not collected. | Current privacy copy matches code evidence. |
| "Health" stat wording | App strings use `건강`, `health`, HP, recovery, exercise quests, and game stat labels. | Acceptable as RPG/game terminology if store listing and onboarding do not present it as medical or fitness analysis. |
| Exercise quest examples | Initial/default quests include examples such as `운동 30분`, weekly exercise, and monthly exercise counts. | Acceptable as user-entered self-management goals; not sensor-derived health data. |
| Medical claims | `rg` found no user-facing promise to diagnose, treat, prescribe, measure vitals, infer health conditions, or provide medical advice. | No repository evidence of medical-functionality overclaim. |
| AI runtime features | `rg` found no OpenAI/Gemini/Vertex/Firebase AI SDK, chatbot, generative model, or AI coach runtime path in `lib/`, `android/`, or `pubspec.yaml`. | Current Android app is not a generative AI app. |
| Recommendation copy | User-facing recommendations come from deterministic `CoreLoopRules.recommendAction`, not an AI model. | Copy should continue to say "recommended action" rather than "AI coach" or "AI-managed life." |
| Planning docs | Remake docs mention Health Connect and AI personal coach as deferred or prohibited for v1 scope. | Planning direction is aligned, but store copy must avoid surfacing deferred features as available. |

## Store Listing / In-App Copy Guardrails

Allowed for v1:
- "현실 행동을 RPG 성장과 보상으로 바꾸는 앱"
- "수동 기록 기반 퀘스트, 성장, 칭호, 추천 행동"
- "건강 스탯" only as a game stat category, alongside strength/wisdom/charisma
- "운동/수면/휴식 같은 생활 목표를 직접 기록"

Avoid before the matching feature and policy review exist:
- "Health Connect 연동", "Google Fit 연동", "자동 건강 데이터 분석"
- "의료", "진단", "치료", "처방", "건강 상태 예측"
- "칼로리/수면/심박/걸음 수를 자동 수집" unless implemented and declared
- "AI 개인 코치", "AI가 인생을 관리", "AI 건강 조언"
- Any claim that Life Quest replaces professional medical, mental health, financial, or legal advice

## Required Play Console Checks

- Complete the Play Console Health apps declaration before any closed testing or production track. Current repository evidence supports a declaration that the app does not access Health Connect or collect health data, but the final answer must match the exact store listing copy.
- If Health Connect, Google Fit, sensor, or medical/fitness analysis features are added later, redo Data safety, privacy policy, permission justification, Play declaration, and Android smoke tests before release.
- If generative AI content or an AI coach is added later, add user reporting/feedback controls where required by Google Play AI policy and redo misleading-claim review.

## Decision

Repository-side Health/AI copy risk is acceptable for the current Android release candidate. The app uses "health" as an RPG stat and deterministic recommendation logic; it does not currently implement Health Connect, Google Fit, medical advice, fitness sensor collection, or generative AI features.

The full release gate remains open until Play Console declarations and store listing copy are reviewed together.
