# Repository guide

This checkout is a thin Linux Telegram gateway for native Codex and Claude harnesses. Telegram authentication, topic routing, unchanged media storage, file policy, temporary progress, audio transcription, and service lifecycle belong here. Model behavior, tools, skills or agents, permissions, sandboxing, reasoning, and repository instructions belong to the selected native harness.

## Development

Use Python 3.11+ and the repository virtual environment.

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
pytest
ruff format --check .
ruff check .
mypy src/telegram_to_agents
```

The tracked feature contract and executable proof are under `docs/features/telegram-to-agents-gateway/`. Run repository validation with:

```bash
"${CODEX_HOME:-$HOME/.codex}/scripts/gate" --root "$PWD"
```

## Runtime map

- `src/telegram_to_agents/messenger/telegram/`: authenticated Telegram ingress and delivery.
- `src/telegram_to_agents/orchestrator/` and `src/telegram_to_agents/session/`: provider- and Codex-backend-safe native session continuity and per-topic project selection.
- `src/telegram_to_agents/cli/`: native Codex App Server and Claude CLI boundaries plus subprocess lifecycle.
- `src/telegram_to_agents/files/`, `src/telegram_to_agents/security/`, and `src/telegram_to_agents/transcription/`: local file boundaries and optional OpenAI audio transcription.
- `src/telegram_to_agents/infra/`: PID lock and Linux systemd service lifecycle.
- `src/telegram_to_agents/config.py` and `src/telegram_to_agents/cli/init_wizard.py`: focused configuration and onboarding.

## Invariants

- Pass ordinary Telegram text to the selected harness unchanged. Pass-through is the only mode; do not add gateway prompts, memory, instructions, provider settings, or agent supervision.
- Native Codex/Claude configuration remains authoritative. Do not synthesize model, reasoning, sandbox, approval, permission, tool, skill, or agent overrides.
- Select Codex transport automatically before each turn: use `codex app-server proxy` only for the canonical live control socket, otherwise use `codex app-server --listen stdio://`. Never retry an accepted turn on the other transport, and never expose this as gateway configuration.
- Keep Telegram authentication and local file restrictions outside the harness.
- Use the same resolved project root for a topic's harness working directory, `/where`, media handling, and workspace-scoped file delivery.
- Keep original attachment bytes unchanged. Use Codex native local-image input and the defined minimal attachment line where a native local-file input is unavailable.
- Keep audio transcription optional. Never merge the gateway's private `.env` into harness subprocesses; preserve the service's inherited native-harness environment.
- Support Linux systemd only; foreground source execution may run on macOS, but do not introduce macOS or Windows service backends.
- Do not reintroduce other providers, transports, Docker execution, automation, background workers, memory injection, or gateway-managed agents.

Tests use `asyncio_mode = "auto"`; Ruff uses a 100-character line length; mypy is strict. Make the smallest effective change and add focused regression coverage.
