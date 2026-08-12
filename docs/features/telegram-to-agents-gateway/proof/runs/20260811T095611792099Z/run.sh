#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../../.." && pwd)"
cd "$repo_root"

python_bin="$repo_root/.venv/bin/python"
if [[ ! -x "$python_bin" ]]; then
  python_bin="$(command -v python3)"
fi

echo "python=$python_bin"
"$python_bin" --version
"$python_bin" -m pytest --version
uv --version
echo "repo_root=$repo_root"
echo "proof_tests=tests/features/test_codex_telegram_gateway.py"
echo "providers=codex,claude"

proof_tmp="$(mktemp -d)"
trap 'rm -rf "$proof_tmp"' EXIT
uv build --wheel --out-dir "$proof_tmp"
wheel_path="$(find "$proof_tmp" -maxdepth 1 -name '*.whl' -print -quit)"
echo "wheel=$(basename "$wheel_path")"

wheel_site="$proof_tmp/wheel-site"
uv pip install --python "$python_bin" --no-deps --target "$wheel_site" "$wheel_path"
(
  cd "$proof_tmp"
  PYTHONPATH="$wheel_site" "$python_bin" -m ductor_bot --help
  PYTHONPATH="$wheel_site" "$python_bin" -c \
    "from pathlib import Path; import ductor_bot; from ductor_bot.messenger.telegram.app import TelegramBot; from ductor_bot.transcription import transcribe_openai_audio; assert Path(ductor_bot.__file__).is_relative_to(Path('$wheel_site')); print('installed_wheel_import=PASS')"
  GATEWAY_WHEEL_SITE="$wheel_site" GATEWAY_SMOKE_TMP="$proof_tmp/smoke" \
    PYTHONPATH="$wheel_site" "$python_bin" \
    "$repo_root/docs/features/codex-telegram-gateway/proof/installed_runtime_smoke.py"
)

GATEWAY_WHEEL="$wheel_path" "$python_bin" -m pytest -q \
  tests/features/test_codex_telegram_gateway.py::test_configuration_commands_and_file_policy_are_gateway_only
GATEWAY_WHEEL="$wheel_path" "$python_bin" -m pytest -q \
  tests/features/test_codex_telegram_gateway.py
"$python_bin" -m pytest -q tests/transcription/test_openai_audio.py
