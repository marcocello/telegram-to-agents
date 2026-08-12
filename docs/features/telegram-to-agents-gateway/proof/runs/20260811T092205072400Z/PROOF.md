# Proof

## Done

- A real Telegram update reaches the Codex App Server boundary with unchanged text, the selected project `cwd`, native Codex configuration authority, and resumable thread state.
- `/new` causes the next Telegram message to create a different native Codex thread.
- A Telegram audio update is downloaded and transcribed through the real media path, and only its transcript plus caption reaches Codex.
- Onboarding and configuration expose only Telegram and Codex while retaining audio transcription.
- The source checkout and built wheel contain only the lean gateway runtime and its current tests/assets; alternate providers/transports and Ductor agent-framework runtimes are absent rather than hidden behind package exclusions.
- Runtime startup applies `log_level`, and `timeouts.normal` terminates one slow Codex turn without an activity-extension subsystem or retrying the turn.
- A real Telegram forum-topic name selects one project consistently for Codex `cwd`, `/where`, media storage guidance, and workspace-scoped file delivery.

## Command

```bash
"${CODEX_HOME:-$HOME/.codex}/scripts/proof_run_capture" --feature-dir docs/features/codex-telegram-gateway --timeout-seconds 180 --note "final Codex-only Telegram gateway candidate"
```

## Scenario: Telegram text creates and resumes a native Codex thread

- Producer/activation: feed realistic authorized private-chat Telegram updates through the aiogram dispatcher and normal Telegram handler with a temporary Ductor home and existing project directory.
- Consumer: Telegram handler, session manager, orchestrator, CLI service, and real Codex App Server command/RPC serializers.
- Read-back: the fake outer Codex daemon records the exact user text, selected `cwd`, distinct thread creation/resume IDs, proxy invocations, and RPC payloads after the real bridge subprocess and WebSocket protocol run; Telegram's fake network records streamed progress followed by the clean final answer.
- Fake: Telegram Bot API and external Codex App Server process only.
- Catches: bypassing Telegram routing, modifying user text, using a Ductor workspace, losing session continuity, invoking another provider, adding provider overrides at CLI or RPC layers, or leaking progress into the final answer.

## Scenario: `/new` resets the native Codex thread

- Producer/activation: after two resumed turns, feed `/new` and then another ordinary message through the same authorized Telegram chat/topic.
- Consumer: Telegram command handler and persisted Codex session state.
- Read-back: the next Codex request uses no previous thread ID and the newly returned thread ID replaces the old one without changing project `cwd`.
- Fake: Telegram Bot API and external Codex App Server process only.
- Catches: a cosmetic `/new`, resetting the wrong topic, retaining a stale thread, or resetting native Codex configuration.

## Scenario: Telegram audio transcription remains first-class

- Producer/activation: feed an authorized Telegram voice update with a caption through the real media download and automatic-transcription path.
- Consumer: Telegram media handler and the same Codex turn boundary used by ordinary text.
- Read-back: the fake outer transcription API receives the downloaded audio, Codex receives exactly the transcript plus normalized caption, and a forced transcription failure produces a Telegram error with no Codex invocation.
- Fake: Telegram file download, an outer local OpenAI-compatible HTTP endpoint, Telegram delivery, and the external Codex process; the real OpenAI client, application media/transcription routing, Codex bridge, and RPC serialization remain active.
- Catches: accidentally deleting transcription, sending file guidance instead of the transcript, appending Ductor instructions, ignoring captions, or invoking Codex after transcription failure.

## Scenario: Product surface is Codex and Telegram only

- Producer/activation: run Codex-only onboarding/config validation, load and rewrite a representative legacy multi-provider configuration, migrate a representative multi-provider session, and build the wheel from the current checkout.
- Consumer: generated config, runtime entrypoint, command registry, project metadata, and wheel contents. Compatibility-only notification, localization, update-observer, and automatic session-aging settings are also absent.
- Read-back: onboarding probes only Codex and asks no provider/transport/prompt-mode choice; direct config rejects non-Codex/non-Telegram values; legacy config is rewritten to the exact focused schema and legacy sessions retain only their Codex thread; all retained commands are present and removed commands absent; package metadata and dependency extras describe only the focused gateway; allowlisted root, source-tree, test-tree, and wheel inspections reject every unexpected product artifact, runtime directory, CLI module, obsolete test tree, bundled agent workspace asset, or broad packaging exclusion; a clean temporary environment installs the wheel and starts its real gateway entrypoint with only the external Telegram boundary replaced.
- Fake: terminal answers and Codex auth probe only.
- Catches: merely hiding or packaging-excluding legacy features, silently accepting removed providers, retaining dead provider/agent source and tests, retaining unrelated optional dependencies, or losing transcription from the package.

