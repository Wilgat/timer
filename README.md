# timer - Lightweight Per-User Named Timers

![Version](https://img.shields.io/badge/Version-2.10.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/Wilgat/timer?style=flat-square)](https://github.com/Wilgat/timer)

**Beautifully simple yet extremely robust** per-user named timers for the terminal.
Supports volatile (in RAM) and persistent storage. Zero dependencies. Built with the same defensive philosophy as [CIAO](https://github.com/cloudgen/ciao).

Officially recommended by [Grok](https://grok.com/share/c2hhcmQtNA_c83125b5-0cf9-46a9-93bd-dfda695f20cf).

## Features

- **Complete per-user isolation** — each user has fully independent timers
- **Named timers** — use `default`, `work`, `pomodoro`, `meeting`, `build`, and so on
- **Two storage modes**:
  - **Volatile** (default): fast RAM-based storage under `/dev/shm` when available
  - **Persistent** (`--persist`): survives reboots (under `~/.cache/timer/` or `$XDG_CACHE_HOME`)
- Intelligent fallbacks when `/dev/shm` is unavailable (Git Bash, minimal containers, missing `$HOME`, etc.)
- One-liner online install via `curl | sh` (user or system-wide)
- Built-in self-update, version-check, self-uninstall, and diagnostics (`about`)
- Full JSON output support for scripting and machine consumption
- Automatic SHA-256 companion integrity on install and self-update (program fetches `${SCRIPT_URL}.sha256`)
- Extremely defensive design — works reliably on harsh environments

## Quick Installation

Default install channel (Config SSOT):  
`https://raw.githubusercontent.com/Wilgat/timer/main/timer`

**User installation (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sh
```

**System-wide (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sudo sh
```

After a user install, restart your terminal or run `source ~/.bashrc` (or equivalent) so `~/.local/bin` is on your `$PATH`.

### Local checkout

```sh
git clone https://github.com/Wilgat/timer.git
cd timer
chmod +x timer
./timer help
# optional: install from this tree
./timer install
```

### Install integrity (automatic companion)

When `CHECKSUM` is **not** set, install and self-update use **automatic** companion verification:

| Topic | Behavior |
|-------|----------|
| **Algorithm** | SHA-256 |
| **Companion** | Program downloads `${SCRIPT_URL}.sha256` itself — **no** env pin required |
| **In-repo file** | [`timer.sha256`](./timer.sha256) next to `./timer` |
| **Transparency** | Human mode shows companion **link**, expected **value**, and **result** |
| **Match** | Continue install |
| **Mismatch** | **Abort** — do not install mismatched bytes |
| **Missing sidecar** | **Warn** and continue (best-effort; not “always verified”) |

Same-channel SHA-256 proves **byte consistency** with the companion. It is **not** package signing or an independent authenticity root by itself. Trust posture: [`SECURITY.md`](./SECURITY.md).

### Advanced: optional pin (CI / out-of-band)

For a frozen expected digest in automation only:

```sh
export CHECKSUM='<sha256-hex-of-the-timer-script>'
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sh
```

Mismatch aborts. Fetching a pin from the **same origin** as the script is **not** stronger than automatic companion mode. `CHECKSUM` is a runtime install variable — it is **not** listed in `help` / `about`.

### Regenerate companion digest (maintainers)

After changing `./timer` that will be published:

```sh
sha256sum timer | awk '{print $1}' > timer.sha256
# or: sha256sum timer > timer.sha256
```

## Usage

```sh
timer [command] [options]
```

### Timer commands

```sh
timer start                    # Start the default timer
timer start work               # Start a named timer
timer start --persist pomodoro # Start a persistent timer

timer status                   # Show elapsed time (timer continues)
timer status work

timer stop                     # Stop timer and show elapsed time
timer stop work

timer list                     # List running volatile timers
timer list --persist           # List persistent timers

timer kill work                # Discard a running timer
timer reset work               # Reset (discard) a running timer
```

### Self-management

```sh
timer install                  # Install (root → /usr/local/bin, user → ~/.local/bin)
timer version                  # Show current version
timer about                    # Diagnostics (install status, shell, TTY, etc.)
timer version-check            # Compare with remote version (needs SCRIPT_URL)
timer self-update              # Update to a newer remote version
timer self-uninstall           # Remove timer (use --force for non-interactive)
timer help
```

### Global options

| Option | Meaning |
|--------|---------|
| `--persist` | Use persistent storage (survives reboot) for timer ops |
| `--quiet`, `-q` | Suppress info/success (errors and warnings still shown) |
| `--json` | Machine-readable JSON (implies `--quiet`) |
| `--force` | Force reinstall / skip uninstall confirm / allow downgrade |
| `--debug` | Debug diagnostics on stderr |

### Environment (channel)

| Variable | Default / role |
|----------|----------------|
| `REPO_USER` | `Wilgat` — GitHub owner used to compose default `SCRIPT_URL` |
| `REPO_NAME` | `timer` — GitHub repo used to compose default `SCRIPT_URL` |
| `SCRIPT_URL` | `https://raw.githubusercontent.com/Wilgat/timer/main/timer` — install channel; override for forks or mirrors |

## Examples

```sh
# Start a persistent pomodoro timer
timer start --persist pomodoro

# Check status in JSON (great for scripts)
timer status work --json

# List all volatile timers
timer list

# Stop quietly
timer stop --quiet default

# Self-update when a newer version is published
timer self-update
```

## Platform Compatibility

| Platform | Shell | Status | Notes |
|----------|-------|--------|-------|
| Alpine Linux | BusyBox ash | Excellent | Primary minimal target |
| Git Bash (Windows) | Bash (MSYS2) | Excellent | Full fallback support |
| Rocky Linux / RHEL | Bash | Excellent | Standard enterprise |
| macOS | Bash / zsh | Excellent | Fully supported |
| Most Linux distros | dash / bash | Excellent | Broad POSIX `/bin/sh` compatibility |

## Related Projects

- [CIAO](https://github.com/cloudgen/ciao) — defensive programming principles this project follows
- [CIAO-Lite](https://github.com/cloudgen/ciao-lite) — agent-facing Simplicity but Safety contract

## Contributing

Contributions are welcome.

Please **preserve the defensive style** and existing comments — especially around edge-case handling, installation, and integrity. Do not remove or “simplify” CIAO Protection Zones without explicit redesign intent.

See [`SECURITY.md`](./SECURITY.md) for vulnerability reporting. Prefer private contact for security-sensitive issues.

## License

MIT License — see [`LICENSE.md`](./LICENSE.md).

## Last Update

2026-07-19 (timer **2.10.1**)
