**file**: docs/requirements/requirement-shell-interactive-vs-noninteractive.md  
**Requirement-ID**: `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE`  
**Status**: Active (Version 1.0.2 – CIAO v2.10.2 Principles 16/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for how the timer **POSIX shell CLI** behaves in **interactive** (human + TTY) versus **non-interactive** (automation, `curl | sh`, CI/CD, pipes, `--json` / often `--quiet`) environments.

It defines interactive vs non-interactive behavior for this shell project (global flags + `prompt_*` + TTY detection—not a Node Config singleton).

**Scope:** Mode detection signals, prompt policy, auto-install vs confirm, force/skip rules, interaction with quiet/json/debug and output SSOT.  
**Out of scope (cited, not re-owned):** Full command catalog (`requirement-shell-cli-interface.md`); output function catalog (`requirement-shell-output-requirements.md`); self-update integrity (`requirement-shell-self-management.md`); idempotency matrix (`requirement-shell-idempotency.md`).

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Definitions (portable)

| Mode | Definition |
|------|------------|
| **Interactive** | A human is driving the tool with a usable terminal (**TTY**). Confirmations, colors, and onboarding prompts are allowed when not overridden by machine flags. |
| **Non-interactive** | No human is available to answer prompts: pipes, CI/CD, `curl \| sh`, config management, Docker build, scripts, or machine flags such as `--json` (and often `--quiet`). The tool **must never hang waiting for input** and must apply **documented safe automatic defaults**. |

### 2.2 Detection (mode SSOT for shell)

For shell CLIs without a separate Config class, the **mode SSOT** is the **global flag / TTY block** at script top + values set by the dispatcher after parsing:

| Signal | Variable / check | Meaning |
|--------|------------------|---------|
| TTY | `TTY=1` when stdin and stdout are terminals; also live `[ -t 0 ]` / `[ -t 1 ]` in prompt helpers | Interactive UX possible |
| Quiet | `QUIET=1` (`--quiet` / `-q`) | Suppress non-essential human chatter |
| JSON | `JSON=1` (`--json`; implies quiet) | Machine output; no human hang; no human banners |
| Debug | `DEBUG=1` (`--debug`) | Extra stderr diagnostics; suppressed under JSON |
| Force | `FORCE=1` / `FORCE_REINSTALL=1` (`--force`) | Skip confirms / force reinstall / allow policy-gated downgrade |
| Explicit interactive override | `INTERACTIVE=1` (optional env) | Rare override when low-level TTY checks are flaky (prompt_ask only) |

**Rules:**

1. Prompt, color, and hang-sensitive decisions **MUST** respect these globals and/or the shared `prompt_*` helpers—not ad-hoc `read` scattered in domain logic.  
2. After global flags are parsed in `app_main`, subsequent code **MUST** see the updated `QUIET` / `JSON` / `FORCE` / `DEBUG` values.  
3. Do **not** invent a second parallel mode system in individual commands.  
4. Direct `[ -t … ]` checks **inside** `prompt_*` and carefully documented install helpers are allowed as part of the mode SSOT implementation; command business logic **SHOULD** call `prompt_*` instead of re-implementing prompt guards.

```text
flags + TTY / environment
           │
           ▼
  Global mode SSOT (QUIET / JSON / DEBUG / FORCE / TTY)
           │
     ┌─────┴─────┐
     ▼           ▼
interactive   non-interactive
(human UX)    (no hang, safe defaults)
```

### 2.3 Behavioral differences (portable)

#### 2.3.1 Interactive mode (TTY, not quiet/json)

| Allowed / expected | Notes |
|--------------------|--------|
| Colored / prefixed human output | Via `out_*` when TTY and not quiet/json |
| Helpful messages and about diagnostics | Full human surface |
| Confirmation prompts for destructive actions | Via `prompt_yes_no` unless `--force` |
| Onboarding / install prompt when not installed | When product supports it |
| Value prompts with defaults | Via `prompt_ask` |

#### 2.3.2 Non-interactive mode (automation)

| Required | Forbidden |
|----------|-----------|
| **Never wait** for user input | Bare `read` without mode guards |
| **Safe automatic defaults** documented per command | Assuming someone will type “yes” |
| Suppress or skip prompts under quiet/json | Hanging on confirm in CI |
| Support `--json` purity (output requirement) | Mix human text into JSON stdout |
| Non-zero exit on critical failure | Silent hang that looks like a stuck job |
| Work under `curl \| sh`, Docker, CI | Requiring a full TTY for core ensure ops that claim automation support |

#### 2.3.3 Flag interactions

| Flag / state | Interactive impact |
|--------------|--------------------|
| `--json` | Force quiet-style human suppression; no prompts; structured stdout; errors on stderr |
| `--quiet` | No prompts via `prompt_*`; reduced chatter; errors (and warnings per output requirement) still surface |
| `--force` | Skip uninstall confirm; allow reinstall/downgrade policy paths |
| `--debug` | stderr diagnostics; never block; suppressed under JSON |
| Non-TTY stdin/stdout | Treat as non-interactive for prompts |

### 2.4 Prompt SSOT (portable)

| Helper | Role |
|--------|------|
| `prompt_yes_no` | **Only** yes/no confirmation path for destructive/optional confirms |
| `prompt_ask` | **Only** simple value prompt path with default |
| `out_msg_n` | Prompt fragment without newline (human only) |

**Rules:**

1. Never implement user-visible confirms with raw `printf` + `read` outside `prompt_*`.  
2. Under `JSON=1` or `QUIET=1`, prompts **MUST NOT** block: return default / no / cancel per documented policy.  
3. Without TTY (unless `INTERACTIVE=1` where designed), prompts **MUST NOT** block.  
4. Destructive non-interactive actions that would have required confirm **MUST** either:  
   - require `--force` (fail closed without it), or  
   - document an explicit safe auto-proceed policy (e.g. zero-arg install under pipe).

### 2.5 Implementation Notes (this project)

| Item | Value for timer |
|------|------------------------|
| **Product / binary** | `timer` |
| **Implementation** | Repo root `./timer` |
| **Mode globals** | `TTY`, `QUIET`, `JSON`, `DEBUG`, `FORCE`, `FORCE_REINSTALL` |
| **TTY init** | `[ -t 0 ] && [ -t 1 ] && TTY=1` near config block |
| **Flag parse SSOT** | `app_main` |
| **Prompt SSOT** | `prompt_yes_no`, `prompt_ask` |
| **Output SSOT** | `out_*` (`requirement-shell-output-requirements.md`) |
| **No Node Config singleton** | Shell globals + helpers are the mode SSOT for this project |

#### Command-level interactive matrix (normative)

| Command / path | Interactive (TTY, not quiet/json) | Non-interactive / quiet / json |
|----------------|-----------------------------------|--------------------------------|
| Zero-arg, **not** installed (**Type O**) | `inst_maybe_install`: show note + `prompt_yes_no` install confirm | Auto path: quiet/json zero-arg → `inst_perform_install` without prompt; non-TTY human path → auto-install message + install |
| Zero-arg, **already** installed local or global (**Type O**) | `inst_perform_install` success no-op (“already installed”); **not** help; no re-download without force | Same (quiet/json: structured success no-op) |
| `install` | Install with human `out_*` messages | No prompt; honor force for reinstall; JSON structured results |
| `self-uninstall` | `prompt_yes_no` unless `--force` | Without force: fail closed with explicit “requires --force” (JSON: `out_json_error` / `confirm_required`); never pretend user cancelled; with `--force`: remove without confirm |
| `self-update` / `version-check` | Human status messages | No prompts; fail loud if `SCRIPT_URL` missing; JSON structured results |
| `about` / `version` / `help` | Human diagnostics / help | Quiet: suppress human; JSON: structured object only |
| Colors | When `TTY=1` and not quiet/json | No color under quiet/json |

#### `prompt_yes_no` contract (this project)

| Condition | Behavior |
|-----------|----------|
| `JSON=1` or `QUIET=1` | Return **1** (no / cancel)—never `read` |
| Not a TTY on stdin or stdout | Return **1** (no)—never `read` |
| TTY + interactive | Prompt via `out_msg_n`; yes → 0, else → 1 |
| Uninstall without force + non-TTY | Confirm fails → uninstall cancelled (safe default) |
| Uninstall with `--force` | Skip confirm entirely |

#### `prompt_ask` contract (this project)

| Condition | Behavior |
|-----------|----------|
| `JSON=1` or `QUIET=1` | Return **default** without `read` |
| Not a TTY (and `INTERACTIVE` ≠ 1) | Return **default** without `read` |
| TTY interactive | Show current/default via `out_*`, then `read` |

#### `inst_maybe_install` contract (this project)

| Condition | Behavior |
|-----------|----------|
| Already installed (force off) | No-op success |
| Quiet or JSON | No prompt; return without installing from this helper (zero-arg quiet/json uses `inst_perform_install` in `app_main` instead) |
| TTY interactive | Prompt install yes/no |
| Non-TTY (pipe / automation) | **Auto-install** with clear human message when not quiet/json |

This dual policy is intentional: **pipe install proceeds**; **destructive uninstall does not** without `--force`.

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Never hang automation; destructive ops fail closed without force.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Explicit matrices for install vs uninstall vs flags.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Works under `curl | sh`, CI, and human TTY.  
- **CIAO Principle 16 – Interactive vs non-interactive awareness** (https://github.com/cloudgen/ciao): First-class mode policy.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Protected `prompt_*` helpers; no raw read regressions.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Prefer cancel over destructive auto-action when intent is ambiguous; prefer auto-install for classic one-liner when not installed.  
- **Intentional:** Mode globals + `prompt_*` ownership is documented and stable.  
- **Anti-fragile:** Non-TTY and quiet/json paths always terminate without stdin.  
- **Over-protect:** Do not “simplify” prompt guards or replace `prompt_yes_no` with ad-hoc `read`.  
- **Pair with output SSOT:** Prompts use `out_msg_n` / `out_*`; JSON never shows prompts.  
- **Pair with CLI interface:** Flag meanings stay aligned with `requirement-shell-cli-interface.md`.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Add `read` or confirmation prompts outside `prompt_ask` / `prompt_yes_no` without updating this requirement.  
2. Allow prompts to run under `--json` or `--quiet`.  
3. Hang on prompts when stdin/stdout are not TTYs (except explicit `INTERACTIVE=1` for `prompt_ask` only).  
4. Break the invariant that `--json` forces quiet-style non-interactive human suppression.  
5. Auto-delete / uninstall without confirm **or** `--force` in interactive design—and must not auto-uninstall in non-interactive without `--force`.  
6. Remove the zero-arg non-TTY auto-install path for classic `curl | sh` without an explicit requirement change.  
7. Bypass `out_*` for prompt text (raw `echo`/`printf` user messages).  
8. Scatter ad-hoc TTY/mode logic that contradicts the global flag SSOT and `prompt_*` contracts.  
9. Hardcode project-specific secrets or release URLs into prompt strings.

**Supporting non-interactive environments cleanly is mandatory for CIAO compliance.**

---

## 5. Definition of done (shell interactive vs non-interactive)

Mode-related work for timer is **not done** if any of the following fail:

1. No code path blocks on `read` under `--json`, `--quiet`, or non-TTY (except documented `INTERACTIVE=1` value prompt).  
2. Destructive uninstall without `--force` does not silently proceed in non-interactive mode.  
3. Zero-arg install-ensure supports automation (`curl | sh` / quiet/json): not-installed installs; already-installed (local or global) success no-op without help (`requirement-shell-cli-zero-arguments.md`).  
4. All confirms go through `prompt_yes_no`.  
5. Colors only when TTY and not quiet/json.  
6. JSON/human contracts remain aligned with `requirement-shell-output-requirements.md`.  
7. Changes cite `requirement-shell-interactive-vs-noninteractive`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-interface.md` | Flags and commands |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv install-ensure matrix |
| `docs/requirements/requirement-shell-output-requirements.md` | quiet/json/debug output contracts |
| `docs/requirements/requirement-shell-self-management.md` | Uninstall confirm / force policy |
| `docs/requirements/requirement-shell-idempotency.md` | Re-run safety under automation |
| `docs/requirements/index.md` | Registry SSOT |
| `./timer` | Implementation under test |

---

## Design-time verification

**Requirement-ID:** `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE`  
**Specialized from:** `LM-INTERACTIVE-VS-NONINTERACTIVE`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-07** quiet mode | `tests/test_cli.sh` | have |
| **TP-CLI-11** uninstall refuse (no hang / confirm_required) | `tests/test_cli.sh` | have |
| **TP-LC-07** lifecycle uninstall refuse | `tests/test_install_lifecycle.sh` | have |
| **TP-CURL-02** non-TTY first pipe | `tests/test_online_curl_install.sh` | have |
| **TP-CURL-03** non-TTY second pipe | `tests/test_online_curl_install.sh` | have |


**Last Updated**: 2026-07-14
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO Principles 1, 2, 3, 4, 16, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
