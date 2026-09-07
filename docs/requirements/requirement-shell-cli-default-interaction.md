**file**: docs/requirements/requirement-shell-cli-default-interaction.md  
**Requirement-ID**: `RQ-SHELL-CLI-DEFAULT-INTERACTION`  
**Status**: Active (Version 1.1.0 – TTY numbered start list; extra name prompt)  
**Area**: shell  
**Key**: `requirement-shell-cli-default-interaction`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for timer’s **default interaction**: a **short numbered main menu** of daily named-timer work. timer has `requirement-shell-cli-zero-arguments` (**case 3**): that REQ **defers TTY empty argv** to this menu and **owns off-TTY empty argv as Type O ensure**. The menu **MUST** also be the command **`menu`**. **`main` MAY** be accepted as the same handler.

On a **real terminal**, empty argv (no command token — overlay switches such as `--debug` allowed) and `timer menu` (or `main`) **MUST** show the main menu. `menu`/`main` **MUST ignore `--json`**. Off-TTY, **`menu`/`main` MUST** print **help**, following `--json`. Off-TTY **empty argv** is **not** this file — it is channel ensure. Command rows **MUST** be `command: what it does`.

Empty-argv type and the TTY vs off-TTY split for **no command token** stay on `requirement-shell-cli-zero-arguments`. Confirm / no-hang stays on `requirement-shell-interactive-vs-noninteractive`. Live command inventory stays dispatcher truth (`requirement-shell-cli-interface`). Domain start/stop semantics stay on `requirement-domain-timer`.

Actor/role: **considered** — no dest approver (Type 0 this-login only). Dest fences: **considered — none**.

### 1.1 Human-facing

**In one sentence:** Typing only `timer` at a real terminal shows a numbered list of start/stop/status/list/kill/reset; in a script, bare `timer` still installs.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Type `timer` or `timer --debug` at a prompt | Pick `1`, then Enter for the default name |
| The other role | CI / pipe | Empty argv ensures install; `timer --json` prints JSON help |
| Not this file | How a timer file is stored | Domain requirement |

