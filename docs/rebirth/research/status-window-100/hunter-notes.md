# Hunter/gate/modern-system reference audit

Date: 2026-09-27
Deliverable: `hunter.json` — 30 distinct IPs, counting a novel and its webtoon adaptation once.

## Evidence levels

| Level | Count | Meaning |
|---|---:|---|
| panel | 3 | An actual official free webtoon image was inspected. Two are personal status/profile panels; one is a temporary player-mode notification. |
| text | 9 | A passage of an official novel was actually read. This confirms described fields or interaction, not the webtoon's artwork. |
| official-system | 13 | The official synopsis explicitly presents a personal level, system mechanism, quest/message, or prompt. It does not prove a full personal status table. |
| candidate | 5 | An official publication exists, but reviewed material did not prove the status/system interface. Exclude these from a “confirmed status-window works” count. |

This batch therefore supplies 25 works with some system-specific evidence and 5 candidly unconfirmed candidates. Only 3 works have directly inspected visual evidence. A full completed status table was not required for the notification-panel category.

The final five candidates are Seoul Station Druid, I Log In Alone, The SSS-Rank Hunter's Lucky Draw, Solo Resurrection, and Tomb Raider King. Solo Resurrection was deliberately downgraded: a synopsis's ability-name/value pair is insufficient evidence of a diegetic system interface. The missing evidence is not a claim that these works lack a status window.

## Directly inspected visual anchors

