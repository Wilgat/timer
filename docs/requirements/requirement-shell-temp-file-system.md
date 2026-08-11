**file**: docs/requirements/requirement-shell-temp-file-system.md  
**Requirement-ID**: `RQ-SHELL-TEMP-FILE-SYSTEM`  
**Status**: Active (Version 1.0.0 – specialized from LM-TEMP-FILE-SYSTEM for Type 0 timer CLI)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **temporary / scratch leaf policy** of the timer POSIX `/bin/sh` Type 0 CLI: unique temp creation, root inheritance, fail-closed behavior, cleanup on install/download paths, and atomic stage→publish for ship-unit placement.

**Specialized from:** **`LM-TEMP-FILE-SYSTEM`**.  
**Proof design:** install/lifecycle + CLI suites that exercise `mktemp` under `TMPDIR` (**TP-LC-***, **TP-CSUM-***, storage wire **TP-CLI-05**).

**Scope:** `mktemp` / unique leaves; use of `TMPDIR` / isolated roots; cleanup of install/download sidecars; atomic install staging.  
**Out of scope (cited, not re-owned):** Shell storage **root resolve** and about storage fields (**`RQ-SHELL-CLI-STORAGE`** / **`LM-SHELL-CLI-STORAGE`**); named-timer **domain record** files (**`RQ-DOMAIN-TIMER`**); companion digest semantics (**`RQ-SHELL-AUTOMATIC-CHECKSUM`**); full `out_*` catalog (**`RQ-SHELL-OUTPUT-REQUIREMENTS`**).

**Mandatory-peer note:** **`LM-NAMED-TIMER-DOMAIN`** requires this peer Active alongside CLI, shell storage, and output when domain named-timer is product law.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Never assume / never predict

1. **MUST NOT** assume a temp root exists, is writable, is large enough, or is exec-capable.  
2. **MUST NOT** use predictable sensitive names alone (e.g. bare `/tmp/${APP_NAME}.tmp` as the only entropy). Prefer **`mktemp` / `mktemp -t` / `mktemp -d`**.  
3. If no usable root / create fails → **MUST** fail closed via Output SSOT (`out_die` / structured error).

### 2.2 Root inheritance (this product)

| Step | Rule |
|------|------|
| 1 | `app_main` resolves shell storage via **`util_resolve_storage`** (**`RQ-SHELL-CLI-STORAGE`**) |
| 2 | Export **`TMPDIR=${EFFECTIVE_STORAGE_DIR}`** so `mktemp -t` lands under the isolated product root |
| 3 | Install / download / checksum paths **MUST** create unique leaves under that inheritance (or explicit documented fallback) |

**Family:** Install/download staging (CIAO Principle 11) uses the **storage-resolved root + `mktemp`**. Domain epoch files are **not** temps — they are domain records under **`RQ-DOMAIN-TIMER`**.

### 2.3 Unique leaves and cleanup

1. Download staging and companion-digest temp files **MUST** use unique names (`mktemp`).  
2. On success or controlled failure, install paths **MUST** remove or not leave world-sensitive predictable debris when design allows (idempotent cleanup preferred).  
3. **Atomic publish:** write temp → verify (when integrity applies) → `mv`/`install` to final path (**`RQ-SHELL-SELF-MANAGEMENT`** / install helpers own final placement).

### 2.4 Permissions and isolation

1. Prefer explicit mode on created leaves where the install path sets mode; do **not** rely on sticky global `umask` alone as complete policy.  
2. Isolation for shared mounts is owned primarily by storage resolve (**`APP_NAME` + `USERNAME`** segments); temp leaves inherit that root.

### 2.5 Implementation Notes (this project)

