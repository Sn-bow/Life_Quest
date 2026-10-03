"""Prevent either release profile from silently permitting the wrong billing policy."""
import unittest
from inspect_release_artifact import permission_checks


class ReleasePermissionProfileTests(unittest.TestCase):
    def test_paid_requires_billing_and_free_rejects_it(self):
        for profile, billing, expected in [('free', False, True), ('free', True, False),
                                           ('paid', False, False), ('paid', True, True)]:
            permissions = {'android.permission.INTERNET'}
            if billing:
                permissions.add('com.android.vending.BILLING')
            with self.subTest(profile=profile, billing=billing):
                self.assertEqual(all(permission_checks(permissions, profile).values()), expected)

    def test_ads_and_package_enumeration_fail_both_profiles(self):
        for profile in ['free', 'paid']:
            for permission in ['com.google.android.gms.permission.AD_ID',
                               'android.permission.ACCESS_ADSERVICES_AD_ID',
                               'android.permission.ACCESS_ADSERVICES_ATTRIBUTION',
                               'android.permission.ACCESS_ADSERVICES_TOPICS',
                               'android.permission.QUERY_ALL_PACKAGES']:
                permissions = {permission}
                if profile == 'paid':
                    permissions.add('com.android.vending.BILLING')
                with self.subTest(profile=profile, permission=permission):
                    self.assertFalse(all(permission_checks(permissions, profile).values()))


if __name__ == '__main__':
    unittest.main()
