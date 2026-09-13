# 무료 온디바이스 모델 결정 — 2026-09-14 KST

**Android 구현 후보: Gemma 4 E2B IT + LiteRT-LM 0.17.0. 공개 출시 승인은 실기기 검증 후.**

사용자 조건은 무료 공개 모델, 상업 앱에 사용 가능, 한국어 개인화, 클라우드 LLM 비용 없음이다. Gemini Nano/AICore는 공개 가중치 조건과 다르므로 제외했다.

## 비교 실험

Apple Silicon Mac, RAM 16GB, CPU 4 threads, context 2048, thinking off, temperature 0.2, seed 42, max output 550 tokens. Qwen은 llama.cpp 0.4.0의 Q4_K_M, Gemma는 LiteRT-LM 0.17.0 CPU. **각기 다른 런타임/양자화이며 Android 성능 비교가 아니다.** 네트워크는 모델 파일 다운로드에만 사용하고 추론은 로컬. 실제 사용자 정보 대신 합성 시나리오 8개. 각 조건 1회 실행으로 통계적 우월성이나 안전성을 입증하지 않는다.

| 모델 | 프롬프트 | 구조 검사 통과 | 평균 생성 시간 |
|---|---|---|---|
| qwen2b | 자유 JSON 생성 | 0/8 | 7.00초 |
| qwen2b | 앱이 시간 배정 | 2/8 | 15.21초 |
| gemma4e2b | 자유 JSON 생성 | 2/8 | 13.94초 |
| gemma4e2b | 앱이 시간 배정 | 8/8 | 8.54초 |

1차 실험에서 두 모델 모두 시간 예산을 자주 초과했다. 2차에서는 앱이 퀘스트 수·시간·성장 분야·보상을 먼저 정하고 모델은 제목·행동·이유만 작성하도록 했다. Gemma가 형식 준수에서 우세했다. 따라서 모델을 게임 수치의 결정자로 사용하지 않는다.

수동 검토 한계: Gemma의 밤 시간 예시에 음악 틀기가 나와 소음 조건을 더 명확히 해야 한다. 일부 이유는 반복적인 효능 표현이며, 물 마시기를 정리 분야에 배치하는 등 분야 일치가 완벽하지 않다. 형식 8/8이 내용의 안전성·유용성 8/8을 의미하지 않는다. 앱은 행동 범위를 제한하고 위험/길이/시간 표현을 검사하며 거절·신고·기본 추천 복귀를 제공한다. 더 큰 한국어 평가 세트와 실제 사용자의 검증이 출시 전 필요하다.

## 파일과 배포 조건

- 원저자 Qwen: https://huggingface.co/Qwen/Qwen3.5-2B — Apache 2.0. 실험 양자화는 원저자가 아닌 Unsloth 배포: https://huggingface.co/unsloth/Qwen3.5-2B-GGUF — 1,280,835,840 bytes.
- Gemma 4: https://ai.google.dev/gemma/docs/core — Apache 2.0. 과거 Gemma 계열의 조건을 이 모델에 대입하지 않는다. LiteRT 배포 파일: https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm — 2,588,147,712 bytes.
- 파일 URL은 커밋 고정, 크기 및 SHA-256을 `model-candidates.json`에 기록하고 내려받은 파일과 대조했다. 모델/라이선스 표기를 앱에 포함한다.
- LFM2.5 1.2B는 한국어 지원 소형 후보지만 https://docs.liquid.ai/lfm/help/model-license 의 연 매출 $10M 조건이 있어 Apache 후보 뒤로 두었다.
- Qwen 0.8B는 더 작지만 원저자 설명상 프로토타이핑/미세조정 성격이 강하고 이 앱의 한국어 생성 품질은 아직 측정하지 않았다.

## 구현 계약

최초 선택 다운로드, HTTPS, 고정 파일 해시 확인 후 원자적 반영, 중단/재시도/삭제 지원. 모델은 Android noBackupFilesDir에 저장한다. 생성은 기기 내부 CPU에서만 수행하고 모델을 사용하지 못하면 기본 추천이라고 표시한다. 자동 클라우드 전환이나 API 키 입력 없음. 프로필과 최근 행동 요약으로 프롬프트를 구성하며 모델 가중치의 지속 학습을 주장하지 않는다.

APK/AAB에 2.59GB 모델을 내장하지 않는다. 권장 RAM 8GB부터 실기기 검증하며 낮은 메모리/미지원 기기는 기본 추천을 유지한다. 저사양 대체 모델과 GPU 가속은 별도 품질·발열·배터리 측정 후 결정한다. 공개 비용이 없는 모델이라도 다운로드 통신 요금/기기 저장 공간은 필요함을 UI에 설명한다.

공식 Android API: https://developers.google.com/edge/litert-lm/android
공식 Gemma 4 벤치마크: https://developers.google.com/edge/litert-lm/models/gemma-4 — 제조사 수치를 이 앱의 실측치로 사용하지 않는다.

재현: `scripts/download_eval_models.py`, `scripts/evaluate_quest_models.py`. 원시 출력은 ignored `qa_artifacts/rebirth/eval-*.json`. 출시에 쓸 확정 프롬프트/네이티브 빌드로 전체 평가를 다시 실행해야 한다.


## Android 통합 검증 — 2026-09-14 01:20 KST

API 35 / ARM64 / RAM 6GB / 16KB 페이지 에뮬레이터 `LifeQuest_API35_16KB`에서 실제 Android MethodChannel과 LiteRT-LM JNI를 사용했다. 합성 한국어 학습 목표 1건이며 실물 휴대폰 측정이 아니다.

- 잘못된 입력 거부, 약 9.4MB 다운로드 후 취소, 부분 파일에서 이어받기, 전체 2,588,147,712바이트 SHA-256 확인까지 성공.
- 실제 앱의 `QuestGeneration.system/prompt/parse`로 3개 퀘스트 생성: **20,087ms**, 구조·언어·위험 문구 검사 통과. 시간/ID/보상은 앱이 정한 값 유지.
- 총 통합 테스트 시간 4분 31초. 소음·건강 제약 등 모든 의미적 안전성이나 실물 기기 발열/배터리를 입증한 결과가 아니다.
- 실행: `flutter test integration_test/on_device_model_smoke_test.dart -d emulator-5556 --dart-define=LIFEQUEST_QA_PREVIEW=true --dart-define=LIFEQUEST_AI_MODEL_SMOKE=true`.
- 2.59GB 다운로드를 명시적으로 켜는 테스트다. 전용 QA 기기에만 실행한다. 테스트 종료 시 Flutter가 테스트 앱을 제거할 수 있다.
- APK ZIP 정렬 검사 `zipalign -c -P 16 4` 성공. release AAB 전체 ELF 세그먼트 검사는 별도 진행한다.
