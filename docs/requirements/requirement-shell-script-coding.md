**file**: docs/requirements/requirement-shell-script-coding.md  
**Requirement-ID**: `RQ-SHELL-SCRIPT-CODING`  
**Status**: Active (Version 1.0.0 – coding-style specialize-in home; Termux target)  
**Area**: shell  
**Key**: `requirement-shell-script-coding`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This file is the **coding-style specialize-in home** for the timer POSIX `/bin/sh` ship unit. Without it, portable learned lessons arrive **raw** (agents treat coding skills as product law). New shell lessons that are not already owned by a peer requirement **MUST** land here.

**Intention:** Own-or-point. Do **not** copy full output, prefix, TTY, temp, checksum, or CLI tables that peers already own.

### 1.1 Human-facing

**In one sentence:** A person reading `./timer` can tell why a helper exists; new shell lessons for this product are written here, not only in a skill.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Run and read the program as yourself | `./timer help` |
| The other role | Maintainers who add helpers | Keep prefixes; do not invent a second output family |
| Not this file | Command list, install dest, timer start/stop | Peer requirements own those |

| Includes | Excludes |
|----------|----------|
| Prefixes already on disk (`out_` `inst_` `app_` `timer_` `util_` `path_` `ver_`) | A second `out_*` catalog |
| Protection Zones; surgical change; no in-tool `sudo` | Linux `apt` / Termux `pkg` wrapping (no package list) |
| Termux helpers stay this-login (`util_is_termux`) | Admin privilege or a dedicated system user |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./timer` | ship unit | live helpers |
| `timer help` | command | listed verbs |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Add a helper | Use an existing prefix; do not flatten names | edit `./timer` |
| Run on Termux | Helpers must not call `sudo` or `apt` | `timer about` |

## 2. Core Rules / Requirements (Mandatory)

1. **MUST** treat this file as the specialize-in home for POSIX `/bin/sh` coding lessons for **this** product.  
2. **MUST NOT** tell agents that a coding skill is product law.  
3. **MUST** keep live prefixes: `out_` (output), `inst_` (install/lifecycle), `app_` (dispatch/help/about), `timer_` (domain), `util_` (shared helpers), `path_` (PATH/rc), `ver_` (version compare).  
4. **MUST** preserve CIAO Protection Zones and “DO NOT MODIFY” helpers unless the user orders a redesign.  
5. **MUST NOT** wrap in-tool `sudo` or Linux `apt`/`dnf`/`yum`. This product has **no** sudo allow table.  
6. **MUST NOT** wrap Termux `pkg` (no named package list). Detect Termux; keep this-login dest.  
7. **MUST** point at peers instead of duplicating their bodies:

| Slice | Owner |
|-------|--------|
| Commands / flags / dispatch | `requirement-shell-cli-interface` |
| Empty argv | `requirement-shell-cli-zero-arguments` |
| Output `out_*` | `requirement-shell-output-requirements` |
| Scratch resolve | `requirement-shell-cli-storage` |
| Temp leaves | `requirement-shell-temp-file-system` |
| Self-update / about | `requirement-shell-self-management` |
| TTY / prompt | `requirement-shell-interactive-vs-noninteractive` |
| Prefix table (full) | `requirement-shell-modular-function-design` |
| Named timers | `requirement-domain-timer` |

### 2.1 Implementation Notes (this project)

| Item | Live value |
|------|------------|
| **Product / binary** | `timer` · `./timer` |
| **Language** | POSIX `/bin/sh` (dash/bash-as-sh) |
| **Termux helpers** | `util_is_termux` · `util_apply_termux_target` |
| **In-tool sudo** | none |
| **Termux pkg list** | none (not a Termux-first package companion) |
| **Tests** | `tests/test_cli.sh` (**TP-CLI-01**, **TP-TX-01..05**) |

## Under command line for normal user only

When the program runs on Termux, Git Bash, Windows cmd, or the same class, only **this login** may use it. Admin privilege and a dedicated system-user switch stay **unused**.

**This requirement:** coding of helpers. Termux detect helpers stay this-login. Do not add `sudo` wrappers or `pkg`/`apt` calls in new helpers.

| MUST | MUST NOT |
|------|----------|
| Detect Termux (`PREFIX` contains `com.termux`, `TERMUX_VERSION`, or Termux usr tree) | In-tool `sudo`; wrap `apt`/`dnf`; dedicated system user |
| Keep install dest as this login (`$PREFIX/bin` or `~/.local/bin`) | Recommend `sudo curl \| sh` on detect |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume Termux has no root dest.  
- **Intentional:** One specialize-in home so lessons do not arrive raw.  
- **Anti-fragile:** Prefixes and Protection Zones survive harsh shells.  
- **Over-protect:** Do not flatten helpers or add privilege paths “for convenience.”

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Delete this file while the workspace stays software-development.  
2. Treat coding skills as product law instead of this file plus peers.  
3. Add in-tool `sudo` or Linux package wrappers without a new requirement.  
4. Wrap Termux `pkg` without a named package table and an authorized companion requirement.  
5. Strip Protection Zones or flatten prefixes.  
6. Omit the section titled **Under command line for normal user only**.

## 5. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix table |
| `docs/requirements/requirement-shell-cli-interface.md` | Command surface |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `./timer` | Implementation |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-SCRIPT-CODING`  
**Specialized from:** `LM-SHELL-SCRIPT-CODING`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| Gate / TP | Suite or method | Status |
|-----------|-----------------|--------|
| **TP-CLI-01** syntax | `tests/test_cli.sh` | have |
| **TP-TX-01** off-Termux detect | `tests/test_cli.sh` | have |
| **TP-TX-02** Termux PREFIX detect | `tests/test_cli.sh` | have |
| **TP-TX-03** no `sudo curl` on Termux | `tests/test_cli.sh` | have |
| **TP-TX-04** `$PREFIX/bin` dest | `tests/test_cli.sh` | have |
| **TP-TX-05** `pkg` not invoked | `tests/test_cli.sh` | have |
| **TP-LC-16** named `pkg install` | n/a — no package list | n/a |

**Last Updated**: 2026-09-06  
**Owner**: timer maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
