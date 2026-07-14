**file**: docs/requirements/requirement-shell-cli-zero-arguments.md  
**Status**: Active (Version 1.1.1 – CIAO v2.10.2 principle map)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **zero-argument (empty argv) dispatcher behavior** of the selfmanaged POSIX `/bin/sh` Type 0 CLI.

### 1.0 Product type (template dual-model)

| Field | Value for selfmanaged |
|-------|------------------------|
| **Empty-argv type** | **Type O — Online-install** (not Type N) |
| **Rationale** | Product advertises `curl … \| sh` one-liner install; empty argv is install-ensure, not help |

Type N (non-online-install → empty argv = help) does **not** apply to this product.

It defines what happens when the tool is invoked with **no command and no flags**, including the classic one-liner:

```sh
curl -fsSL https://raw.githubusercontent.com/cloudgen/selfmanaged/main/selfmanaged | /bin/sh
```

Empty argv means **install-ensure** for three detect cases:

| Case | Meaning |
|------|---------|
| **Not installed** | No managed binary at the resolved install path(s) |
| **Installed (local)** | Managed binary at the user path (`USER_BIN` / `${HOME}/.local/bin/selfmanaged`) |
| **Installed (global)** | Managed binary at the global path (`GLOBAL_BIN` / `/usr/local/bin/selfmanaged`) |

**Scope:** Empty-argv routing, detect cases (global / local / absent), messages, force boundary, exit status, interaction with TTY / quiet / json.  
**Out of scope (own requirements):** Full command catalog (`requirement-shell-cli-interface.md`); download/checksum detail (`requirement-shell-automatic-checksum.md`); full self-update/uninstall lifecycle (`requirement-shell-self-management.md`); output function catalog (`requirement-shell-output-requirements.md`); general idempotency matrix beyond empty-argv rows (`requirement-shell-idempotency.md`).

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Definitions (portable + project)

| Term | Definition for selfmanaged |
|------|----------------------------|
| **Type O** | Online-install empty-argv product type: empty argv = install-ensure (this product). |
| **Type N** | Non-online-install empty-argv type: empty argv = help — **out of scope** for selfmanaged. |
| **Empty argv / zero-arg** | `$# -eq 0` at entry to `app_main` (no command tokens; classic `curl \| sh` with no trailing args). |
| **Install-ensure** | Converge to “managed `selfmanaged` binary present”; either perform install or success no-op. |
| **Not installed** | `inst_is_installed` returns false (`inst_get_version` → `not installed`). |
| **Installed (local)** | Executable at `${USER_BIN}/selfmanaged` (default `USER_BIN=${HOME}/.local/bin`) observed by install-detect SSOT. |
| **Installed (global)** | Executable at `${GLOBAL_BIN}/selfmanaged` (default `GLOBAL_BIN=/usr/local/bin`) observed by install-detect SSOT. |
| **Force / reinstall** | `FORCE_REINSTALL=1` from `--force` (and related force wiring in `app_main`). Required only for deliberate replace, not for ensure. |

### 2.2 Single meaning of empty argv

1. When **argv is empty**, `app_main` **MUST** run **install-ensure** — **MUST NOT** route to `app_help` / default `COMMAND=help`.  
2. Explicit `selfmanaged help` remains the only full-usage path for help text.  
3. Bootstrap **MUST** always call `app_main "$@"` so pipe one-liners reach this contract (no `${0##*/}` product-name gate).  
4. Empty argv **MUST NOT** require the user to pass `install` or `install --force` merely because a previous ensure already succeeded.

### 2.3 Normative case matrix

| Case | Detect condition (project) | Empty argv, `FORCE_REINSTALL=0` | Empty argv / install with force |
|------|----------------------------|--------------------------------|---------------------------------|
| **A. Not installed** | `inst_is_installed` false | Install into privilege-correct path (§2.4) | Same first-time install |
| **B. Installed — local** | User binary present via detect SSOT | Success no-op: already installed; no re-download; **no help** | `inst_perform_install` re-download/replace (user path when non-root) |
| **C. Installed — global** | Global binary present via detect SSOT | Success no-op: already installed; no re-download; **no help** | Re-download/replace (global path when root / global binary policy) |

