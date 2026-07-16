# Report: findings fix — timer 2.9.0

**Date:** 2026-07-16  
**Mode:** Implement (authorized: “fix”)  
**Prior report:** `reports/2026-07-16-timer-product-review.md`  
**Baseline after fix:** PASS=130 FAIL=0 SKIP=0  

---

## Summary

Closed all open items from the 2026-07-16 full product review.

| ID | Severity | Resolution |
|----|----------|------------|
| T-JSON-01 | bug | `out_json` supports `@key` raw nested JSON; `timer_list` uses `@timers` nested array; domain suite asserts array |
| T-CITE-01 | suggestion | Top ALIGNMENT lists `requirement-domain-timer.md` |
| T-CITE-02 | suggestion | Bootstrap comment cites live requirements only (not terminologies) |
| T-ID-01 | nit | `APP_NAME="timer"` hard-assign |
| T-DOC-01 | nit | `app_about` VERSION comment no longer says 1.0.0 |

**Law:** `requirement-shell-output-requirements.md` v1.2.0 documents `@key` raw fields.  
**Companion:** `timer.sha256` refreshed.

**Verdict:** **Pass** (prior open findings closed; suite green).

---

## Evidence

### T-JSON-01

```text
# before: "timers":"[{...}]"  (string)
# after:  "timers":[{...}]    (array)
```

- `out_json`: keys starting with `@` emit unquoted JSON values  
- `timer_list`: `out_json … "@timers" "$timers_json"`  
- Test: `domain json list timers is nested array` (python3 isinstance list)

### Citations / identity

- Header ALIGNMENT includes domain REQ  
- EOF bootstrap cites `requirement-shell-cli-zero-arguments.md` + `requirement-shell-cli-interface.md`  
- `APP_NAME="timer"` + `VERSION="2.9.0"` hard-assign parity  

---

## Lessons / TP updates

| Item | Status |
|------|--------|
| L-JSON-01 | **Closed** |
| L-CITE-01 | **Closed** |
| L-ID-01 | **Closed** |
| TP-JSON-01 | **have** |
| TP-CITE-01 | **have** (static header; optional suite later) |
| TP-CITE-02 | **have** (comment fix) |
| TP-ID-01 | **have** (static hard-assign) |
