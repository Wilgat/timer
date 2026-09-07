# Requirement ↔ test matrix — timer

| Field | Value |
|-------|--------|
| **Product** | timer · `VERSION=2.13.0` |
| **Updated** | 2026-09-07 |
| **Map** | `reviews/test-plan.md` |
| **Suite** | `./tests/run.sh` |
| **Baseline** | PASS=246 FAIL=0 SKIP=1 |
| **Portable RTM mold** | `PM-REQUIREMENT-TEST-TRACEABILITY` |

Primary citation: **Requirement-ID (`RQ-*`)**, **law mold-ID (`LM-*`)** for specialize provenance, and **TP-***. Paths secondary.  
Git-surface: versioned REQs list TP + `tests/*` + `reviews/*` only (no `docs/templates/**` paths).

---

## Traceability table

| Requirement-ID | Key | Specialized from (LM) | Proof mold (PM) | TP families | Suite files | Core status |
|----------------|-----|----------------------|-----------------|-------------|-------------|-------------|
| **RQ-CLASS-SOFTWARE-DEV** | requirement-class-software-dev | **LM-REQUIREMENT-CLASS-SOFTWARE-DEV** | — | TP-CLASS-01; suite green | static + `tests/run.sh` | **have** |
| **RQ-SHELL-CLI-INTERFACE** | requirement-shell-cli-interface | **LM-CLI-INTERFACE** | **PM-SHELL-CLI-TEST-PLAN** | TP-CLI-*; TP-TIMER-01; **TP-TX-01..05**; **TP-TX-08**; **TP-CLI-16/17/29** | `test_cli.sh`, `test_timer_domain.sh` | **have** |
| **RQ-SHELL-CLI-DEFAULT-INTERACTION** | requirement-shell-cli-default-interaction | **LM-CLI-DEFAULT-INTERACTION** | **PM-SHELL-CLI-TEST-PLAN** | **TP-CLI-07**; **TP-CLI-16**; **TP-CLI-17**; **TP-CLI-29** | `test_cli.sh` | **have** |
| **RQ-SHELL-SCRIPT-CODING** | requirement-shell-script-coding | **LM-SHELL-SCRIPT-CODING** | **PM-SHELL-TERMUX-ISH-TEST-PLAN** (detect) | TP-CLI-01; **TP-TX-01..05**; **TP-TX-08** | `test_cli.sh` | **have** |
| **RQ-SHELL-CLI-STORAGE** | requirement-shell-cli-storage | **LM-SHELL-CLI-STORAGE** | **PM-SHELL-CLI-TEST-PLAN** | **TP-CLI-05**; **TP-TX-08** | `test_cli.sh` | **have** |
| **RQ-SHELL-CLI-ZERO-ARGUMENTS** | requirement-shell-cli-zero-arguments | **LM-SHELL-CLI-ZERO-ARGUMENTS** | PM-SHELL-CLI · PM-INSTALL · PM-CURL | TP-CLI-09; TP-CLI-07; TP-CLI-29; TP-LC-01/09; TP-CURL-02/03/08; TP-U-02 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-TEMP-FILE-SYSTEM** | requirement-shell-temp-file-system | **LM-TEMP-FILE-SYSTEM** | PM-INSTALL · PM-CHECKSUM · PM-SHELL-CLI | TP-LC-06/12; TP-CSUM-02..04; TP-CLI-05 | lifecycle, CLI | **have** |
| **RQ-SHELL-OUTPUT-REQUIREMENTS** | requirement-shell-output-requirements | **LM-OUTPUT-REQUIREMENTS** | **PM-SHELL-CLI-TEST-PLAN** | TP-CLI-02/04/06/07/12; TP-TIMER-04 | CLI, domain | **have** |
| **RQ-SHELL-AUTOMATIC-CHECKSUM** | requirement-shell-automatic-checksum | **LM-AUTOMATIC-CHECKSUM** | **PM-CHECKSUM-TEST-PLAN** | TP-CSUM-01..05; TP-LC-06 | CLI, lifecycle | **have** |
| **RQ-SHELL-SELF-MANAGEMENT** | requirement-shell-self-management | **LM-SELF-MANAGEMENT** | **PM-INSTALL-LIFECYCLE-TEST-PLAN** | TP-LC-04..08,11,12; TP-CLI-11; TP-CURL-02/07 | lifecycle, CLI, curl | **have** |
| **RQ-SHELL-IDEMPOTENCY** | requirement-shell-idempotency | **LM-IDEMPOTENCY** | PM-INSTALL · PM-CURL | TP-LC-01/05/10; TP-CURL-03 | lifecycle, curl | **have** |
| **RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE** | requirement-shell-interactive-vs-noninteractive | **LM-INTERACTIVE-VS-NONINTERACTIVE** | PM-SHELL-CLI · PM-CURL | TP-CLI-07/11; TP-LC-07; TP-CURL-02/03 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-MODULAR-FUNCTION-DESIGN** | requirement-shell-modular-function-design | **LM-MODULAR-FUNCTION-DESIGN** | **PM-SHELL-CLI-TEST-PLAN** | TP-CLI-01; review | CLI + review | **have** |
| **RQ-DOMAIN-TIMER** | requirement-domain-timer | **LM-NAMED-TIMER-DOMAIN** (+ base **LM-SHELL-INTERNAL-VOLATILE-TIMER**) | **PM-DOMAIN-TEST-PLAN** | **TP-TIMER-01..07**; **TP-STORAGE-01/02**; **TP-TX-08** | `test_timer_domain.sh`, `test_cli.sh` | **have** |

---

## Named-timer mandatory peers (`LM-NAMED-TIMER-DOMAIN` §1.1)

| Peer mold concern | Requirement-ID | Status |
|-------------------|----------------|--------|
| CLI interface | **RQ-SHELL-CLI-INTERFACE** | **have** |
| Shell CLI storage | **RQ-SHELL-CLI-STORAGE** | **have** |
| Temp file system | **RQ-SHELL-TEMP-FILE-SYSTEM** | **have** |
| Output | **RQ-SHELL-OUTPUT-REQUIREMENTS** | **have** |

---

## n/a (honest)

| Family / item | Why |
|---------------|-----|
| **TP-PAYLOAD-*** | Not a Type O-P payload product |
| **TP-CLI-10** | No product sdkman/source path |
| **TP-DOM-*** | Deprecated product family — use **TP-TIMER-*** |
| **TP-STORAGE-03** | Corrupted-state path not claimed in suite |
| Separate **LM-ONLINE-INSTALL** REQ | Online package covered by zero-arg + self-management + automatic-checksum (no dual local install) |
| Type 1 TTY/sudo TP rows | Product does not claim Type 1 elevation |
| **TP-LC-16** named `pkg install` | No Termux package list; detect/ceiling only |
| **TP-TX-06** / **TP-TX-07** | No guest/proot one-shot dispatch |

---

## Storage ownership split

| Surface | Law | Proof |
|---------|-----|-------|
| Shell scratch / about fields / TMPDIR parent | **RQ-SHELL-CLI-STORAGE** · **RQ-SHELL-TEMP-FILE-SYSTEM** | **TP-CLI-05** · TP-LC / TP-CSUM |
| Domain timer records (volatile / persist) | **RQ-DOMAIN-TIMER** | **TP-STORAGE-01/02** · **TP-TIMER-*** |

---

**Law mold ↔ proof mold (portable design):** load `PM-REQUIREMENT-TEST-TRACEABILITY` under local harness templates/tests. Product maps stay under `reviews/` only.
