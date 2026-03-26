#!/bin/zsh
set -euo pipefail

if [[ -z "${AIMLAPI_API_KEY:-}" ]]; then
  echo "AIMLAPI_API_KEY is not set."
  exit 1
fi

PART="${1:-}"
if [[ -z "$PART" ]]; then
  echo "Usage: AIMLAPI_API_KEY=... zsh scripts/aimlapi_generate_sd_part.sh <front_hair|back_hair|eyes|mouth|outfit>"
  exit 1
fi

MODEL="${AIMLAPI_MODEL:-imagen-4.0-ultra-generate-preview-06-06}"
SIZE="${AIMLAPI_IMAGE_SIZE:-1024x1024}"
OUTPUT_DIR="${AIMLAPI_OUTPUT_DIR:-tmp/aimlapi_sd_parts/$PART}"
mkdir -p "$OUTPUT_DIR"

case "$PART" in
  front_hair)
    PROMPT=$(cat <<'EOF'
Create only one isolated front-hair and bangs asset for a Korean webtoon merchandise style SD avatar.
Do not generate a character sheet.
Do not generate a complete head.
Do not generate a face.
Do not generate eyes, eyebrows, nose, mouth, ears, body, outfit, palette card, labels, reference board, or any extra objects.
Generate only one single front-hair shape, centered, isolated, transparent background, suitable to place on top of an existing chibi face.
Use a soft rounded silhouette, polished Korean webtoon goods feeling, and readable volume.
EOF
)
    ;;
  back_hair)
    PROMPT=$(cat <<'EOF'
Create a single front-facing back-hair asset for a Korean webtoon merchandise style SD avatar.
This must be only the back hair layer for a cute self-insert chibi character.
Soft rounded silhouette, readable at small mobile size, no face, no eyes, no mouth, no body, no outfit, no text, no sheet layout.
Single asset only, centered, isolated, transparent background.
EOF
)
    ;;
  eyes)
    PROMPT=$(cat <<'EOF'
Create a single pair of front-facing eyes for a Korean webtoon merchandise style SD avatar.
Very large glossy cute eyes, warm and charming expression, suitable for a self-insert chibi character.
Only the eye pair, no face, no nose, no mouth, no hair, no body, no text, no sheet layout.
Single asset only, centered, isolated, transparent background.
EOF
)
    ;;
  mouth)
    PROMPT=$(cat <<'EOF'
Create a single tiny mouth asset for a Korean webtoon merchandise style SD avatar.
Cute, simple, warm, chibi expression.
Only the mouth, no face, no nose, no eyes, no hair, no body, no text, no sheet layout.
Single asset only, centered, isolated, transparent background.
EOF
)
    ;;
  outfit)
    PROMPT=$(cat <<'EOF'
Create a single front-facing outfit asset for a Korean webtoon merchandise style SD avatar.
Cute modern everyday clothing for a self-insert chibi character, soft rounded silhouette, simple shapes, polished Korean webtoon goods feeling.
Only the outfit, no head, no hair, no face, no body skin, no text, no sheet layout.
Single asset only, centered, isolated, transparent background.
EOF
)
    ;;
  *)
    echo "Unsupported part: $PART"
    exit 1
    ;;
esac

NEGATIVE_PROMPT=$(cat <<'EOF'
realistic, semi-realistic, complete character sheet, text, watermark, labels, multiple assets, collage, background scene, props, weapon, emblem, symbol, extra limbs, face, head, eyes, eyebrows, nose, mouth, ears, body, clothing details outside the requested part, messy composition, palette board, UI board, reference board
EOF
)

REQUEST_FILE="$OUTPUT_DIR/request.json"
RESPONSE_FILE="$OUTPUT_DIR/response.json"

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
