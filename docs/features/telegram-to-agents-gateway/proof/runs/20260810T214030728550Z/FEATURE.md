# Codex-only Telegram gateway

## Goal

A Ductor operator can use Telegram as a thin, authenticated interface to the native Codex harness without Ductor acting as a separate agent framework.

## Behavior

- Telegram is the only messaging transport and Codex is the only execution provider exposed by onboarding, configuration, runtime startup, commands, documentation, and the installable package.
- Onboarding verifies native Codex availability, collects the Telegram bot token and allowed user, selects an existing project directory, and optionally configures automatic audio transcription. It does not ask for a provider, model, reasoning effort, prompt mode, sandbox, approval policy, permission mode, alternate transport, Docker sandbox, automation, memory, or multi-agent settings.
- Ordinary Telegram text is sent to Codex unchanged. Ductor does not add a system prompt, developer instructions, memory, agent roster, background-worker instructions, delegation guidance, repository guidance, reflection hooks, or appended prompt files.
- Ductor invokes the Remote Control-managed Codex App Server through `codex app-server proxy`. Codex's native configuration controls the model, reasoning effort, tools, skills, subagents, provider options, sandbox, approval policy, permissions, repository instructions, and environment.
- A selected existing project directory is the default `cwd` for Codex threads. A valid per-topic project mapping may override it. Invalid or missing project directories fail clearly instead of falling back to Ductor's shared workspace.
- The first Telegram turn creates an app-visible Codex thread, later turns resume the stored thread ID, and `/new` clears the current chat/topic thread so the next turn creates a new one. `/stop` and `/interrupt` cancel active work without altering native Codex configuration.
- Codex commentary, thinking, tool activity, and final-answer events continue to use the existing bounded Telegram progress and final-message behavior.
- Telegram voice notes and audio files are automatically transcribed when enabled. The transcript, plus an optional caption, becomes the user message sent to Codex. Transcription failures return a clear Telegram error and do not invoke Codex.
- Telegram user/group/channel authorization, mention policy, file download/send policy, topic isolation, reply context, streaming limits, timeout handling, service lifecycle, restart handling, logging, and update checks remain transport responsibilities.
- Loading a legacy Ductor configuration migrates only relevant Telegram, project, streaming, timeout, transcription, notification, language, logging, and update fields. Removed provider, prompt, memory, automation, multi-agent, alternate transport, API, webhook, and Docker settings are not preserved in the rewritten configuration.
- Direct configuration validation rejects any provider other than Codex and any transport other than Telegram.

## Commands

- Retained commands: `/start`, `/help`, `/info`, `/status`, `/new`, `/reset`, `/stop`, `/stop_all`, `/interrupt`, `/restart`, `/where`, `/leave`, and `/showfiles`.
- Removed commands: `/model`, `/effort`, `/memory`, `/cron`, `/tasks`, `/session`, `/sessions`, `/agents`, `/agent_start`, `/agent_stop`, `/agent_restart`, `/agent_commands`, `/diagnose`, and `/upgrade`.

## Constraints

- Audio transcription is the only supported OpenAI API call made outside the native Codex harness and remains optional.
- Telegram authentication and file-access restrictions are never delegated to Codex.
- Ductor must not inject `DUCTOR_*` provider environment variables or secrets into the Codex process. Environment needed by the Telegram service or transcription client remains allowed at those boundaries.
- The installed package must not contain runtime implementations for Claude, Gemini, Grok, Antigravity, Matrix, Slack, Ductor multi-agent supervision, background workers, cron, delegated tasks, webhooks, heartbeat, or the direct API.
- Existing persisted Telegram session records may be migrated to the single Codex thread representation; unrelated provider session buckets are discarded.
- The source checkout may retain historical feature evidence, but removed runtime modules, configuration fields, onboarding choices, commands, dependencies, and package metadata are not part of the product.

## Non-Goals

- Replacing or editing Codex's native system prompt, developer instructions, `AGENTS.md`, skills, tools, subagents, or `~/.codex/config.toml`.
- Supporting Claude or any other execution provider.
- Supporting Matrix, Slack, direct API clients, webhooks, scheduled work, named background sessions, or Ductor-managed subagents.
- Providing a Ductor model or permission selector.
- Changing the transcription provider or transcription model beyond retaining the existing OpenAI transcription integration.
