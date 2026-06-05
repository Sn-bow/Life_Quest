# Life Quest Play Console IARC Draft - 2026-06-05

Scope: default real Android release or closed-testing build for
`com.lifequest.app`.

This is a preparation aid, not a final rating certificate. Answer the exact
question wording shown in Play Console and recheck the installed Android build
before submitting.

## Official References

- Google Play content ratings:
  https://support.google.com/googleplay/android-developer/answer/9898843
- Google Play content rating requirements:
  https://support.google.com/googleplay/android-developer/answer/9859655

Google Play requires accurate questionnaire answers and a new questionnaire
when app content or features change in a way that affects the answers.

## Product Classification

- Product type: game / RPG-style productivity app.
- Primary activity: users record private personal quests, gain game stats and
  gold, and play fantasy card battles against monsters.
- Network account: Firebase Auth and synced private progress.
- Public user interaction: none.

## Content Answer Guardrails

### Violence

- Fantasy/card-battle violence against fictional monsters is present.
- Attacks, damage numbers, poison/burn status effects, enemy defeat, and
  fantasy weapons or magic are present.
- No realistic human violence is intended.
- No blood, gore, dismemberment, or graphic injury is implemented in the
  default build.

Answer the Play Console violence questions as fantasy/non-realistic violence,
not as no violence.

### Fear Or Horror

- The app uses dark-fantasy monsters, relics, dungeon environments, and a
  death-knight-style boss.
- Review the exact Android screenshots and assets shown in the uploaded build.
- If the questionnaire asks about frightening imagery, do not automatically
  answer "No" solely because the combat is stylized.

### Gambling And Random Items

- No real-money gambling, betting, casino simulation, cash prize, or
  redeemable prize is present.
- No active in-app purchase is available in the default Android build.
- The in-game shop does contain Normal and Premium Equipment Boxes.
- These boxes spend earned in-game gold and award random virtual equipment.
- The boxes cannot be bought with real money in the default build and their
  contents cannot be sold or redeemed for real-world value.

If the questionnaire asks whether the app contains loot boxes, randomized
virtual items, or purchases with uncertain rewards, answer according to the
actual question wording and disclose these equipment boxes. Do not describe
the app as having no randomized rewards.

### User-Generated Content And Communication

- Users can create private quest names and personal profile/progress data.
- There is no public UGC feed, public profile directory, user-to-user sharing,
  public chat, private messaging, friend system, multiplayer, or location
  sharing.
- Private quest text is not published to other users by an app feature.

For questions about public UGC or user communication, answer "No" for the
default build. Re-review if sharing, chat, community, or public profiles are
added.

### Ads And Purchases

- AdMob startup and rewarded-ad UI are disabled in the default Android build.
- Google Play Billing startup and paid purchase flows are disabled in the
  default Android build.
- Answer the ads declaration separately as "No" for this exact default build.
- Do not claim active in-app purchases or paid loot boxes.

### Other Mature Content

Current repository evidence does not show:

- Sexual content or nudity.
- Alcohol, tobacco, or illegal drug use.
- Profanity or discriminatory language as a designed feature.
- Real-money gambling or cash prizes.

The final installed-build review must still inspect visible localized text,
monster art, card art, relic art, and event text before submission.

## Re-Review Triggers

Submit a new questionnaire review before release if any version adds or changes:

- Real-money purchases, paid random items, subscriptions, or active ads.
- Public UGC, chat, sharing, multiplayer, leaderboards, or social profiles.
- More realistic violence, blood, gore, frightening imagery, or mature story
  content.
- Casino, betting, prize redemption, or real-world reward mechanics.
- Store screenshots or descriptions that materially change the content shown.