| Includes | Excludes |
|----------|----------|
| TTY empty argv numbered list; `menu`/`main`; Exit **9** | Off-TTY empty argv (Type O); install/version/about/help as rows |
| Default CLI main menu style (bold name, italic version, gray italic explain) | A menu that hangs a pipeline; help because `--debug` was present |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./timer` | ship unit | TTY list / pipe ensure |
| `timer menu` | command | same list on a TTY |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Start daily work at a prompt | Numbered list; **start** is **1**; then name (Enter = `default`) | `timer` then `1` then Enter |
| Same list with diagnostics | Same list; `[DEBUG]` on stderr | `timer --debug` |
| Ask for machine-readable usage | JSON help (empty argv **special case**) | `timer --json` |
| Open the list by name | Same list as empty argv on a TTY | `timer menu` |
| First install from the channel | Pipe places the binary | `curl -fsSL …/timer \| sh` |

---

## 2. Core Rules (Mandatory)

### 2.1 Claim and case

timer **claims** a default function. **Case 3** applies: `requirement-shell-cli-zero-arguments` exists. That REQ **defers TTY empty argv** to this menu. Off-TTY empty argv is Type O ensure on that REQ — **this file MUST NOT** print help for bare off-TTY empty argv. Off-TTY **`menu`/`main`** still print help.

### 2.2 Routed verb `menu` / `main` and TTY empty argv

| Token | Role |
|-------|------|
| empty argv (no command token; overlay `--debug` / `--quiet` allowed) | Same handler as `menu` when TTY=1; Type O ensure when TTY=0 (owned by zero-arguments; **not** `app_default`) |
| `menu` | Primary named command for this default |
| `main` | Same handler (alias) |

After flag parse, when the command token is `menu` or `main`, **or** when no command token was present and `--json` is off (zero-arguments routes `COMMAND=menu` on a TTY — including `timer --debug`), timer **MUST** branch (`TTY` measured in the main process, **not** inside helpers):

| # | Condition | MUST | MUST NOT |
|---|-----------|------|----------|
| 1 | Interactive (`TTY=1`) | **Main menu** (§2.3). For `menu`/`main`, **ignore `--json`** even if `JSON=1` | JSON help; hang |
| 2 | Not interactive (`TTY=0`) and `JSON=0` | **Human help screen** — `app_help` (not JSON) | Menu; silent return; hang |
| 3 | Not interactive (`TTY=0`) and `JSON=1` | **JSON help** — `app_help` in JSON mode | Menu; human banners; hang |

`--quiet` without a TTY on **`menu`/`main`** still takes the **help screen** path (do not swallow `menu` help). Flags-only `--json` **is** empty argv on `requirement-shell-cli-zero-arguments`; **special case** = JSON help **even on a TTY** (this file **MUST NOT** steal it onto the numbered list). Overlay flags-only (`--debug`, `--quiet` with no command) follow the ordinary empty-argv path on that REQ. `timer menu --json` on a TTY still ignores `--json` (rule 1).

### 2.3 Main menu

1. Print a **numbered list** of daily timer verbs, then **Exit**.  
2. **MUST NOT** list **install / setup**, **self-managed** commands (`install`, `self-uninstall`, `self-update`, `version-check`), **diagnostics** (`version`, `about`), or **test-purpose** verbs.  
3. Command-row text **MUST** be `command: what it does`. The numbered list **MUST** follow **default CLI main menu style**: header as in rule 8; each numbered row `command: what it does` with the number and command name **unstyled**; on a TTY the **explain** text after `: ` **MUST** be *italic* **and** light gray (SGR **3** + **37**, CSI `ESC[3;37m` … `ESC[0m` via `out_menu_choice`). Off-TTY: plain. **MUST NOT** print explain unstyled on a TTY.  
4. **MUST NOT** list `help` or `menu`/`main` on the **main** list.  
5. Command rows **N = 6**. Exit **MUST** be **9**. Unused integers **7** and **8** are omitted.  
6. Accept a **number** or a **listed verb**. **9** / `exit` / `quit` returns 0.  
7. The choice **MUST** be read in the **current shell**. **MUST NOT** `$()` / backticks a helper whose body contains `read` (do-not-capture-read / **PP-A-22**; current-shell `PROMPT_ASK_VALUE` or a direct `read` in `app_default`).  
8. **Header (mandatory):** the first human line that names the program **MUST** be live **`APP_NAME(VERSION)`** with **bold** name and *italic* version, then the product short description. Typical: `out_info "$(util_app_ident) — ${SHORT_DESCRIPTION}"`. TTY: SGR 1 / SGR 3. Off-TTY: plain. **MUST NOT** a bare `APP_NAME` on that header.  
9. Extra name field: picking **start** / **stop** / **status** / **kill** / **reset** **MUST** prompt for the timer name on a TTY (`prompt_ask "Timer name" "default"` in the current shell; value is **`PROMPT_ASK_VALUE`**). Empty answer / Enter **MUST** use `default` (same as omitting the operand on the CLI). **list** **MUST NOT** prompt. Persist overlay already parsed (`--persist`) **MUST** still apply. TTY `menu`/`main` extra fields **MUST** run with `JSON=0` / `QUIET=0` (ignore `--json` for the prompt; restore after the prompt). **MUST NOT** `$()` `prompt_ask`. **MUST NOT** hang off-TTY asking for a name.

Normative **main** order:

| # | Token | Label |
|---|-------|-------|
| *(header)* | — | `**APP_NAME**(*VERSION*) — Lightweight per-user named timers (volatile or persistent)` |
| 1 | `start` | `start: Start a named timer` |
| 2 | `stop` | `stop: Stop a named timer and show elapsed` |
| 3 | `status` | `status: Show elapsed without stopping` |
| 4 | `list` | `list: List running timers` |
| 5 | `kill` | `kill: Discard a running timer` |
| 6 | `reset` | `reset: Reset a running timer` |
| **9** | **Exit** | leave the menu |

### 2.4 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product** | timer |
| **Ship unit** | `./timer` |
| **Claimed** | yes |
| **Case** | **3** (zero-argument REQ exists; that REQ defers TTY empty argv here; off-TTY empty argv is Type O, not this file) |
| **Empty argv** | TTY → this menu; off-TTY → Type O ensure (`requirement-shell-cli-zero-arguments`; not this handler) |
| **Verb** | `menu` (alias `main`); TTY empty argv (including `--debug` with no command) sets `COMMAND=menu` |
| **Handler** | `app_default` (`menu` / `main` / TTY empty argv); `app_default_print_menu` / `app_default_run_pick` / `timer_run_domain`; extra name via current-shell `prompt_ask` + `PROMPT_ASK_VALUE` |
| **Label source** | `reviews/cli-routed-verb-table.md` **human-readable** for command rows |
| **Interactive + `--json`** | Ignore json on `menu`/`main`; still the menu |
| **Non-interactive `menu`/`main`** | `app_help` (human; `--quiet` still prints help) |
| **Look** | **default CLI main menu style** — header `APP_NAME(VERSION)`; TTY explain *italic* + light gray (SGR 3+37) via `out_menu_choice` |
| **Honesty** | **Implemented.** TTY empty argv (including `--debug` with no command) draws this menu. Off-TTY empty argv is Type O ensure. `--json` with no command is JSON help even on a TTY. TTY menu start/stop/status/kill/reset prompt for the name; Enter keeps `default`; list does not prompt. |
| **Actor/role** | Considered — no dest approver |
| **Invocation samples** | `timer` · `timer --debug` · `timer --json` · `timer menu` · `timer main` |

### 2.5 Why this requirement exists (CIAO)

- **Intentional**: Daily timer verbs are the start list; install stays off it.  
- **Caution**: Scripts never hang; `--json` with no command is JSON help, not the list.  
- **Anti-fragile**: Overlay `--debug` is still empty argv, not a third meaning.  
- **Over-protect**: Exit is **9**, not **7**; do-not-capture-read on the pick.

---

## Under command line for normal user only

When the program runs on Termux, Git Bash, Windows cmd, or the same class, only **this login** may use it. Admin privilege and a dedicated system-user switch stay **unused**.

**This requirement:** the numbered list is this-login daily work. It **MUST NOT** add sudo/apt rows or recommend `sudo curl | sh`.

| MUST | MUST NOT |
|------|----------|
| Same six domain rows on Termux | Hide start/stop because Android has no `/dev/shm` |
| Off-TTY empty argv stays this-login install-ensure | Enable admin privilege from the menu |

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: No menu on a pipe.  
- **Intentional**: Help is `help` / `--json` with no command, not `--debug` with no command.  
- **Anti-fragile**: Off-TTY `menu` prints help; never hangs.  
- **Over-protect**: Do not `$()` a `read` helper for the choice.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Draw the numbered menu on off-TTY empty argv, or hang a pipe.  
2. Put install / self-update / version / about / help / `menu` itself on the numbered list.  
3. Number Exit as **7** (N+1) instead of **9**.  
4. Capture the menu choice with `$()` of a `read` helper.  
5. Steal flags-only `--json` onto the numbered list.  
6. Treat overlay `--debug` with no command as help.  
7. Print a bare `APP_NAME` header without live `VERSION`, or unstyled explain on a TTY.  
8. Skip the TTY name prompt for **start** / **stop** / **status** / **kill** / **reset** (immediate `default`).  
9. Prompt for a name on **list**.  
10. Hang off-TTY asking for a timer name.

**Violating this rule is a critical dispatcher / menu regression.**

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv owner; defers TTY here |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention of `menu` / `main` |
| `docs/requirements/requirement-domain-timer.md` | Domain verb behavior |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_menu_choice` / `out_*` |
| `./timer` | Implementation |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-DEFAULT-INTERACTION`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-07** TTY empty argv list / TTY `--json` JSON help | `tests/test_cli.sh` | have |
| **TP-CLI-16** no `$()` of `prompt_*` | `tests/test_cli.sh` | have |
| **TP-CLI-17** header nametag + gray italic explain | `tests/test_cli.sh` | have |
| **TP-CLI-29** overlay `--debug` / `--quiet` follow empty argv | `tests/test_cli.sh` | have |
| **TP-CLI-30** TTY menu name prompt; Enter = `default`; list skips | `tests/test_cli.sh` | have |

**Last Updated**: 2026-09-07  
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
