"""Fetch pinned public model artifacts for local quality evaluation (no API key)."""
import hashlib
import json
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
CACHE = Path.home() / '.local/share/lifequest/models'

def main():
    candidates = json.loads((ROOT / 'docs/rebirth/model-candidates.json').read_text())
    for model in candidates:
        target = CACHE / model['file']
        if target.exists() and target.stat().st_size == model['bytes']:
            print('Cached:', target.name, flush=True)
            continue
        url = f"https://huggingface.co/{model['repo']}/resolve/{model['revision']}/{model['file']}"
        partial = target.with_suffix(target.suffix + '.part')
        digest = hashlib.sha256()
        print('Downloading:', model['file'], model['bytes'], flush=True)
        with urllib.request.urlopen(url, timeout=60) as response, partial.open('wb') as sink:
            while chunk := response.read(4 * 1024 * 1024):
                sink.write(chunk)
                digest.update(chunk)
        if partial.stat().st_size != model['bytes'] or digest.hexdigest() != model['sha256']:
            raise RuntimeError('Artifact integrity mismatch: ' + model['file'])
        partial.replace(target)
        print('Verified:', target.name, flush=True)

if __name__ == '__main__':
    main()
