# What to review — timer

**Living checklist** (review plan). Product: **timer** Type 0 CLI + named-timer domain.  
**Class:** Domain product — Active domain SSOT required and present.  
**Always load first:** `reviews/lessons.md`

**Last plan update:** 2026-07-16

---

## Pre-flight

| # | Check | Notes |
|---|--------|--------|
| P1 | Read `docs/requirements/index.md` (live law only) | 9 shell REQs including **domain** |
| P2 | Confirm domain SSOT present | `requirement-domain-timer.md` Active |
| P3 | Confirm ship unit `./timer` + companion `./timer.sha256` | Digest match via tests |
| P4 | Load `reviews/lessons.md` and re-check every open L-* | Mandatory |
| P5 | Run `./tests/run.sh` for baseline | Record PASS/FAIL in report |
| P6 | Class still domain (domain surface + domain law) | Not bootstrap; not genesis |

---

## Product law surfaces

| Surface | Path | Review focus |
|---------|------|--------------|
| CLI interface | `requirement-shell-cli-interface.md` | Commands, flags, dispatch; domain rows + Type 0 |
| Domain product law | `requirement-domain-timer.md` | Subcommands, storage, help/about domain, JSON codes |
| Zero-arg Type O | `requirement-shell-cli-zero-arguments.md` | Empty argv = install-ensure, not help |
| Self-management | `requirement-shell-self-management.md` | version-check, self-update, self-uninstall, about |
| Output SSOT | `requirement-shell-output-requirements.md` | `out_*`; JSON errors on stderr |
| Modular design | `requirement-shell-modular-function-design.md` | Prefixes; `timer_*` vs `app_*`/`inst_*` |
| Idempotency | `requirement-shell-idempotency.md` | Re-run ensure safety |
| Interactive modes | `requirement-shell-interactive-vs-noninteractive.md` | TTY vs pipe / quiet / json |
| Automatic checksum | `requirement-shell-automatic-checksum.md` | Companion primary; CHECKSUM not help/about |

---

## High-risk paths (ship unit)

| Path / symbol | Risk | Prior IDs |
|--------------|------|-----------|
| `app_main "$@"` entry (end of file) | Basename gate under pipe | L-BOOT-01 |
| Empty argv branch | Help instead of install-ensure | L-TYPEO-01 |
| Domain dispatch `start\|stop\|status\|list\|kill\|reset` | Orphan vs law; wrong storage mode | L-DOM-01 |
| `timer_sanitize_name` | Path injection / unsafe names | L-DOM-02 |
| `timer_list` JSON `timers` field | Machine contract (array vs string) | L-JSON-01 |
| `timer_start` already-running | Silent overwrite | L-DOM-03 |
| Install / self-update integrity | Companion vs pin trust bounds | L-CSUM-01 |
| `self-uninstall` non-force | Fake JSON success cancel | L-UNIN-01 |
| `set -u` defaults (`HOME`, `IS_ROOT`, …) | nounset crashes | L-SETU-01 |
| Ship unit ALIGNMENT header | Missing domain REQ cite | L-CITE-01 |
| Identity extractors (`APP_NAME` / `VERSION`) | Grep/SSOT shape | L-ID-01 |

---

## Tests surface

| Check | Path |
|-------|------|
| Suite entry | `tests/run.sh` |
| CLI surface | `tests/test_cli.sh` |
| Install lifecycle | `tests/test_install_lifecycle.sh` |
| Domain suite | `tests/test_timer_domain.sh` |
| Helpers | `tests/helpers.sh` |
| TP registry | `reviews/test-plan.md` |

---

## Product user / integrity docs

| Check | Path |
|-------|------|
| README domain + install channel | `README.md` |
| SECURITY trust bounds | `SECURITY.md` |
| CHANGELOG when releasing fixes | `CHANGELOG.md` |
| Companion digest present | `timer.sha256` |

---

## Bootstrap origin (chain)

| Check | Path / note |
|-------|-------------|
| Origin A | Sibling `…/prjs/selfmanaged` (`./selfmanaged`) |
| Latest origin report | `reviews/reports/2026-07-16-bootstrap-origin-selfmanaged-from-timer.md` |
| A open inherited | SM-STOR-01 dead util; SM-ID-01; terminologies cite — fix on **A**, never reverse-copy B |
| Direction | **A → B only** |

## Explicit non-goals for default full review

- Reverse-copy domain into bootstrap parent (selfmanaged) as “shared cleanup”  
- Treating harness skills/templates as product behavioral authority  
- Claiming ISO/OWASP certification from templates alone  
- Wiping domain law to look like genesis while domain surface remains  

---

## Publish steps (after a run)

1. Write `reviews/reports/YYYY-MM-DD-<scope>.md`  
2. Update `reviews/index.md`  
3. Merge new failure modes into `reviews/lessons.md`  
4. Add/update TP rows in `reviews/test-plan.md`  
5. Adjust this file if a permanent surface appeared  
