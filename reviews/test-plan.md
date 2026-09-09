# Test plan — timer

Maps **portable TP families** (proof molds) and product domain cases to product-root `tests/`.

| Field | Value |
|-------|--------|
| **Product** | timer |
| **Ship unit** | `./timer` · `VERSION=2.14.0` |
| **Companion** | `./timer.sha256` |
| **Suite entry** | `./tests/run.sh` |
| **RTM** | `reviews/requirement-test-matrix.md` |
| **Live law** | **15** Active REQs — `docs/requirements/index.md` |
| **Last update** | 2026-09-09 (PATH/rc **TP-LC-20..22** **TP-TX-09**; **2.14.0**) |

Status: **have** = automated · **todo** = needed · **n/a** = not applicable · **optional** = gated

---

## Proof molds (cite by PM-ID)

| Family | Proof mold-ID | Suite file(s) | Primary product law |
|--------|---------------|---------------|---------------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE · RQ-SHELL-CLI-STORAGE · RQ-SHELL-OUTPUT-REQUIREMENTS |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` | RQ-SHELL-SELF-MANAGEMENT · RQ-SHELL-IDEMPOTENCY · RQ-SHELL-PATH-AND-SHELL-SUPPORT · RQ-SHELL-TEMP-FILE-SYSTEM |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle | RQ-SHELL-AUTOMATIC-CHECKSUM |
| **TP-U** | `PM-SET-U-TEST-PLAN` | CLI + curl (partial) | set -u / defaults (cross-cutting) |
| **TP-CURL** | `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `tests/test_online_curl_install.sh` | RQ-SHELL-CLI-ZERO-ARGUMENTS · RQ-SHELL-SELF-MANAGEMENT |
| **TP-TX** | `PM-SHELL-TERMUX-ISH-TEST-PLAN` (detect/ceiling; pkg n/a) | `tests/test_cli.sh` | **RQ-SHELL-CLI-INTERFACE** · **RQ-SHELL-SELF-MANAGEMENT** · **RQ-SHELL-SCRIPT-CODING** |
| **TP-TIMER** | `PM-DOMAIN-TEST-PLAN` (ops / subject catalog) | `tests/test_timer_domain.sh` | **RQ-DOMAIN-TIMER** · **LM-NAMED-TIMER-DOMAIN** |
| **TP-STORAGE** | `PM-DOMAIN-TEST-PLAN` § shared dual-storage | `tests/test_timer_domain.sh` | **RQ-DOMAIN-TIMER** (domain *records*; not shell scratch) |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` | full Type 0 + domain |
| RTM mold | `PM-REQUIREMENT-TEST-TRACEABILITY` | `reviews/requirement-test-matrix.md` | design-time RQ↔TP |

**Storage split (do not collapse):**

| Concern | Owner | Proof |
|---------|-------|-------|
| Shell scratch / about fields / `TMPDIR` root | **RQ-SHELL-CLI-STORAGE** · **RQ-SHELL-TEMP-FILE-SYSTEM** | **TP-CLI-05** · install **TP-LC** / **TP-CSUM** |
| Named-timer domain records (volatile / `--persist`) | **RQ-DOMAIN-TIMER** | **TP-STORAGE-01/02** · **TP-TIMER-*** |

---

## Baseline result

| Date | Result | Notes |
|------|--------|-------|
| 2026-07-19 | PASS=133 FAIL=0 | Domain JSON number lock-in |
| 2026-07-24 | PASS=187 FAIL=0 SKIP=1 | TP labels; lifecycle parity; TP-CURL local |
| 2026-08-11 | **PASS=195 FAIL=0 SKIP=1** | Re-specialize + mold peers; full product review **Pass** (`reports/2026-08-11-timer-product-review.md`) |
| 2026-09-06 | **PASS=205 FAIL=0 SKIP=1** | Termux target **TP-TX-01..05**; 13 REQs; **2.12.0** |
| 2026-09-07 | **PASS=210 FAIL=0 SKIP=1** | Termux `$PREFIX/tmp` **TP-TX-08**; **2.12.1** |
| 2026-09-07 | **PASS=246 FAIL=0 SKIP=1** | TTY numbered menu **TP-CLI-07/16/17/29**; **2.13.0** |
| 2026-09-07 | **PASS=256 FAIL=0 SKIP=1** | TTY menu name prompt **TP-CLI-30**; **2.13.1** |
| 2026-09-07 | **PASS=264 FAIL=0 SKIP=1** | TTY running-timer pick **TP-CLI-30**; **2.13.2** |
| 2026-09-09 | **PASS=284 FAIL=0 SKIP=1** | PATH/rc **TP-LC-20..22** **TP-TX-09**; **2.14.0** |

**How to re-baseline:** `cd` product root → `./tests/run.sh` → paste summary line into this table when law/suite changes.

---

## TP-CLI — CLI surface (`PM-SHELL-CLI-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence / owner |
|-------|--------|--------|------------------|
| **TP-CLI-01** | Syntax + companion Shape A | **have** | `sh -n`; `timer.sha256` match |
| **TP-CLI-02** | Version human + JSON | **have** | version exit/app/version; `--debug` |
| **TP-CLI-03** | Help Type 0 + domain surface | **have** | install/self-*; start/stop/list; no CHECKSUM |
| **TP-CLI-04** | Help/about JSON purity | **have** | help/about JSON; about no CHECKSUM |
| **TP-CLI-05** | About shell storage resolve | **have** | `effective_storage` / `storage_dir` + isolation + dir exists + `STORAGE_DIR` override (**RQ-SHELL-CLI-STORAGE**) |
| **TP-CLI-06** | Unknown command | **have** | human + JSON `out_error` |
| **TP-CLI-07** | Quiet mode; TTY empty argv numbered list; TTY `--json` JSON help | **have** | `--quiet`/`-q`; PTY empty argv / `--json` |
| **TP-CLI-08** | `env -u HOME` under set -u | **have** | also **TP-U-01** |
| **TP-CLI-09** | Zero-arg bad channel | **have** | non-zero; not silent; no binary |
| **TP-CLI-10** | bashrc+sdkman under set -u | **n/a** | No product sdkman/source path |
| **TP-CLI-11** | self-uninstall refuse without force | **have** | `confirm_required`; binary remains |
| **TP-CLI-12** | `out_json` `@key` raw nested | **have** | extracted harness |
| **TP-CLI-16** | No `$()` of `prompt_*` (do-not-capture-read) | **have** | `tests/test_cli.sh` |
| **TP-CLI-17** | Menu header nametag + gray italic explain | **have** | `tests/test_cli.sh` (PTY; skip if no python3) |
| **TP-CLI-29** | Overlay `--debug`/`--quiet` follow empty argv; `--json` JSON help | **have** | `tests/test_cli.sh` |
| **TP-CLI-30** | TTY menu start name prompt; stop/status/kill/reset numbered running list | **have** | `tests/test_cli.sh` (PTY; skip if no python3) |

