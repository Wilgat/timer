**file**: docs/requirements/requirement-domain-timer.md  
**Status**: Active (Version 1.0.0 – CIAO v2.10.2 domain product law SSOT)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth for domain product law** of the timer POSIX shell CLI: **named-timer operations beyond Type 0 self-management**.

It owns the **four domain pillars**:

1. **Specialized CLI subcommands** (verbs, operands, flags, dispatch routing, error codes)  
2. **Specialized features** (semantics, identifiers, storage modes, machine contracts, non-goals)  
3. **Specialized project help items** (what `help` must list for domain)  
4. **Specialized project about items** (what `about` must expose for domain guidance)

**Scope:** Domain command surface, timer identity/storage rules, human/JSON domain contracts, help/about domain rows.  
**Out of scope (peer requirements own):** Install / self-update / uninstall / empty-argv install-ensure; full `out_*` catalog; modular prefix system shape; companion-digest integrity; Type 1 host bootstrap / Type 2 system-user app ops.

**Must not confuse with:** Type 0 lifecycle commands (`install`, `version`, `about`, `version-check`, `self-update`, `self-uninstall`, `help`); OS package managers; multi-user daemon services.

**Registry role:** This is the **one Active domain-requirements SSOT** for timer. Parallel Active domain-law files are forbidden; supersede this file before activating a replacement.

**Naming law:** Domain SSOT files use `requirement-domain-<subject>.md` where `<subject>` is the domain knowledge noun. This product’s subject is **`timer`** → `requirement-domain-timer.md` (not `requirement-shell-domain*`). Agents creating a **new** domain requirement for another product **MUST confirm** `<subject>` before writing the file.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialized CLI subcommands (normative catalog)

Domain verbs **MUST** be stable unless this requirement is explicitly revised. Dispatch **MUST** run through the single CLI entry (`app_main`); handlers **MUST** live under the domain function prefix (`timer_*`), not under `inst_*` / lifecycle-only helpers.

| Command | Privilege | Handler family | Operands / flags | Required behavior | Typical non-zero outcomes |
|---------|-----------|----------------|------------------|-------------------|---------------------------|
| `start` | Type 0 (invoker) | `timer_start` | optional `[name]`; global `--persist` | Create running timer record with start epoch; default name `default` when omitted | already running → fail; invalid name → fail; I/O create fail → fail |
| `stop` | Type 0 | `timer_stop` | optional `[name]` | Remove running timer; report elapsed since start | no timer → fail |
| `status` | Type 0 | `timer_status` | optional `[name]` | Report elapsed **without** stopping | no timer → fail |
| `list` | Type 0 | `timer_list` | optional `--persist` (mode scope) | List running timers in the selected storage mode | empty list → success (not an error) |
| `kill` | Type 0 | `timer_kill_or_reset kill` | optional `[name]` | Discard running timer **without** elapsed success report | no timer → fail |
| `reset` | Type 0 | `timer_kill_or_reset reset` | optional `[name]` | Discard running timer with reset/discard success messaging | no timer → fail |

**Dispatch rules:**

1. Domain commands **MUST** be recognized in the same global flag parse pass as Type 0 lifecycle commands.  
2. Free token after a domain command **MUST** be treated as timer **name** (not a second command).  
3. Unknown tokens after flags **MUST** fail loudly with pointer to `help` (CLI interface ownership of unknown-command path).  
4. Domain handlers **MUST** call `timer_sanitize_name` (or equivalent single name-gate) before file I/O.  
5. Domain handlers **MUST** resolve storage path via the storage SSOT helpers (`timer_resolve_base_dir` / `timer_get_file` or successors with the same contracts).  
6. All user-facing domain messages **MUST** go through centralized `out_*` (`requirement-shell-output-requirements.md`).

### 2.2 Specialized features (normative)

#### 2.2.1 Timer identity

| Rule | Meaning |
|------|---------|
| Default name | When name omitted or empty after sanitize, use **`default`** |
| Path-safe names | Names **MUST** reject path traversal and shell/path metacharacters (including `/`, `\\`, `..`, spaces, quotes, glob metas, `$`, backticks, pipe, redirect, colon, etc.) |
| Invalid name exit | **MUST** exit non-zero; JSON mode **MUST** use error code **`invalid_name`** |
| Multi-timer | Distinct valid names **MUST** be independent concurrent timers (same storage mode) |

#### 2.2.2 Storage modes

| Mode | Trigger | Preferred location | Fallback |
|------|---------|--------------------|----------|
| **Volatile** (default) | No `--persist` | Writable `/dev/shm` (or configured `VOLATILE_DIR`) | Writable `/tmp` (warn when not quiet/json) |
| **Persistent** | `--persist` | `${XDG_CACHE_HOME:-$HOME/.cache}/${APP_NAME}` (or configured `PERSISTENT_DIR`) | Documented writable fallback under `/tmp` when home unusable; fail loud if no writable location |

