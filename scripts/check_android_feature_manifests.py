#!/usr/bin/env python3
"""Exercise the actual Gradle manifest merger for independent release switches.

Uses Google's public TEST AdMob app ID only for manifest inspection. Does not
build, upload or install an ad-enabled APK and does not read signing secrets.
Run serially with other Flutter/Gradle operations.
"""
import base64
import json
import os
from pathlib import Path
import subprocess
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
ANDROID = '{http://schemas.android.com/apk/res/android}'
OUTPUT = ROOT / 'qa_artifacts/rebirth/feature-manifests'
OUTPUT.mkdir(parents=True, exist_ok=True)
env = dict(os.environ)
env.setdefault('JAVA_HOME', '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home')
results = []
for name, cloud, billing, ads, app_id, expected_failure in [
    ('default', False, False, False, None, False),
    ('billing-without-ads', True, True, False, None, False),
    ('ads-without-billing', True, False, True, 'ca-app-pub-3940256099942544~3347511713', False),
    ('both', True, True, True, 'ca-app-pub-3940256099942544~3347511713', False),
    ('reject-billing-without-cloud', False, True, False, None, True),
    ('reject-ads-without-id', True, False, True, None, True),
    ('default-with-unused-ad-id', False, False, False, 'ca-app-pub-3940256099942544~3347511713', False),
]:
    flags = {'LIFEQUEST_CLOUD_ENABLED': cloud, 'LIFEQUEST_MONETIZATION_ENABLED': billing, 'LIFEQUEST_ADS_ENABLED': ads}
    encoded = ','.join(base64.b64encode(f'{k}={str(v).lower()}'.encode()).decode() for k, v in flags.items())
    args = ['./gradlew', ':app:processReleaseMainManifest', '--console=plain', f'-Pdart-defines={encoded}']
    if app_id: args.append(f'-PADMOB_ANDROID_APP_ID={app_id}')
    run = subprocess.run(args, cwd=ROOT / 'android', env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    (OUTPUT / f'{name}.log').write_text(run.stdout)
    if expected_failure:
        reason = 'Billing and ads require' if not cloud else 'Ads require a valid'
        assert run.returncode != 0 and reason in run.stdout, f'{name} did not fail closed'
    else:
        assert run.returncode == 0, f'{name} failed; see its log'
        manifest = ROOT / 'build/app/intermediates/merged_manifest/release/processReleaseMainManifest/AndroidManifest.xml'
        text = manifest.read_text()
        (OUTPUT / f'{name}.xml').write_text(text)
        root = ET.fromstring(text)
        permissions = {n.get(ANDROID + 'name') for n in root.findall('uses-permission')}
        assert ('com.android.vending.BILLING' in permissions) == billing, name
        assert ('com.google.android.gms.permission.AD_ID' in permissions) == ads, name
        assert ('com.google.android.gms.ads.MobileAdsInitProvider' in text) == ads, name
        assert 'com.google.firebase.provider.FirebaseInitProvider' not in text, name
    results.append({'case': name, 'pass': True})
    print('PASS:', name, flush=True)
(OUTPUT / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
