# Product reviews (timer)

**Purpose:** Public, git-tracked **product quality surface** for this specialized Type 0 + domain CLI — peer of `tests/`. Holds the living review plan, test-plan lock-in, prior-report lessons, and committed run reports.

**Not:** Product law (`docs/requirements/`). Not harness blank checklists. Not session `/tmp` scratch (promote durable outcomes here).

**Product class:** **software-development** + **domain product** (Active class + domain SSOT **`RQ-DOMAIN-TIMER`** · **`LM-NAMED-TIMER-DOMAIN`**).  
**Ship unit:** `./timer` · **VERSION=2.11.0**  
**Tests:** `./tests/run.sh` (baseline **PASS=195 FAIL=0 SKIP=1** as of 2026-08-11)

## Layout

```text
reviews/
  README.md              # this file
  index.md               # registry of plans + reports + open items
  what-to-review.md      # living checklist (review plan)
  test-plan.md           # TP-* → tests/
  requirement-test-matrix.md  # RQ-* ↔ TP families
  lessons.md             # L-* failure modes from prior reports
  reports/
    YYYY-MM-DD-<scope>.md
```

## Agent rules

1. Every durable product review **loads** `lessons.md` first.  
2. Walk applicable sections of `what-to-review.md`.  
3. Map open **bugs** to `test-plan.md` rows (have / TODO / n/a).  
4. Publish under `reports/` + update `index.md` in the same change.  
5. No secrets. No harness path tree dumps as navigation.  
6. Review-only by default — do not change ship unit unless implement is authorized.  
7. Prefer root `reviews/` (this tree).

## Related

| Artifact | Path |
|----------|------|
| Product review skill | `docs/skills/skill-product-review.md` |
| Template (law mold) | `docs/templates/requirements/template-project-reviews.md` |
| Terms | `project-reviews`, `review-plan`, `project-review-folder`, `review-report`, `id-notation` |
| Domain law | `RQ-DOMAIN-TIMER` · `docs/requirements/requirement-domain-timer.md` |
| RTM | `requirement-test-matrix.md` |