- **Auto Hunting With My Clones / 분신으로 자동사냥** — [official free Ep. 2, Awakening](https://www.webtoons.com/en/action/auto-hunting-with-my-clones/ep-2-awakening/viewer?episode_no=2&title_no=5034), assets `AutoHuntingWithMyClones_EN_002_09_06.jpg` and `09_07.jpg`. Cyan translucent floating rectangle, thin grid, white name/STATS text, stacked numeric attributes; directly readable Reflex 0.51, Stamina 0.643, Endurance 0.539. The facing-away view reverses the letters. The panel is summoned by thought. Clone synchronization mechanics were not verified.
- **The Lone Spellcaster / 나 홀로 주문 사용자** — [official free Episode 2](https://www.webtoons.com/en/fantasy/the-lone-spellcaster/episode-2/viewer?episode_no=2&title_no=3478), asset `1639362869954347823.jpg`. Blue field and white outlined sections; User/Level upper left, large Rank F upper right, three classes in the wide row underneath; faint binary-digit background. Lower attributes are obscured/cut off and not transcribed. A separate earlier item tooltip says the steel sword is unverified and points to the sword with a connector.
- **Kill the Hero / 킬 더 히어로** — [official free Episode 2](https://tapas.io/episode/2096717), asset `790b7024-19fd-407e-adb3-b9d9c4a52ca3-2.jpg`. An “Entering Player Mode” transition notification, not a personal stat table. Cream interior, ornate brown/gold frame and crest, white/cyan outer glow, red emphasis on Player were directly observed.

Private QA copies of the above rendered public official preview images are in `qa_artifacts/rebirth/status-research-20260927/`: `hunter-clones-ep2-window.jpg`, `hunter-clones-ep2-stats.jpg`, `hunter-spellcaster-ep2-profile.jpg`, `hunter-kill-hero-ep2-player-mode.jpg`. These are research evidence, not assets licensed for inclusion in the product. No image was changed to imply an interface that the work does not show.

## Strong prose anchors

- [Seoul Station's Necromancer, Chapter 4](https://tapas.io/episode/2927545): level/class/basic attributes, more than one unallocated point pool, skill restriction and inventory combine/extract action. Useful for separating permanent profile, spendable points, and object-level actions.
- [The Divine Twilight's Return, Chapter 3](https://tapas.io/episode/2986778): access restrictions, partial information, errors/unknown values, renewed status and authority details. Useful for clearly distinguishing missing data from zero.
- [Leveling Up Alone, Chapter 1](https://tapas.io/episode/2977912): named Ego System, current stamina percentage, time estimate, own/opponent level and new skill feedback. Useful for short feedback tied to a present activity.
- [The Frozen Player Returns, Chapter 9](https://tapas.io/episode/2926285): skill grade/effect/condition, training-based attribute increment, personal status values. Useful for connecting a changed metric to its cause.
- [The Celestial Returned from Hell, Chapter 15](https://www.wuxiaworld.com/novel/the-constellation-returned-from-hell/tcrfh-chapter-15): measurement limitations, proficiency-dependent visibility and partly shared status. Useful for visibility/permission distinctions.
- [After Ten Millennia in Hell, Chapter 193 public teaser](https://www.wuxiaworld.com/novel/after-ten-millennia-in-hell/atmh-chapter-193): status-window invocation followed by unread messages and activation/condition notices. Only the freely readable teaser was used; the full chapter was not claimed read.
- [The Housekeeper of the Dungeon, Chapter 1](https://tapas.io/episode/3119637): awakening prompt, class selection/loading sequence, hidden class result. Useful for progressive disclosure and explaining how a role was assigned.

## Design synthesis — recommendations, not observations

1. Build separate personal profile, quest, change log, skill detail and object tooltip components. These sources show several interface functions; flattening every one into the same status card loses useful meaning.
2. Keep the main profile short. Route conditional rules, spendable points, locked abilities and source evidence to details.
3. Explain each increase with its triggering activity. Avoid giving real-life measurements unsupported decimal precision.
4. Give unknown, locked, loading and unavailable states their own labels; do not show them as numeric zero.
5. Use class, role and progress to communicate context. Do not copy a hunter rank onto a real person as a universal judgment.
6. The official [My Daughter Is the Final Boss synopsis](https://www.rokmedia.com/webtoons/nae-ttaleun-choejong-boseu-2) supplies a 0/5 family-centered quest; this supports goal structure beyond combat. Exact artwork remains uninspected.

## Method and limitations

The parent had already exhausted discovery of callable Exa tools, so this audit used available web search/open and public official publication pages as a fallback. No account, purchase, paywall workaround or unofficial scan site was used. Official chapter body was preferred to search snippets; comments were not evidence. Korean titles are only used where verified from Korean publication pages; otherwise the official English title remains in the title_ko field to avoid invented translations.

Titles assigned to other researchers were excluded. Druid of Seoul Station and Seoul Station Druid are one IP, as are translated aliases of each other work. My Dad Is Too Strong was not retained; the parent approved After Ten Millennia in Hell as a replacement.

Some official pages are app-oriented or stop at a teaser. Opening a page does not imply reading all its episodes. The table records the exact inspected locator and each row states what was not established. The numeric sources_reviewed metric below counts distinct successfully opened page URLs across web/browser research, including several discovery/reference pages; it is not the number of searches, IPs, fully read works, or confirmed interfaces. Repeated opens of one exact URL count once. Assets do not add to the page count. Failed/404 pages were excluded.

## Opened-page audit

1. https://tapas.io/series/seoul-stations-necromancer/info
2. https://www.webtoons.com/en/action/the-druid-of-seoul-station/list?title_no=3453
3. https://tapas.io/series/kill-the-hero/info
4. https://tapas.io/series/the-return-of-the-disaster-class-hero/info
5. https://tapas.io/series/the-player-who-cant-level-up-novel
6. https://tapas.io/episode/2977912
7. https://www.webtoons.com/en/action/auto-hunting-with-my-clones/list?title_no=5034
8. https://www.webtoons.com/en/action/limit-breaker/list?title_no=4176
9. https://www.webtoons.com/en/action/the-druid-of-seoul-station/episode-2/viewer?episode_no=2&title_no=3453
10. https://tapas.io/episode/2096717
11. https://tapas.io/series/the-return-of-the-disaster-class-hero-novel
12. https://www.tappytoon.com/en/book/i-log-in-alone
13. https://tapas.io/series/the-sss-rank-hunters-lucky-draw/info
14. https://tapas.io/series/hoarding-in-hell/info
15. https://www.rokmedia.com/webtoons/nae-ttaleun-choejong-boseu-2
16. https://tapas.io/series/i-am-the-sorcerer-king/info
17. https://series.naver.com/novel/detail.series?productNo=6270860
18. https://www.webtoons.com/en/action/the-player-hides-his-past/list?title_no=5655
19. https://tapas.io/series/the-frozen-player-returns-novel
20. https://tapas.io/series/tomb-raider-king/info
21. https://tapas.io/series/the-celestial-returned-from-hell
22. https://www.webtoons.com/en/fantasy/the-lone-spellcaster/list?title_no=3478
23. https://tapas.io/series/leveling-beyond-the-max
24. https://tapas.io/series/level-1-player
25. https://tapas.io/series/past-life-returner
26. https://tapas.io/series/the-divine-twilights-return
27. https://www.webtoons.com/en/fantasy/enrolling-in-the-transcendent-academy/list?title_no=5420
28. https://us.webtoons.com/en/action/the-dungeon-cleaning-life-of-a-once-genius-hunter/list?title_no=4677
29. https://webtoon.kakao.com/content/F%EA%B8%89-%EC%82%AC%EC%A3%BC-%ED%97%8C%ED%84%B0/3481
30. https://m.mrblue.com/webtoon/detail/wt_000065088
31. https://www.webtoons.com/fr/action/solo-auto-hunting/list?title_no=3488
32. https://bff-page.kakao.com/landing/series/list/page/landing/15709
33. https://tapas.io/episode/2927545
34. https://tapas.io/episode/2986778
35. https://tapas.io/episode/2922438
36. https://tapas.io/episode/3119637
37. https://series.naver.com/novel/detail.series?productNo=11292429
38. https://series.naver.com/novel/detail.series?productNo=4158689
39. https://series.naver.com/novel/detail.series?OSType=pc&productNo=3109583
40. https://m.series.naver.com/novel/detail.series?productNo=3286460
41. https://series.naver.com/novel/detail.series?productNo=4440912
42. https://series.naver.com/comic/detail.series?OSType=pc&productNo=6261200
43. https://series.naver.com/novel/detail.series?productNo=4705125
44. https://series.naver.com/novel/detail.series?productNo=8809333
45. https://series.naver.com/comic/detail.nhn?productNo=5679957
46. https://series.naver.com/novel/detail.series?productNo=3494118
47. https://series.naver.com/novel/detail.series?productNo=8032356
48. https://series.naver.com/novel/detail.series?productNo=6502811
49. https://series.naver.com/novel/detail.series?productNo=2715761
50. https://tapas.io/episode/2926285
51. https://www.wuxiaworld.com/novel/the-constellation-returned-from-hell/tcrfh-chapter-15
52. https://www.wuxiaworld.com/novel/after-ten-millennia-in-hell/atmh-chapter-193
53. https://m.series.naver.com/novel/detail.series?productNo=3419485
54. https://bff-page.kakao.com/content/55291149
55. https://www.tappytoon.com/en/chapters/312157617
56. https://www.webtoons.com/en/action/auto-hunting-with-my-clones/ep-2-awakening/viewer?episode_no=2&title_no=5034
57. https://www.webtoons.com/en/fantasy/the-lone-spellcaster/episode-2/viewer?episode_no=2&title_no=3478

## Limited follow-up: The Druid of Seoul Station

Only this existing candidate was revisited. Two search queries were submitted in one web search call; four additional official free episode pages were opened. The unavailable in-app browser was replaced with the available Chrome browser. No account, payment, unofficial chapter, additional IP, or expanded search was used.

- [Episode 3](https://www.webtoons.com/en/action/the-druid-of-seoul-station/episode-3/viewer?episode_no=3&title_no=3453): sampled forest/return/action panels; no personal status panel found in the inspected portions.
- [Episode 4](https://www.webtoons.com/en/action/the-druid-of-seoul-station/episode-4/viewer?title_no=3453&episode_no=4): sampled hospital and paperwork scenes, including a spoken F-rank reference. A spoken rank and paper registration are not proof of a personal system window.
- [Episode 5](https://www.webtoons.com/en/action/the-druid-of-seoul-station/episode-5/viewer?title_no=3453&episode_no=5): sampled conversation, broadcast/combat and family scenes; no personal window identified in those portions.
- [Episode 7](https://www.webtoons.com/en/action/the-druid-of-seoul-station/episode-7/viewer?title_no=3453&episode_no=7): sampled street and payment conversation; a hunter-registration suggestion was visible, but no personal status panel was established.

Decision: retain `candidate`. The episode pages were sampled rather than exhaustively read, so this is an unresolved evidence gap, not a claim that the work has no status window. No new colors, stat fields, UI layout, or mechanistic conclusions were added. The 30-row evidence counts remain unchanged. These four distinct page URLs raise the audit total from 57 to 61.

sources_reviewed: 61
