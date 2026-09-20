"""Evaluate Dart-exported synthetic prompts, locally, with the pinned model.

Export: flutter test test/features/quest_model_contract_test.dart
  --dart-define=LIFEQUEST_EXPORT_MODEL_FIXTURES=true
Run with the litert-lm Python environment. No network or user app data is read.
"""
import argparse
import json
import time
from pathlib import Path
import litert_lm

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--count-only', action='store_true')
parser.add_argument('--input', type=Path, default=root / 'qa_artifacts/rebirth/production-model-inputs.json')
parser.add_argument('--output', type=Path, default=root / 'qa_artifacts/rebirth/production-model-probe.json')
args = parser.parse_args()
litert_lm.set_min_log_severity(litert_lm.LogSeverity.ERROR)
engine = litert_lm.Engine(
    str(Path.home() / '.local/share/lifequest/models/gemma-4-E2B-it.litertlm'),
    backend=litert_lm.Backend.CPU(thread_count=4), max_num_tokens=2048)
rows = []
try:
    for fixture in json.loads(args.input.read_text()):
        tokens = len(engine.tokenize(fixture['system'])) + len(engine.tokenize(fixture['prompt']))
        row = {'id': fixture['id'], 'input_tokens': tokens, 'output': '', 'error': None}
        started = time.monotonic()
        if not args.count_only:
            try:
                with engine.create_conversation(
                    system_message=fixture['system'],
                    thinking_config=litert_lm.ThinkingConfig(enable_thinking=False, thinking_token_budget=0),
                    sampler_config=litert_lm.SamplerConfig(temperature=.2, top_k=20, top_p=.95, seed=42),
                    max_output_tokens=550) as conversation:
                    response = conversation.send_message(fixture['prompt'])
                    row['output'] = ''.join(p.get('text', '') for p in response.get('content', []) if p.get('type') == 'text')
                    row['conversation_tokens'] = conversation.token_count
            except Exception as error:
                row['error'] = type(error).__name__ + ': ' + str(error)
        row['seconds'] = round(time.monotonic() - started, 2)
        rows.append(row)
        print(row['id'], tokens, 'input tokens;', row['seconds'], 'seconds;', row['error'] or 'ok', flush=True)
        if not args.count_only:
            args.output.parent.mkdir(parents=True, exist_ok=True)
            args.output.write_text(json.dumps({
                'runtime': 'Mac CPU 4 threads; not a phone benchmark',
                'prompt_source': 'shipping Dart QuestGeneration', 'context_tokens': 2048,
                'max_output_tokens': 550, 'cases': rows,
            }, ensure_ascii=False, indent=2))
finally:
    engine.close()
