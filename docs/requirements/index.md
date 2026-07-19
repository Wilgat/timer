# Requirements index

**Product:** timer (POSIX `/bin/sh` Type 0 CLI + named-timer domain)  
**Workspace state:** Specialized product law (not blank genesis); **software-development class** + **domain SSOT present**.  
**Class law:** `requirement-class-software-dev` (software-development; residual stack).  
**Domain SSOT:** `requirement-domain-timer` (subject `timer` — domain knowledge, not shell stack).  
**Updated:** 2026-07-19

| ID / key | Title | Area | Status | Path | Updated |
|----------|-------|------|--------|------|---------|
| requirement-class-software-dev | Software-development class law + residual stack (posix-sh Type 0) | class | Active | `requirement-class-software-dev.md` | 2026-07-19 |
| requirement-shell-automatic-checksum | Automatic companion-digest integrity (transparent link/value/result; CHECKSUM not help/about) | shell | Active | `requirement-shell-automatic-checksum.md` | 2026-07-14 |
| requirement-shell-cli-interface | Shell CLI interface (commands, flags, dispatch, modes) | shell | Active | `requirement-shell-cli-interface.md` | 2026-07-16 |
| requirement-shell-cli-zero-arguments | Empty argv Type O install-ensure (not installed / local / global) | shell | Active | `requirement-shell-cli-zero-arguments.md` | 2026-07-14 |
| requirement-domain-timer | Named-timer domain product law (subcommands, storage, help/about domain rows) | domain | Active | `requirement-domain-timer.md` | 2026-07-19 |
| requirement-shell-idempotency | Shell idempotency / re-run safety for ensure-style ops | shell | Active | `requirement-shell-idempotency.md` | 2026-07-14 |
| requirement-shell-interactive-vs-noninteractive | Interactive vs non-interactive / `curl\|sh` behavior | shell | Active | `requirement-shell-interactive-vs-noninteractive.md` | 2026-07-14 |
| requirement-shell-modular-function-design | Single-file modular function design (prefixes, zones) | shell | Active | `requirement-shell-modular-function-design.md` | 2026-07-16 |
| requirement-shell-output-requirements | Central `out_*` output SSOT (stdout/stderr, modes; `@key` raw nested/numeric JSON) | shell | Active | `requirement-shell-output-requirements.md` | 2026-07-19 |
| requirement-shell-self-management | Self-management lifecycle (version-check, update, uninstall, about) | shell | Active | `requirement-shell-self-management.md` | 2026-07-14 |

**Rules for agents:**

1. Treat rows above as the **live product-law inventory** for timer.  
2. **Do not invent** additional `requirement-*.md` paths — verify on disk and add a registry row in the same change when creating one.  
3. Product source comments cite **only** these live requirement files (or future registered ones) — never `template-*` / `skill-*` as behavioral authority.  
4. This versioned surface lists **requirement rows only** — do not dump templates / skills / terminologies / incidents path inventories here (git-surface; INC-20260712-005).  
5. Keep Status and Path in sync with each file’s header when status changes.  
6. **Registry discipline (summary only):** invent no paths; same-change file+row; empty registry valid at genesis; this file stays **requirement rows only** (no harness tree dumps).  
7. **Domain naming:** Domain SSOT basename is `requirement-domain-<subject>.md` only (this product: `requirement-domain-timer`). Confirm domain **subject** before creating a new domain requirement; Area `domain`; exactly one Active domain SSOT. Do not use `requirement-shell-domain*` for domain law.

When adding a requirement: append a row, create the file under `docs/requirements/`, keep Status in sync with the file header.
