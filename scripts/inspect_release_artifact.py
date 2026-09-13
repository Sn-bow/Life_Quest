#!/usr/bin/env python3
"""Inspect actual default-mode artifacts, not Play publication readiness.

No passwords or keystores are read. Supply the expected PUBLIC certificate hash.
Device APKs must come from this AAB; native binaries are compared with the AAB.
"""
import argparse
import csv
import hashlib
import io
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile

ANDROID = '{http://schemas.android.com/apk/res/android}'


def command(args):
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT)


def elf_alignments(data):
    if data[:4] != b'\x7fELF' or data[5] != 1:
        raise ValueError('Expected little-endian ELF')
    if data[4] == 2:
        offset = struct.unpack_from('<Q', data, 32)[0]
        size, count = struct.unpack_from('<HH', data, 54)
        fmt = '<IIQQQQQQ'
    elif data[4] == 1:
        offset = struct.unpack_from('<I', data, 28)[0]
        size, count = struct.unpack_from('<HH', data, 42)
        fmt = '<IIIIIIII'
    else:
        raise ValueError('Unknown ELF class')
    loads = [struct.unpack_from(fmt, data, offset + i * size) for i in range(count)]
    return [row[-1] for row in loads if row[0] == 1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bundle', type=Path, default=Path('build/app/outputs/bundle/release/app-release.aab'))
    parser.add_argument('--bundletool', type=Path, default=Path.home() / '.local/share/lifequest/tools/bundletool-1.18.3.jar')
    parser.add_argument('--certificate-sha256', required=True)
    parser.add_argument('--device-apks', type=Path)
    parser.add_argument('--device-spec', type=Path)
    parser.add_argument('--output', type=Path, default=Path('qa_artifacts/rebirth/artifact-inspection.json'))
    args = parser.parse_args()
    if bool(args.device_apks) != bool(args.device_spec):
        parser.error('Provide both --device-apks and --device-spec.')
    java_home = Path(os.environ.get('JAVA_HOME', '/usr'))
    java, keytool, jarsigner = [str(java_home / 'bin' / t) for t in ['java', 'keytool', 'jarsigner']]
    bundletool = [java, '-jar', str(args.bundletool)]
    checks = []

    def check(label, okay):
        checks.append({'check': label, 'pass': bool(okay)})
        print(('PASS' if okay else 'FAIL') + ': ' + label)

    command(bundletool + ['validate', '--bundle=' + str(args.bundle)])
    manifest_text = command(bundletool + ['dump', 'manifest', '--bundle=' + str(args.bundle)])
    manifest = ET.fromstring(manifest_text)
    app = manifest.find('application')
    check('Package com.lifequest.app', manifest.get('package') == 'com.lifequest.app')
    check('Target API at least 36', int(manifest.find('uses-sdk').get(ANDROID + 'targetSdkVersion', '0')) >= 36)
    for attr in ['debuggable', 'testOnly', 'usesCleartextTraffic']:
        check('Release ' + attr + ' is not true', app.get(ANDROID + attr) != 'true')
    check('Automatic cloud backup disabled', app.get(ANDROID + 'allowBackup') == 'false')
    permissions = {n.get(ANDROID + 'name') for n in manifest.findall('uses-permission')}
    forbidden = {'com.android.vending.BILLING', 'com.google.android.gms.permission.AD_ID',
                 'android.permission.ACCESS_ADSERVICES_AD_ID', 'android.permission.ACCESS_ADSERVICES_ATTRIBUTION',
                 'android.permission.ACCESS_ADSERVICES_TOPICS', 'android.permission.QUERY_ALL_PACKAGES'}
    check('Default artifact excludes billing and advertising permissions', not permissions.intersection(forbidden))
    check('No Mobile Ads components', 'com.google.android.gms.ads.' not in manifest_text)
    metadata = {m.get(ANDROID + 'name'): m.get(ANDROID + 'value') for m in app.findall('meta-data')}
    for name in ['firebase_crashlytics_collection_enabled', 'firebase_analytics_collection_enabled']:
        check(name + ' disabled', metadata.get(name) == 'false')
    # Android upload certificates are intentionally self-signed. Verify both
    # archive integrity and identity instead of requiring a public CA chain.
    verification = command([jarsigner, '-J-Duser.language=en', '-verify', str(args.bundle)])
    check('JAR signature verifies', 'jar verified.' in verification)
    cert = command([keytool, '-J-Duser.language=en', '-printcert', '-jarfile', str(args.bundle)])
    expected = args.certificate_sha256.replace(':', '').lower()
    fingerprints = re.findall(r'SHA256:\s*([A-Fa-f0-9:]+)', cert)
    check('Expected public upload certificate', len(fingerprints) == 1 and fingerprints[0].replace(':', '').lower() == expected)
    libraries, native_hashes = [], {}
    with zipfile.ZipFile(args.bundle) as archive:
        for name in archive.namelist():
            if not name.endswith('.so'):
                continue
            data = archive.read(name)
            native_hashes[name.removeprefix('base/')] = hashlib.sha256(data).hexdigest()
            alignments = elf_alignments(data)
            libraries.append({'path': name, 'loadAlignments': alignments})
            check(name + ' ELF LOAD alignment >= 16 KB', bool(alignments) and all(a >= 16384 for a in alignments))
            if name.endswith('/libapp.so'):
                check(name + ' excludes native QA entry point', b'LIFEQUEST_RELEASE_PROBE=' not in data)
        check('On-device ARM64 JNI included', 'base/lib/arm64-v8a/liblitertlm_jni.so' in archive.namelist())
        check('Model downloaded separately', not any(n.endswith(('.litertlm', '.gguf')) for n in archive.namelist()))
    size = None
    if args.device_apks:
        sizes = command(bundletool + ['get-size', 'total', '--apks=' + str(args.device_apks), '--device-spec=' + str(args.device_spec)])
        size = {k: int(v) for k, v in next(csv.DictReader(io.StringIO(sizes))).items()}
        # Conservative product budget; does not claim a universal Play size limit.
        check('Sample device download within 200 MB project budget', size['MAX'] <= 200_000_000)
        with zipfile.ZipFile(args.device_apks) as apks:
            for name in apks.namelist():
                if not name.endswith('.apk'):
                    continue
                raw = apks.read(name)
                with zipfile.ZipFile(io.BytesIO(raw)) as apk:
                    for member in apk.infolist():
                        if not member.filename.endswith('.so'):
                            continue
                        name_len, extra_len = struct.unpack_from('<HH', raw, member.header_offset + 26)
                        offset = member.header_offset + 30 + name_len + extra_len
                        check(name + '/' + member.filename + ' ZIP 16 KB alignment', member.compress_type == zipfile.ZIP_STORED and offset % 16384 == 0)
                        check(name + '/' + member.filename + ' matches AAB', hashlib.sha256(apk.read(member)).hexdigest() == native_hashes.get(member.filename))
    with args.bundle.open('rb') as bundle_file:
        bundle_hash = hashlib.file_digest(bundle_file, 'sha256').hexdigest()
    report = {
        'scope': 'Local default-mode artifact only; NOT ready-to-publish certification',
        'bundle': str(args.bundle), 'bytes': args.bundle.stat().st_size, 'sha256': bundle_hash,
        'versionName': manifest.get(ANDROID + 'versionName'), 'versionCode': manifest.get(ANDROID + 'versionCode'),
        'certificateSha256': expected, 'libraries': libraries, 'sampleDeviceDownloadBytes': size,
        'checks': checks, 'pass': all(c['pass'] for c in checks),
        'remaining': ['Physical Android device validation', 'Working AI reporting backend',
                      'Real Play purchase/refund/restore before selling', 'Public privacy URL and Data safety review',
                      'Closed testing eligibility and Play review'],
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print('Report: ' + str(args.output))
    print('Local artifact checks only. External release gates remain open.')
    return 0 if report['pass'] else 1


if __name__ == '__main__':
    sys.exit(main())
