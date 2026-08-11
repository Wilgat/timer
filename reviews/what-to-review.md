# What to review — timer

**Living checklist** (review plan). Product: **timer** Type 0 CLI + named-timer domain.  
**Class:** software-development + **domain product** — Active class + domain SSOT required and present.  
**Ship unit:** `./timer` · **VERSION=2.11.0**  
**Always load first:** `reviews/lessons.md`

**Last plan update:** 2026-08-11 (revise after re-specialize + mold alignment; baseline PASS=195)

---

## Pre-flight

| # | Check | Notes |
|---|--------|--------|
| P1 | Read `docs/requirements/index.md` (live law only) | **12** Active: class + domain + shell (incl. storage + temp) |
| P2 | Confirm domain SSOT present | **RQ-DOMAIN-TIMER** · `requirement-domain-timer.md` · **LM-NAMED-TIMER-DOMAIN** |
| P2b | Confirm class law present | **RQ-CLASS-SOFTWARE-DEV** Active |
| P2c | Named-timer mandatory peers | CLI · shell storage · temp · output — all Active |
| P3 | Confirm ship unit `./timer` + companion `./timer.sha256` | Digest match via **TP-CLI-01** / suite |
| P4 | Load `reviews/lessons.md` and re-check every open L-* | Mandatory |
| P5 | Run `./tests/run.sh` for baseline | Record PASS/FAIL/SKIP in report |
| P6 | Class still software-dev + domain | Not genesis; not bootstrap-only |
| P7 | Maps honest | `test-plan.md` + `requirement-test-matrix.md` match suite + REQs |
| P8 | Type 1 elevation claimed? | If **no** → N/A TTY/sudo plan gate; if **yes** → **CL-SHELL-TTY-PRIVILEGE-TRAPS** |

---

## Product law surfaces

| Surface | Requirement-ID | Review focus |
|---------|----------------|--------------|
| Class residual stack | **RQ-CLASS-SOFTWARE-DEV** | posix-sh Type 0 residual; no brand hardcode in core |
| CLI interface | **RQ-SHELL-CLI-INTERFACE** | Commands, flags, dispatch; domain rows + Type 0 |
| Domain product law | **RQ-DOMAIN-TIMER** | Subcommands, domain records, help/about domain, JSON codes |
| Zero-arg Type O | **RQ-SHELL-CLI-ZERO-ARGUMENTS** | Empty argv = install-ensure, not help |
| Shell CLI storage | **RQ-SHELL-CLI-STORAGE** | `util_resolve_storage` wire; about `effective_storage` / `storage_dir` |
| Temp file system | **RQ-SHELL-TEMP-FILE-SYSTEM** | `mktemp` leaves; `TMPDIR` inheritance; not domain records |
| Self-management | **RQ-SHELL-SELF-MANAGEMENT** | version-check, self-update, self-uninstall, about |
| Output SSOT | **RQ-SHELL-OUTPUT-REQUIREMENTS** | `out_*`; JSON errors on stderr; `@key` raw |
| Modular design | **RQ-SHELL-MODULAR-FUNCTION-DESIGN** | Prefixes; `timer_*` vs `app_*`/`inst_*` |
| Idempotency | **RQ-SHELL-IDEMPOTENCY** | Re-run ensure safety |
| Interactive modes | **RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE** | TTY vs pipe / quiet / json |
| Automatic checksum | **RQ-SHELL-AUTOMATIC-CHECKSUM** | Companion primary; CHECKSUM not help/about |

---

## High-risk paths (ship unit)