---

## TP-TX — Termux target (`PM-SHELL-TERMUX-ISH-TEST-PLAN` detect/ceiling; no pkg companion)

This product does **not** wrap `pkg`. Cases prove **target system** detect + this-login dest.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-TX-01** | Off detect: `about` `termux=false`; stub `pkg` not called | **have** | `tests/test_cli.sh` |
| **TP-TX-02** | PREFIX/`TERMUX_VERSION` detect: `about` `termux=true` | **have** | `tests/test_cli.sh` |
| **TP-TX-03** | Termux: no `sudo curl` in help / empty-argv recommend | **have** | `tests/test_cli.sh` |
| **TP-TX-04** | Termux: `user_bin` is `$PREFIX/bin` when that dir exists | **have** | `tests/test_cli.sh` |
| **TP-TX-05** | Termux: stub `pkg` still not invoked (no companion list) | **have** | `tests/test_cli.sh` |
| **TP-TX-06** | One-shot `proot` reaper | **n/a** | No guest/proot dispatch |
| **TP-TX-07** | One-shot without `proot` | **n/a** | No guest/proot dispatch |
| **TP-TX-08** | Termux: unusable `VOLATILE_DIR` → file under `$PREFIX/tmp`; no `/timer_*` root write | **have** | `tests/test_cli.sh` |
| **TP-TX-09** | Termux: `$PREFIX/bin` dest does not write PATH into rc | **have** | `tests/test_cli.sh` |
| **TP-LC-16** | Named `pkg install -y` | **n/a** | No package list |

