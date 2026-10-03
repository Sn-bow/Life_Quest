"""Merge the reviewed research batches; no network calls or app changes."""
from collections import Counter
import json
from pathlib import Path
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parent
BATCHES = ["anchors", "hunter", "tower-murim", "novel-manga", "novel-backups"]
LABELS = {
    "panel": "웹툰 장면 직접 확인",
    "text": "소설 본문 직접 확인",
    "official-system": "공식 소개의 성장·시스템 설정",
    "candidate": "상태창 근거 보류",
}
REQUIRED = ["id", "title_en", "medium", "category", "official_url", "evidence_url",
            "locator", "evidence_level", "observed", "unknowns", "design_takeaway", "scope", "source_quality"]

entries = []
for batch in BATCHES:
    source = json.loads((ROOT / f"{batch}.json").read_text())
    rows = source if isinstance(source, list) else source["entries"]
    for row in rows:
        assert all(key in row for key in REQUIRED), (batch, row.get("id"), "missing field")
        assert row["evidence_level"] in LABELS, row["id"]
        assert row["observed"] and row["unknowns"] and row["locator"], row["id"]
        for field in ("official_url", "evidence_url"):
            assert urlparse(row[field]).scheme == "https", (row["id"], field)
        entries.append({**row, "research_batch": batch})

for field in ("id", "title_en", "official_url"):
    values = [row[field].lower().rstrip("/") for row in entries]
    assert len(set(values)) == len(values), (field, "duplicate; review aliases manually")
assert len(entries) >= 100, "Research corpus smaller than requested approximate breadth"

counts = Counter(row["evidence_level"] for row in entries)
metadata = {
    "date": "2026-09-27", "distinct_ips_reviewed": len(entries), "evidence_counts": dict(counts),
    "scope_counts": dict(Counter(row["scope"] for row in entries)),
    "method": "Official free comic panels, author-published or licensed novel text, and official premises. Exa tools were unavailable; web search/open and browser used.",
    "limits": "Not full-series reading. Panel includes notifications, selections and one enhancement-rule narration, not exclusively personal status sheets. Text includes narrative status lists and system messages; some are not physically visible windows. Official-system is context and not UI proof. Candidates are not accepted visual references.",
    "dedup": "One IP per row; original/adaptation/translated titles not counted separately. Catalog exact-key validation plus human alias review.",
    "implementation_changed": False,
}
(ROOT / "catalog.json").write_text(json.dumps({"metadata": metadata, "entries": entries}, ensure_ascii=False, indent=2) + "\n")

lines = [f"# 상태창 레퍼런스 — {len(entries)}개 IP 조사 대장", "", "2026-09-27. 한 IP의 소설·웹툰·번역명을 중복 집계하지 않았다. 전체 정독이나 모든 작품의 상태창 그림 확인을 뜻하지 않는다.", "",
         "개인 상태표 / 시스템 알림 / 선택창 / 장비 상세 / 성장 서술을 구별해서 읽는다. 소개 근거와 보류 항목은 창 외형의 증거로 쓰지 않는다. 작품별 ‘미확인’ 항목을 함께 읽어야 한다.", "",
         "| 확인 수준 | 작품 수 |", "|---|---:|"]
lines += [f"| {LABELS[level]} | {counts[level]} |" for level in LABELS]
lines += ["", "[연구 요약](README.md) · [다음 디자인 기준](DESIGN_TRANSLATION.md)", "", "## 빠른 색인", "",
          "| 번호 | 작품 | 확인 수준 | 근거 |", "|---:|---|---|---|"]
for i, row in enumerate(entries, 1):
    title = row.get("title_ko") or row["title_en"]
    lines.append(f"| {i} | {title} | {LABELS[row['evidence_level']]} | [{row['id']}]({row['evidence_url']}) |")

for i, row in enumerate(entries, 1):
    title = row.get("title_ko") or row["title_en"]
    lines += ["", f"## {i:03d}. {title}", "", f"{row['title_en']} · `{row['id']}` · {row['medium']} · {row['category']} · {row['scope']}", "",
              f"**확인 수준:** {LABELS[row['evidence_level']]}", "",
              f"**출처/위치:** [공식 작품]({row['official_url']}) · [확인한 근거]({row['evidence_url']}) — {row['locator']}", "",
              f"**관찰:** {row['observed']}", "", f"**미확인:** {row['unknowns']}", "",
              f"**앱 적용 — 설계 추론:** {row['design_takeaway']}", "", f"**출처 품질:** {row['source_quality']}"]
    extras = row.get("additional_sources", [])
    if extras:
        lines += ["", "추가 근거: " + " · ".join(f"[출처 {j}]({url})" for j, url in enumerate(extras, 1))]
(ROOT / "CATALOG.md").write_text("\n".join(lines) + "\n")
print(json.dumps(metadata, ensure_ascii=False, indent=2))