**File record contract:**

1. One file per (user, name, mode family) under the resolved base directory.  
2. Filename pattern **MUST** include app identity and invoker username plus timer name (implementation: `${APP_NAME}_${USERNAME}_${name}` under base dir).  
3. File body **MUST** store start time as Unix epoch seconds suitable for elapsed arithmetic.  
4. Timers are **per-user** (invoker identity) — no shared multi-tenant daemon required.  
5. Domain **MUST NOT** require root or a dedicated system user.

#### 2.2.3 Command semantics

| Command | Success semantics | Failure / edge semantics |
|---------|-------------------|--------------------------|
| `start` | Creates file with current epoch; reports started (+ persistent note when applicable) | If file already exists → **already running** fail (exit 1); do not overwrite silently |
| `stop` | Reads epoch, deletes file, reports elapsed (minutes/seconds and total seconds) | Missing file → **no_timer** |
| `status` | Reads epoch, reports elapsed; **keeps** file | Missing file → **no_timer** |
| `list` | Enumerates valid timer files in mode; empty → success message / empty JSON list | Corrupt unreadable file **MAY** be skipped/removed without failing the whole list |
| `kill` | Deletes file; discarded messaging (warn-class human allowed) | Missing file → **no_timer** |
| `reset` | Deletes file; reset success messaging | Missing file → **no_timer** |

#### 2.2.4 Machine / mode contracts

| Mode | Domain contract |
|------|-----------------|
| Human | Prefixed/plain messages via `out_*`; elapsed in minutes + seconds where designed |
| `--json` | Structured objects via `out_json` / `out_json_error`; **no** mixed human success banners on stdout |
| Quiet | Suppress non-error human noise; errors still visible |
| JSON error codes (stable) | At least: `invalid_name`, `no_timer`; I/O failures use explicit domain/io error path (e.g. `io_error`) |

JSON success-ish domain types (when JSON mode):

| Situation | `type` (or equivalent) | Required fields (minimum) |
|-----------|------------------------|---------------------------|
| start / stop / kill / reset success | `success` | `name` (and elapsed fields on stop) |
| status | `status` | `name`, elapsed fields (`minutes`, `seconds`, `elapsed`) |
| list | `list` | `mode`, `count`, `timers` (array; may be empty) |
| domain error | error object via `out_json_error` / domain fail helper | stable `code` |

#### 2.2.5 Non-goals (explicit)

Domain law **MUST NOT** claim:

1. Network time sync / NTP as a dependency.  
2. Multi-host shared timer state.  
3. Type 1 host package install or Type 2 system-user service control.  
4. Calendar scheduling / cron replacement.  
5. Secrets storage or encrypted timer payloads.  
6. Replacing Type 0 self-management with domain verbs.

### 2.3 Specialized project help items (normative)

`help` (human mode) **MUST** list domain content as a distinct **Timer commands** (or equivalent) section:

| Help row | Required |
|----------|----------|
| `start [--persist] [name]` | Yes — start named timer; default name `default` |
| `stop [name]` | Yes — stop and show elapsed |
| `status [name]` | Yes — elapsed without stopping |
| `list [--persist]` | Yes — list running timers (mode-aware) |
| `kill [name]` | Yes — discard without elapsed report |
| `reset [name]` | Yes — reset/discard running timer |
| Global `--persist` | Yes — persistent storage for timer ops |
| Type 0 self-management rows | Yes — retained; owned in detail by CLI + self-management peers |

JSON mode `help` **MUST NOT** dump long domain text (short structured note only — CLI interface contract).

### 2.4 Specialized project about items (normative)

`about` **MUST**:

| Item | Requirement |
|------|-------------|
| Type 0 diagnostics | Remain (install presence, paths, user, shell, TTY) — self-management ownership |
| Domain guidance | Include at least starter domain command hints: `start`, `stop`, `list` (and pointer to full `help`) |
| Domain storage dump | **Not required** as mandatory about fields (optional future); absence is allowed |
| CHECKSUM | **MUST NOT** list (automatic-checksum peer) |

### 2.5 Implementation Notes (this project)

| Item | Value for timer |
|------|-----------------|
| **Product / binary** | `timer` (`APP_NAME`) |
| **Ship unit** | Repo root `./timer` |
| **Domain prefix** | `timer_*` |
| **Live domain handlers** | `timer_resolve_base_dir`, `timer_get_file`, `timer_sanitize_name`, `timer_domain_fail`, `timer_start`, `timer_stop`, `timer_status`, `timer_kill_or_reset`, `timer_list` |
| **Dispatcher** | `app_main` routes `start\|stop\|status\|list\|kill\|reset` after sanitize + `TIMER_FILE` resolve |
| **Persist flag** | Global `--persist` → `TIMER_PERSIST=1` → storage mode `persistent` |
| **Default name** | `default` |
| **Volatile default root** | `VOLATILE_DIR` default `/dev/shm` (fallback `/tmp`) |
| **Persistent default root** | `PERSISTENT_DIR` default `${XDG_CACHE_HOME:-$HOME/.cache}/timer` |
| **File pattern** | `${base_dir}/${APP_NAME}_${USERNAME}_${name}` |
| **Proof suite** | `tests/test_timer_domain.sh` (start/stop/status/list, JSON, persist, kill/reset, invalid name, already-running, no_timer) |
| **User docs** | Root `README.md` Features / Usage for named timers |
| **Peer CLI surface** | Domain rows also appear in `requirement-shell-cli-interface.md` command table with **this file as domain behavior owner** |

