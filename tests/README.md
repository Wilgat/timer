# Tests (timer)

POSIX `/bin/sh` CI suite for the Type 0 + domain ship unit `./timer`.

Assert labels use portable **TP-IDs** (policy-harness-id-notation). Product map: `reviews/test-plan.md`. RTM: `reviews/requirement-test-matrix.md`.

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional:

```sh
APP_NAME=timer ./tests/run.sh
RUN_ONLINE_CURL_TESTS=1 ./tests/run.sh   # optional public channel smoke
```

## Suites

| Suite | File | TP families | Primary REQs |
|-------|------|-------------|--------------|
| CLI surface | `test_cli.sh` | TP-CLI, TP-CSUM-01/05, TP-U-01, TP-CLI-12 | `RQ-SHELL-CLI-INTERFACE`, `RQ-SHELL-OUTPUT-REQUIREMENTS`, `RQ-SHELL-AUTOMATIC-CHECKSUM` |
| Install lifecycle | `test_install_lifecycle.sh` | TP-LC, TP-CSUM-02..04 | `RQ-SHELL-SELF-MANAGEMENT`, `RQ-SHELL-IDEMPOTENCY`, `RQ-SHELL-AUTOMATIC-CHECKSUM` |
| Online curl\|sh | `test_online_curl_install.sh` | TP-CURL (local channel Core) | `RQ-SHELL-CLI-ZERO-ARGUMENTS`, `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` |
| Timer domain | `test_timer_domain.sh` | **TP-TIMER-01..09** (domain-subject family; not `TP-DOM`) | `RQ-DOMAIN-TIMER` |

## Proof molds (harness-local)

| PM-ID | Path (local) |
|-------|----------------|
| `PM-SHELL-CLI-TEST-PLAN` | `docs/templates/tests/template-shell-cli-test-plan.md` |
| `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `docs/templates/tests/template-install-lifecycle-test-plan.md` |
| `PM-CHECKSUM-TEST-PLAN` | `docs/templates/tests/template-checksum-test-plan.md` |
| `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `docs/templates/tests/template-online-curl-install-test-plan.md` |
| `PM-DOMAIN-TEST-PLAN` | `docs/templates/tests/template-domain-test-plan.md` |
| `PM-SET-U-TEST-PLAN` | `docs/templates/tests/template-set-u-test-plan.md` |
| `PM-REQUIREMENT-TEST-TRACEABILITY` | `docs/templates/tests/template-requirement-test-traceability.md` |

## Network / safety

- No secrets and no root.
- Core install/curl cases serve the checkout over `127.0.0.1` (no public GitHub required).
- Domain tests use isolated `HOME` for persistent storage and clean volatile timer files after the suite.
