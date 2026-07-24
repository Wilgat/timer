# Test plan — timer

Maps **portable TP families** (proof molds) to product-root `tests/`.  
**Suite entry:** `./tests/run.sh`  
**Last update:** 2026-07-24 (H2 sync, ID notation, full TP coverage + curl suite)

**Proof molds (cite by PM-ID):**

| Family | Proof mold-ID | Suite file |
|--------|---------------|------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle |
| **TP-U** | `PM-SET-U-TEST-PLAN` | CLI + curl (partial) |
| **TP-CURL** | `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `tests/test_online_curl_install.sh` |
| **TP-TIMER** | `PM-DOMAIN-TEST-PLAN` §4.3.2 (ops) | `tests/test_timer_domain.sh` |
| **TP-STORAGE** | `PM-DOMAIN-TEST-PLAN` §4.2 shared dual-storage | `tests/test_timer_domain.sh` |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` |
| RTM mold | `PM-REQUIREMENT-TEST-TRACEABILITY` | `reviews/requirement-test-matrix.md` |

Status: **have** = automated · **todo** = needed · **n/a** = not applicable · **optional** = gated

---

## Baseline result

| Date | Result | Notes |
|------|--------|-------|
| 2026-07-19 | PASS=133 FAIL=0 | Prior domain JSON number lock-in |
| 2026-07-24 | **PASS=187 FAIL=0 SKIP=1** | TP labels; lifecycle parity; TP-CURL local; domain TP-TIMER-02+ |

---

## TP-CLI — CLI surface (`PM-SHELL-CLI-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CLI-01** | Syntax + companion Shape A | **have** | `sh -n`; `timer.sha256` match |
| **TP-CLI-02** | Version human + JSON | **have** | version exit/app/version; `--debug` |
| **TP-CLI-03** | Help Type 0 + domain surface | **have** | install/self-*; start/stop/list; no CHECKSUM |
| **TP-CLI-04** | Help/about JSON purity | **have** | help/about JSON; about no CHECKSUM |
| **TP-CLI-05** | About shell storage resolve | **n/a** | domain owns storage (**TP-STORAGE-***) |
| **TP-CLI-06** | Unknown command | **have** | human + JSON `out_error` |
| **TP-CLI-07** | Quiet mode | **have** | `--quiet` and `-q` |
| **TP-CLI-08** | `env -u HOME` under set -u | **have** | also **TP-U-01** |
| **TP-CLI-09** | Zero-arg bad channel | **have** | non-zero; not silent; no binary |
| **TP-CLI-10** | bashrc+sdkman under set -u | **n/a** | No product sdkman/source path |
| **TP-CLI-11** | self-uninstall refuse without force | **have** | `confirm_required`; binary remains |
| **TP-CLI-12** | `out_json` `@key` raw nested | **have** | extracted harness |

**Legacy product-local IDs (retired → family):**

| Legacy | Now |
|--------|-----|
| TP-JSON-01 / T-JSON-01 | **TP-TIMER-04** |
| TP-JSON-02 / T-JSON-02 | **TP-TIMER-04** |
| TP-CSUM-01 (help hide) | **TP-CSUM-05** + **TP-CLI-03/04** |
| TP-UNIN-01 | **TP-CLI-11** |
| TP-SETU-01 | **TP-U-01** / **TP-CLI-08** |
| TP-TIMER-01..03 (old) | **TP-TIMER-01**, **TP-TIMER-02+** |

---

## TP-LC — Install lifecycle (`PM-INSTALL-LIFECYCLE-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-LC-01** | Empty-argv ensure (first + already local/global) | **have** | lifecycle suite |
| **TP-LC-02** | Payload `install` | **n/a** | Type O CLI — no domain payload project |
| **TP-LC-03** | Payload uninstall | **n/a** | No payload surface |
| **TP-LC-04** | About installed + version-check JSON | **have** | local/remote/is_latest |
| **TP-LC-05** | self-update already-latest | **have** | success message |
| **TP-LC-05b** | self-update when remote newer | **have** | upgrades VERSION |
| **TP-LC-06** | Force reinstall companion transparency | **have** | link/expected/actual/PASS |
| **TP-LC-07** | self-uninstall refuse / force + PATH cleanup | **have** | refuse + force remove |
| **TP-LC-08** | Downgrade refuse / force | **have** | `downgrade_blocked` |
| **TP-LC-09** | Bad channel empty argv | **have** | same class as **TP-CLI-09** |
| **TP-LC-10** | Idempotent re-install | **have** | “already installed” |
| **TP-LC-11** | version-check network failure | **have** | `network_error` |
| **TP-LC-12** | Explicit `install --json` | **have** | first install path |

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

## TP-TIMER — Domain-subject family (`RQ-DOMAIN-TIMER`)

Domain product cases use **`TP-TIMER-*`** (subject = `timer`), **not** portable **`TP-TIMER-*`**.  
Proof mold **`PM-DOMAIN-TEST-PLAN`** is a design aid only; Type O-P payload tokens are **`TP-PAYLOAD-*`** (n/a here).  
Policy: `policy-harness-id-notation` §5.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-TIMER-01** | Help lists domain verbs/flags | **have** | start/stop/status/list/kill/reset/--persist |
| **TP-TIMER-02** | start / status / list / stop human | **have** | `test_timer_domain.sh` |
| **TP-TIMER-03** | already-running start fails | **have** | domain suite |
| **TP-TIMER-04** | JSON start/status/list/stop + number types | **have** | timers array; elapsed ints |
| **TP-TIMER-05** | `no_timer` error code | **have** | domain suite |
| **TP-TIMER-06** | kill / reset | **have** | domain suite |
| **TP-TIMER-07** | `invalid_name` | **have** | domain suite |
| **TP-PAYLOAD-*** | Type O-P payload scaffold (mold) | **n/a** | not a Type O-P payload product |

---

## TP-STORAGE — Shared dual-storage (`PM-DOMAIN-TEST-PLAN` §4.2)

**Not subject-branded** (timer · countdown · pomo · peers). Primary storage proof IDs.

| TP-ID | Intent | Status | Evidence | Legacy alias |
|-------|--------|--------|----------|--------------|
| **TP-STORAGE-01** | Volatile storage path resolve | **have** | `/dev/shm` or `/tmp` file | was **TP-TIMER-09** |
| **TP-STORAGE-02** | `--persist` start/list/stop | **have** | domain suite | was **TP-TIMER-08** |
| **TP-STORAGE-03** | Corrupted state fail-closed | **n/a** | product does not claim corruption code path in suite | — |

**Legacy map:** ops remain **`TP-TIMER-01..07`**; storage **TP-TIMER-08/09** → **`TP-STORAGE-02/01`**.


---

## Static proof (finding lock-in)

| TP-ID | Intent | Status | Notes |
|-------|--------|--------|-------|
| **TP-CLASS-01** | Active class REQ registered | **have** | `RQ-CLASS-SOFTWARE-DEV` |
| **TP-CITE-01** | Ship unit ALIGNMENT cites live REQs | **have** | header comments |
| **TP-ID-01** | `APP_NAME="…"` hard-assign | **have** | ship unit |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have** (or supersedes with a new test).  
2. Do not mark TP **have** without a suite assertion (or documented static fix).  
3. Domain product: keep domain suite green.  
4. Primary citation uses **TP-IDs** / **RQ-***; suite path secondary (policy-harness-id-notation).  
5. Versioned requirements list TP + `tests/*` + `reviews/*` only — never `docs/templates/**`.  
