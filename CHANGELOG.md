# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [2.13.0] - 2026-09-07

### Added

- **Numbered start list** on a real terminal: empty argv and overlay `--debug` (no command) open the same menu as `timer menu` / `main`. Domain rows **start** … **reset**, then **Exit 9**. Header is **timer**(*version*) with gray italic explains.
- Suite **TP-CLI-16** (do-not-capture-read), **TP-CLI-17** (menu look), **TP-CLI-07** TTY empty argv / TTY `--json`, **TP-CLI-29** overlay flags-only.

### Changed

- Empty argv is **no command token after flag parse**. Off-TTY empty argv stays Type O install-ensure (`curl | sh`). `--json` with no command is empty argv **special case**: JSON help on a TTY and off-TTY (not the list, not install-ensure).
- Ship-unit `VERSION` and README Version badge → **2.13.0**.
- Active law **`RQ-SHELL-CLI-DEFAULT-INTERACTION`**; zero-arg REQ **1.2.0**.

## [2.12.1] - 2026-09-07

### Fixed

- **Termux volatile storage:** `timer start` no longer dies with `No writable temporary storage available (/dev/shm, /tmp)` when Android `/tmp` is missing or read-only. Domain records use `$PREFIX/tmp` (then cache). Empty resolve no longer writes `/timer_<user>_<name>` on the read-only root.
- Shell scratch resolve (`util_resolve_storage`) prefers Termux `$PREFIX/tmp` after `/dev/shm` and before Linux `/tmp`.

### Changed

- Ship-unit `VERSION` and README Version badge → **2.12.1**.
- Suite **TP-TX-08** (Termux `$PREFIX/tmp` when `VOLATILE_DIR` is unusable).

## [2.12.0] - 2026-09-06

### Added

- **Termux** as a named target system: detect via `PREFIX` / `TERMUX_VERSION` / Termux usr tree; user-only install (`$PREFIX/bin` when present); `about` reports `termux` / `user_bin` / `prefix`; never recommend `sudo curl | sh` on detect.
- Active coding-style law **`RQ-SHELL-SCRIPT-CODING`** (`requirement-shell-script-coding.md`) so portable shell lessons have a specialize-in home.
- Suite **TP-TX-01..05** (Termux off/on detect, no sudo one-liner, `$PREFIX/bin` dest, `pkg` not invoked).
- **§1.1 Human-facing** and **Under command line for normal user only** on every live requirement (closes HK-REQ-01 / HK-REQ-02).
- Prior unreleased housekeeping (H2 harness pull, mold alignment) is included in this cut.

### Changed

- Ship-unit `VERSION` and README Version badge → **2.12.0**.
- Product README: people-first description; Termux install notes; platform table; system-wide `sudo` labeled Linux/macOS only.
- Class residual names Termux as a runtime target; actor/role **considered — no dest approver**; dest fences **considered — none**.
- Registry inventory: **13** Active REQs.

### Fixed

- README human readability: lead with what a person does; Termux missing from Platform Compatibility.
- Help on Termux names this-login dest instead of root→global.

## [2.11.0] - 2026-08-11

### Added

- Re-specialized ship unit from bootstrap origin **selfmanaged 1.2.1** (A→B only): inherit wired shell storage resolve (`util_resolve_storage` + `EFFECTIVE_STORAGE_DIR` / `TMPDIR` + about fields).
- Active product law **`RQ-SHELL-CLI-STORAGE`** / `requirement-shell-cli-storage.md` (shell scratch; domain timer files remain under **`RQ-DOMAIN-TIMER`**).
- Suite **TP-CLI-05** now asserts shell about storage fields, isolation, and `STORAGE_DIR` override (ported from selfmanaged storage proof).

### Changed

- Ship-unit `VERSION` and README Version badge → **2.11.0**.
- Registry inventory: **11** Active REQs (class + domain + 9 shell including storage).
- Companion digest `timer.sha256` regenerated for the rebuilt ship unit.

### Fixed

- Dead / unwired `util_resolve_storage` inheritance from older A: resolver now creates tier root fail-closed and is called from `app_main` / `app_about` (architecture parity with selfmanaged 1.2.x).

## [2.10.1] - 2026-07-19

### Fixed

- Domain JSON **status** / **stop** elapsed fields (`minutes`, `seconds`, `elapsed`) and list **`count`** are JSON **numbers** (aligned with nested `timers[]` members), not quoted strings.
- Product-law class gate: Active `requirement-class-software-dev.md` registered for software-development residual stack.

### Changed

- Bump project target version and ship-unit `VERSION` to **2.10.1** (README Version badge SSOT + binary parity).
- Refresh in-repo companion digest `timer.sha256` for the automatic integrity path.
- Domain / output requirements document numeric JSON field contract; domain suite covers type checks.

## [2.10.0] - 2026-07-16

### Changed

- Bump project target version and ship-unit `VERSION` to **2.10.0** (README Version badge SSOT + binary parity).
- Refresh in-repo companion digest `timer.sha256` for the automatic integrity path.

## [2.9.0] - 2026-07-14

### Added

- Product-root documentation set: complete `README.md`, `CHANGELOG.md`, `SECURITY.md`, and `LICENSE.md` (MIT; author-email SSOT on the Copyright line).
- Security policy with vulnerability reporting contact, CIAO design principles, and honest install-integrity trust bounds.
- Automatic companion-checksum transparency on install/self-update: human mode surfaces companion **link**, expected **value**, and verification **result** (match / mismatch / missing).
- In-repo companion digest `timer.sha256` for the `${SCRIPT_URL}.sha256` automatic integrity path.

### Changed

- Product README restructured to the fixed user-facing section order (Features → Quick Installation → Usage → Examples → Platform Compatibility → Related Projects → Contributing → License → Last Update).
- Quick Installation documents Config channel SSOT as simple literal one-liners (user and elevated), with automatic SHA-256 companion integrity as the primary story.
- Optional `CHECKSUM` env pin documented as Advanced / CI only (not listed in `help` / `about`).

### Fixed

- Align public install/docs language with live Config defaults (`SCRIPT_URL`, `REPO_USER` / `REPO_NAME`) and with automatic-checksum product law (warn+continue on missing sidecar; abort on mismatch).

### Security

- Document same-channel SHA-256 as **byte consistency**, not independent authenticity or signing.
- Maintainer contact for private vulnerability reports taken from `LICENSE.md` author-email SSOT only (no invented contact).
