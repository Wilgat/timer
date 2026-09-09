# Reviews index — timer

**Registry** of review plan artifacts and run reports. Keep rows in sync with disk.  
**Updated:** 2026-09-07  
**Product:** timer **2.14.1** · **15** Active REQs · PATH heal `$PREFIX/bin` · suite **PASS=289 FAIL=0 SKIP=1**

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
| 2026-09-06 | `reports/2026-09-06-readme-req-coverage-termux-review.md` | README readability + REQ/checklist/test coverage + Termux target | suite this cut | **Pass** with implemented fixes |
| 2026-08-19 | *(housekeeping — full cycle)* | H2 already current; REQ confirm-as-is; suite re-run | PASS=195 FAIL=0 SKIP=1 | **Pass** (source unchanged → no VCS) |
| 2026-08-19 | `reports/2026-08-19-h2-sync-from-genesis.md` | H2 from RAM genesis + dest-SSOT map rebind | HK N=287; ship+12 REQs intact | **Pass** |
| 2026-08-11 | `reports/2026-08-11-requirement-mold-full-fix.md` | Full fix all mold suggestions (P1+P2) on genesis + H2 to timer | 13 molds updated | **Pass** — all suggestion IDs closed |
| 2026-08-11 | `reports/2026-08-11-h2-sync-and-requirement-mold-review.md` | H2 from genesis + requirement mold suggestions | harness SAME; maps rebound | **Pass** H2; mold suggestions later fully fixed |
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
| HK-REQ-01 | P3 | **closed** | §1.1 Human-facing on all live REQs (2026-09-06) |
| HK-REQ-02 | P3 | **closed** | Class residual: considered — no dest approver / no dest fence (2026-09-06) |
| HK-REQ-03 | P3 | deferred | Interactive REQ still allows live `[ -t` inside `prompt_*` vs new no-retest-tty mold |

## Notes

- Product class: **software-development** + **domain product** (class REQ + domain SSOT + named-timer peers).  
- Latest full product review: **2026-08-11** → **Pass** (PASS=195).  
- Shell storage (**TP-CLI-05**) ≠ domain dual-storage (**TP-STORAGE-***).  
- Origin-A defects stay on A — never reverse-copy from B.  
