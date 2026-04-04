# timer - Lightweight Per-User Named Timers

<img src="https://img.shields.io/badge/Version-2.6.1-blue?style=flat-square" alt="Version">
<img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">

**Beautifully simple, extremely robust** per-user named timers for the terminal.  
Volatile (in RAM) or persistent. Zero dependencies. Built with the same defensive philosophy as [ciao](https://github.com/Wilgat/ciao).

---

## ✨ Features

- **Per-user isolation** — timers are completely separate per user
- **Named timers** — `default`, `work`, `pomodoro`, `meeting`, etc.
- **Two storage modes**:
  - **Volatile** (default): Fast, in `/dev/shm` — lost on reboot
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/timer/`)
- Smart fallback when `/dev/shm` is unavailable (Git Bash, minimal containers, etc.)
- One-liner install via `curl | sh`
- Supports user (`~/.local/bin`) and system-wide (`/usr/local/bin`) installation
- Built-in self-update, version check, and diagnostics (`about`)
- `--json` output mode (planned / partially prepared)
- Extremely defensive — works reliably on Alpine (BusyBox ash), Git Bash, macOS, Rocky Linux, and more

---

## 🚀 Quick Installation

**User installation (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sh
```

**System-wide (root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/main/timer | sudo sh
```

---

## 📖 Usage

```sh
# Start timers
timer start                    # Start default timer
timer start work               # Start a named timer
timer start --persist pomodoro # Persistent timer (survives reboot)

# Query timers
timer status                   # Show elapsed time (without stopping)
timer status work
timer stop                     # Stop and display elapsed time
timer stop work

# Management
timer list                     # List all running timers
timer list --persist           # List only persistent timers
timer kill work                # Discard a timer
timer reset work               # Reset (same as kill in current version)

# Information & Maintenance
timer about                    # Show diagnostics (install status, versions, shell, etc.)
timer version
timer version-check
timer self-update
timer help
```

**Options:**
- `--persist` — Use persistent storage
- `--quiet, -q` — Suppress non-error output
- `--json` — Machine-readable JSON output (implies `--quiet`; full support coming soon)

---

## Why This Defensive Style?

The script is **intentionally verbose**, heavily commented, and full of repeated safety checks. This is not accidental.

It protects against real-world edge cases such as:
- `curl | sh` installation in non-interactive environments
- Minimal shells (`dash`, BusyBox `ash`)
- Missing `$HOME`, no `/dev/shm`, restricted containers
- Git Bash on Windows

The many `!!! DO NOT MODIFY OR SIMPLIFY !!!` warnings exist to prevent well-meaning "cleanups" from breaking subtle but critical behaviors. This same philosophy powers other tools like **ciao**.

While it may look "ugly" to some, this style has proven extremely reliable across diverse systems.

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                          |
|-----------------------|----------------------|------------|--------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary minimal target         |
| Git Bash (Windows)    | Bash (MSYS2)         | Excellent  | Full fallback support          |
| Rocky/RHEL/CentOS     | Bash                 | Excellent  | -                              |
| macOS                 | Bash / zsh           | Excellent  | -                              |
| Most Linux distros    | dash / bash          | Excellent  | -                              |

---

## Program Structure

The script is a **single self-contained file** with clear separation:

- Constants & safe defaults
- Environment / root detection
- Logging & color system
- Core helpers (`resolve_timer_base_dir`, `get_timer_file`, etc.)
- Dedicated command functions (`timer_start`, `timer_stop`, ...)
- Central `main()` dispatcher (kept simple on purpose)

All critical paths are protected. The heavy commenting serves as both documentation and protection against future refactoring.

---

## Contributing

Contributions are welcome.  
When submitting changes, **please preserve the defensive style and existing comments**, especially around edge-case handling.

---

## License

MIT

---

**Made with care and a healthy dose of paranoia.**  
Enjoy your timers! ⏱️

---

*Last updated for version 2.6.1*