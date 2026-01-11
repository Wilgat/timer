# timer - Simple Per-User CLI Timer for Linux/Unix

A lightweight, per-user command-line timer written in pure POSIX shell (dash/sh compatible).  
Perfect for quickly measuring how long tasks, breaks, meetings, or any activity takes — without any dependencies.

Each user gets their own independent timer, stored safely in fast in-memory filesystem (`/dev/shm`).

## Features

- **Per-user isolation** — multiple users/sessions can run timers simultaneously
- Uses `/dev/shm` (RAM-based, auto-cleaned on reboot)
- Simple commands: `start`, `stop`, `version`, `help`
- One-file script — easy to install globally
- Fully POSIX-compliant (works with `dash`, `bash`, etc.)
- Installation suggestion via curl | sh for convenience

## Installation

### Recommended (global install - recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/master/timer | sh
```

This installs the script to `/usr/local/bin/timer` (requires sudo if needed).

After installation you can simply run:

```bash
timer start
timer stop
```

### Manual (local use)

```bash
# Download the script
curl -fsSL -o timer https://raw.githubusercontent.com/Wilgat/timer/master/timer

# Make it executable
chmod +x timer

# Run it (from current directory)
./timer start
```

## Usage

```bash
timer <command>
```

| Command   | Description                                      |
|-----------|--------------------------------------------------|
| `start`   | Start a new timer for the current user           |
| `stop`    | Stop timer and display elapsed time (min + sec)  |
| `version` | Show current version                             |
| `help`    | Show this help message                           |

### Example

```bash
$ timer start
Timer started for user 'alice' at 2026-01-11 14:30:45

# ... do some work ...

$ timer stop
Time elapsed for user 'alice': 7 minutes and 42 seconds
```

## How It Works

- `start` → saves current Unix timestamp to `/dev/shm/timer_timestamp_$USER`
- `stop` → reads it, calculates difference, removes file, shows result
- File is automatically cleaned up on `stop` or system reboot

## Requirements

- POSIX-compliant shell (`/bin/sh` — dash is fine)
- `date`, `id`, `rm`, `cat` (standard on any Linux/Unix)
- Write access to `/dev/shm` (default on most modern systems)

## Contributing

Feel free to open issues or pull requests!

Ideas for future versions:
- Named timers (`timer work start`, `timer coffee start`)
- `status` command
- Sub-second precision (using `time` or `date +%s.%N`)
- Pause/resume functionality

## License

MIT License

See [LICENSE](LICENSE) for details.

---

**Happy timing!** ⏱️

