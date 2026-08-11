# Bootstrap specialize report: selfmanaged (A) → timer (B)

**Date:** 2026-08-11  
**Skill:** `SK-BOOTSTRAP-SPECIALIZE-PRODUCT`  
**Checklist:** `CL-BOOTSTRAP-SPECIALIZE-PRODUCT`  
**Direction:** **A → B only** (never reverse-copy)

---

## Direction

| Field | Value |
|-------|--------|
| Bootstrap product **A** | `selfmanaged` **1.2.1** |
| Ship unit A | workspace `./selfmanaged` (identical to `…/prjs/selfmanaged/selfmanaged`) |
| Specialized product **B** | `timer` **2.11.0** |
| Ship unit B | `./timer` (+ `timer.sha256`) |
| Shared architecture | **yes** (Type 0 `out_*` / `inst_*` / `app_*`, online install, automatic checksum, shell storage wire) |
| Domain surface on B | **yes** (`timer_*` start/stop/status/list/kill/reset) |
| Archive of pre-B | `.bootstrap-archive/timer-2.10.1-pre-respecialize-20260811-072122` |
| Change type | re-specialize from updated A (inherit storage wire + keep domain) |

---

## Load list (disk-truth)

- Term: `docs/terminologies/bootstrap-specialize-product.md`
- Skill: `docs/skills/skill-bootstrap-specialize-product.md`
- Checklist form: `docs/templates/checklists/checklist-bootstrap-specialize-product.md`
- A requirements (sibling): includes `requirement-shell-cli-storage.md`
- B requirements after: **11** Active rows incl. new `RQ-SHELL-CLI-STORAGE` + existing `RQ-DOMAIN-TIMER`

---

## Gate

| Gate | Status |
|------|--------|
| Requirements Step 0 | Authorized re-specialize: inherit A storage law; keep domain SSOT; no reverse-copy of domain onto A |
| Archive of A | A left intact; B pre-state archived under `.bootstrap-archive/` |
| Reverse-copy | **none** — A still `APP_NAME=selfmanaged` / no `timer_*` |

---

## Plan executed (A → B only)

1. Freeze A (`./selfmanaged` = sibling 1.2.1).  
2. Archive prior B (`timer` 2.10.1).  
3. Copy A body → rebuild B.  
4. Retarget B identity/channel (`timer`, Wilgat/timer, VERSION **2.11.0**).  
5. Re-apply domain block + help/about/dispatch from archived B.  
6. Keep A storage inheritance (`util_resolve_storage` create + `app_main`/`app_about` wire).  
7. Register `requirement-shell-cli-storage.md` / **RQ-SHELL-CLI-STORAGE**.  
8. Align TP-CLI-05 + RTM; regenerate `timer.sha256`; run suite.

---

## Checklist verdict (filled summary)

### 1. Direction gate — **Pass**
- A and B named; A→B only; no reverse plan.

### 2. Freeze / archive A — **Pass**
- A present and unpolluted; prior B archived.

### 3. Requirements gate — **Pass**
- Domain SSOT kept; shell storage law added for inherited wire; no bulk rewrite of A law.

### 4. Create B from A — **Pass**
- B rebuilt from A + domain port; A not overwritten by B.

### 5. Identity / channel (B only) — **Pass**
- `APP_NAME=timer`, REPO timer channel, companion digest regenerated.

### 6. Architecture inheritance — **Pass**
- `out_*`, `inst_*`, Type O empty argv, self-management, automatic checksum, **storage wire**.

### 7. Domain surface — **Pass**
- Domain prefix `timer_*`; path-safe names; domain dispatch retained.

### 7b. Domain requirements — **Pass**
- Existing `requirement-domain-timer.md` / **RQ-DOMAIN-TIMER** remains sole Active domain SSOT.

### 8. Tests — **Pass**
- `./tests/run.sh` → **PASS=195 FAIL=0 SKIP=1** (optional online).

### 9–11. Anti-pollution / dual policies / CIAO — **Pass**
- A identity/channel/domain-free; skill stayed portable; B deliverables complete.

**Verdict: Pass**

---

## Verification smoke

| Check | Result |
|-------|--------|
| `timer --json version` | `2.11.0` |
| `timer --json about` | includes `effective_storage`, `storage_dir` |
| Domain start/stop/list | OK |
| A `selfmanaged` identity | intact (`APP_NAME=selfmanaged`, no domain) |
| Suite | 195/0/1 |

---

## Forbidden checks

- Reverse-copy: **none planned / none remaining**  
- B channel pointing at A: **no**  
- Domain law on A: **no**

---

**Last Updated:** 2026-08-11  
**Owner:** Bootstrap Specialization Engineer (council)
