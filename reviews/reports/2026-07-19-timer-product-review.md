# Product review — timer (2026-07-19)

**Scope:** Full product (requirements class gate + ship unit domain JSON + precommit docs)  
**Ship unit:** `./timer` **2.10.1**  
**Baseline suite:** `./tests/run.sh` → **PASS=133 FAIL=0 SKIP=0**  
**Lessons loaded:** `reviews/lessons.md` (all prior L-* re-checked)  
**Verdict:** **Pass** (findings fixed in same pass)

---

## Pre-flight

| # | Result |
|---|--------|
| P1 registry | 10 Active rows after class REQ add (was 9) |
| P2 domain SSOT | `requirement-domain-timer` Active |
| P3 ship + digest | `timer` + `timer.sha256` match |
| P4 lessons | Loaded; L-CSUM-01 still Partial (wording vigilance only) |
| P5 suite | PASS=133 |
| P6 class | software-development + domain product |

---

## Findings

| ID | Severity | Surface | Finding | Resolution |
|----|----------|---------|---------|------------|
| T-CLASS-01 | **bug** (law gate) | `docs/requirements/` | Software-development workspace lacked Active `requirement-class-software-dev.md` (class gate fail) | **Fixed** — created class REQ + registry row |
| T-JSON-02 | **bug** (machine contract) | `./timer` domain JSON | `status`/`stop` emitted `minutes`/`seconds`/`elapsed` as **strings**; list `count` as string — inconsistent with nested `timers[]` numbers | **Fixed** — `@minutes`/`@seconds`/`@elapsed`/`@count` raw JSON numbers; domain + output REQs updated; suite asserts types |
| T-MOD-01 | **nit** | modular design REQ | Core table still said domain prefix “none required until domain ops exist” while domain is live | **Fixed** — wording points to Implementation Notes |

---

## Lessons re-check (prior L-*)

| L-ID | Result |
|------|--------|
| L-BOOT-01 | Closed — `app_main "$@"` at end |
| L-TYPEO-01 | Closed — suite |
| L-UNIN-01 | Closed — suite |
| L-SETU-01 | Closed — suite |
| L-CSUM-01 | Partial — suite OK; wording vigilance only |
| L-CITE-01 | Closed — ALIGNMENT lists domain REQ |
| L-JSON-01 | Closed — timers nested array |
| L-DOM-01..03 | Closed — suite |
| L-ID-01 | Closed — `APP_NAME="timer"` hard-assign |

**New lesson:** L-JSON-02 — domain elapsed/count must stay JSON numbers (see TP-JSON-02).

---

## Precommit / docs (this pass)

| Gate | Status |
|------|--------|
| README identity + install + Last Update | 2.10.1 aligned |
| CHANGELOG [2.10.1] | Present |
| SECURITY supported versions | 2.10.1 current |
| Companion digest | Regenerated; matches ship unit |
| Requirements git-surface | No harness path dumps |
| Reviews surface | This report + index/lessons/test-plan updates |

---

## Test-plan deltas

| TP-ID | Status | Notes |
|-------|--------|-------|
| TP-JSON-02 | **have** | status/stop elapsed + list count are JSON numbers (`test_timer_domain.sh`) |
| TP-CLASS-01 | **have** (static) | Active class REQ registered |

---

## Bootstrap direction

No reverse-copy. Origin A (`selfmanaged`) not modified. Domain remains on B only.