| Path / symbol | Risk | Prior IDs / TP |
|--------------|------|----------------|
| `app_main "$@"` entry (end of file) | Basename gate under pipe | L-BOOT-01 · Type O suite |
| Empty argv branch | Help instead of install-ensure | L-TYPEO-01 · TP-LC-01 · TP-CLI-09 |
| Storage resolve early in `app_main` | Dead util / no TMPDIR wire | L-STOR-01 · **TP-CLI-05** |
| Domain dispatch `start\|stop\|status\|list\|kill\|reset` | Orphan vs law; wrong storage mode | L-DOM-01 · TP-TIMER-* |
| `timer_sanitize_name` | Path injection / unsafe names | L-DOM-02 · TP-TIMER-07 |
| `timer_list` JSON `timers` field | Array vs escaped string | L-JSON-01 · TP-TIMER-04 |
| Domain JSON elapsed / `count` types | Numbers not quoted strings | L-JSON-02 · TP-TIMER-04 |
| Class requirement present | software-dev class gate | L-CLASS-01 · TP-CLASS-01 |
| `timer_start` already-running | Silent overwrite | L-DOM-03 · TP-TIMER-03 |
| Install / self-update integrity | Companion vs pin trust bounds | L-CSUM-01 · TP-CSUM-* |
| Install `mktemp` staging | Predictable temp paths / wrong root | L-TEMP-01 · TP-LC-06/12 |
| `self-uninstall` non-force | Fake JSON success cancel | L-UNIN-01 · TP-CLI-11 |
| `set -u` defaults (`HOME`, `IS_ROOT`, …) | nounset crashes | L-SETU-01 · TP-U-* |
| Ship unit ALIGNMENT header | Missing live REQ cites (domain/storage/temp) | L-CITE-01 · TP-CITE-01 |
| Identity extractors (`APP_NAME` / `VERSION`) | Grep/SSOT shape | L-ID-01 · TP-ID-01 |
| Mold peer set incomplete | Domain law without storage/temp/CLI/output | L-MOLD-01 · TP-MOLD-01 |

---

## Tests surface

| Check | Path |
|-------|------|
| Suite entry | `tests/run.sh` |
| CLI surface | `tests/test_cli.sh` |
| Install lifecycle | `tests/test_install_lifecycle.sh` |
| Online curl (local channel) | `tests/test_online_curl_install.sh` |
| Domain suite | `tests/test_timer_domain.sh` |
| Helpers | `tests/helpers.sh` |
| TP registry | `reviews/test-plan.md` |
| RQ↔TP matrix | `reviews/requirement-test-matrix.md` |

---

## Product user / integrity docs

| Check | Path |
|-------|------|
| README domain + install channel | `README.md` (Version badge = ship unit) |
| SECURITY trust bounds | `SECURITY.md` (supported versions) |
| CHANGELOG when releasing fixes | `CHANGELOG.md` |
| Companion digest present | `timer.sha256` |

---

## Bootstrap origin (chain)

| Check | Path / note |
|-------|-------------|
| Origin A | Sibling `…/prjs/selfmanaged` and/or workspace `./selfmanaged` (gitignored bootstrap ref) |
| Latest specialize report | `reviews/reports/2026-08-11-bootstrap-specialize-selfmanaged-to-timer.md` |
| Latest mold coverage report | `reviews/reports/2026-08-11-requirement-mold-coverage-review.md` |
| Origin-from-B report (historical) | `reviews/reports/2026-07-16-bootstrap-origin-selfmanaged-from-timer.md` |
| Direction | **A → B only** — never reverse-copy domain onto A |
| Inherited storage on B | B now wires storage (**RQ-SHELL-CLI-STORAGE**); origin A issues stay on A |

## Explicit non-goals for default full review

- Reverse-copy domain into bootstrap parent (selfmanaged) as “shared cleanup”  
- Treating harness skills/templates as product behavioral authority  
- Claiming ISO/OWASP certification from templates alone  
- Wiping domain law to look like genesis while domain surface remains  
- Collapsing shell scratch (**TP-CLI-05**) into domain dual-storage (**TP-STORAGE-***) or the reverse  
- Type 1 elevation suite work when product does not claim Type 1  

---

## Publish steps (after a run)

1. Write `reviews/reports/YYYY-MM-DD-<scope>.md`  
2. Update `reviews/index.md`  
3. Merge new failure modes into `reviews/lessons.md`  
4. Add/update TP rows in `reviews/test-plan.md` + RTM  
5. Adjust this file if a permanent surface appeared  
