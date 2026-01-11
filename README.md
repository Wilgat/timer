# timer - Beautiful & Flexible Per-User Timer

Lightweight, named, multi-timer CLI tool written in pure POSIX shell.

Now with colors, persistent mode, `list`, and force discard!

## Features

- Multiple independent named timers per user  
- `timer list` — see everything that's running  
- `--persist` — survive reboots (stored in `~/.cache/timer/`)  
- Color output when terminal supports it  
- `timer kill <name>` / `stop --force` — discard forgotten timers  
- Zero dependencies, works with dash/sh

### Main features

Here are **all the main features** of the `timer` tool from https://github.com/Wilgat/timer (based on the current README and script behavior as of early 2026):

| Feature                              | Description                                                                                   | Notes / Details                              |
|--------------------------------------|-----------------------------------------------------------------------------------------------|----------------------------------------------|
| Pure POSIX shell implementation      | Works with `/bin/sh`, `dash`, `ash` etc. — no bashisms                                       | Zero extra dependencies                      |
| Multiple independent named timers    | Each user can run many timers at once with different names                                   | Default name = `default`                     |
| Two storage modes                    | Volatile (fast, in `/dev/shm` — lost on reboot) + Persistent (`~/.cache/timer/`)            | Controlled with `--persist` flag             |
| Survive reboots                      | When using `--persist` mode                                                                   | Persistent storage option                    |
| Color output                         | Nice colored terminal output when running in interactive terminal                            | Falls back to plain text otherwise           |
| Commands: `start [name]`             | Start a new timer (with optional name)                                                        | Example: `timer start work --persist`        |
| Commands: `stop [name]`              | Stop timer + show elapsed time in min:sec format                                             | Normal graceful finish                       |
| Commands: `stop --force`             | Discard / kill timer without showing time                                                     | For forgotten or unwanted timers             |
| Commands: `kill [name]`              | Alias for `stop --force`                                                                      | Quick cleanup shortcut                       |
| Commands: `status [name]`            | Show current elapsed time without stopping the timer                                          | Non-destructive check                        |
| Commands: `list [--persist]`         | Show all currently running timers (with elapsed time)                                        | Can filter by storage mode                   |
| Commands: `version`                  | Display current version number                                                                | Currently around 1.2.x                       |
| Commands: `help`                     | Show usage information and examples                                                           | Built-in documentation                       |
| Force discard / cleanup              | Easy way to remove forgotten timers (`kill` or `stop --force`)                               | Prevents clutter                             |
| Automatic install suggestion         | When run without global installation — suggests / can auto-install to `/usr/local/bin`      | Nice UX touch                                |
| Per-user isolation                   | Timers are stored separately per user (using username in filename)                           | Safe for shared systems                      |
| Minimal & lightweight                | Tiny codebase, very fast, no external tools required beyond basic POSIX utilities           | Uses only `date`, `id`, `mkdir`, `rm` etc.   |
| Beautiful & clean output             | Formatted elapsed time + colored status messages                                              | Focus on pleasant terminal experience        |

This tool stays true to the "small, focused, beautiful" philosophy — perfect for people who want a dead-simple, dependency-free timer that just works in any POSIX environment.

## Installation

```bash
# Recommended (global install)
curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/refs/heads/main/timer | sh

# With sudo if needed:
sudo curl -fsSL https://raw.githubusercontent.com/Wilgat/timer/refs/heads/main/timer | sudo sh
```

## Usage

```bash
timer <command> [--persist] [--force] [name]
```

| Command           | Description                                    | Example                        |
|-------------------|------------------------------------------------|--------------------------------|
| `start [name]`    | Start new timer                                | `timer start work --persist`   |
| `stop [name]`     | Stop & show elapsed time                       | `timer stop work`              |
| `stop --force`    | Discard timer without showing time             | `timer stop old --force`       |
| `kill [name]`     | Alias for `stop --force`                       | `timer kill forgotten`         |
| `status [name]`   | Show current elapsed time (no stop)            | `timer status coffee`          |
| `list`            | Show all running timers                        | `timer list --persist`         |
| `version`         | Show version                                   | `timer version`                |
| `help`            | This help                                      | `timer help`                   |

**Default timer name** is `default` when no name is given.

### Examples

```bash
# Normal workflow
timer start coding
# ... later ...
timer status coding
timer stop coding

# Multiple + list
timer start meeting --persist
timer start break
timer list

# Cleanup forgotten timer
timer kill oldtask
```

## Requirements

- POSIX shell (`/bin/sh`, dash, etc.)
- Standard utilities: `date`, `id`, `mkdir`, `rm`

## Contributing

Ideas welcome:

- Pause/resume  
- Lap/split times  
- Export/import timers  
- Notification when timer reaches certain time

## License

MIT

Enjoy your timers! ⏱️✨
