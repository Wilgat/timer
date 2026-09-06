# Report: README readability, requirement coverage, Termux target — timer 2.12.0

**Date:** 2026-09-06  
**Mode:** review + implement (user authorized fix, commit, push)  
**Status:** findings implemented  
**Product:** timer · `VERSION=2.12.0`  
**Ship unit:** `./timer`  
**Scope:** Human readability of README and requirements; coverage of requirements, checklists, tests; add target system Termux  
**Method:** disk read + suite run (**PASS=205 FAIL=0 SKIP=1**)  
**Lessons loaded:** `reviews/lessons.md` (incl. new **L-TX-01**)

## Summary

README led with slogan language and omitted Termux while Git Bash was listed. Live law had no **§1.1 Human-facing**, no **Under command line for normal user only** sections, no coding-style specialize-in file, and class residual did not record dest-approver/fence **none**. The ship unit recommended `sudo curl | sh` whenever `id -u` was 0 and always used `/usr/local/bin` as the global dest — unsafe on Termux.

Fixes landed in **2.12.0**: Termux detect + this-login dest, README people-first copy and platform row, 13th REQ (`RQ-SHELL-SCRIPT-CODING`), human-facing + named ceiling sections on all live REQs, **TP-TX-01..05**.

## Strengths

| Area | Notes |
|------|--------|
| Type 0 already | No in-tool sudo / dest approve to disable |
| Storage fallback | `/dev/shm` → `/tmp` already exists (Termux-friendly) |
| Suite isolation | Local channel; no public network for Core |
| Registry honesty | 12 files matched index before this cut |

## Findings (as reviewed, then fixed)

### TM-DOC-01 — Severity: P2 (medium)
- **Area:** README
- **Status:** fixed
- **Location:** `README.md` Description + Platform Compatibility
- **Description:** Description led with marketing/CIAO slogans; Termux missing; `sudo` system-wide one-liner looked universal.
- **Impact:** Phone users follow a root one-liner that does not apply.
- **Suggestion:** People-first lead; Termux subsection; label sudo as Linux/macOS root only.
- **Cross-ref:** `SK-WRITE-README` §4.2

### TM-REQ-01 — Severity: P2 (medium)
- **Area:** requirements
- **Status:** fixed
- **Location:** all `docs/requirements/requirement-*.md`
- **Description:** HK-REQ-01 — no §1.1 Human-facing; HK-REQ-02 — class residual silent on dest approver/fence none; no coding-style REQ.
- **Impact:** Coverage Fail against current review gates; people cannot read law.
- **Suggestion:** Add §1.1, named ceiling section, coding-style file, class residual rows.
- **Cross-ref:** HK-REQ-01/02; `SK-REQUIREMENT-REVIEW` checklist B

### TM-TX-01 — Severity: P1 (high)
- **Area:** ship unit
- **Status:** fixed
- **Location:** `inst_maybe_install` / `inst_perform_install` / `util_get_install_bin_path`
- **Description:** No Termux detect; sudo one-liner on uid 0; global `/usr/local/bin` even in Termux-like PREFIX.
- **Impact:** Wrong dest and dangerous recommend on the new target.
- **Suggestion:** `util_is_termux` + `util_apply_termux_target`; about fields; tests.
- **Cross-ref:** L-TX-01 · TP-TX-01..05

## Non-findings (explicitly OK)

| Check | Result |
|-------|--------|
| Help vs dispatcher | Domain + Type 0 verbs match |
| Automatic checksum README | Companion table still honest |
| Domain storage vs shell scratch | Split still holds |
| `pkg` companion | Honest n/a — no named package list |
| HK-REQ-03 no-retest-tty | Still deferred (not this cut) |

## Coverage verdict (C-full-product)

| Gate | Result |
|------|--------|
| Domain REQ present | ok `RQ-DOMAIN-TIMER` |
| CLI dual mention of dest | ok CLI + self-management |
| Coding-style REQ | ok `RQ-SHELL-SCRIPT-CODING` |
| Actor/role | considered — no dest approver |
| Dest fences | considered — none |
| Human-facing | ok on all 13 |
| Under command line section | ok on related shell REQs |
| Tests | TP-TX have after suite green |
| Checklists | filled `docs/checklists/2026-09-06-plan-and-requirements-termux-coverage.md` (local) |

**Verdict:** Sufficient with Gaps (HK-REQ-03 TTY measure still deferred).

## Priority remediation order

1. (done) Termux detect + no sudo recommend  
2. (done) README + REQ human-facing  
3. (done) TP-TX suite  
4. (open) HK-REQ-03 no-retest-tty mold vs live `prompt_*`

## Related

| Artifact | Role |
|----------|------|
| `README.md` | Product README |
| `docs/requirements/index.md` | 13 Active |
| `tests/test_cli.sh` | TP-TX |
| `reviews/test-plan.md` | TP map |

**Written by:** implement + review this turn  
**Review status:** Findings fixed except HK-REQ-03 deferred
