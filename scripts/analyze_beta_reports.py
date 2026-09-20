#!/usr/bin/env python3
"""Offline, aggregate-only pilot readout. Never a public-release approval.

Roster: JSON array of enrollment codes, kept outside Git. Exported reports:
one or more JSON files. Missing reports are unknown, not fabricated dropouts.
"""
import argparse
import json
from pathlib import Path
import re

ID = re.compile(r'^[a-f0-9]{32}$')
FLAGS = {'clock_reversed', 'profile_changed', 'storage_failure', 'profile_restored', 'profile_deleted'}
KEYS = {'schema', 'cohort', 'content', 'environment', 'participant', 'elapsedDays',
        'baselineCompletions', 'baselinePreviewComplete', 'days', 'previewDay',
        'feedback', 'qualityFlags', 'evidence'}


def integer(value, low, high):
    return type(value) is int and low <= value <= high


def validate(d):
    if not isinstance(d, dict) or set(d) != KEYS:
        raise ValueError('Unexpected report fields')
    if (d['schema'] != 1 or d['cohort'] != 'crossing-library-v1' or d['content'] != 'tide-v1'
            or d['environment'] not in ('device', 'web_preview')
            or d['evidence'] != 'device_reported_not_purchase'
            or not isinstance(d['participant'], str) or not ID.fullmatch(d['participant'])
            or not integer(d['elapsedDays'], 0, 3650)
            or not integer(d['baselineCompletions'], 0, 2**53)
            or type(d['baselinePreviewComplete']) is not bool):
        raise ValueError('Invalid report identity or baseline')
    days = d['days']
    if not isinstance(days, dict) or '0' not in days:
        raise ValueError('Enrollment day missing')
    for day, count in days.items():
        if (not isinstance(day, str) or not re.fullmatch(r'0|[1-9]|1[0-3]', day)
                or not integer(count, 0, 10000)
                or int(day) > d['elapsedDays'] and not d['qualityFlags']):
            raise ValueError('Invalid study day')
    preview = d['previewDay']
    if preview is not None and (not integer(preview, 0, 13) or str(preview) not in days
                                or d['baselinePreviewComplete']):
        raise ValueError('Invalid preview event')
    flags = d['qualityFlags']
    if not isinstance(flags, list) or any(not isinstance(f, str) or f not in FLAGS for f in flags):
        raise ValueError('Invalid quality flags')
    f = d['feedback']
    if not isinstance(f, dict) or f and (set(f) != {'value', 'maxPriceKRW'}
            or not integer(f['value'], 1, 5) or type(f['maxPriceKRW']) is not int
            or f['maxPriceKRW'] not in (-1, 0, 2900, 4900, 6900)
            or preview is None and not d['baselinePreviewComplete']):
        raise ValueError('Invalid price response')
    return d


def analyze(roster, reports):
    if (not isinstance(roster, list) or any(not isinstance(x, str) or not ID.fullmatch(x) for x in roster)
            or len(set(roster)) != len(roster)):
        raise ValueError('Roster must contain unique enrollment codes only')
    selected, invalid, duplicate, foreign, conflicts = {}, 0, 0, 0, set()
    baseline_keys = ('cohort', 'content', 'environment', 'baselineCompletions', 'baselinePreviewComplete')
    for raw in reports:
        try:
            d = validate(raw)
        except (ValueError, TypeError, KeyError):
            invalid += 1
            # A malformed revision of a known participant must not silently
            # leave an older clean report eligible.
            if isinstance(raw, dict) and isinstance(raw.get('participant'), str) and raw['participant'] in roster:
                conflicts.add(raw['participant'])
            continue
        pid = d['participant']
        if pid not in roster:
            foreign += 1
            continue
        previous = selected.get(pid)
        if previous is not None:
            duplicate += 1
            if any(previous[k] != d[k] for k in baseline_keys):
                conflicts.add(pid)
            # Storage/clock problems never disappear by submitting a later file.
            if previous['qualityFlags'] or d['qualityFlags']:
                conflicts.add(pid)
            older, newer = sorted([previous, d], key=lambda x: x['elapsedDays'])
            if any(newer['days'].get(k, -1) < v for k, v in older['days'].items()):
                conflicts.add(pid)
            if previous['elapsedDays'] == d['elapsedDays'] and previous != d:
                conflicts.add(pid)  # no exact timestamp: cannot order two revisions
            if d['elapsedDays'] < previous['elapsedDays']:
                continue
        selected[pid] = d
    clean = [d for pid, d in selected.items() if pid not in conflicts
             and not d['qualityFlags'] and d['environment'] == 'device']
    fresh = [d for d in clean if d['baselineCompletions'] == 0 and not d['baselinePreviewComplete']]
    returning = [d for d in clean if d not in fresh]

    def metrics(group):
        # A day must be finished before including its participant in denominator.
        result = {'reports': len(group)}
        for day in (1, 7):
            mature = [d for d in group if d['elapsedDays'] >= day + 1]
            visits = sum(str(day) in d['days'] for d in mature)
            action = sum(d['days'].get(str(day), 0) > 0 for d in mature)
            result[f'd{day}'] = {'matureReports': len(mature), 'returned': visits,
                                'completedQuest': action,
                                'returnRateAmongReports': visits / len(mature) if mature else None}
        result['firstDayAction'] = sum(d['days']['0'] > 0 for d in group)
        result['previewCompletedDuringStudy'] = sum(d['previewDay'] is not None for d in group)
        feedback = [d['feedback'] for d in group if d['feedback']]
        result['priceResponses'] = len(feedback)
        result['undecided'] = sum(f['maxPriceKRW'] == -1 for f in feedback)
        result['wouldNotBuy'] = sum(f['maxPriceKRW'] == 0 for f in feedback)
        result['statedAtLeastKRW'] = {str(p): sum(f['maxPriceKRW'] >= p for f in feedback)
                                    for p in (2900, 4900, 6900)}
        result['actualPurchases'] = None
        return result

    return {
        'decision': 'HOLD_PUBLIC_RELEASE',
        'evidence': 'voluntary_device_reports_not_verified_actions_or_purchases',
        'enrolled': len(roster), 'uniqueReports': len(selected),
        'missingReports': len(set(roster) - selected.keys()),
        'reportCoverage': len(selected) / len(roster) if roster else None,
        'invalidFiles': invalid, 'duplicateFiles': duplicate, 'unrosteredFiles': foreign,
        'excludedParticipants': len(set(selected) | conflicts) - len(clean),
        'newUsers': metrics(fresh), 'returningUsers': metrics(returning),
        'limitations': [
            'Retention denominators contain received mature reports only; missing participants are unknown.',
            'Voluntary reporting and a small convenience sample cannot estimate market conversion.',
            'Price answers follow a free preview, not a verified full-pack value or payment test.',
            'No conclusion about profit, real-world task performance or Play tester eligibility.',
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--roster', required=True, type=Path)
    parser.add_argument('reports', nargs='*', type=Path)
    args = parser.parse_args()
    reports = []
    for path in args.reports:
        try:
            if path.stat().st_size > 65536:
                raise ValueError('Report too large')
            reports.append(json.loads(path.read_text()))
        except (ValueError, OSError):
            reports.append(None)
    result = analyze(json.loads(args.roster.read_text()), reports)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
