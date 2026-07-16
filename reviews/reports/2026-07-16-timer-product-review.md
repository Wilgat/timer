# Report: full product — timer 2.9.0

**Date:** 2026-07-16  
**Reviewer:** Grok (product-review skill)  
**Product:** timer `VERSION=2.9.0`  
**Ship unit:** `./timer` (`#!/bin/sh`)  
**Product class:** **Domain product** (Active domain SSOT + domain surface)  
**Scope:** Full Type 0 + domain; bootstrap public `reviews/` plan tree; post–domain-requirements alignment  
**Method:** Load lessons (seeded from lineage incidents + this run); walk what-to-review; static ship unit + 9 requirements; run `./tests/run.sh`  
**Baseline:** PASS=129 FAIL=0 SKIP=0 (2026-07-16)  
**Mode:** Review-only (no ship-unit behavior change in this pass)

---

## Pre-flight

| Step | Result |
|------|--------|
| Lessons loaded | Yes — `reviews/lessons.md` (created this pass; lineage L-* + new domain/JSON/cite) |
| What-to-review loaded | Yes — `reviews/what-to-review.md` (created) |
| Requirements registry | **9** Active REQs: eight `requirement-shell-*` plus **`requirement-domain-timer.md`** |
| Class detection | Specialized + domain surface + domain SSOT → **domain product** |
| Companion digest | `timer.sha256` matches `./timer` (suite) |
| Tests | RESULT: OK — PASS=129 FAIL=0 SKIP=0 |

---

## Summary

timer is a mature **CIAO Type 0 + named-timer domain** CLI: pipe-safe entry, Type O empty-argv, companion integrity, fail-closed uninstall, output SSOT, and a fully green suite (**129/129**) including a dedicated domain suite.

**2026-07-16 law fix (prior session):** Domain SSOT was added and CLI interface was aligned so domain is no longer “out of scope” while handlers exist (closes L-DOM-01 honesty gap).

**This pass** establishes the public **review plan** under root `reviews/` and records open machine-contract / citation hygiene items. No product-code remediation in this review-only run.

**Verdict:** **Revise** — baseline green; open findings are citation hygiene + JSON list field shape vs domain law wording (not suite-red).

---

## Strengths

| Area | Evidence |
|------|----------|
| Entry / bootstrap | File ends with unconditional `app_main "$@"` (L-BOOT-01 hold) |
| Type O empty argv | Suite zero-arg not-installed / local / global |
| Domain suite | start/stop/status/list, JSON, persist, kill/reset, invalid_name, already-running, no_timer |
| Domain law present | `requirement-domain-timer.md` Active; registry row; modular/CLI peers point to it |
| Help domain rows | `app_help` lists all six domain verbs + `--persist` |
| About domain hints | start / stop / list + help pointer |
| CHECKSUM not help/about | Suite + ship unit comments |
| Uninstall fail-closed | confirm_required without --force |
| set -u / HOME | Suite env -u HOME |
| Companion integrity | sha256 match + transparency messages |
| Path-safe names | invalid_name suite green |
| Already-running | start fails when file exists |

---

## Lessons re-check

| L-ID | Result 2026-07-16 | Evidence |
|------|-------------------|----------|
| L-BOOT-01 | Closed (hold) | `app_main "$@"` at EOF |
| L-TYPEO-01 | Closed (hold) | Suite zero-arg cases green |
| L-UNIN-01 | Closed (hold) | Suite confirm_required |
| L-SETU-01 | Closed (hold) | Suite + HOME resolution block |
| L-CSUM-01 | Partial | Suite green; keep SECURITY/README honest |
| L-DOM-01 | **Closed** this lineage | Domain SSOT + CLI table domain rows |
| L-DOM-02 | Closed (hold) | invalid_name suite |
| L-DOM-03 | Closed (hold) | already-running suite |
| L-CITE-01 | **Open** | Top header ALIGNMENT omits domain REQ; bootstrap comment cites terminologies |
| L-JSON-01 | **Open** | `timers` is JSON **string** field, not nested array |
| L-ID-01 | **Open** | `APP_NAME` only `:="${APP_NAME:=timer}"`; `VERSION="2.9.0"` hard-assign |

---

## Issues

### Issue 1 — T-JSON-01 — Severity: **bug** (machine contract / law)

