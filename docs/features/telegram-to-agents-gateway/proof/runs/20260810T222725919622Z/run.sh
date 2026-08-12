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

proof_tmp="$(mktemp -d)"
trap 'rm -rf "$proof_tmp"' EXIT
uv build --wheel --out-dir "$proof_tmp"
wheel_path="$(find "$proof_tmp" -maxdepth 1 -name '*.whl' -print -quit)"
echo "wheel=$(basename "$wheel_path")"

wheel_venv="$proof_tmp/wheel-venv"
"$python_bin" -m venv --system-site-packages "$wheel_venv"
"$wheel_venv/bin/python" -m pip install --no-deps "$wheel_path"
(
  cd "$proof_tmp"
  PYTHONPATH="" "$wheel_venv/bin/python" -m ductor_bot --help
  PYTHONPATH="" "$wheel_venv/bin/python" -c \
    "from ductor_bot.messenger.telegram.app import TelegramBot; from ductor_bot.transcription import transcribe_openai_audio; print('installed_wheel_import=PASS')"
)

GATEWAY_WHEEL="$wheel_path" "$python_bin" -m pytest -q \
  tests/features/test_codex_telegram_gateway.py::test_configuration_commands_and_file_policy_are_gateway_only
GATEWAY_WHEEL="$wheel_path" "$python_bin" -m pytest -q \
  tests/features/test_codex_telegram_gateway.py
"$python_bin" -m pytest -q tests/transcription/test_openai_audio.py
