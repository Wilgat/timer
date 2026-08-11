# Reviews index — timer

**Registry** of review plan artifacts and run reports. Keep rows in sync with disk.  
**Updated:** 2026-08-11  
**Product:** timer **2.11.0** · **12** Active REQs · suite baseline **PASS=195 FAIL=0 SKIP=1**

## Plan artifacts

| Artifact | Path | Role |
|----------|------|------|
| What to review | `what-to-review.md` | Living checklist (review plan) |
| Test plan | `test-plan.md` | TP-* → `tests/` lock-in |
| Requirement ↔ test matrix | `requirement-test-matrix.md` | RQ-* ↔ LM/PM ↔ TP families |
| Lessons | `lessons.md` | L-* re-check |
| README | `README.md` | Surface rules |

## Reports

| Date | File | Scope | Baseline | Verdict |
|------|------|-------|----------|---------|
| 2026-08-11 | `reports/2026-08-11-timer-product-review.md` | Full product review (Type 0 + domain + law/maps) | PASS=195 FAIL=0 SKIP=1 | **Pass** — residuals fixed (L-CSUM-01 closed) |
| 2026-08-11 | `reports/2026-08-11-review-and-test-plan-revision.md` | Revise living review plan + test plan/RTM after re-specialize + mold align | PASS=195 FAIL=0 SKIP=1 | **Pass** — maps honest; no new open bugs |
| 2026-08-11 | `reports/2026-08-11-requirement-mold-coverage-review.md` | REQ coverage + LM/PM alignment | PASS=195 FAIL=0 SKIP=1 | **Pass** (aligned) |
| 2026-08-11 | `reports/2026-08-11-bootstrap-specialize-selfmanaged-to-timer.md` | A→B re-specialize selfmanaged 1.2.1 → timer 2.11.0 | PASS=195 FAIL=0 SKIP=1 | **Pass** |
| 2026-08-11 | *(housekeeping — H2 + rebind)* | RAM genesis H2 harness pull + dest-SSOT map rebind | PASS=187 FAIL=0 SKIP=1 (then) | **Pass** (historical) |
| 2026-07-24 | *(housekeeping — suite/maps)* | H2 + TP coverage + RQ notation | PASS=187 FAIL=0 SKIP=1 | **Pass** (historical) |
| 2026-07-19 | `reports/2026-07-19-timer-product-review.md` | Class gate + domain JSON numbers + precommit | PASS=133 FAIL=0 | **Pass** — T-CLASS-01 / T-JSON-02 fixed |
| 2026-07-16 | `reports/2026-07-16-timer-product-review.md` | Full Type 0 + domain; plan bootstrap | PASS=129 FAIL=0 | **Revise** — findings opened |
| 2026-07-16 | `reports/2026-07-16-timer-findings-fix.md` | Close T-JSON/CITE/ID/DOC | PASS=130 FAIL=0 | **Pass** — all prior opens closed |
| 2026-07-16 | `reports/2026-07-16-bootstrap-origin-selfmanaged-from-timer.md` | Origin A=selfmanaged from this B report | A prior PASS=93 | **Block** on A (historical storage debt on A) |

## Open items summary

| ID | Severity | Status | One-line |
|----|----------|--------|----------|
| *(none)* | — | — | L-CSUM-01 closed; SECURITY version table + non-claim language fixed 2026-08-11 |

## Notes

- Product class: **software-development** + **domain product** (class REQ + domain SSOT + named-timer peers).  
- Latest full product review: **2026-08-11** → **Pass** (PASS=195).  
- Shell storage (**TP-CLI-05**) ≠ domain dual-storage (**TP-STORAGE-***).  
- Origin-A defects stay on A — never reverse-copy from B.  