- **File:** `./timer` `timer_list` (~2490–2495); `out_json` always stringifies values (~402–415)  
- **Description:** Domain law (`requirement-domain-timer.md` §2.2.4) says list JSON includes `timers` as an **array**. Runtime emits:
  ```json
  {"type":"list","mode":"volatile","count":"1","timers":"[{\"name\":\"…\"}]"}
  ```
  i.e. `timers` is a **string** of JSON text (because `out_json` wraps every value in quotes after escape). Consumers that `json.loads` the root object get `str`, not `list`. Suite only asserts `"type":"list"`.  
- **Suggestion:** Either (A) extend output SSOT with a typed/raw JSON field path for nested arrays, or (B) revise domain REQ to document `timers` as a JSON-text string field and document the parse-twice rule; then add TP-JSON-01 assertion.  
- **Lesson:** L-JSON-01  
- **Test:** TP-JSON-01 TODO  
- **Status:** open  

### Issue 2 — T-CITE-01 — Severity: **suggestion**

- **File:** `./timer` lines 10–18 (ALIGNMENT header)  
- **Description:** Live registry has nine REQs including `requirement-domain-timer.md`. Top ALIGNMENT still lists eight Type 0 peers only. Domain block (~2232) cites domain SSOT, but header inventory is incomplete.  
- **Suggestion:** Add `- requirement-domain-timer.md` to the top ALIGNMENT list.  
- **Lesson:** L-CITE-01  
- **Test:** TP-CITE-01 TODO  
- **Status:** open  

### Issue 3 — T-CITE-02 — Severity: **suggestion**

- **File:** `./timer` bootstrap comment (~2887)  
- **Description:** Comment cites `docs/terminologies/shell-cli-bootstrap.md` and incident ID. Product-source authority policy prefers live `docs/requirements/` only for behavioral ALIGNMENT (templates/skills/terms as law are forbidden).  
- **Suggestion:** Retarget comment to zero-arguments / CLI interface requirements (pipe entry rules already covered by Type O + modular). Keep incident ID only if desired as history, not as law.  
- **Lesson:** L-CITE-01  
- **Test:** TP-CITE-02 TODO  
- **Status:** open  

### Issue 4 — T-ID-01 — Severity: **nit**

- **File:** `./timer` ~38 vs ~43  
- **Description:** `VERSION="2.9.0"` hard-assign exists for extractors; `APP_NAME` is only `:="${APP_NAME:=timer}"`. Tools that greps `^APP_NAME="` miss identity.  
- **Suggestion:** Add `APP_NAME="timer"` hard-assign (keep `:=` default for env override policy if designed).  
- **Lesson:** L-ID-01  
- **Test:** TP-ID-01 TODO  
- **Status:** open  

### Issue 5 — T-DOC-01 — Severity: **nit**

- **File:** `./timer` `app_about` ~2516  
- **Description:** Comment still says `VERSION="1.0.0" near top` while SSOT is `2.9.0`.  
- **Suggestion:** Fix comment to current SSOT wording.  
- **Status:** open  

---

## Non-findings (checked OK)

| Check | Result |
|-------|--------|
| Domain verbs in help | All six + `--persist` |
| Domain handlers under `timer_*` | Yes |
| Registry ↔ disk | 9 files / 9 Active rows |
| Domain SSOT four pillars | Present in `requirement-domain-timer.md` |
| CLI domain “out of scope” | Removed (v1.1.0 peer) |
| `--persist` after name | Works (`start foo --persist`) |
| Companion tmp debris | None at root |
| Secrets in review surface | None |

---

## Remediation order (when implement authorized)

1. **T-JSON-01** — resolve array vs string law/code + TP-JSON-01  
2. **T-CITE-01** — header ALIGNMENT domain line  
3. **T-CITE-02** — bootstrap comment authority  
4. **T-ID-01** / **T-DOC-01** — identity hard-assign + stale comment  

---

## Publish artifacts (this run)

| Path | Action |
|------|--------|
| `reviews/README.md` | Created |
| `reviews/what-to-review.md` | Created (review plan) |
| `reviews/test-plan.md` | Created |
| `reviews/lessons.md` | Created |
| `reviews/index.md` | Created |
| `reviews/reports/2026-07-16-timer-product-review.md` | This report |

---

**Verdict:** **Revise**  
**Open bugs:** T-JSON-01  
**Open suggestions/nits:** T-CITE-01, T-CITE-02, T-ID-01, T-DOC-01  
