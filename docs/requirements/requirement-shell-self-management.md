**file**: docs/requirements/requirement-shell-self-management.md  
**Status**: Active (Version 1.0.2 – CIAO v2.10.2 Principles 5/9/10/11/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **CLI self-management** of the timer POSIX shell tool: inspecting, upgrading, and removing its own installed binary (and related install artifacts) safely—especially for tools installed via one-command online install (`curl | sh`)—without requiring a separate package-manager workflow for routine updates.

It defines lifecycle capabilities and safety rules for this shell project’s self-management commands.

**Scope:** Lifecycle capabilities and safety rules for `version-check`, `self-update`, `self-uninstall`, and `about` (plus reuse of install primitives).  
**Out of scope (cited, not re-owned):** Full CLI dispatcher catalog (`requirement-shell-cli-interface.md`); pure re-run matrix (`requirement-shell-idempotency.md`); full online-install algorithm depth; Type 1 host bootstrap / Type 2 system-user app ops.

**Must not confuse with:** OS package managers, domain product start/stop ops, dedicated system-user policy, or non-CLI “self-management.”

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Command surface (self-management)

User-facing names **MUST** be stable unless this requirement is explicitly revised:

| Command | Purpose | Typical flags |
|---------|---------|----------------|
| `version-check` | Compare **local** version with **remote/latest** | `--quiet`, `--json` |
| `self-update` | Update the installed CLI to a newer trusted release | `--force` (reinstall / allow policy-gated non-default paths) |
| `self-uninstall` | Remove the managed CLI binary and clean PATH **only when safe** | `--force` (skip interactive confirm when designed) |
| `about` | Diagnostics and version / install context | `--quiet`, `--json` |

Shell implementation **SHOULD** use `inst_*` helpers for install/lifecycle and `app_*` for help/about/dispatch; **MUST NOT** bury binary lifecycle under domain product prefixes without a specialized requirement.

Related Type 0 commands (`version`, `install`, `help`) are owned by `requirement-shell-cli-interface.md` but **MUST** stay consistent with this lifecycle model.

### 2.2 Self-update (normative)

| Requirement | Meaning |
|-------------|---------|
| Trusted source | Fetch only from the configured official channel (project Config / env — not ad hoc URLs in random helpers) |
| Semver compare | Prefer upgrade when remote is **newer**; **MUST NOT** downgrade without explicit force policy |
| Integrity | Checksum or digest verification before replace when downloading update artifacts |
| Atomic install | Download to temp → verify → atomic move/replace of the installed binary |
| Install type preserved | Per-user vs global/system-wide placement remains consistent with invoker privilege / install policy |
| Reuse install SSOT | Self-update **MUST** reuse the same install orchestrator primitives as first-time install (no second ad hoc download/replace path) |
| Output SSOT | All messages via centralized `out_*` |

### 2.3 Version check (normative)

| Requirement | Meaning |
|-------------|---------|
| Dual report | Human mode shows local and remote/latest |
| Semver | Same comparison helper family as update (e.g. pure POSIX `ver_gt`) |
| Fail loud | Unset/unreachable channel **MUST NOT** be reported as “already latest” |
| Machine mode | `--json` emits structured result via output SSOT |

### 2.4 Self-uninstall (normative)

| Requirement | Meaning |
|-------------|---------|
| Locate binary | Resolve path from install type / Config (`GLOBAL_BIN` / `USER_BIN` / privilege), not scattered absolute path literals in business logic |
| Remove binary | Delete only the managed CLI file(s) this tool owns |
| PATH cleanup | Edit shell config PATH entries **only if** the managed bin directory is empty after removal (or equivalent safe policy) |
| Confirmation | Interactive confirm unless `--force` / non-interactive policy applies |
| Non-interactive / JSON without force | **Fail closed** with explicit confirm-required outcome (JSON: `out_json_error` / `confirm_required`) — **MUST NOT** emit success JSON that pretends the user cancelled (see interactive-vs-noninteractive requirement) |
| No over-delete | **MUST NOT** wipe unrelated user data or arbitrary home trees |
| Idempotent absence | Already uninstalled → success no-op (see `requirement-shell-idempotency.md`) |

### 2.5 About / diagnostics (normative)

| Requirement | Meaning |
|-------------|---------|
| Context | Version, install presence/paths, execution user, shell/TTY hints as designed |
| Modes | Respect `--quiet` / `--json` |
| Guidance | When not installed, may show recommended install one-liner using configured channel patterns (no secrets) |

### 2.6 Privilege model (default for self-management)

| Type | Self-management default |
|------|-------------------------|
| **Type 0 (invoker)** | **Yes** — `version-check`, `about`, `self-update`, `self-uninstall` for invoker-owned CLI install |
| **Type 1 / Type 2** | **Not required** for base CLI self-management; do not invent a system-user requirement solely for binary lifecycle |

Root may write global install path; non-root uses user path. Do not assume root for every self-management command.

### 2.7 Sacred safety rules

| Rule | Detail |
|------|--------|
| **No silent downgrade** | Without explicit force policy, refuse remote older than local |
| **No skip integrity** | Digest/checksum path required for downloaded update artifacts — automatic companion is default; strict pin secondary. Full automatic transparency law: `requirement-shell-automatic-checksum.md` |
| **No weak atomicity** | Avoid partial replaces that leave a broken binary |
| **No reckless PATH edit** | Only clean PATH when managed bin dir is empty / policy-safe |
| **No raw I/O** | Use output SSOT; quiet/json channel rules |
| **No secrets in tree** | Never embed tokens or credentials in update URLs in docs/code; Config/env only |
| **Idempotent where sensible** | Already-latest update and already-removed uninstall must not corrupt state |

### 2.8 Implementation Notes (this project)

| Item | Value for timer |
|------|------------------------|
| **Product / binary** | `timer` (`APP_NAME`) |
| **Implementation file** | Repo root `./timer` |
| **Dispatcher** | `app_main` routes `version-check` → `ver_check`; `self-update` → `inst_self_update`; `self-uninstall` → `inst_self_uninstall`; `about` → `app_about` |
| **Install orchestrator SSOT** | `inst_perform_install` (+ prepare / download with or without checksum / atomic install) |
| **Version compare** | `ver_gt` (pure POSIX); local version via `inst_get_version` |
| **Install presence** | `inst_is_installed` |
| **Paths** | `GLOBAL_BIN` default `/usr/local/bin`; `USER_BIN` default `${HOME}/.local/bin` |
| **Repository identity** | `REPO_USER` default `Wilgat`; `REPO_NAME` default `timer` |
| **Release channel** | `SCRIPT_URL` Config default composed as `https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/main/${APP_NAME}` (this project: `https://raw.githubusercontent.com/Wilgat/timer/main/timer` — product channel SSOT; override `SCRIPT_URL` or `REPO_*` via env if needed) |
| **Strict digest pin** | Runtime `CHECKSUM` when set in process env → `inst_perform_install_download_with_checksum` (secondary install-path only; **not** shown in `help`/`about`; see automatic-checksum requirement) |
| **Companion digest** | Default `${SCRIPT_URL}.sha256` via `inst_perform_install_download_without_checksum` — law + transparency: `requirement-shell-automatic-checksum.md` |
| **Force reinstall** | `FORCE_REINSTALL`; CLI `--force` required by CLI interface requirement |
| **Uninstall steps** | `inst_self_uninstall_determine_bin` → `inst_self_uninstall_confirm_and_remove` → `inst_self_uninstall_cleanup_path` |
| **PATH ensure** | `path_add_shell` / bash / zsh / fish helpers on user install |
| **Privilege** | Type 0 only for self-management surface; no dedicated system user |
| **Version SSOT** | `VERSION` in script config block (product SSOT; currently `VERSION="2.10.0"`) |

#### Normative acceptance behaviors (this project)

1. **`version-check`:** Fetch remote `VERSION` from `SCRIPT_URL`; report local vs remote; JSON fields include local/remote and latest-status semantics; fail if channel missing/unreachable.  
2. **`self-update`:**  
   - Fail if remote version cannot be fetched.  
   - If local equals remote and force off → success no-op (“already latest”).  
   - If remote is **older** than local and force off → **refuse** (no silent downgrade).  
   - If remote is newer (or force policy allows reinstall) → set reinstall and call `inst_perform_install` with integrity + atomic replace.  
3. **`self-uninstall`:** Resolve binary; confirm when interactive and force off; without force under quiet/json/non-TTY → fail closed (`confirm_required`), never fake cancel success; with force → remove without confirm; clean PATH only if `~/.local/bin` empty (non-root); never delete unrelated trees.  
4. **`about`:** Human diagnostics + JSON about object; no secrets; **no `CHECKSUM` name/value**.  
5. **Shared install path:** Self-update **must not** introduce a parallel curl-to-final-path overwrite outside `inst_perform_install*`.

#### Compliance notes (implementation status)

| Item | Status |
|------|--------|
| Downgrade gate via `ver_gt` (refuse unless `--force`) | **Implemented** in `inst_self_update` (2026-07-12) |
| CLI `--force` → `FORCE` / `FORCE_REINSTALL` | **Implemented** in `app_main` |
| `SCRIPT_URL` default channel URL | **This project:** non-empty product default composed from `REPO_USER` / `REPO_NAME` / `APP_NAME` (`https://raw.githubusercontent.com/Wilgat/timer/main/timer`); product README must show simple literal one-liner(s) from that SSOT; env may still override |

### 2.9 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Block silent downgrade and unsafe uninstall; verify downloads.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Separate version-check, self-update, self-uninstall, and about.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Per-user and global installs; temp + atomic replace survive partial failure.  
- **CIAO Principle 5 / 14 – Output & traceability** (https://github.com/cloudgen/ciao): Central `out_*`; JSON/human modes.  
- **CIAO Principle 9 – Three Types of Commands** (https://github.com/cloudgen/ciao): Lifecycle commands are Type 0 (invoker) for this product surface.
- **CIAO Principle 10 – Least privilege** (https://github.com/cloudgen/ciao): Type 0 invoker default for CLI lifecycle.  
- **CIAO Principle 11 – Safe temp files** (https://github.com/cloudgen/ciao): `mktemp`, cleanup on error.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Digest, atomicity, PATH empty-dir check are sacred.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Never trust network bytes without verification path; never silent downgrade.  
- **Intentional:** One orchestrator for install and update; clear command separation.  
- **Anti-fragile:** Works for root global and user local; idempotent no-ops when already good.  
- **Over-protect:** Do not simplify away checksum layers, atomic move, or safe PATH cleanup.  
- **SSOT:** Channel via `SCRIPT_URL`/Config; install via `inst_perform_install*`; output via `out_*`.  
- **Idempotency:** Align with `requirement-shell-idempotency.md` for already-latest / already-uninstalled.  
- **Respect old working logic:** Preserve Protection Zones on install and self-management helpers.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove or weaken checksum/digest verification on self-update downloads.  
2. Bypass semantic version comparison to allow silent downgrades without force.  
3. Replace atomic install with in-place curl overwrite of the live binary.  
4. Remove the empty-directory (or equivalent safe) PATH cleanup guard on uninstall.  
5. Over-delete user data or non-owned paths during uninstall.  
6. Change standard self-management command names without updating this requirement and help together.  
7. Use raw user-facing `echo`/`printf` instead of the centralized output system.  
8. Hard-code project secrets or private tokens into update URLs in the tree.  
9. Require a dedicated system user solely for Type 0 CLI self-update without a specialized architecture requirement.  
10. Invent a second update implementation path that bypasses `inst_perform_install*`.

**Self-management is critical for long-term maintainability of one-command shell CLIs. Violating this rule is a critical regression.**

---

## 5. Definition of done (shell self-management)

Work claiming self-management support for timer is **not done** if any of the following fail:

1. User-facing lifecycle commands exist and are routed (`version-check`, `self-update`, `self-uninstall`, `about`).  
2. Update path verifies integrity (pinned and/or companion digest policy) and uses atomic replace via install SSOT.  
3. Downgrade is blocked without explicit force policy.  
4. Uninstall does not over-delete and cleans PATH only when safe.  
5. Version-check reports local and remote (or fails loud if channel missing).  
6. All messages go through output SSOT; `--json` stays machine-oriented when claimed.  
7. Project channel/path facts live in Config/env / Implementation Notes—not scattered hardcodes.  
8. Idempotent already-latest / already-uninstalled behaviors hold.  
9. Implementation changes cite `requirement-shell-self-management`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-interface.md` | Command surface, flags, dispatcher |
| `docs/requirements/requirement-shell-idempotency.md` | Re-run safety for ensure ops |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | Uninstall confirm / non-interactive fail-closed |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Integrity on self-update downloads |
| `docs/requirements/requirement-shell-output-requirements.md` | Lifecycle messaging / quiet / JSON |
| `docs/requirements/requirement-shell-modular-function-design.md` | `inst_*` / `out_*` ownership |
| `docs/requirements/index.md` | Registry SSOT |
| `./timer` | Implementation under test |

---

**Last Updated**: 2026-07-14
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO Principles 1, 2, 3, 4, 5, 9, 10, 11, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
