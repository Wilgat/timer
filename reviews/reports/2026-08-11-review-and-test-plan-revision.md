# Report: review plan + test plan revision — timer 2.11.0

**Date:** 2026-08-11  
**Mode:** Plan revision (living `what-to-review` + `test-plan` + RTM + lessons/index)  
**Status:** clean (no new open bugs on B)  
**Baseline:** `./tests/run.sh` → **PASS=195 FAIL=0 SKIP=1**

---

## Summary

Revised the public **reviews/** plan surface so it matches post–re-specialize product truth: ship unit **2.11.0**, **12** Active REQs (including shell storage + temp), shell vs domain storage split, named-timer mold peers, and honest TP-CLI-05 **have**. Lessons table gained L-STOR / L-TEMP / L-MOLD / L-MAP closed modes. No ship-unit behavior change in this report.

---

## Scope revised

| Artifact | Change |
|----------|--------|
| `reviews/test-plan.md` | Full refresh: product metadata, proof-mold table, storage split, TP-CLI-05 evidence, temp ownership on TP-LC/CSUM, fixed TP-TIMER wording, TP-MOLD-01, Type 1 N/A |
| `reviews/what-to-review.md` | Full refresh: P2c peers, law table with all 12 REQs, high-risk storage/temp/mold paths, bootstrap reports list |
| `reviews/requirement-test-matrix.md` | PM column + peer matrix + storage ownership split + baseline |
| `reviews/lessons.md` | L-STOR-01, L-TEMP-01, L-MOLD-01, L-MAP-01; date |
| `reviews/index.md` | New report rows; 2.11.0 / 12 REQs / PASS=195 |
| `reviews/README.md` | Class + version + baseline |

---

## Issues

### Issue count

| Severity | Open | Closed this pass |
|----------|------|------------------|
| bug | 0 | 0 (map honesty was plan debt) |
| suggestion | 0 | plan/map nits revised |
| nit | 0 | — |

No new product bugs opened. Map debt closed via L-MAP-01.

---

## Lessons re-check (sample)

| L-ID | Result |
|------|--------|
| L-BOOT-01 | Closed — `app_main "$@"` still final entry |
| L-STOR-01 | Closed on B — TP-CLI-05 green |
| L-MOLD-01 | Closed — four peers Active |
| L-CSUM-01 | Partial — suite OK; SECURITY wording vigilance only |
| Origin A historical Block | Not re-opened on B; fix stays on A |

---

## Test-plan deltas

| TP | Before | After |
|----|--------|-------|
| TP-CLI-05 | historically n/a in maps | **have** (shell storage) |
| TP-MOLD-01 | missing | **have** (static peers) |
| TP-TIMER intro | contradictory “not portable TP-TIMER” wording | subject-family vs **TP-DOM-*** only |
| Storage split | easy to confuse with domain dual-storage | explicit shell vs domain tables |

---

## Non-findings

| Check | Result |
|-------|--------|
| Suite green | PASS=195 FAIL=0 SKIP=1 |
| Registry ↔ disk | 12/12 |
| Type 1 elevation | Not claimed → plan N/A |
| Reverse-copy | None |

---

## Verdict

**Pass** — living review plan and test plan revised and coherent with law + suite.

**Related:**  
`reports/2026-08-11-bootstrap-specialize-selfmanaged-to-timer.md` ·  
`reports/2026-08-11-requirement-mold-coverage-review.md`

**Written by:** Multi-agent council (product review publisher)  
**Review status:** Closed (plan revision)
