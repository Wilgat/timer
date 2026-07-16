# Bootstrap origin review: selfmanaged (A) ← timer (B) revision report

**Date:** 2026-07-16  
**Reviewer:** Grok  
**Mode:** Review only (no A ship-unit edits)  
**Direction:** **A → B only** (selfmanaged → timer). Never reverse-copy timer onto selfmanaged.

---

## Summary

**Bootstrap origin A** = `selfmanaged` (`VERSION=1.1.0`, `./selfmanaged`).  
**Specialized product B** = `timer` (`VERSION=2.9.0`, `./timer`), bootstrapped from selfmanaged Type 0 architecture.

Revision inputs: timer full product review + findings-fix report (2026-07-16). Every timer issue was classified against A on disk. **B-only domain fixes** (JSON `timers` array, domain ALIGNMENT) must **not** be reverse-copied as “make A look like timer.” Shared Type 0 debt on A remains: **dead `util_resolve_storage`**, **no `APP_NAME` hard-assign**, **terminologies cite in bootstrap comment**, hygiene `.tmp`.

**Verdict: Block** — at least one **inherited structural bug class** remains open on A (`SM-STOR-01` / dead storage resolver; confirmed still present on A and still dead-inherited on B). Plus open identity / cite nits inherited on A.

---

## Scope

| Field | Value |
|-------|--------|
| Bootstrap origin **A** | selfmanaged |
| Ship unit A | `/var/www/grok.dr-sense.com/prjs/selfmanaged/selfmanaged` |
| Companion A | `selfmanaged.sha256` present; `selfmanaged.sha256.tmp` also present (gitignored) |
| Specialized **B** | timer |
| Ship unit B | `/var/www/grok.dr-sense.com/prjs/timer/timer` |
| Hop | Immediate: selfmanaged → timer (root origin for timer) |
| Revision report (primary) | `…/timer/reviews/reports/2026-07-16-timer-product-review.md` |
| Follow-up report | `…/timer/reviews/reports/2026-07-16-timer-findings-fix.md` (B issues closed on B) |
| B baseline after fix | PASS=130 FAIL=0 |
| A prior product review | `…/selfmanaged/reviews/reports/2026-07-16-selfmanaged-product-review.md` (PASS=93) |
| A lessons loaded | Yes — `selfmanaged/reviews/lessons.md` |

---

## Issue traceability (B report → A)

| Report # | ID | Severity (B) | Class | A evidence | Notes |
|----------|-----|--------------|-------|------------|-------|
| 1 | T-JSON-01 | bug (B domain use) | **domain_only_B** (active) + **inherited_on_A** (latent `out_json` capability) | `selfmanaged` `out_json()` ~409–421: still stringifies all values; **no** `@key` raw path | B fixed with `@timers`. A has no domain `list`; promoting `@key` to A is optional shared SSOT improvement — **not** reverse-copy of domain. Do **not** copy `timer_list`. |
| 2 | T-CITE-01 | suggestion | **domain_only_B** / **specialized_only_B** | A ALIGNMENT correctly omits domain REQ (bootstrap class) | B needs domain cite; A must **not** invent domain SSOT. |
| 3 | T-CITE-02 | suggestion | **inherited_on_A** | `selfmanaged` ~2572: `docs/terminologies/shell-cli-bootstrap.md` | Same cite pattern as pre-fix B. Patch A comment → live requirements only. |
| 4 | T-ID-01 | nit | **inherited_on_A** (open on A); **fixed on B** | `selfmanaged` ~38: only `: "${APP_NAME:=selfmanaged}"`; no `APP_NAME="selfmanaged"` | Matches SM-ID-01 / L-ID-01. B now has hard-assign. |
| 5 | T-DOC-01 | nit | **specialized_only_B** / **na_on_A** | — | Stale timer `app_about` comment; not an A defect. |

---

## Issues on origin A (actionable)

### Issue A1 — SM-STOR-01 / L-STOR-01 — Severity: **bug** (P1) — **inherited / confirmed**

- **File:** `selfmanaged` `util_resolve_storage()` ~2024  
- **Source:** selfmanaged product review (2026-07-15/16); also present on B as dead inheritance  
- **Classification:** `inherited_on_A` (also dead copy still in timer ship unit)  
- **Description:** Function defined; **no call sites** from `app_main` / `about`. Tiers 1–2 path echo without durable create contract. Timer specialized **domain storage** under `timer_*` instead of wiring this util.  
- **Suggestion:** On **A**: either wire storage into about/main with mkdir policy + tests, **or** document honest Gap and remove/hide from “live inventory” until wired. Then re-specialize B only if B should inherit the wire (B domain already has `timer_resolve_base_dir` — do **not** reverse-copy domain into A).  
- **Status:** open  

### Issue A2 — SM-STOR-02 / L-STOR-02 — Severity: **suggestion** (P2)

