# timer - Beautiful & Flexible Per-User Timer

<img src="https://img.shields.io/badge/Version-2.1.2-blue?style=flat-square" alt="Version">
<img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">

**Lightweight per-user named timers** — volatile (in RAM) or persistent.  
Built with the same defensive philosophy as **ciao**.

> A robust, zero-dependency POSIX shell script for starting, stopping, and monitoring named timers in the terminal.

---

## ✨ Features

- **Per-user isolation** — each user has their own independent timers
- **Named timers** — `default`, `work`, `coffee`, `meeting`, etc.
- **Volatile mode** (default): lives in `/dev/shm` → disappears on reboot
- **Persistent mode** (`--persist`): survives reboots (stored in `~/.cache/timer/`)
- One-liner install (`curl | sh`)
- Supports both **user** (`~/.local/bin`) and **root/system** (`/usr/local/bin`) installation
- Full self-update and version checking
- Extremely defensive code — works on Alpine (BusyBox ash), Git Bash, macOS, Rocky Linux, etc.
- No external dependencies

---

## 🚀 Quick Installation

**For normal users:**

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
timer start                # Start default timer
timer start work           # Start named timer
timer start --persist pomodoro   # Persistent timer

timer status               # Show elapsed time (without stopping)
timer stop                 # Stop and show elapsed time
timer kill work            # Force discard a timer

timer list                 # List all running timers
timer list --persist       # List persistent timers only

timer --version
timer --version-check
timer --self-update
timer --help
```

---

## Program Structure (for curious people)

This script is intentionally written in a **verbose, heavily commented, and defensive style**. Every critical section is protected against common edge cases (non-interactive shells, minimal environments, missing variables, etc.).

### Overall Architecture

```
timer (single file shell script)
├── Header & Metadata
├── Constants & Safe Defaults
├── Root / Environment Detection
├── Color & Logging System
├── Core Helper Functions
│   ├── get_timer_file()          → Determines storage path
│   ├── list_timers()             → Shows all active timers
│   ├── is_installed()            → Robust install check
│   ├── get_installed_version()
│   ├── version_check()
│   ├── self_update()
│   ├── show_install_suggestion() → curl | sh logic
│   └── show_timer_help()
├── Main Argument Parser
├── Command Handler (start/stop/status/list/kill)
└── Entry Point
```

### Key Design Decisions

- **Single-file design**: Everything is contained in one executable script for maximum portability.
- **Defensive programming**: Uses `: "${VAR:=default}"` pattern extensively to prevent undefined variable errors.
- **Two storage backends**:
  - Volatile → `/dev/shm/timer_${USER}_${NAME}` (fast, in-memory, lost on reboot)
  - Persistent → `~/.cache/timer/timer_${USER}_${NAME}` (survives reboot)
- **Self-contained installation**: The script can install, update, and maintain itself.
- **POSIX compatibility**: Carefully written to run on `dash`, `ash` (BusyBox), and Bash without relying on bashisms.
- **Non-interactive safety**: All interactive prompts are skipped when run via `curl | sh` or in scripts.

The heavy commenting and "DO NOT SIMPLIFY" warnings are deliberate — they protect subtle but important behaviors that have been refined through real-world testing across many environments.

---

## Why This Coding Style & Heavy Comments?

This is completely intentional.

The verbose style, repeated safe defaults, extensive comments, and explicit warnings (`!!! DO NOT MODIFY OR SIMPLIFY !!!`) exist to protect the script from breaking in edge cases such as:

- `curl | sh` installation
- Non-interactive environments (CI, Docker, cron)
- Minimal shells (`dash`, BusyBox `ash`)
- Missing `$HOME`, no `/dev/shm`, Git Bash on Windows, etc.

This defensive approach was refined through real-world testing and is shared with other tools like **ciao**. While it may look overly cautious to some, it ensures maximum reliability and portability across very different systems. Clean, minimalist code often fails silently in these scenarios — this style doesn't.

---

## Platform Compatibility

| Platform          | Shell              | Status     | Notes |
|-------------------|--------------------|------------|-------|
| Alpine Linux      | BusyBox ash        | Excellent  | Primary minimal target |
| Git Bash          | Bash (MSYS2)       | Excellent  | Windows support |
| Rocky/RHEL/CentOS | Bash               | Excellent  | - |
| macOS             | Bash / zsh         | Excellent  | - |
| Most Linux distros| dash / bash        | Excellent  | - |

---

## Contributing

Feel free to open issues or PRs.  
When modifying core functions, **please preserve the defensive style and comments**.

---

## License

MIT

---

**Made with the same care and paranoia as [ciao](https://github.com/Wilgat/ciao).**  
Enjoy your timers! ⏱️
