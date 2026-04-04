# timer - Lightweight Per-User Named Timers

![Version](https://img.shields.io/badge/Version-2.7.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**Beautifully simple yet extremely robust** per-user named timers for the terminal.  
Supports volatile (in RAM) and persistent storage. Zero dependencies. Built with the same defensive philosophy as other tools by Wilgat.

---

## ✨ Features

- **Complete per-user isolation** — each user has fully independent timers
- **Named timers** — use `default`, `work`, `pomodoro`, `meeting`, `build`, etc.
- **Two storage modes**:
  - **Volatile** (default): Fast RAM-based storage in `/dev/shm`
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/timer/`)
- Intelligent fallbacks when `/dev/shm` is unavailable (Git Bash, minimal containers, no `$HOME`, etc.)
- One-liner install via `curl | sh`
- Supports both user (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version check, and full diagnostics (`about`)
- `--quiet` and `--json` mode support (JSON output partially prepared)
- Extremely defensive design — works reliably on harsh environments

---

## 🚀 Quick Installation

**User installation (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sh
```

**System-wide (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sudo sh
```

After installation, restart your terminal or run `source ~/.bashrc` (or equivalent) so `~/.local/bin` is in your `$PATH`.

---

## 📖 Usage

### Basic Commands

```sh
timer start                    # Start the default timer
timer start work               # Start a named timer
timer start --persist pomodoro # Start a persistent timer

timer status                   # Show elapsed time (timer continues)
timer status work

timer stop                     # Stop timer and show elapsed time
timer stop work

timer list                     # List all running volatile timers
timer list --persist           # List persistent timers

timer kill work                # Discard a running timer
timer reset work               # Reset timer (currently same as kill)
```

### Information & Maintenance

```sh
timer about                    # Show detailed diagnostics (install status, versions, shell, TTY, etc.)
timer version
timer version-check            # Compare with latest version on GitHub
timer self-update              # Update to the latest version
timer help
```

### Options

- `--persist`          — Store timer in persistent storage (survives reboot)
- `--quiet, -q`        — Suppress non-error messages
- `--json`             — Machine-readable JSON output (implies `--quiet`; full implementation coming soon)

---

## Why the Defensive Style?

This script is **intentionally verbose**, heavily commented, and contains repeated safety checks. This is deliberate.

It protects against real-world edge cases:
- `curl | sh` in non-interactive environments
- Minimal shells (`dash`, BusyBox `ash`)
- Missing `$HOME`, no `/dev/shm`, restricted containers
- Git Bash on Windows

The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` comments exist to prevent well-meaning "cleanups" that often break subtle but critical behaviors in harsh environments. The same philosophy is used in other tools like **ciao**.

It may look "ugly" to modern eyes, but this approach has proven extremely reliable across diverse systems.

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                              |
|-----------------------|----------------------|------------|------------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary minimal target             |
| Git Bash (Windows)    | Bash (MSYS2)         | Excellent  | Full fallback support              |
| Rocky Linux / RHEL    | Bash                 | Excellent  | Standard enterprise                |
| macOS                 | Bash / zsh           | Excellent  | Fully supported                    |
| Most Linux distros    | dash / bash          | Excellent  | Broad compatibility                |

---

## Program Structure

The entire tool is a **single self-contained shell script** with clear separation of concerns:

- Safe defaults and constants
- Root / environment detection
- Centralized output system (`output_text` + `output_json`)
- Smart storage resolver with fallbacks
- Dedicated command handlers
- Central `main()` dispatcher

All critical paths include defensive checks. Heavy commenting serves as both documentation and protection against future refactoring.

---

## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing comments — especially around edge-case handling and installation logic.

---

## License

MIT License

---

**Made with care and a healthy dose of paranoia.** ⏱️

*Last updated for version 2.7.1*
