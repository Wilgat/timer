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
