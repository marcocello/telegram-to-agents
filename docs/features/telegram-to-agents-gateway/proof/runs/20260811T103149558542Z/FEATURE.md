# Native-harness Telegram gateway

## Goal

A Ductor operator can use Telegram as a thin, authenticated interface to either the native Codex or Claude harness without Ductor acting as an agent framework.

## Behavior

- Telegram is the only messaging transport. `provider` is the only agent-facing choice and has the closed values `codex` and `claude`.
- Pass-through is the only prompt policy. There is no prompt-mode setting or augmented mode in onboarding, configuration, runtime, or documentation.
- Ordinary Telegram text is sent to the selected harness unchanged. Ductor does not add a system prompt, developer instructions, appended prompt files, `MAINMEMORY.md`, an agent roster, background-worker instructions, delegation guidance, repository guidance, memory reminders, or reflection hooks.
- Codex runs through the Remote Control-managed Codex App Server via `codex app-server proxy`. Claude runs through its native CLI streaming interface. Each harness's native configuration controls its model, reasoning effort, tools, skills or agents, provider options, sandbox, approval or permission policy, repository instructions, and environment.
- Ductor supplies only transport coordinates required for the turn: the selected project `cwd`, the exact user payload, an optional native session/thread ID, and the gateway timeout. It does not emit model, effort, tool, prompt, permission, sandbox, approval, repository-bypass, or provider-environment overrides.
- A selected existing project directory is the default `cwd`. A valid per-topic project mapping may override it by topic name, `chat:topic`, or topic ID. Invalid or missing directories fail clearly instead of falling back to Ductor state.
- The first Telegram turn creates a provider-native session. Later turns resume it. The persisted record includes its provider so a provider change never sends a Codex thread ID to Claude or a Claude session ID to Codex. `/new` clears the current chat/topic session; `/stop` and `/interrupt` cancel active work without altering native harness configuration.
- Telegram shows bounded temporary commentary/tool/status progress while work is active, then removes or finalizes that temporary state and sends one clean final answer. Assistant answer deltas are not repeatedly edited into Telegram messages.
- Telegram voice notes and audio files are automatically transcribed when enabled. The transcript plus an optional caption becomes the user payload. Transcription failure returns a clear Telegram error and does not invoke either harness.
- Images and other attachments are downloaded without transcoding, resizing, metadata removal, or deletion of the received file. Internally, a user turn keeps user text and attachment metadata separate until the provider boundary. Codex receives static images as native `localImage` input items alongside unchanged caption text. Claude, and non-image Codex attachments, receive the unchanged caption plus exactly one deterministic transport line per file: `[Telegram attachment: <absolute-path>; type=<mime>]`. That line references the unchanged downloaded file and contains no instruction or inferred description.
- Telegram authorization, mention policy, file access, topic isolation, reply/media normalization, fixed per-turn timeout, cancellation, service lifecycle, and logging remain gateway responsibilities.
- The deployable service targets Linux VMs only. macOS and Windows service backends, metadata, and tests are absent.
- Loading a legacy configuration migrates only relevant provider, Telegram, project, progress, timeout, transcription, scene, state-root, and logging fields. Removed prompt modes and agent-framework settings are discarded when configuration is rewritten.

## Commands

- Retained commands: `/start`, `/help`, `/info`, `/status`, `/new`, `/reset`, `/stop`, `/stop_all`, `/interrupt`, `/restart`, `/where`, `/leave`, and `/showfiles`.
- Removed commands: `/model`, `/effort`, `/memory`, `/cron`, `/tasks`, `/session`, `/sessions`, `/agents`, `/agent_start`, `/agent_stop`, `/agent_restart`, `/agent_commands`, `/diagnose`, and `/upgrade`.

## Constraints

- Audio transcription is the only supported OpenAI API call outside a selected native harness and remains optional.
- Telegram authentication and file restrictions are never delegated to Codex or Claude.
- Ductor must not inject `DUCTOR_*` or provider override variables into harness processes. Service and transcription environment remains allowed at those boundaries.
- The installed package contains no Gemini, Grok, Antigravity, Matrix, Slack, Ductor multi-agent supervision, background workers, cron, delegated tasks, webhooks, heartbeat, direct API, prompt enrichment, memory injection, or automatic image-conversion runtime.
- The source checkout contains only runtime, tests, root tooling, assets, and active documentation needed by this product. Compatibility code is allowed only for migrating persisted Telegram configuration and provider-native sessions.
- A harness failure after accepting a turn is surfaced once. Ductor never replays the same user turn automatically as a fallback.
- Temporary progress must be confirmed deleted before the final answer is delivered. If deletion still fails after the bounded retry, Ductor withholds the final answer and surfaces a transport-delivery error rather than leaving progress beside a second final message.
- Timeout, `/stop`, and `/interrupt` terminate the active provider process, clear temporary progress, preserve any provider session ID already observed, and never replay the turn.

## Non-Goals

- Replacing or editing native system prompts, developer instructions, `AGENTS.md`, `CLAUDE.md`, skills, tools, agents, or native configuration.
- Supporting providers other than Codex and Claude.
- Supporting transports other than Telegram.
- Providing Ductor model, reasoning, tool, sandbox, approval, or permission selectors.
- Live token-by-token assistant-answer editing in Telegram.
- Supporting macOS or Windows service installation.
- Changing the transcription provider or transcription model beyond retaining the existing OpenAI transcription integration.
