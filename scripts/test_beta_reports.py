import copy
import unittest
from analyze_beta_reports import analyze, validate


def fixture(n=1, elapsed=8):
    return dict(schema=1, cohort='crossing-library-v1', content='tide-v1',
                environment='device', participant=f'{n:032x}', elapsedDays=elapsed,
                baselineCompletions=0, baselinePreviewComplete=False,
                days={'0': 1, '7': 1} if elapsed >= 7 else {'0': 1}, previewDay=0,
                feedback={'value': 4, 'maxPriceKRW': 4900}, qualityFlags=[],
                evidence='device_reported_not_purchase')


class ReportsTest(unittest.TestCase):
    def test_no_evidence_is_unknown_and_hold(self):
        result = analyze([], [])
        self.assertIsNone(result['reportCoverage'])
        self.assertIsNone(result['newUsers']['d7']['returnRateAmongReports'])
        self.assertEqual(result['decision'], 'HOLD_PUBLIC_RELEASE')

    def test_missing_roster_members_are_not_hidden(self):
        a, b = fixture(1), fixture(2)
        result = analyze([a['participant'], b['participant']], [a])
        self.assertEqual(result['reportCoverage'], .5)
        self.assertEqual(result['missingReports'], 1)
        self.assertEqual(result['newUsers']['d7']['matureReports'], 1)
        self.assertIsNone(result['newUsers']['actualPurchases'])

    def test_day_7_is_immature_until_192_hours(self):
        a = fixture(elapsed=7)
        result = analyze([a['participant']], [a])
        self.assertEqual(result['newUsers']['d7']['matureReports'], 0)
        a['elapsedDays'] = 8
        self.assertEqual(analyze([a['participant']], [a])['newUsers']['d7']['returned'], 1)

    def test_duplicates_do_not_inflate_counts(self):
        a, b = fixture(elapsed=0), fixture()
        result = analyze([a['participant']], [b, a, b])
        self.assertEqual(result['duplicateFiles'], 2)
        self.assertEqual(result['uniqueReports'], 1)
        self.assertEqual(result['newUsers']['reports'], 1)

    def test_same_day_conflicts_and_disappearing_flags_are_excluded(self):
        a = fixture()
        for change in ({'baselineCompletions': 9}, {'qualityFlags': ['storage_failure']},
                       {'feedback': {'value': 5, 'maxPriceKRW': 6900}}, {'days': {'0': 1}}):
            b = {**a, **change}
            result = analyze([a['participant']], [a, b])
            self.assertEqual(result['excludedParticipants'], 1)
            self.assertEqual(result['newUsers']['reports'], 0)

    def test_preview_and_returning_profiles_do_not_enter_first_use_funnel(self):
        a, b = fixture(1), fixture(2)
        a['environment'] = 'web_preview'
        b['baselineCompletions'] = 9
        result = analyze([a['participant'], b['participant']], [a, b])
        self.assertEqual(result['newUsers']['reports'], 0)
        self.assertEqual(result['returningUsers']['reports'], 1)
        self.assertEqual(result['excludedParticipants'], 1)

    def test_malformed_nested_data_is_rejected_without_copying_it(self):
        a = fixture()
        bad = copy.deepcopy(a)
        bad['feedback']['goal'] = 'PRIVATE'
        with self.assertRaises(ValueError):
            validate(bad)
        result = analyze([a['participant']], [a, bad])
        self.assertEqual(result['invalidFiles'], 1)
        self.assertEqual(result['newUsers']['reports'], 0)
        self.assertNotIn('PRIVATE', str(result))

    def test_unknown_and_zero_willingness_are_distinct(self):
        a, b = fixture(1), fixture(2)
        a['feedback']['maxPriceKRW'] = -1
        b['feedback']['maxPriceKRW'] = 0
        result = analyze([a['participant'], b['participant']], [a, b])['newUsers']
        self.assertEqual(result['undecided'], 1)
        self.assertEqual(result['wouldNotBuy'], 1)
        self.assertEqual(result['statedAtLeastKRW']['2900'], 0)


if __name__ == '__main__':
    unittest.main()