- **Classification:** `inherited_on_A` (bootstrap law honesty)  
- **Description:** No storage product requirement on A; helper implies multi-user isolation.  
- **Suggestion:** Requirement or explicit Gap in modular inventory on A.  
- **Status:** open  

### Issue A3 — SM-ID-01 / T-ID-01 — Severity: **nit** (P3) — **inherited_on_A**

- **File:** `selfmanaged` ~38  
- **Evidence:** `APP_NAME` default-only; `VERSION="1.1.0"` hard-assign exists  
- **Suggestion:** Add `APP_NAME="selfmanaged"` hard-assign (same pattern B applied for timer).  
- **Status:** open  

### Issue A4 — T-CITE-02 pattern — Severity: **suggestion** — **inherited_on_A**

- **File:** `selfmanaged` bootstrap footer ~2572  
- **Suggestion:** Cite `requirement-shell-cli-zero-arguments.md` + `requirement-shell-cli-interface.md` instead of `docs/terminologies/…`.  
- **Status:** open  

### Issue A5 — SM-HYG-01 — Severity: **nit** — **na_on_A product / local**

- **Evidence:** `selfmanaged.sha256.tmp` present; gitignored  
- **Suggestion:** `rm -f` local leftover  
- **Status:** open (local)  

### Issue A6 — SM-OUT-01 / SM-DOC-01 / SM-SEC-01

- **Classification:** origin docs/product-choice (storage about fields; modular inventory honesty; trust wording)  
- **Status:** open as prior A review; not driven by timer domain  

---

## Specialized-only / domain-only on B (not origin work)

| Item | Why not A |
|------|-----------|
| Domain verbs / `timer_*` / domain SSOT | Domain surface of timer |
| T-JSON-01 active list array bug | Fixed on B; domain `list` only |
| T-CITE-01 domain ALIGNMENT | B domain law cite |
| T-DOC-01 about comment | B-only |
| Domain suite 130 tests | B proof |

**Do not** copy `requirement-domain-timer.md`, `timer_start`, or domain help into selfmanaged to “align.”

---

## Reverse-copy risks

| Risk | Status |
|------|--------|
| Copy `./timer` body onto `./selfmanaged` to share fixes | **Forbidden** |
| Add domain REQs to A because B has them | **Forbidden** (would break bootstrap class) |
| Promote only portable `out_json` `@key` to A | **Allowed** shared SSOT (harness/output law), not reverse-copy |
| Promote `APP_NAME` hard-assign / bootstrap comment cite fix | **Allowed** Type 0 hygiene on A |

---

## Lessons re-check on A (from A lessons.md)

| L-ID | Result this origin pass |
|------|-------------------------|
| L-STOR-01 | **Still open** — dead `util_resolve_storage` |
| L-STOR-02 | **Still open** — no storage law/Gap honesty |
| L-BOOT-01 | Closed (hold) — `app_main "$@"` |
| L-TYPEO-01 | Closed (hold) — suite |
| L-UNIN-01 | Closed (hold) — suite |
| L-SETU-01 | Closed (hold) — suite |
| L-CSUM-01 | Partial — suite OK |
| L-HYG-01 | **Still open** — `.tmp` present |
| L-ID-01 | **Still open** — no hard-assign |
| L-CITE (from B) | **Open on A** — terminologies in bootstrap comment |

---

## Architecture inheritance (B kept from A)

| Inherited surface | B status |
|-------------------|----------|
| Type 0 install / self-update / uninstall | Present |
| `out_*` / `inst_*` / `app_*` prefixes | Present |
| Companion digest + CHECKSUM pin model | Present |
| Type O empty argv | Present |
| Dead `util_resolve_storage` copy | **Still present on B** (unused; domain uses `timer_*`) |
| `out_json` base | B **extended** with `@key` (A not yet) |

---

## Verdict

**Block** — open **inherited bug** on A: **SM-STOR-01** (dead storage resolver; also pollutes B as unused inheritance).  

Additional **Revise**-class inherited nits: SM-ID-01, terminologies bootstrap cite, hygiene tmp, storage law honesty.

**Next (authorized implement on A only):**

1. Resolve SM-STOR-01 + SM-STOR-02 on selfmanaged (wire or Gap)  
2. APP_NAME hard-assign + bootstrap comment cite (quick)  
3. Optional: port `out_json` `@key` raw fields to A output SSOT for future specializes  
4. **Then** optional re-specialize timer from fixed A for shared Type 0 only — **never** reverse-copy domain  

---

## Checklist gate (summary)

| Gate | Result |
|------|--------|
| Direction A→B | Pass |
| Report resolved | Pass (timer reviews) |
| A inventory | Pass |
| Every B issue classified | Pass |
| Reverse-copy plan absent | Pass |
| Inherited bugs on A | **Fail → Block** |

---

**Written by:** Grok  
**Review status:** Durable origin report; **no A code changes** this pass.  
