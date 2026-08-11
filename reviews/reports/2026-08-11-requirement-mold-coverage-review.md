# Requirement coverage + mold alignment review — timer

**Date:** 2026-08-11  
**Mode:** Review + authorized align (user: “review requirements coverage and align with molds”)  
**Skills:** `SK-REQUIREMENT-REVIEW` · `PM-REQUIREMENT-TEST-TRACEABILITY`  
**Product:** timer (software-development · Type 0 + domain)

---

## Registry inventory (Step −1)

| Bucket | Result |
|--------|--------|
| Registered ∩ on disk | **12** Active `requirement-*.md` |
| Orphans (disk not registry) | **none** |
| Ghosts (registry missing file) | **none** |
| Foreign candidates | **none** (product identity = timer) |
| Scope | **registry-only** |

### Class gate (Step −2)

| Check | Result |
|-------|--------|
| Class | software-development |
| Active class REQ | **RQ-CLASS-SOFTWARE-DEV** · `LM-REQUIREMENT-CLASS-SOFTWARE-DEV` | **Pass** |

### Bootstrap gate (Step 0)

| Check | Result |
|-------|--------|
| Direction | selfmanaged (A) → timer (B) already specialized |
| Edits this turn | Mold alignment only (no reverse-copy) |

---

## Findings (pre-align → disposition)

| ID | Severity | Finding | Disposition |
|----|----------|---------|-------------|
| M-01 | **high** | **RQ-SHELL-CLI-STORAGE** missing Design-time verification / LM primary cite | **Fixed** — DTV + **`LM-SHELL-CLI-STORAGE`** + **`PM-SHELL-CLI-TEST-PLAN`** / **TP-CLI-05** |
| M-02 | **high** | **TP-CLI-05** still marked n/a in CLI DTV + `reviews/test-plan.md` after shell storage inheritance | **Fixed** — **have** + owner **RQ-SHELL-CLI-STORAGE** |
| M-03 | **high** | **RQ-DOMAIN-TIMER** claimed “no portable domain law mold” while **`LM-NAMED-TIMER-DOMAIN`** exists | **Fixed** — Specialized from **`LM-NAMED-TIMER-DOMAIN`** (+ base **`LM-SHELL-INTERNAL-VOLATILE-TIMER`**) |
| M-04 | **high** | Named-timer mold mandatory peer **temp file system** missing from registry | **Fixed** — Active **RQ-SHELL-TEMP-FILE-SYSTEM** · **`LM-TEMP-FILE-SYSTEM`** |
| M-05 | **medium** | Index law-mold section outdated (domain “no mold”) | **Fixed** |
| M-06 | **medium** | RTM domain row omitted **LM-NAMED-TIMER-DOMAIN**; storage LM hedged “when mold present” | **Fixed** |
| M-07 | **low** | Ship-unit header cite list omitted temp REQ | **Fixed** + companion digest regen |

---

## Coverage matrix (post-align)