#### Error code inventory (this project)

| Code | When |
|------|------|
| `invalid_name` | Forbidden characters / unsafe name |
| `no_timer` | stop/status/kill/reset on missing timer |
| `io_error` | Cannot create timer file on start (domain fail path) |

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Path-safe names; fail closed on missing timer and already-running start; no silent overwrite.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Six domain verbs + two storage modes are explicit product promise, not accidental extras.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Volatile fallback chain; empty list is success; works without root.  
- **CIAO Principle 5 – Single source of output** (https://github.com/cloudgen/ciao): Domain messages only via `out_*`.  
- **CIAO Principle 6 – Single point of entry** (https://github.com/cloudgen/ciao): Domain routes through `app_main`.  
- **CIAO Principle 9 – Three types of commands** (https://github.com/cloudgen/ciao): Domain remains Type 0 invoker ops, not Type 2 system-user service control.  
- **CIAO Principle 10 – Least privilege** (https://github.com/cloudgen/ciao): Per-user storage; no mandatory dedicated system user.  
- **CIAO Principle 11 – Temporary / storage discipline** (https://github.com/cloudgen/ciao): Explicit volatile vs persistent locations and fallbacks.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect** (https://github.com/cloudgen/ciao): Protection Rule blocks erasing domain law or merging domain into lifecycle-only docs.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Reject unsafe names; never clobber a running timer on `start`.  
- **Intentional:** Domain verbs and storage modes are product identity for timer.  
- **Anti-fragile:** Fallbacks for volatile storage; empty list is not an error.  
- **Over-protect:** Keep domain law in this SSOT; do not hide domain only in README or tests.  
- **SSOT:** This file owns domain behavior; CLI interface lists routing; output REQ owns channels; modular REQ owns prefix placement.  
- **Simplicity but Safety:** Named file timestamps — not a scheduler platform.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove domain commands (`start` / `stop` / `status` / `list` / `kill` / `reset`) from the product without an explicit superseding requirement.  
2. Treat domain as “out of scope” in the CLI interface while leaving domain handlers in `./timer`.  
3. Put domain business logic under `inst_*` or bury lifecycle install under `timer_*` without an explicit redesign.  
4. Allow path-unsafe timer names (path separators, `..`, shell metas) as valid identifiers.  
5. Silently overwrite an already-running timer on `start`.  
6. Report missing timer on stop/status/kill/reset as success.  
7. Require root or a dedicated system user solely for named-timer domain ops.  
8. Drop `--persist` / dual storage modes without an explicit requirement change.  
9. Emit domain success paths with raw `echo`/`printf` outside `out_*`.  
10. Cite `template-*` or `skill-*` as product-source behavioral authority, or invent a second Active domain-requirements file without superseding this one.  
11. Empty or delete this domain SSOT to “look like genesis” while domain surface remains in the ship unit.

**Violating this rule is a critical domain-product or stay-honest regression.**

---

## 5. Definition of done (domain)

This requirement is satisfied for timer when all of the following hold:

1. All six domain commands in §2.1 are routed and implemented with §2.2 semantics.  
2. Name sanitization and storage modes match §2.2.  
3. Human and JSON contracts match §2.2.4.  
4. `help` lists §2.3 domain rows; `about` includes §2.4 domain guidance.  
5. `tests/test_timer_domain.sh` (or successor suite) covers start/stop/status/list, JSON, persist, kill/reset, invalid name, already-running, no_timer.  
6. Registry `docs/requirements/index.md` lists this file as Active domain SSOT.  
7. CLI interface peer lists domain commands and points behavior ownership here.  
8. Protection Rule items are not violated in code or product law.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-cli-interface.md` | Dispatcher, global flags, full command table routing |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` / JSON channel SSOT |
| `docs/requirements/requirement-shell-modular-function-design.md` | `timer_*` prefix ownership |
| `docs/requirements/requirement-shell-self-management.md` | Type 0 lifecycle (not domain verbs) |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | Mode / non-hang contracts |
| `./timer` | Implementation under test |
| `tests/test_timer_domain.sh` | Domain proof suite |
| Root `README.md` | User-facing domain usage |

---

**Last Updated**: 2026-07-16  
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO Principles 1, 2, 3, 4, 5, 6, 9, 10, 11, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