**Legacy product-local IDs (retired → family):**

| Legacy | Now |
|--------|-----|
| TP-JSON-01 / T-JSON-01 | **TP-TIMER-04** |
| TP-JSON-02 / T-JSON-02 | **TP-TIMER-04** |
| TP-CSUM-01 (help hide) | **TP-CSUM-05** + **TP-CLI-03/04** |
| TP-UNIN-01 | **TP-CLI-11** |
| TP-SETU-01 | **TP-U-01** / **TP-CLI-08** |
| TP-TIMER-01..03 (old numbering) | **TP-TIMER-01**, **TP-TIMER-02+** |
| TP-TIMER-08/09 (old storage ops) | **TP-STORAGE-02/01** |

---

## TP-LC — Install lifecycle (`PM-INSTALL-LIFECYCLE-TEST-PLAN`)

Also proves install **temp leaves** / staging (**RQ-SHELL-TEMP-FILE-SYSTEM**): download and companion stages use `mktemp` under storage-resolved `TMPDIR`.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-LC-01** | Empty-argv ensure (first + already local/global) | **have** | lifecycle suite |
| **TP-LC-02** | Payload `install` | **n/a** | Type O CLI — no domain payload project |
| **TP-LC-03** | Payload uninstall | **n/a** | No payload surface |
| **TP-LC-04** | About installed + version-check JSON | **have** | local/remote/is_latest |
| **TP-LC-05** | self-update already-latest | **have** | success message |
| **TP-LC-05b** | self-update when remote newer | **have** | upgrades VERSION |
| **TP-LC-06** | Force reinstall companion transparency | **have** | link/expected/actual/PASS (**temp + CSUM**) |
| **TP-LC-07** | self-uninstall refuse / force + PATH cleanup | **have** | refuse + force remove |
| **TP-LC-08** | Downgrade refuse / force | **have** | `downgrade_blocked` |
| **TP-LC-09** | Bad channel empty argv | **have** | same class as **TP-CLI-09** |
| **TP-LC-10** | Idempotent re-install | **have** | “already installed” |
| **TP-LC-11** | version-check network failure | **have** | `network_error` |
| **TP-LC-12** | Explicit `install --json` | **have** | first install path (**mktemp** stage); exact USER_BIN PATH in `.bashrc` |
| **TP-LC-20** | `rc-test --root` create-if-missing | **have** | fixture `.bashrc`; exact PATH; login/CI home untouched |
| **TP-LC-21** | `rc-test --root` modify dongle | **have** | dongle body kept; exact PATH once |
| **TP-LC-22** | `rc-test --root` VERSION+exact-PATH no-op | **have** | bytes unchanged; JSON success |

---

## TP-CSUM — Checksum (`PM-CHECKSUM-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CSUM-01** | Publisher companion matches ship unit | **have** | repo `.sha256` |
| **TP-CSUM-02** | Human force reinstall transparency | **have** | lifecycle human install |
| **TP-CSUM-03** | Shape B pin mismatch | **have** | `checksum_mismatch` |
| **TP-CSUM-04** | Shape B pin match | **have** | good CHECKSUM install |
| **TP-CSUM-05** | Help/about hide CHECKSUM | **have** | CLI suite |

---

## TP-U — set -u (`PM-SET-U-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-U-01** | `env -u HOME` safe command | **have** | version |
| **TP-U-02** | Defaults on zero-arg fail path | **have** | TP-CLI-09 loud fail |
| **TP-U-03** | HOME with bashrc stub | **have** | TP-CURL-04 direct version |
| **TP-U-04** | bashrc via pipe | **n/a** / partial | product does not source bashrc on pipe |
| **TP-U-05** | Safe external source helper | **n/a** | no bare product sdkman source path |

---