| Requirement-ID | Law mold (LM) | Proof mold (PM) primary | TP proof | Status |
|----------------|---------------|-------------------------|----------|--------|
| RQ-CLASS-SOFTWARE-DEV | LM-REQUIREMENT-CLASS-SOFTWARE-DEV | — | TP-CLASS-01 | have |
| RQ-SHELL-CLI-INTERFACE | LM-CLI-INTERFACE | PM-SHELL-CLI-TEST-PLAN | TP-CLI-* | have |
| RQ-SHELL-CLI-STORAGE | LM-SHELL-CLI-STORAGE | PM-SHELL-CLI-TEST-PLAN | TP-CLI-05 | have |
| RQ-SHELL-CLI-ZERO-ARGUMENTS | LM-SHELL-CLI-ZERO-ARGUMENTS | PM-SHELL-CLI-TEST-PLAN / PM-INSTALL / PM-CURL | TP-CLI-09, TP-LC, TP-CURL | have |
| RQ-SHELL-TEMP-FILE-SYSTEM | LM-TEMP-FILE-SYSTEM | PM-INSTALL / PM-CHECKSUM / PM-SHELL-CLI | TP-LC, TP-CSUM, TP-CLI-05 | have |
| RQ-SHELL-OUTPUT-REQUIREMENTS | LM-OUTPUT-REQUIREMENTS | PM-SHELL-CLI-TEST-PLAN | TP-CLI-02/04/06/07/12; TP-TIMER-04 | have |
| RQ-SHELL-AUTOMATIC-CHECKSUM | LM-AUTOMATIC-CHECKSUM | PM-CHECKSUM-TEST-PLAN | TP-CSUM-01..05 | have |
| RQ-SHELL-SELF-MANAGEMENT | LM-SELF-MANAGEMENT | PM-INSTALL-LIFECYCLE-TEST-PLAN | TP-LC-* | have |
| RQ-SHELL-IDEMPOTENCY | LM-IDEMPOTENCY | PM-INSTALL / PM-CURL | TP-LC-01/05/10; TP-CURL-03 | have |
| RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | LM-INTERACTIVE-VS-NONINTERACTIVE | PM-SHELL-CLI / PM-CURL | TP-CLI-07/11; TP-CURL | have |
| RQ-SHELL-MODULAR-FUNCTION-DESIGN | LM-MODULAR-FUNCTION-DESIGN | PM-SHELL-CLI-TEST-PLAN | TP-CLI-01 + review | have |
| RQ-DOMAIN-TIMER | LM-NAMED-TIMER-DOMAIN | PM-DOMAIN-TEST-PLAN | TP-TIMER-01..07; TP-STORAGE-01/02 | have |

### Named-timer mandatory peers (**LM-NAMED-TIMER-DOMAIN** §1.1)

| Peer | REQ | Status |
|------|-----|--------|
| CLI interface | RQ-SHELL-CLI-INTERFACE | **have** |
| Shell CLI storage | RQ-SHELL-CLI-STORAGE | **have** |
| Temp file system | RQ-SHELL-TEMP-FILE-SYSTEM | **have** (aligned this review) |
| Output | RQ-SHELL-OUTPUT-REQUIREMENTS | **have** |

### Honest n/a

| Item | Why |
|------|-----|
| TP-PAYLOAD-* | Not Type O-P |
| TP-CLI-10 | No sdkman source path |
| TP-STORAGE-03 | Corrupted-state path not claimed |
| Separate LM-ONLINE-INSTALL REQ | Online install covered by zero-arg + self-management + automatic-checksum package (no dual local/online install) |

---

## ID notation (Step 0-ID)

| Check | Result |
|-------|--------|
| RQ-* unique / stem-matched | **Pass** |
| DTV primary TP-* | **Pass** |
| LM/PM primary on alignment | **Pass** (post-align) |
| No harness path dumps in REQs | **Pass** |
| Foreign RQ | **none** |

## Least privilege (Step 0-LP)

**N/A** — Type 0 only; no Type 1/2 / system-user elevation law claimed.

---

## Checklist A–G (summary)

| Section | Verdict |
|---------|---------|
| A Process / class / registry | **Pass** |
| B Template alignment | **Pass** (post-align) |
| B2 ID notation | **Pass** |
| B3 Least privilege | **N/A** |
| C Dual policy | **Pass** (notes filled; no secrets) |
| D Naming | **Pass** |
| E Defensive strength | **Pass** |
| F Process protection | **Pass** |
| G Git-surface | **Pass** |

---

## Suite

```text
./tests/run.sh → PASS=195 FAIL=0 SKIP=1  RESULT: OK
```

---

## Verdict

**Approve with follow-ups closed this turn** — coverage aligned to live law/proof molds; named-timer peer set complete; stale TP-CLI-05 n/a removed.

**Optional later (not blocking):** deepen dedicated trap/cleanup asserts for every mktemp leaf if incidents demand (currently n/a in temp DTV).

---

**Last Updated:** 2026-08-11
