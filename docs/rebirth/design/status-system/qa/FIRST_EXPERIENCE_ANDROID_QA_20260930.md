# First experience Android visual QA — 2026-09-30

## Scope and build provenance

- Android 35 emulator `LifeQuest_API35_16KB`, package `com.logian.lifequest`.
- Standard viewport: 1080 × 1920 at 420 dpi (about 411 × 731 dp). Small phone: 720 × 1280 at 320 dpi (360 × 640 dp).
- Local release APK built with cloud and monetization flags enabled, ads and QA preview disabled. No Play upload or production deployment occurred.
- Fresh app data was cleared **on the emulator only**. The guest name `SeokQA` and a synthetic completion were used; these captures do not establish that a person performed the real-world reading task.
- Source baseline for the corrected 5-minute suggestion: `ecf754a` (which includes `73c3052` and `4d69f42`). Screenshots `14`–`28` include the local reward-layout and status-return patch before this QA commit. Screenshots `29`–`31` come from a later local APK with the extra small-phone spacing patch and an in-progress Plus-entry gate from another agent. The Plus gate is reviewed separately and should be judged against its own eventual commit.

## Observed flow

1. The new user entered a name, selected Learning, kept the suggested specific goal and selected 5 minutes. The setup CTA was visible after scrolling on the small phone: [setup](first-experience-20260930/23-small-setup-ready.png).
2. Opening the status showed `Lv. 1`, `0 / 150 XP` and **one** immediately actionable 5-minute quest inside the status window: [standard phone](first-experience-20260930/14-recheck-first-quest.png), [small phone](first-experience-20260930/24-small-first-status.png). This corrected the earlier three 1-minute suggestions and `1 minutes` wording seen in [the first APK](first-experience-20260930/05-status-first-quest.png).
3. Accepting moved to the quest list, where the accepted quest remained accessible. The confirmation sheet offered `I did it` and `Too much today`; it did not award XP on acceptance.
4. A synthetic completion produced +10 quest XP and +50 first-achievement XP. The standard reward screen now shows `0 → 60 / 150 XP`, `Quest focus · Wisdom`, and the journal note above Continue: [standard reward](first-experience-20260930/17-recheck-reward.png). It avoids saying Wisdom itself increased while its numeric stat remains 0.
5. Continue returned directly to the status window with `60 / 150 XP`: [status return](first-experience-20260930/18-recheck-status-return.png). Before this patch, Continue returned to Quests and required another tap to see the changed status: [before](first-experience-20260930/09-status-after-reward.png).
6. On 360 × 640 dp, the first reward layout kept later details in the scrollable content but hid them beneath the fixed Continue area until swiped: [before](first-experience-20260930/27-small-reward.png), [after scroll](first-experience-20260930/28-small-reward-scrolled.png). Smaller-height spacing now puts the XP change, quest focus, journal note and Continue in the initial viewport: [corrected small reward](first-experience-20260930/31-small-reward-compact.png). The content remains scrollable for larger fonts or longer translations.

The smaller status window retains all data and scrolls to reveal its lower frame; the first viewport can still reach the initial quest CTA. After the later local APK install, the 360 × 640 dp status showed 60/150 XP with no unowned Plus CTA: [small status, later APK](first-experience-20260930/29-small-relaunch.png). That screenshot verifies only this one screen of the concurrent Plus gate, not the full monetization flow.

## Checks and limits

- Focused system-scene widget tests: **6/6 passed**, including reward details reachable above the fixed Continue button at 360 × 640 dp and the Japanese phone case.
- The new return-to-status test passed before a concurrent Plus-gate edit changed older Plus-button expectations. Those older expectations are being updated by the Plus-gate owner; this QA does not claim the combined suite passed after that edit.
- The emulator checked the English first-user journey and two phone viewports. It did not verify tablet layout, all localized first-user copy, model downloads, actual billing, or retention and willingness to pay.

## Product interpretation

The first status screen now offers an action instead of leaving the user to discover a separate task tab, and the completion scene visibly closes the XP loop. The next falsifiable question is whether new users accept and finish that first suggestion, then return on a later day. The Plus entry should appear only after a useful free experience and with a concrete personalized preview; a decorative lock on the opening status would weaken that test. Neither emulator QA nor widget tests prove a paying market.
