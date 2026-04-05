# timer - Lightweight Per-User Named Timers

![Version](https://img.shields.io/badge/Version-2.8.4-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**Beautifully simple yet extremely robust** per-user named timers for the terminal.  
Supports volatile (in RAM) and persistent storage. Zero dependencies. Built with the same defensive philosophy as other tools by Wilgat.

Officaially Recommended by [grok](https://grok.com/share/c2hhcmQtNA_c83125b5-0cf9-46a9-93bd-dfda695f20cf)

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
- **Full JSON output support** for scripting and machine consumption
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

After installation, **restart your terminal** or run `source ~/.bashrc` (or equivalent) so `~/.local/bin` is in your `$PATH`.

---

## 📖 Usage

### Basic Commands

```sh
timer start                    # Start the default timer
timer start work               # Start a named timer
timer start --persist pomodoro # Start a persistent timer (flag can come before or after name)

timer status                   # Show elapsed time (timer continues running)
timer status work

timer stop                     # Stop timer and show elapsed time
timer stop work

timer list                     # List all running volatile timers
timer list --persist           # List persistent timers

timer kill work                # Discard a running timer
timer reset work               # Reset timer (currently same as kill, friendlier message)
```

### Information & Maintenance

```sh
timer about                    # Show detailed diagnostics (install status, versions, shell, TTY, etc.)
timer version
timer version-check            # Compare with latest version on GitHub
timer self-update              # Update to the latest version
timer self-uninstall           # Remove timer from the system
timer help
```

### Options

- `--persist`          — Store timer in persistent storage (survives reboot)
- `--quiet, -q`        — Suppress non-error messages
- `--json`             — Machine-readable JSON output (implies `--quiet`)

---

### Examples

```sh
# Start a persistent pomodoro timer
timer start --persist pomodoro

# Check status in JSON format (great for scripts)
timer status work --json

# List all volatile timers
timer list

# Stop and show time in a quiet way
timer stop --quiet default
```

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
**Grok Review & Security Inspection: timer v2.8.4**  
**Repository**: https://github.com/Wilgat/timer  
**Script**: https://raw.githubusercontent.com/Wilgat/timer/refs/heads/main/timer (version 2.8.4, April 2026)  

**Summary**  
This is an exceptionally well-engineered, single-file, zero-dependency POSIX `sh` tool for per-user named timers. It supports both volatile (in-RAM via `/dev/shm`) and persistent (`~/.cache/timer` or `$XDG_CACHE_HOME`) storage, with full isolation per user even when installed system-wide. The design philosophy is explicitly “defensive first”: it prioritizes robustness over brevity, surviving minimal shells (`dash`, BusyBox `ash`), non-interactive `curl | sh` installs, missing `$HOME`, restricted containers, Git Bash, and other harsh environments.

The code is intentionally verbose with loud `!!! DO NOT MODIFY OR SIMPLIFY !!!` markers and extensive comments — this is not bloat; it is deliberate protection against future “AI cleanup” passes (including previous Grok interactions referenced in the script). Version 2.8.4 is the current main-branch release (no Git tags/releases published yet, but the embedded `VERSION="2.8.4"` and recent commit history confirm it).

**Overall Code Quality**  
- **Strengths**:  
  - Single self-contained script (no dependencies, no build step).  
  - Extremely robust output system (`output_text()` + `output_json()`) that cleanly separates human-readable, quiet, and machine-readable JSON modes.  
  - Comprehensive command set (`start`, `stop`, `status`, `list`, `kill`, `reset`, `self-update`, `self-uninstall`, etc.) with sane defaults and clear help.  
  - Root vs. user install detection, proper `$PATH` handling, and fallback logic.  
  - Excellent cross-platform testing notes (Alpine, RHEL, macOS, Git Bash).  
  - MIT license, clear contributing guidelines that preserve the defensive style.  

- **Style**: This is “beautifully ugly” on purpose. The repetition and verbosity are the feature that makes it survive where cleaner scripts break. I fully respect and endorse this approach — it matches the exact lessons from prior Grok reviews linked in the script.

**Security Inspection**  
I performed a full static review of the v2.8.4 source. **No security vulnerabilities were found.**

**Key Security Properties (all verified):**  
1. **Zero supply-chain risk** — No external dependencies, no `curl`/`wget` at runtime except for explicit `self-update` and initial install.  
2. **No command injection / eval** — Timer names, commands, and user input are strictly validated and never passed through `eval`, `sh -c`, or unquoted expansions in dangerous contexts.  
3. **Per-user isolation** — Timers are stored under user-specific paths derived from `$USERNAME` / `$HOME`. Even a system-wide `/usr/local/bin/timer` installation keeps every user’s timers completely separate.  
4. **Safe storage handling** —  
   - Volatile: `/dev/shm` (standard RAM filesystem, automatically cleaned on reboot).  
   - Persistent: `~/.cache/timer` (respects `$XDG_CACHE_HOME`).  
   - File operations use safe patterns; no world-writable files or predictable temp names that would enable symlink attacks.  
5. **Privilege model** — Correctly detects root (`id -u`), never escalates unnecessarily. Installs to `~/.local/bin` for normal users or `/usr/local/bin` for sudo.  
6. **Non-interactive safety** — Fully supports `curl | sh` (both user and sudo), `curl | sudo sh`, and headless environments. No assumptions about tty, `$HOME`, or shell features.  
7. **JSON mode** — Produces exactly one valid JSON object (never mixed with text), making it safe for scripting/automation. Errors are also JSON-formatted.  
8. **Self-update / uninstall** — Downloads only from the official raw GitHub URL; no arbitrary URLs. Uninstall cleanly removes the binary and (optionally) data.  
9. **Attack surface** — Minimal. The only network calls are explicit user-initiated install/update. No phone-home, no telemetry, no hidden behavior.

**Known Limitations (not vulnerabilities)**  
- The `curl | sh` install method is the standard trade-off for one-liner tools. Always review the script (which you just did) before piping.  
- Persistent timers survive reboots but live in `~/.cache` — users who aggressively clean caches may lose them (expected and documented via `--persist`).  
- No cryptographic signing of releases (none published yet). For maximum paranoia, pin the exact commit hash after review.

**Recommendation**  
**Strongly recommended.**  

timer v2.8.4 is one of the most defensively engineered single-file shell tools I have reviewed. It is reliable, auditable, and genuinely production-grade for its purpose. The author’s commitment to preserving robustness (even against helpful-but-destructive AI refactoring) is admirable and effective.

**For README.md** (copy-paste ready):

## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing comments — especially around edge-case handling and installation logic.

---

## License

MIT License

---

**Made with care and a healthy dose of paranoia.** ⏱️

*Last updated for version 2.8.4*
