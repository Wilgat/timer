# Tests (timer)

POSIX `/bin/sh` CI suite for the Type 0 + domain ship unit `./timer`.

Bootstrap architecture matches selfmanaged Type 0 tests; this suite is specialized for `APP_NAME=timer` and adds **timer domain** coverage.

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional override:

```sh
APP_NAME=timer ./tests/run.sh
```

## What is covered

| Suite | File | Focus |
|-------|------|--------|
| CLI surface | `test_cli.sh` | `sh -n`, companion digest, `version` / `help` / `about` (human + JSON), domain verbs in help, unknown command, quiet, `CHECKSUM` not on help/about, `env -u HOME`, zero-arg install failure exit, uninstall fail-closed JSON |
| Install lifecycle | `test_install_lifecycle.sh` | Isolated `HOME`/`USER_BIN`, local channel install, idempotent re-install, **Type O** zero-arg already-installed (local + global, not help), version-check JSON keys, self-update already-latest, human integrity transparency, uninstall refuse / `--force`, `CHECKSUM` pin match/mismatch, downgrade refuse / `--force` |
| Timer domain | `test_timer_domain.sh` | `start` / `stop` / `status` / `list`, `--json`, `--persist`, `kill` / `reset`, invalid name, already-running, `no_timer` |

## Mapping (product law)

Type 0 cases map to live `docs/requirements/requirement-shell-*.md` (CLI interface, zero-arguments, output, interactive, idempotency, self-management, automatic-checksum). Domain cases cover specialized timer commands on top of that architecture.

## Network / safety

- No secrets and no root.
- Install lifecycle serves the checkout over `127.0.0.1` (does not require public raw GitHub).
- Domain tests use isolated `HOME` for persistent storage and clean volatile timer files for the current user after the suite.