**Already-installed rules (Cases B and C, force off):**

1. Exit status **MUST** be `0`.  
2. Human mode **MUST** use `out_success` with an **already installed** message (via `inst_perform_install` no-op path).  
3. Human mode **MAY** add `out_info` tips that `--force` / `self-update` are for **deliberate** reinstall or upgrade — **MUST NOT** imply force is required for a normal one-liner re-run.  
4. JSON mode **MUST** use structured success (`out_json` success type) with already-installed message — **MUST NOT** emit help JSON.  
5. Detect **MUST** treat either global or local managed binary as installed when that is how `inst_is_installed` / `inst_get_version` resolve paths (project SSOT today prefers global when executable there, else user path).

### 2.4 Case A — not installed (modes)

| Mode | Required empty-argv behavior |
|------|------------------------------|
| **Interactive** (TTY stdin+stdout, not quiet/json) | `inst_maybe_install`: note + `prompt_yes_no`; yes → `inst_perform_install`; no → skip without help dump |
| **Non-interactive** (non-TTY / `curl \| sh`) | Auto-install message + `inst_perform_install` (via `inst_maybe_install` non-TTY branch) |
| **Quiet or JSON** | `inst_perform_install` directly (no prompt) |
| **Failure** (network, checksum, I/O) | Non-zero exit; no fake success; no help-only output |

**Placement privilege:**

| Invoker | Target |
|---------|--------|
| root (`id -u` 0), e.g. `curl … \| sudo sh` | `${GLOBAL_BIN}/selfmanaged` → `/usr/local/bin/selfmanaged` |
| non-root | `${USER_BIN}/selfmanaged` → `${HOME}/.local/bin/selfmanaged` |

### 2.5 Equivalence to explicit `install`

| Invocation | Contract |
|------------|----------|
| Empty argv | Same ensure semantics as `install` for Cases A/B/C |
| `install` | Explicit ensure; same detect / no-op / force |
| `install --force` | Deliberate reinstall |
| `help` | Usage only — **not** empty-argv default |

### 2.6 Forbidden empty-argv outcomes

1. Dump full help when Case B or C applies.  
2. Silent success when Case A should install (or when Case B/C should acknowledge already installed).  
3. Require `--force` solely because detect says installed.  
4. Blind re-download every empty-argv run without force.  
5. Basename-gate main so `curl \| sh` never hits the empty-argv branch.  
6. Detect only one of global/local incorrectly so a present local install is treated as Case A (or the reverse) contrary to `inst_*` SSOT.

### 2.7 Implementation Notes (this project)

| Item | Value for selfmanaged |
|------|------------------------|
| **Empty-argv type** | **Type O — Online-install** (install-ensure; not Type N help-default) |
| **Product / binary** | `selfmanaged` (`APP_NAME`) |
| **Ship unit** | Repo root `./selfmanaged` |
| **Dispatcher** | `app_main` — empty-argv block **before** flag/command parse default help |
| **Install ensure** | `inst_perform_install` (quiet/json and already-installed no-op) |
| **Friendly first install** | `inst_maybe_install` (TTY confirm / non-TTY auto) when not installed and not quiet/json |
| **Detect SSOT** | `inst_is_installed` ← `inst_get_version` |
| **Global path** | `GLOBAL_BIN` default `/usr/local/bin` |
| **Local path** | `USER_BIN` default `${HOME}/.local/bin` |
| **Force wiring** | `--force` → `FORCE=1` and `FORCE_REINSTALL=1` in `app_main` |
| **Output SSOT** | `out_success` / `out_info` / `out_json` / errors via `out_*` |
| **Channel** | `SCRIPT_URL` (compose from `REPO_USER` / `REPO_NAME` / `APP_NAME`) for download path inside install |
| **Tests** | `tests/test_cli.sh` (Case A failure when not installed); `tests/test_install_lifecycle.sh` (Case B local + Case C global already-installed → not help) |

#### Dispatcher algorithm (normative sketch)

