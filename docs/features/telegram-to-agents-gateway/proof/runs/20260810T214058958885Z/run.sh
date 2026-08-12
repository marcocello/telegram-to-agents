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

GATEWAY_WHEEL="$wheel_path" "$python_bin" -m pytest -q \
  tests/features/test_codex_telegram_gateway.py
