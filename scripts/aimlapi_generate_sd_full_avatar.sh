#!/bin/zsh
set -euo pipefail

if [[ -z "${AIMLAPI_API_KEY:-}" ]]; then
  echo "AIMLAPI_API_KEY is not set."
  exit 1
fi

MODEL="${AIMLAPI_MODEL:-gpt-image-1}"
SIZE="${AIMLAPI_IMAGE_SIZE:-1024x1024}"
OUTPUT_DIR="${AIMLAPI_OUTPUT_DIR:-tmp/aimlapi_sd_full_avatar}"
mkdir -p "$OUTPUT_DIR"

DEFAULT_PROMPT=$(cat <<'EOF'
Create one single front-facing Korean webtoon goods style SD avatar portrait for a mobile game profile.
Show one cute self-insert human character only.
Use a 2-head-tall chibi proportion with a very large head and a small upper body.
The face must dominate the frame.
Use huge glossy eyes, a soft round face, tiny nose, tiny mouth, subtle blush, clean hair silhouette, and gentle polished shading.
Draw only from the chest up or waist up so the face reads clearly at tiny mobile sizes.
Use simple modern casual clothing in soft neutral tones.
Make it look like premium Korean webtoon merchandise sticker art.
Transparent background.
No fantasy class concept, no weapons, no props, no text, no labels, no frame, no scene background, no multiple poses.
EOF
)

PROMPT="${AIMLAPI_PROMPT:-$DEFAULT_PROMPT}"

DEFAULT_NEGATIVE_PROMPT=$(cat <<'EOF'
realistic, semi-realistic, character sheet, multiple poses, text, watermark, labels, props, weapons, fantasy armor, emblem, symbol, background scene, mature proportions, long legs, detailed fingers, extra limbs, collage
EOF
)

NEGATIVE_PROMPT="${AIMLAPI_NEGATIVE_PROMPT:-$DEFAULT_NEGATIVE_PROMPT}"
QUALITY="${AIMLAPI_QUALITY:-high}"
BACKGROUND="${AIMLAPI_BACKGROUND:-transparent}"

REQUEST_FILE="$OUTPUT_DIR/request.json"
RESPONSE_FILE="$OUTPUT_DIR/response.json"

python3 - <<PY
import json
from pathlib import Path

model = "${MODEL}"

if model == "imagen-4.0-ultra-generate-preview-06-06":
    payload = {
        "model": model,
        "prompt": "Front-facing Korean webtoon merchandise style SD character, ultra cute chibi self-insert avatar, 2-head-tall proportion, very large glossy eyes, soft round face, tiny nose and mouth, short limbs, gentle blush, simple modern casual outfit, sticker-like silhouette, transparent background, one character only, no text, no props.",
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
        "quality": "${QUALITY}",
        "background": "${BACKGROUND}",
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
