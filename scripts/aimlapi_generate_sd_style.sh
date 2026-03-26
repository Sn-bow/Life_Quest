#!/bin/zsh
set -euo pipefail

if [[ -z "${AIMLAPI_API_KEY:-}" ]]; then
  echo "AIMLAPI_API_KEY is not set."
  echo "Example: export AIMLAPI_API_KEY='your_key_here'"
  exit 1
fi

MODEL="${AIMLAPI_MODEL:-imagen-4.0-ultra-generate-preview-06-06}"
SIZE="${AIMLAPI_IMAGE_SIZE:-1024x1024}"
OUTPUT_DIR="${AIMLAPI_OUTPUT_DIR:-tmp/aimlapi_sd_style}"
mkdir -p "$OUTPUT_DIR"

PROMPT=$(cat <<'EOF'
Create a front-facing Korean webtoon merchandise style SD character sheet for a mobile app avatar.
The character should feel cute, soft, rounded, and emotionally warm, like collectible sticker goods or bonus SD illustrations from a popular Korean webtoon.
Use a 2-head-tall chibi proportion, very large glossy expressive eyes, a soft round face, tiny nose, tiny mouth, short limbs, and a clean sticker-like silhouette.
The style should be more charming and polished than generic anime chibi, with gentle line weight, soft shading, subtle cheek blush, and clear hair volume.
Use a simple modern everyday outfit with clean shapes and warm neutral colors.
Show 4 small expression variations in one sheet: neutral, smile, happy, calm.
Front-facing only.
Transparent or plain light background.
No props, no weapons, no text, no logos.
EOF
)

NEGATIVE_PROMPT=$(cat <<'EOF'
realistic, semi-realistic, mature proportions, long legs, detailed fingers, fantasy armor, weapon, magical sigil, emblem, mascot, animal ears, clutter, background scene, text, watermark, extra limbs, distorted eyes, harsh shadows, cold sci-fi style, class-based RPG design
EOF
)

RESPONSE_FILE="$OUTPUT_DIR/style_exploration_response.json"

REQUEST_FILE="$OUTPUT_DIR/style_exploration_request.json"

python3 - <<PY
import json
from pathlib import Path

model = "${MODEL}"

if model == "imagen-4.0-ultra-generate-preview-06-06":
    payload = {
        "model": model,
        "prompt": """${PROMPT}""",
        "convert_base64_to_url": True,
        "num_images": 1,
        "aspect_ratio": "1:1",
        "enhance_prompt": True,
        "person_generation": "allow_adult",
        "add_watermark": False,
    }
else:
    payload = {
        "model": model,
        "size": "${SIZE}",
        "n": 1,
        "response_format": "b64_json",
        "prompt": """${PROMPT}""",
        "negative_prompt": """${NEGATIVE_PROMPT}""",
    }

Path("${REQUEST_FILE}").write_text(
    json.dumps(payload, ensure_ascii=False, indent=2),
    encoding="utf-8",
)
PY

curl -sS https://api.aimlapi.com/v1/images/generations \
  -H "Authorization: Bearer ${AIMLAPI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d @"$REQUEST_FILE" > "$RESPONSE_FILE"

echo "Saved response to $RESPONSE_FILE"
echo "Decode the returned image payload after checking the provider response shape."
