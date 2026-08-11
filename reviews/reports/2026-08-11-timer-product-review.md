# Report: full product review — timer 2.11.0

**Date:** 2026-08-11  
**Mode:** Full product review (publish under `reviews/`)  
**Reviewer:** Multi-agent council  
**Product:** timer · `VERSION=2.11.0`  
**Ship unit:** `./timer` (+ `timer.sha256`)  
**Scope:** Type 0 self-management + named-timer domain + law/maps/docs honesty  
**Method:** Load lessons → walk `what-to-review.md` → disk inspect → suite + high-risk spot checks  
**Baseline:** `./tests/run.sh` → **PASS=195 FAIL=0 SKIP=1**  
**Status:** clean (no open bugs; residual nits fixed same day)

---

## Summary

Timer **2.11.0** is a healthy specialized Type 0 + domain CLI: registry and ship unit agree, shell storage and temp peers are wired, domain JSON/name/storage contracts hold under suite, install lifecycle and local curl channel are green, and bootstrap origin A is not polluted with domain DNA. Residual item remains documentation vigilance only (**L-CSUM-01** Partial). **Verdict: Pass.**

---

## Pre-flight

| # | Check | Result |
|---|--------|--------|
| P1 | Registry live law | **12** Active REQs; disk match |
| P2 | Domain SSOT | **RQ-DOMAIN-TIMER** · **LM-NAMED-TIMER-DOMAIN** Active |
| P2b | Class law | **RQ-CLASS-SOFTWARE-DEV** Active |
| P2c | Named-timer peers | CLI · storage · temp · output Active |
| P3 | Ship unit + companion | Digest match `bfc49df3…` = `sha256sum ./timer` |
| P4 | Lessons loaded | All closed except L-CSUM-01 Partial |
| P5 | Suite | PASS=195 FAIL=0 SKIP=1 (optional online) |
| P6 | Class | software-dev + domain (not genesis) |
| P7 | Maps | test-plan + RTM aligned to 2.11.0 / TP-CLI-05 have |
| P8 | Type 1 elevation | **Not claimed** → TTY/sudo plan gate **N/A** |

---

## Strengths

| Area | Notes |
|------|--------|
| Architecture inheritance | Same Type 0 stack as selfmanaged (`out_*` / `inst_*` / `app_*`); domain under `timer_*` |
| Type O empty argv | Always install-ensure; suite covers first/local/global/fail loud |
| Shell storage wire | `util_resolve_storage` + `EFFECTIVE_STORAGE_DIR` / `TMPDIR`; about JSON fields |
| Domain law + suite | Full verb catalog; path-safe names; numeric JSON; dual storage |
| Integrity | Shape A companion primary; CHECKSUM not on help/about; suite CSUM rows green |
| Identity / channel | `APP_NAME="timer"` hard-assign; README/Config `Wilgat/timer` consistent |
| Prefix discipline | Clean `out`/`inst`/`timer`/`util`/`app` modular surface |
| Bootstrap hygiene | A remains `APP_NAME=selfmanaged`, **0** `timer_start` on A |

---

## Lessons re-check

| L-ID | Status this review | Evidence |
|------|--------------------|----------|
| L-BOOT-01 | **Closed** | Final line `app_main "$@"`; comment forbids basename gate |
| L-TYPEO-01 | **Closed** | TP-LC-01 / TP-CLI-09 suite green |
| L-UNIN-01 | **Closed** | TP-CLI-11 / TP-LC-07 suite green |
| L-SETU-01 | **Closed** | TP-U-01 / env -u HOME suite green |
| L-CSUM-01 | **Closed** (follow-up fix same day) | Suite OK; SECURITY **Must not claim** + collapsed support table |
| L-CITE-01 | **Closed** | Header lists class, storage, temp, domain, shell peers |
| L-JSON-01 / L-JSON-02 | **Closed** | Spot check list `timers[]` + numeric fields; TP-TIMER-04 |
| L-CLASS-01 | **Closed** | Class REQ registered |
| L-DOM-01..03 | **Closed** | Domain SSOT + suite start/already-running/invalid_name |
| L-ID-01 | **Closed** | `APP_NAME="timer"` hard-assign |
| L-IDN-01 / L-COV-01 | **Closed** | RQ/TP maps + suite coverage |
| L-STOR-01 | **Closed** on B | About JSON + TP-CLI-05 |
| L-TEMP-01 | **Closed** | TMPDIR export + mktemp install paths (lifecycle) |
| L-MOLD-01 / L-MAP-01 | **Closed** | Peers Active; maps revised same day |

