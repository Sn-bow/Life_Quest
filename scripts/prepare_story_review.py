#!/usr/bin/env python3
"""Create a local editorial manuscript and measured scope from bundled originals.

This does not grant app ownership or change the paid-content boundary.
Character counts include whitespace, exclude UI labels, and are not reading times.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path


def measure(book):
    counts, without_echoes = [], []
    for path in itertools.product(('open', 'keep'), repeat=len(book['scenes'])):
        choices = {f"tide/{s['id']}": c for s, c in zip(book['scenes'], path)}
        total = sum(len(s['narration']) + len(next(c['response'] for c in s['choices'] if c['id'] == choice))
                    for s, choice in zip(book['scenes'], path))
        ending = 'open' if path[:-1].count('open') > path[:-1].count('keep') else 'keep'
        total += len(book['endings'][ending]['narration'])
        without_echoes.append(total)
        total += sum(len(text) for s in book['scenes'] for key, text in s.get('echoes', {}).items()
                     if choices.get(key.split(':')[0]) == key.split(':')[1])
        counts.append(total)
    return dict(scenes=len(book['scenes']), choicePaths=len(counts),
                pathCharactersWithoutEchoes=[min(without_echoes), max(without_echoes)],
                pathCharactersWithEchoes=[min(counts), max(counts)],
                readingMinutes=None, humanReviewed=False)


def manuscript(book):
    lines = [f"# {book['title']} · 편집 검토본", '',
             '내부 원고 검토용. 모든 분기와 결말이 포함됩니다. 앱 소유권을 부여하지 않습니다.', '',
             '읽기 전 가격을 제시하지 말고, 소요 시간·이해되지 않는 장면·계속 읽고 싶은 이유를 먼저 기록하세요.',
             '무료 체험 평가와 전체 원고 평가를 구분합니다. 검토자가 실제 결제했다고 기록하지 않습니다.', '']
    for index, scene in enumerate(book['scenes'], 1):
        lines += [f"## {index}. {scene['title']}", '', scene['narration'], '']
        for choice in scene['choices']:
            lines += [f"### 선택 {choice['id']}: {choice['label']}", '', choice['response'], '']
        for key, echo in scene.get('echoes', {}).items():
            lines += [f'이전 선택 반응 ({key}): {echo}', '']
    for ending in book['endings'].values():
        lines += [f"## {ending['title']}", '', ending['narration'], '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=Path('qa_artifacts/rebirth/editorial'))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    report = {'method': 'All 4096 paths, one ending based on first 11 choices; Unicode characters including whitespace; no titles or UI labels.', 'locales': {}}
    for locale in ('ko', 'en', 'ja', 'zh'):
        path = Path(f'assets/story/tide_{locale}.json')
        raw = path.read_bytes()
        book = json.loads(raw)
        report['locales'][locale] = {'source': str(path), 'sha256': hashlib.sha256(raw).hexdigest(), **measure(book)}
        (args.output / f'tide-review-{locale}.md').write_text(manuscript(book))
    (args.output / 'content-scope.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