## Scenario: Telegram security remains outside Codex

- Producer/activation: submit an unauthorized private update, authorized and unauthorized actor-less channel posts, and allowed/out-of-project file responses through the normal middleware/delivery paths.
- Consumer: Telegram authorization middleware and allowed-root file sender.
- Read-back: unauthorized input and channels never reach Codex, an allowlisted channel does, and an authorized response sends the in-project file while rejecting the out-of-project file.
- Fake: Telegram Bot API and external Codex process only.
- Catches: treating pass-through as bypassing transport authorization or giving Telegram unrestricted file reads implicitly.

## Scenario: Fixed timeout and configured logging are real

- Producer/activation: start the normal runtime with `log_level=DEBUG`, then submit a deliberately slow streaming Telegram turn with a very short `timeouts.normal` value.
- Consumer: runtime logging setup, orchestrator request, Codex provider, subprocess executor, process registry, and Telegram delivery.
- Read-back: logging is configured at DEBUG, the slow subprocess is terminated once at the fixed deadline, the request is not silently retried, and the same topic accepts a later successful turn.
- Fake: Telegram Bot API and external Codex App Server process only.
- Catches: exposed but unused logging configuration, dead timeout-warning/extension settings, unbounded execution, retrying a timed-out user turn, or sticky cancellation state.

## Scenario: Forum topics resolve one project boundary

- Producer/activation: feed a realistic forum-topic-created service update followed by ordinary text, `/where`, and file delivery in that topic, with a topic-name mapping configured.
- Consumer: Telegram topic cache, session manager, orchestrator project resolver, Codex start request, media/file root policy, and `/where` response.
- Read-back: the topic name is persisted and the same mapped absolute directory appears in Codex `cwd`, `/where`, media resolution, and workspace-scoped allowed roots; a file outside that mapped directory is rejected.
- Fake: Telegram Bot API and external Codex App Server process only.
- Catches: an unwired topic-name resolver, topic mappings that affect only Codex, global-root `/where`, or file access escaping the active topic project.

## Scope

Proves:

- The public Telegram path is a thin, Codex-only gateway with native configuration authority, project cwd, persistent native threads, and deterministic `/new` behavior.
- Audio transcription remains active through the same user-turn boundary.
- Removed product surfaces are absent from onboarding, configuration, commands, metadata, runtime startup, and the built package.
- Telegram authorization and file policy remain enforced.
- Fixed timeout/logging configuration and per-topic project consistency are enforced at runtime.

Does not prove:

- Live Telegram delivery, live OpenAI transcription billing, or live Codex model output.
- Remote Control client rendering outside the App Server protocol events exercised by the test daemon.
- VM deployment or systemd restart behavior.

False-green risks:

- Calling the orchestrator directly could pass while Telegram routing is broken, so the primary scenarios feed real dispatcher updates.
- Mocking the CLI service could hide Ductor model/permission overrides, so the fake begins after real Codex command and RPC serialization.
- A denylist could miss renamed or relocated dead code, so proof inspects both the source checkout and a newly built wheel with explicit runtime/test-directory and CLI-module allowlists.
- Inspecting only package directories could miss root-level legacy assets, so proof also uses an explicit root-file allowlist.
- A successful transcript unit test could pass while Telegram still sends a file prompt, so the audio scenario crosses the media handler into the Codex boundary.
- A permissive Pydantic model could ignore removed provider values, so the proof requires explicit rejection and checks the rewritten legacy config.
- A mocked cancellation method could hide sticky abort state, so the proof registers a live process record, routes `/stop`, and proves the same topic can stream another native turn.
- Inspecting an archive could miss broken imports caused by excluded compatibility modules, so the proof installs and starts the wheel outside the checkout with the real runtime entrypoint and only Telegram's external API replaced.

Evidence method:

- deterministic

Known gaps:

- provider: Telegram, OpenAI transcription, and Codex are replaced only at their external network/process boundaries; no paid or credentialed calls run.
- deployment: systemd installation and VM rollout require a separate approved deployment check.

## Environment

- Repository-local Python, pytest, uv build tooling, temporary configuration/session directories, and deterministic fake external boundaries; no credentials or network.
- Runner stdout: Python executable/version, pytest version, uv version, repository root, built wheel name, retained command set, and exercised project directory.