---

## High-risk path spot checks

| Path | Result |
|------|--------|
| Entry under pipe | `app_main "$@"` only — no basename gate |
| Storage resolve | Wired in `app_main` + `app_about`; about has `effective_storage` / `storage_dir` |
| Domain dispatch | start/status/list/stop smoke OK; help lists all six verbs + `--persist` |
| Sanitize | `bad/name` → `invalid_name` exit 1 |
| Already-running | Second start exit 1 with warn |
| JSON list | `"count":1,"timers":[{...}]` nested array + numbers |
| CHECKSUM UX | Not in `help` |
| Companion | Bare hex matches ship unit |
| A pollution | A has no domain; still selfmanaged 1.2.1 |

---

## Issues

### Open bugs

*None.*

### Issue 1 — Severity: nit (residual) — **L-CSUM-01**

- **Area:** Docs / integrity wording  
- **Status:** **fixed** (2026-08-11 follow-up)  
- **Location:** `SECURITY.md` § Install integrity and trust  
- **Description:** Historical residual: avoid overclaiming independent authenticity for same-channel SHA-256.  
- **Fix:** Added **Must not claim** bullets (authenticity, same-origin pin strength, missing-sidecar honesty); trust-bound row kept.  
- **Test:** TP-CSUM-* already green; no suite change required.  

### Issue 2 — Severity: nit

- **Area:** SECURITY supported-versions table  
- **Status:** **fixed** (2026-08-11 follow-up)  
- **Location:** `SECURITY.md` § Supported Versions  
- **Description:** Overlapping **2.10.x** and **2.10.0** rows.  
- **Fix:** Single **2.10.x** security-fixes row; older-than-2.10 best-effort.
---

## Non-findings (explicitly OK)

| Check | Result |
|-------|--------|
| Reverse-copy A←B | Not present |
| Domain without SSOT | Not present |
| Dead storage util on B | Not present |
| Type 1 claimed without TTY plan | N/A — Type 1 not claimed |
| Harness paths as product law | Ship cites live `requirement-*.md` only |
| README channel vs Config | Both `Wilgat/timer` raw main |
| Version package | Badge, SECURITY current, ship unit **2.11.0** |

---

## Architecture inheritance (A → B)

| Layer | Pass? |
|-------|-------|
| Output SSOT `out_*` | Yes |
| Lifecycle `inst_*` | Yes |
| Dispatcher `app_main` under pipe | Yes |
| Type O empty argv | Yes |
| Self-management surface | Yes |
| Automatic companion | Yes |
| Shell storage wire (from A 1.2.x) | Yes |
| Domain separate prefix | Yes (`timer_*`) |

---

## Test-plan lock-in

No new **todo** TP rows required. Baseline remains:

```text
PASS=195 FAIL=0 SKIP=1  RESULT: OK
```

Optional **TP-CURL-09** still gated (`RUN_ONLINE_CURL_TESTS=1`).

---

## Priority remediation order

1. None remaining — nits fixed same day.  

---

## Verdict

| Field | Value |
|-------|--------|
| **Verdict** | **Pass** (residuals closed) |
| **Open bugs** | 0 |
| **Open nits** | 0 |
| **Ship readiness** | Suitable for continued Type 0 + domain use at **2.11.0** |

---

## Related

| Artifact | Role |
|----------|------|
| `reviews/what-to-review.md` | Plan walked |
| `reviews/lessons.md` | L-* re-check |
| `reviews/test-plan.md` | TP lock-in |
| `reviews/requirement-test-matrix.md` | RQ↔TP |
| `reports/2026-08-11-bootstrap-specialize-selfmanaged-to-timer.md` | Specialize edge |
| `reports/2026-08-11-requirement-mold-coverage-review.md` | Law/mold align |
| `reports/2026-08-11-review-and-test-plan-revision.md` | Plan revision |

**Written by:** Multi-agent council (product review publisher)  
**Review status:** Closed — Pass
