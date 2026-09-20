#!/usr/bin/env python3
"""Independent cryptography check for synthetic QA fixtures, never user backups.
Run: uv run --with cryptography python scripts/verify_backup_fixture.py [path]
The public test passphrase is not a user credential.
"""
import base64
import hashlib
import json
from pathlib import Path
import sys
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

path = Path(sys.argv[1] if len(sys.argv) > 1 else 'qa_artifacts/rebirth/backup-fixture.lqbackup')
assert path.stat().st_size <= 8 * 1024 * 1024
value = json.loads(path.read_bytes())
assert value['algorithm'] == 'pbkdf2-sha256-600000-aes256gcm'
key = hashlib.pbkdf2_hmac('sha256', '서랍 속에 보관하는 긴 암호 🌿'.encode(),
                        base64.b64decode(value['salt']), 600000, 32)
plain = AESGCM(key).decrypt(base64.b64decode(value['nonce']),
    base64.b64decode(value['ciphertext']) + base64.b64decode(value['tag']),
    b'LifeQuest encrypted device backup v1/pbkdf2-sha256-600000-aes256gcm')
result = json.loads(plain)
assert result['profile']['character']['name'] == '검증용 각성자'
assert result['director']['profile']['goal'] == '퇴근 후 조용한 영어 공부'
assert result['profile']['isNotificationEnabled'] is False
print('PASS: independent Python PBKDF2 / AES-GCM decryption of synthetic Unicode fixture')
