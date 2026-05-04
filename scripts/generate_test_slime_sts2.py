import base64
import os
import urllib.request
from pathlib import Path

from openai import OpenAI


OUTPUT_PATH = Path(
    r"C:\Users\wjd54\Documents\Life_Quest\assets\images\monsters\test_slime_sts2.png"
)

PROMPT = (
    "A gelatinous slime monster for a dark fantasy card game. Round, semi-transparent green blob body with a large toothy grin and three googly eyes at different heights. Thick bold black outlines, cel-shaded 2D illustration style. Vibrant lime green with darker green shadows. Whimsical yet slightly menacing expression. Inspired by Slay the Spire 2 art style - crisp linework, colorful, dark fantasy with playful whimsy. Full body, front-facing game sprite. Isolated on pure transparent background."
)


def main() -> None:
    if not os.environ.get("OPENAI_API_KEY"):
        raise RuntimeError("OPENAI_API_KEY environment variable is not set.")

    client = OpenAI()

    result = client.images.generate(
        model="gpt-image-2",
        prompt=PROMPT,
        size="1024x1024",
        quality="high",
        background="transparent",
        output_format="png",
    )

    image = result.data[0]
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    if image.b64_json:
        OUTPUT_PATH.write_bytes(base64.b64decode(image.b64_json))
    elif image.url:
        with urllib.request.urlopen(image.url) as response:
            OUTPUT_PATH.write_bytes(response.read())
    else:
        raise RuntimeError("Image generation response did not include image data.")

    print(f"Saved {OUTPUT_PATH} ({OUTPUT_PATH.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
