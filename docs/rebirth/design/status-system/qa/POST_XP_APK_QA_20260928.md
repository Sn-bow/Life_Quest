# Post-XP QA APK check — 2026-09-28

- APK: `build/review/life-quest-2.0.0-2013-paid-review.apk`
- SHA-256: `dee00c5916d0b20c09ca0708110b61217bebddd519c8172eb34053a2153c758e`
- Device: Android Studio `LifeQuest API35 16KB` emulator, API 35, 1080 × 1920 screenshots.
- Method: the APK was installed with `adb -r` over the existing app. The embedded emulator initially displayed black and did not respond to its Power button. A Device Manager **Cold Boot** restored its display; **Wipe Data** was not used. All app interactions and captures below were through Android Studio's Running Devices UI and **Take Screenshot**.

The Japanese status screen opened with the pre-existing `Lv. 1 記録者` profile and `85 / 150 XP`, matching the prior owner-data capture `android-2013-status-ja-final-owner85.png`. The quest screen still displayed the previously completed daily quest, `無理せず5分体をほぐす`, with `+10 XP` and `+5` gold. The cyan status frame, three tabs, typography, and quest card were visible without clipping in the captured phone viewport.

Evidence:

- [`android-2013-post-xp-status-ja.png`](android-2013-post-xp-status-ja.png)
- [`android-2013-post-xp-quests-ja.png`](android-2013-post-xp-quests-ja.png)

**Limit:** A new card expedition was not completed in this UI pass. Its gold reward and `+0` character XP are **not live-verified** by these screenshots. The expedition entry sits below the fold in the Growth Record list; Android Studio's embedded-device mouse-wheel, drag, and keyboard-scroll actions did not move that list during this pass. This does not establish an app scrolling defect, and it does not establish a successful reward settlement.
