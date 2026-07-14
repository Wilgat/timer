# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
