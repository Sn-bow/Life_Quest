#!/usr/bin/env python3
"""Validate an upload-key-signed ARM64 review APK without reading signing secrets."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import zipfile
from inspect_release_artifact import elf_alignments


def command(args):
    return subprocess.check_output([str(a) for a in args], text=True, stderr=subprocess.STDOUT)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apk', type=Path, default=Path('build/app/outputs/flutter-apk/app-release.apk'))
    parser.add_argument('--build-tools', type=Path, required=True)
    parser.add_argument('--certificate-sha256', required=True)
    parser.add_argument('--version-code', type=int, required=True)
    parser.add_argument('--source-commit', required=True, help='Commit used for the build, not inferred from current HEAD')
    parser.add_argument('--output', type=Path, default=Path('docs/rebirth/apk-inspection.json'))
    args = parser.parse_args()
    checks = []

    def check(label, result):
        checks.append({'check': label, 'pass': bool(result)})
        print(('PASS' if result else 'FAIL') + ': ' + label)

    expected = args.certificate_sha256.replace(':', '').lower()
    sig = command([args.build_tools / 'apksigner', 'verify', '--verbose', '--print-certs', args.apk])
    actual = re.findall(r'Signer #1 certificate SHA-256 digest: ([a-fA-F0-9]+)', sig)
    check('APK signature and expected public upload certificate', actual == [expected])
    command([args.build_tools / 'zipalign', '-c', '-P', '16', '4', args.apk])
    check('APK ZIP 16 KiB alignment', True)
    manifest = command([args.build_tools / 'aapt2', 'dump', 'badging', args.apk])
    match = re.search(r"package: name='([^']+)' versionCode='(\d+)' versionName='([^']+)'", manifest)
    check('Expected package and version', bool(match) and match[1] == 'com.lifequest.app' and int(match[2]) == args.version_code)
    target = re.search(r"targetSdkVersion:'(\d+)'", manifest)
    check('Target API at least 36', bool(target) and int(target[1]) >= 36)
    tree = command([args.build_tools / 'aapt2', 'dump', 'xmltree', args.apk, '--file', 'AndroidManifest.xml'])
    for attr in ['debuggable', 'testOnly', 'usesCleartextTraffic', 'allowBackup']:
        check(attr + ' is not true', not re.search(r'android:' + attr + r'[^\n]*0xffffffff', tree))
    check('No Billing or Ads permissions in default build', not any(p in manifest for p in ['com.android.vending.BILLING', 'com.google.android.gms.permission.AD_ID', 'android.permission.ACCESS_ADSERVICES_']))
    check('Firebase initialization is explicit', 'com.google.firebase.provider.FirebaseInitProvider' not in tree)
    with zipfile.ZipFile(args.apk) as archive:
        apps = [n for n in archive.namelist() if n.endswith('/libapp.so')]
        check('Review APK targets ARM64', apps == ['lib/arm64-v8a/libapp.so'])
        for name in archive.namelist():
            if not name.endswith('.so'):
                continue
            data = archive.read(name)
            alignments = elf_alignments(data)
            check(name + ' ELF 16 KiB alignment', bool(alignments) and all(v >= 16384 for v in alignments))
            if name.endswith('/libapp.so'):
                check('No native QA entry point', all(v not in data for v in [b'LIFEQUEST_RELEASE_PROBE=', b'LIFEQUEST_BACKUP_PROBE=']))
        check('Paid story and new generated artwork bundled', all('assets/flutter_assets/' + name in archive.namelist() for name in ['assets/story/tide_ko.json', 'assets/story/tide_en.json', 'assets/story/tide_ja.json', 'assets/story/tide_zh.json', 'assets/images/backgrounds/tide_postoffice.jpg', 'assets/images/ui/tide_mark.png']))
    with args.apk.open('rb') as apk_file:
        digest = hashlib.file_digest(apk_file, 'sha256').hexdigest()
    report = {
        'scope': 'Signed ARM64 development review APK; not public release or physical-device certification',
        'sourceCommit': args.source_commit, 'apk': str(args.apk), 'bytes': args.apk.stat().st_size,
        'sha256': digest, 'certificateSha256': expected,
        'versionCode': int(match[2]) if match else None, 'versionName': match[3] if match else None,
        'checks': checks, 'pass': all(c['pass'] for c in checks), 'physicalDeviceTested': False,
    }
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    return 0 if report['pass'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
