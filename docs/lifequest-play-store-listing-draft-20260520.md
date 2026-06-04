# Life Quest Play Store Listing Draft - 2026-06-04

Scope: Google Play main store listing draft for the default real Android app
package `com.lifequest.app`. The web QA preview is not the product being listed.

## Official References

- Play Console store listing setup: https://support.google.com/googleplay/android-developer/answer/9859152
- Google Play Metadata policy: https://support.google.com/googleplay/android-developer/answer/9898842
- Google Play Deceptive Behavior policy: https://support.google.com/googleplay/android-developer/answer/15407219
- Google Play Health Content and Services policy: https://support.google.com/googleplay/android-developer/answer/16528695
- Google Play AI-Generated Content policy: https://support.google.com/googleplay/android-developer/answer/14094294

## Play Console Limits

| Field | Limit | Draft status |
| --- | ---: | --- |
| App name | 30 characters | `Life Quest` is 10 characters |
| Short description | 80 characters | Korean draft is under 80 characters; English fallback is under 80 characters |
| Full description | 4000 characters | Korean and English drafts are under 4000 characters |

Metadata rules applied:
- Do not use ranking, price, promotion, or unsupported "official" claims.
- Do not imply Health Connect, medical analysis, fitness sensor collection, or AI coaching.
- Do not advertise ads, billing, subscriptions, or premium benefits as active in the current default release.
- Describe only the app behavior available in the Android build.

## Korean Main Listing Draft

App name:

```text
Life Quest
```

Short description:

```text
일상의 퀘스트를 RPG 성장과 보상으로 이어가세요
```

Full description:

```text
Life Quest는 매일의 행동을 퀘스트로 기록하고, 그 기록을 RPG식 성장과 보상으로 이어가는 자기관리 앱입니다.

단순히 할 일을 체크하는 데서 끝나지 않습니다. 완료한 퀘스트는 힘, 지혜, 건강, 매력 같은 게임 스탯과 골드, 칭호, 업적, 던전 보정으로 연결됩니다. 오늘 무엇을 하면 좋을지 한 가지 추천 행동을 보여주고, 쌓인 성장은 카드 기반 던전 전투와 보상에서 다시 체감할 수 있습니다.

주요 기능
- 일일, 주간, 월간 퀘스트 생성과 완료 기록
- 오늘의 성장, 보상, 다음 추천 행동 요약
- 힘, 지혜, 건강, 매력 기반 캐릭터 성장
- 칭호, 업적, 스킬, 현실 보상 계획
- 카드 기반 던전 전투와 보상
- 집중 타이머와 기본 리포트
- 계정 기반 진행 데이터 저장과 계정 삭제 지원

앱 안의 "건강" 스탯은 게임 카테고리입니다. Life Quest는 Health Connect, Google Fit, 의료 기록, 실제 피트니스 센서 데이터, 위치 정보를 수집하거나 분석하지 않으며 의료, 건강, 재정, 법률 조언을 제공하지 않습니다.

현재 기본 Android 릴리스에서는 광고와 인앱 결제가 비활성화되어 있습니다. 향후 유료 기능을 제공하는 경우 가격, 혜택, 갱신 조건, 취소 방법을 앱 또는 스토어 등록정보에 명확히 안내합니다.
```

## English Fallback Draft

Use this only if an en-US listing is needed before a full localization pass.

Short description:

```text
Turn real-life quests into RPG growth, titles, rewards, and focus.
```

Full description:

```text
Life Quest is a self-management app that turns everyday actions into RPG-style growth and rewards.

Create quests, complete real-life tasks, and see those actions become character stats, gold, titles, achievements, and dungeon modifiers. The app shows one next recommended action for today, then lets you feel your progress through card-based dungeon battles and rewards.

Key features
- Daily, weekly, and monthly quest tracking
- Today summary with growth, rewards, and one recommended action
- Character growth through Strength, Wisdom, Health, and Charisma game stats
- Titles, achievements, skills, and real-life reward planning
- Card-based dungeon combat and rewards
- Focus timer and basic reports
- Account-based progress sync and account deletion support

The in-app "Health" stat is a game category. Life Quest does not collect or analyze Health Connect, Google Fit, medical records, real fitness sensor data, or location data, and it does not provide medical, health, financial, or legal advice.

Ads and in-app purchases are disabled in the current default Android release. If paid features are offered in a future version, price, benefits, renewal terms, and cancellation information will be clearly disclosed in the app or store listing.
```

## Screenshot Alignment Requirements

Screenshots must show real Android app screens and match the listing claims:

1. Today summary with quests, growth, and recommended action.
2. Quest creation or quest list.
3. Character growth/status.
4. Dungeon/card battle.
5. Focus timer or basic report.

Do not use screenshots that imply:
- Health Connect, Google Fit, sensor sync, or medical analytics.
- AI coaching or chatbot behavior.
- Active subscription, paywall, or ad rewards in the default release.
- Web QA preview as the production Android app.

## Open Before Console Submission

- Verify the final Play Console Health apps declaration against this exact listing text.
- Verify Data safety answers and public privacy policy URL against this exact listing text.
- Capture fresh Android screenshots from the same build intended for testing or release.
- Re-check that monetization remains disabled in the default build before submitting this copy.
