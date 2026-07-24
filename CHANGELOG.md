# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

- Aligned product Requirement-IDs (`RQ-*`) and suite TP-IDs with harness ID notation; each live requirement has Design-time verification.
- Expanded CI suite: TP-labeled CLI/lifecycle parity, local-channel TP-CURL suite, domain-subject **TP-TIMER-01..09** (not TP-DOM) (187 PASS / 0 FAIL / 1 SKIP optional online).
- Aligned each live requirement **Design-time verification** with law mold TP families (`LM-*` specialize provenance; domain → `TP-TIMER-01..09`); product RTM lists LM/PM + TP matrix.
- ID notation: domain product cases use **`TP-<SUBJECT>-*`** (e.g. **TP-TIMER-***); deprecate product **`TP-DOM-*`** (policy-harness-id-notation §5).
- Product maps: `reviews/test-plan.md`, `reviews/requirement-test-matrix.md`.
- Removed legacy flat `docs/templates/template-*.md` layout; law/proof molds under `templates/requirements/` and `templates/tests/` (H2 from genesis).

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
