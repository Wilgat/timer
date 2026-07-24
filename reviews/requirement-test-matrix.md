# Requirement ↔ test matrix — timer

**Product:** timer  
**Updated:** 2026-07-24  
**Map:** `reviews/test-plan.md`  
**Suite:** `./tests/run.sh`  
**Portable RTM mold:** `PM-REQUIREMENT-TEST-TRACEABILITY` (local harness)

Primary citation: **Requirement-ID (`RQ-*`)**, **law mold-ID (`LM-*`)** for specialize provenance, and **TP-***. Paths secondary.  
Git-surface: versioned REQs list TP + `tests/*` + `reviews/*` only (no `docs/templates/**` paths).

| Requirement-ID | Key | Specialized from (LM / design) | TP families | Suite files | Core status |
|----------------|-----|--------------------------------|-------------|-------------|-------------|
| **RQ-CLASS-SOFTWARE-DEV** | requirement-class-software-dev | **LM-REQUIREMENT-CLASS-SOFTWARE-DEV** | TP-CLASS-01; suite green | static + `tests/run.sh` | **have** |
| **RQ-SHELL-CLI-INTERFACE** | requirement-shell-cli-interface | **LM-CLI-INTERFACE** | TP-CLI-*; TP-TIMER-01 | `test_cli.sh`, `test_timer_domain.sh` | **have** |
| **RQ-SHELL-CLI-ZERO-ARGUMENTS** | requirement-shell-cli-zero-arguments | **LM-SHELL-CLI-ZERO-ARGUMENTS** | TP-CLI-09; TP-LC-01/09; TP-CURL-02/03/08; TP-U-02 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-OUTPUT-REQUIREMENTS** | requirement-shell-output-requirements | **LM-OUTPUT-REQUIREMENTS** | TP-CLI-02/04/06/07/12; TP-TIMER-04 | CLI, domain | **have** |
| **RQ-SHELL-AUTOMATIC-CHECKSUM** | requirement-shell-automatic-checksum | **LM-AUTOMATIC-CHECKSUM** | TP-CSUM-01..05; TP-LC-06 | CLI, lifecycle | **have** |
| **RQ-SHELL-SELF-MANAGEMENT** | requirement-shell-self-management | **LM-SELF-MANAGEMENT** | TP-LC-04..08,11,12; TP-CLI-11; TP-CURL-02/07 | lifecycle, CLI, curl | **have** |
| **RQ-SHELL-IDEMPOTENCY** | requirement-shell-idempotency | **LM-IDEMPOTENCY** | TP-LC-01/05/10; TP-CURL-03 | lifecycle, curl | **have** |
| **RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE** | requirement-shell-interactive-vs-noninteractive | **LM-INTERACTIVE-VS-NONINTERACTIVE** | TP-CLI-07/11; TP-LC-07; TP-CURL-02/03 | CLI, lifecycle, curl | **have** |
| **RQ-SHELL-MODULAR-FUNCTION-DESIGN** | requirement-shell-modular-function-design | **LM-MODULAR-FUNCTION-DESIGN** | TP-CLI-01; review | CLI + review | **have** |
| **RQ-DOMAIN-TIMER** | requirement-domain-timer | **PM-DOMAIN-TEST-PLAN** → **TP-TIMER** (no domain law mold) | **TP-TIMER-01..09** | `test_timer_domain.sh` | **have** |

**n/a (honest):**

| Family | Why |
|--------|-----|
| **TP-PAYLOAD-*** | Not a Type O-P payload product |
| **TP-CLI-05** shell storage fields | Domain owns storage (**TP-TIMER-09**) |
| **TP-CLI-10** | No product sdkman/source path |
| **TP-DOM-*** | Deprecated product family — use **TP-TIMER-*** |

**Law mold ↔ proof mold (portable design):** load `PM-REQUIREMENT-TEST-TRACEABILITY` under local harness templates/tests.