```text
app_main:
  if [ $# -eq 0 ]; then
    if JSON or QUIET:
      inst_perform_install; exit $?
    elif inst_is_installed:
      inst_perform_install   # Case B/C success no-op
      exit $?
    else
      inst_maybe_install     # Case A
      exit $?
    fi
  fi
  # else parse flags/commands; default COMMAND=help only when argv non-empty and command is help/absent token rules
```

#### Message contract (already installed, human)

- Success: `${APP_NAME} is already installed.` (or equivalent via `out_success`)  
- Optional info: force / `self-update` only for deliberate reinstall or upgrade  
- **MUST NOT** print the full `app_help` usage body on this path

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): One-liner re-runs must not look like broken install or force unnecessary reinstall.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Empty argv has one meaning for not-installed, local, and global.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Dual install paths + `curl \| sh` + TTY.  
- **CIAO Principle 6 – Single Point of entry** (https://github.com/cloudgen/ciao): `app_main` owns empty-argv before help default.  
- **CIAO Principle 16 – Interactive vs non-interactive** (https://github.com/cloudgen/ciao): Case A auto under pipe; optional TTY confirm.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Protection Rule against help-fallback regression.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Real failures non-zero; healthy re-runs success with clear text.  
- **Intentional:** Help is never the empty-argv default for this install CLI.  
- **Anti-fragile:** Global and local detect; idempotent second one-liner.  
- **Over-protect:** Do not “simplify” empty-argv back to `COMMAND:=help` after first install.  
- **SSOT:** `inst_is_installed` / `inst_perform_install` / `inst_maybe_install` / `out_*`.  
- **Idempotent ensure:** Case B/C force off → already installed, exit 0.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Route empty argv to `app_help` when Case B or C applies (or when Case A should install).  
2. Require `--force` for a healthy already-installed empty-argv re-run (local or global).  
3. Handle only Case A and leave B/C as accidental help fallthrough.  
4. Break dual-path detect so local or global installs are misclassified.  
5. Blindly reinstall on every empty-argv run without `FORCE_REINSTALL`.  
6. Exit 0 with no install and no already-installed acknowledgment when detect says installed.  
7. Reintroduce a basename-only gate that skips `app_main` under `curl \| sh`.  
8. Bypass `out_*` for empty-argv user messages.  
9. Contradict this file in peer requirements by documenting “already installed → help” as normative empty-argv behavior.

**Violating this rule is a critical zero-arg / online-install regression.**

---

## 5. Definition of done

This requirement is satisfied when all of the following hold:

1. Empty argv + not installed → Case A install path (TTY may confirm; non-TTY / quiet / json auto).  
2. Empty argv + local install present + force off → already-installed success; not help; no re-download.  
3. Empty argv + global install present + force off → already-installed success; not help; no re-download.  
4. Empty argv + install failure → non-zero exit.  
5. `--force` only for deliberate reinstall; not required for ensure.  
6. `help` works when invoked explicitly.  
7. Tests cover Case A failure (not installed, bad channel) and already-installed not-help for local (Case B) and global (Case C).  
8. Changes cite `requirement-shell-cli-zero-arguments`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-interface.md` | Full command surface; empty-argv row must match this SSOT |
| `docs/requirements/requirement-shell-idempotency.md` | Ensure re-run / force boundary |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | TTY vs pipe for Case A |
| `docs/requirements/requirement-shell-self-management.md` | self-update / uninstall (not empty-argv default) |
| `docs/requirements/requirement-shell-output-requirements.md` | out_* / JSON purity |
| `docs/requirements/requirement-shell-automatic-checksum.md` | Integrity on install download path |
| Repo root `./selfmanaged` | Implementation (`app_main`, `inst_*`) |
| `tests/test_cli.sh`, `tests/test_install_lifecycle.sh` | Regression coverage |

---

## 7. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-07-14 | Initial Active v1.0.0: empty argv = install-ensure for not-installed / local / global; forbid help fallthrough | Grok (owner request) |
| 2026-07-14 | v1.1.0: Classify product as Type O (online-install) under dual-type empty-argv template model | Grok |
