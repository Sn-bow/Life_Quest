#!/usr/bin/env python3
"""Create a local Play upload key only when Console has no registered upload cert.
Never overwrite an existing key. Credentials stay outside the repository.
"""
import os
from pathlib import Path
import secrets
import subprocess

root = Path(__file__).resolve().parents[1]
signing = Path.home() / '.local/share/lifequest/signing'
signing.mkdir(parents=True, exist_ok=True, mode=0o700)
os.chmod(signing, 0o700)
store = signing / 'lifequest-upload-2026.p12'
password_file = signing / 'upload-password.txt'
keytool = '/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/keytool'
if store.exists() != password_file.exists():
    raise SystemExit('Incomplete key backup found; inspect locally without overwriting it.')
if not store.exists():
    password = secrets.token_hex(32)
    fd = os.open(password_file, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, 'w') as handle:
        handle.write(password)
    environment = dict(os.environ, LQ_UPLOAD_STORE_PASSWORD=password)
    result = subprocess.run([keytool, '-genkeypair', '-keystore', str(store), '-storetype', 'PKCS12',
        '-alias', 'lifequest-upload', '-keyalg', 'RSA', '-keysize', '4096', '-validity', '10000',
        '-dname', 'CN=Life Quest Upload, C=KR', '-storepass:env', 'LQ_UPLOAD_STORE_PASSWORD',
        '-keypass:env', 'LQ_UPLOAD_STORE_PASSWORD'], env=environment, capture_output=True)
    if result.returncode:
        raise SystemExit('Key generation did not complete; inspect the signing directory locally.')
    os.chmod(store, 0o600)
else:
    password = password_file.read_text()
properties = root / 'android/key.properties'
if properties.exists():
    raise SystemExit('android/key.properties already exists; kept unchanged.')
fd = os.open(properties, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
with os.fdopen(fd, 'w') as handle:
    handle.write(f'storePassword={password}\nkeyPassword={password}\nkeyAlias=lifequest-upload\nstoreFile={store}\n')
environment = dict(os.environ, LQ_UPLOAD_STORE_PASSWORD=password)
subprocess.run([keytool, '-exportcert', '-rfc', '-keystore', str(store), '-alias', 'lifequest-upload',
    '-storepass:env', 'LQ_UPLOAD_STORE_PASSWORD', '-file', str(signing / 'upload-certificate.pem')],
    env=environment, check=True, capture_output=True)
print('Upload key created/configured outside Git; password was not printed.')
print(f'Private backup directory: {signing}')