| Item | Live value |
|------|------------|
| **Product / binary** | `timer` |
| **Root SSOT** | `EFFECTIVE_STORAGE_DIR` from `util_resolve_storage`; `export TMPDIR=…` in `app_main` |
| **Leaf API** | `mktemp -t "${APP_NAME}.XXXXXX"` (install body); `mktemp -t "${APP_NAME}.sha256.XXXXXX"` (companion stage) |
| **Domain records** | **Not** temps — `${base}/${APP_NAME}_${USERNAME}_${name}` under domain resolve |
| **Tests** | Lifecycle + checksum suites exercise download temps; TP-CLI-05 proves storage root exists for TMPDIR |

### 2.6 Why This Requirement Exists (CIAO)

- **Caution:** noexec / missing mounts / multi-user hosts.  
- **Intentional:** one inheritance story (storage root → TMPDIR → mktemp).  
- **Anti-fragile:** fail closed when create fails.  
- **Over-protect:** keep domain records out of “temp” naming so cleanup never deletes live timers by accident.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- Temps are disposable; domain records are product state.  
- Unique names over predictable paths.  
- Storage resolve owns roots; this law owns leaves + install staging hygiene.  
- Atomic stage→publish for ship-unit placement.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Replace `mktemp` install staging with fixed predictable paths under `/tmp/timer`.  
2. Collapse domain timer record files into temp cleanup.  
3. Drop `TMPDIR` export after storage resolve without an equivalent isolated root for install temps.  
4. Assume `/tmp` is always writable/exec without fail-closed handling.  
5. Bypass Output SSOT for temp create failures.  
6. Remove this peer while **`RQ-DOMAIN-TIMER`** claims **`LM-NAMED-TIMER-DOMAIN`** completeness.

**Violating this rule is a critical temp/isolation regression.**

---

## 5. Definition of done (shell temp file system)

Temp work for timer is **not done** if any of the following fail:

1. Install/download staging uses unique `mktemp` leaves (not fixed predictable names).  
2. `app_main` exports `TMPDIR` from storage resolve so leaves inherit isolation.  
3. Create failures fail closed via Output SSOT.  
4. Domain timer records are not treated as temps.  
5. Automated suites cover install/download paths that use temps (lifecycle/checksum) and storage root existence (TP-CLI-05).  
6. This requirement is registered Active and cited as peer of domain law.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| **RQ-SHELL-CLI-STORAGE** | Root resolve + TMPDIR source |
| **RQ-SHELL-SELF-MANAGEMENT** | Install atomic placement |
| **RQ-SHELL-AUTOMATIC-CHECKSUM** | Companion digest temp stage |
| **RQ-SHELL-OUTPUT-REQUIREMENTS** | Fail-loud channels |
| **RQ-DOMAIN-TIMER** | Domain records (not temps) |
| `./timer` | Implementation under test |
| `tests/test_install_lifecycle.sh` | Install temp paths |
| `tests/test_cli.sh` | Storage root for TMPDIR (**TP-CLI-05**) |

---

## Design-time verification

**Requirement-ID:** `RQ-SHELL-TEMP-FILE-SYSTEM`  
**Specialized from:** `LM-TEMP-FILE-SYSTEM`  
**Proof molds:** `PM-INSTALL-LIFECYCLE-TEST-PLAN` · `PM-CHECKSUM-TEST-PLAN` · `PM-SHELL-CLI-TEST-PLAN`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-LC-12** / **TP-LC-06** install + force reinstall (download stage uses mktemp) | `tests/test_install_lifecycle.sh` | have |
| **TP-CSUM-02..04** companion stage paths | `tests/test_install_lifecycle.sh` | have |
| **TP-CLI-05** storage root exists (TMPDIR parent) | `tests/test_cli.sh` | have |
| Dedicated trap-matrix for every mktemp leaf | n/a — not claimed as separate suite; install paths clean on success paths | n/a |

---

**Last Updated**: 2026-08-11  
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; **`LM-TEMP-FILE-SYSTEM`**; mandatory peer of **`LM-NAMED-TIMER-DOMAIN`**; CIAO Principles 1, 2, 3, 11, 22 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
