# Test plan — timer

Maps **baseline coverage** and **finding lock-in (TP-*)** to `tests/`.  
**Suite entry:** `./tests/run.sh`  
**Last update:** 2026-07-19 (JSON number types + class gate)

Status: **have** = automated today · **TODO** = needed · **n/a** = not applicable / product choice

---

## Baseline coverage (Type 0)

| Area | Coverage | Evidence |
|------|----------|----------|
| Syntax | have | `sh -n timer` (via suite) |
| Companion digest matches ship unit | have | `timer.sha256` check in suite |
| version / help / about human + JSON | have | `tests/test_cli.sh` |
| help must not list CHECKSUM | have | test_cli |
| about must not include CHECKSUM | have | test_cli |
| Unknown command fail-closed | have | test_cli |
| quiet / env -u HOME | have | test_cli |
| Zero-arg Type O paths | have | test_cli + lifecycle |
| self-uninstall --json without --force | have | confirm_required, no fake success |
| Install / re-install idempotent | have | test_install_lifecycle |
| version-check local channel | have | lifecycle |
| self-update already-latest | have | lifecycle |
| Companion transparency (link/value/PASS) | have | human install messages |
| CHECKSUM match / mismatch | have | lifecycle |
| Downgrade blocked / --force | have | lifecycle |

## Baseline coverage (domain)

| Area | Coverage | Evidence |
|------|----------|----------|
| start / status / list / stop human | have | `tests/test_timer_domain.sh` |
| already-running fail | have | domain suite |
| JSON start / status / list / stop | have | domain suite |
| no_timer error code | have | domain suite |
| kill / reset | have | domain suite |
| invalid_name | have | domain suite |
| --persist start / list / stop | have | domain suite |
| JSON `timers` nested array | **have** | TP-JSON-01 — python3 isinstance list |
| JSON elapsed/count as numbers | **have** | TP-JSON-02 — status/stop/list type checks |

**Baseline result (2026-07-19):** PASS=133 FAIL=0 SKIP=0

---

## Finding-linked TP rows

| TP-ID | Related finding / lesson | Intent | Status | Target / notes |
|-------|--------------------------|--------|--------|----------------|
| TP-JSON-01 | T-JSON-01, L-JSON-01 | `list --json` → `timers` nested array | **have** | `test_timer_domain.sh` |
| TP-JSON-02 | T-JSON-02, L-JSON-02 | status/stop elapsed + list count are JSON numbers | **have** | `test_timer_domain.sh` |
| TP-CLASS-01 | T-CLASS-01, L-CLASS-01 | Active `requirement-class-software-dev.md` registered | **have** | Static + registry 2026-07-19 |
| TP-CITE-01 | T-CITE-01, L-CITE-01 | Ship unit top ALIGNMENT includes domain REQ | **have** | Static fix 2026-07-16 |
| TP-CITE-02 | T-CITE-02 | Bootstrap cites requirements not terminologies | **have** | Static fix 2026-07-16 |
| TP-ID-01 | T-ID-01, L-ID-01 | `APP_NAME="…"` hard-assign | **have** | Static fix 2026-07-16 |
| TP-DOM-01 | L-DOM-01 | Domain verbs routed + domain suite | **have** | test_timer_domain.sh |
| TP-DOM-02 | L-DOM-02 | invalid_name rejected | **have** | domain suite |
| TP-DOM-03 | L-DOM-03 | already-running start fails | **have** | domain suite |
| TP-CSUM-01 | L-CSUM-01 | help/about never advertise CHECKSUM | **have** | test_cli |
| TP-BOOT-01 | L-BOOT-01 | Always reach app_main under pipe | **have** | Indirect via zero-arg install tests |
| TP-UNIN-01 | L-UNIN-01 | self-uninstall --json no force → confirm_required | **have** | test_cli + lifecycle |
| TP-SETU-01 | L-SETU-01 | env -u HOME still works | **have** | test_cli |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have** (or supersedes with a new test).  
2. Do not mark TP **have** without a suite assertion (or documented static fix for cite/ID shape).  
3. Domain product: keep domain suite green.  