## TP-CURL — curl\|sh (`PM-ONLINE-CURL-INSTALL-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CURL-01** | Channel probe | **have** | local HTTP ship + companion |
| **TP-CURL-02** | First `curl \| sh` | **have** | binary at USER_BIN; not silent |
| **TP-CURL-03** | Second pipe | **have** | already-installed messaging |
| **TP-CURL-04** | Hostile HOME / bashrc | **have** | version under stub bashrc |
| **TP-CURL-05** | Bad URL curl | **have** | not silent |
| **TP-CURL-06** | curl\|sh when bash required | **n/a** | product supports `/bin/sh` |
| **TP-CURL-07** | `sh -s -- version` | **have** | pipe version |
| **TP-CURL-08** | Unreachable SCRIPT_URL | **have** | non-zero; no binary |
| **TP-CURL-09** | Public online channel | **optional** | `RUN_ONLINE_CURL_TESTS=1` |

---

## TP-TIMER — Domain-subject family (`RQ-DOMAIN-TIMER` · `LM-NAMED-TIMER-DOMAIN`)

Domain product cases use **subject family** **`TP-TIMER-*`** (subject = `timer`).  
**Do not** use deprecated product **`TP-DOM-*`**.  
Proof mold **`PM-DOMAIN-TEST-PLAN`** is a design aid; Type O-P payload tokens **`TP-PAYLOAD-*`** are **n/a** here.  
Policy: `policy-harness-id-notation` §5.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-TIMER-01** | Help lists domain verbs/flags | **have** | start/stop/status/list/kill/reset/--persist |
| **TP-TIMER-02** | start / status / list / stop human | **have** | `test_timer_domain.sh` |
| **TP-TIMER-03** | already-running start fails | **have** | domain suite |
| **TP-TIMER-04** | JSON start/status/list/stop + number types | **have** | `timers` array; elapsed ints |
| **TP-TIMER-05** | `no_timer` error code | **have** | domain suite |
| **TP-TIMER-06** | kill / reset | **have** | domain suite |
| **TP-TIMER-07** | `invalid_name` | **have** | domain suite |
| **TP-PAYLOAD-*** | Type O-P payload scaffold (mold) | **n/a** | not a Type O-P payload product |

---

## TP-STORAGE — Domain dual-storage (`PM-DOMAIN-TEST-PLAN` shared)

**Domain record** modes only (volatile / persistent). **Not** shell about `effective_storage` (that is **TP-CLI-05**).

| TP-ID | Intent | Status | Evidence | Legacy alias |
|-------|--------|--------|----------|--------------|
| **TP-STORAGE-01** | Volatile domain record path | **have** | `/dev/shm`, `/tmp`, `$PREFIX/tmp`, or cache | was **TP-TIMER-09** |
| **TP-STORAGE-02** | `--persist` start/list/stop | **have** | domain suite | was **TP-TIMER-08** |
| **TP-STORAGE-03** | Corrupted state fail-closed | **n/a** | product does not claim corruption code path in suite | — |

---

## Static proof (finding lock-in)

| TP-ID | Intent | Status | Notes |
|-------|--------|--------|-------|
| **TP-CLASS-01** | Active class REQ registered | **have** | `RQ-CLASS-SOFTWARE-DEV` |
| **TP-CITE-01** | Ship unit ALIGNMENT cites live REQs | **have** | header lists class, shell, domain, storage, temp |
| **TP-ID-01** | `APP_NAME="…"` hard-assign | **have** | ship unit |
| **TP-MOLD-01** | Named-timer mandatory peers Active | **have** | CLI · shell storage · temp · output (static registry) |

---

## Type 1 elevation (plan completeness)

| Claim | Status |
|-------|--------|
| Type 1 host elevation / password sudo in product law | **Not claimed** — Type 0 only |
| **CL-SHELL-TTY-PRIVILEGE-TRAPS** TP rows | **N/A** |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have** (or supersedes with a new test).  
2. Do not mark TP **have** without a suite assertion (or documented static fix).  
3. Domain product: keep domain suite green (**TP-TIMER-*** + **TP-STORAGE-01/02**).  
4. Primary citation uses **TP-IDs** / **RQ-***; suite path secondary (policy-harness-id-notation).  
5. Versioned requirements list TP + `tests/*` + `reviews/*` only — never `docs/templates/**`.  
6. When adding TP cases end-to-end (mold + DTV + REQ + maps + suite) → **`skill-add-tests`**.  
7. Shell scratch (**TP-CLI-05**) and domain records (**TP-STORAGE-***) must not be collapsed into one owner.
