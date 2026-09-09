**file**: docs/requirements/requirement-shell-path-and-shell-support.md  
**Requirement-ID**: `RQ-SHELL-PATH-AND-SHELL-SUPPORT`  
**Status**: Active (Version 1.0.1 – heal system-bin PATH; self-update runs PATH ensure as new dest)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **shell path integration** of the timer CLI: ensuring a **user drawer** (`USER_BIN`, default `${HOME}/.local/bin`) is on PATH by idempotently updating this login’s interactive rc files after a **user-local** install — and reversing those lines on uninstall **only when safe**.

It does **not** re-own binary place/remove (`requirement-shell-self-management.md`), re-run matrix (`requirement-shell-idempotency.md`), or the dispatcher catalog (`requirement-shell-cli-interface.md`). Those peers **point here** for PATH/rc bodies.

**Scope:** `path_add_*` write paths, exact `export PATH=` idempotency, Termux / OS-bin skip, uninstall reverse, Type 0 `rc-test --root`.  
**Out of scope:** Login-review hooks; rewriting another login’s rc; placing the binary file.

### 1.1 Human-facing

**In one sentence:** After a user install, timer may add your private bin folder to `~/.bashrc` so you can type `timer` by name; on Termux it does **not** add `$PREFIX/bin` because that folder is already on PATH.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | User drawer that may get a PATH line | `${HOME}/.local/bin` |
| The other role | Termux / OS bin already on PATH | `$PREFIX/bin` — **do not** write into `.bashrc` |
| Not this file | Placing the `timer` binary | `timer install` dest |

| Includes | Excludes |
|----------|----------|
| Create / modify / no-op of this login’s `BASHRC` | Adding `$PREFIX/bin` or `/usr/bin` to PATH |
| `timer rc-test --root DIR --case create\|modify\|noop` | Editing another user’s rc; in-tool `sudo` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./timer` | ship unit | `path_add_*` / `path_rc_test` |
| `timer rc-test --root DIR --case create` | tester | prove PATH write on a temp folder |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Install as this login | User drawer may get one PATH line | `timer install` |
| Prove rc write without touching real `.bashrc` | Temp folder only | `timer rc-test --root DIR --case create` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 When PATH ensure runs

| MUST | MUST NOT |
|------|----------|
| Call `path_add_shell` after a **successful user-local** install (`IS_ROOT=0`) **only when** `USER_BIN` is a **user drawer** | PATH-integrate a **system bin** (below) |
| After atomic replace, run PATH ensure/heal as the **new dest file** (child process), not in-memory old `self-update` | Assume `mv` onto `$0` refreshes functions already loaded |
| **Heal:** remove this product’s `# Added by ${APP_NAME} installer` comment **paired with** a system-bin `export PATH=` | Delete sibling PATH lines (`~/.local/bin`, `~/.grok/bin`) |
| Honor `BASHRC` (default `${HOME}/.bashrc`), `ZSHRC`, `FISH_CONFIG` as write paths | Hard-code only `${HOME}/.bashrc` so tests cannot retarget |
| Keep prior rc body; append PATH if the **exact** export is absent | Replace / truncate an existing dongle or user rc |

**System bin (MUST NOT PATH-integrate):**

| Directory | Why |
|-----------|-----|
| `$PREFIX/bin` when `PREFIX` is set (Termux dest) | Already on PATH from login |
| `GLOBAL_BIN` (default `/usr/local/bin`) | Global dest; already on PATH |
| `/usr/bin`, `/bin`, `/usr/local/bin` | OS bins |

Live PATH membership is **not** a skip by itself (CI and one-shot `PATH=` prefixes would hide a missing rc line). Skip is **directory class**, not “is it on PATH in this process.”

### 2.2 Bashrc PATH ensure (normative)

| MUST | MUST NOT |
|------|----------|
| **Create** `BASHRC` if missing (header with `APP_NAME` / `VERSION`, then PATH) | Leave `BASHRC` missing when create is claimed |
| **Modify** an existing file: keep the prior body; append PATH if the exact export is absent | Treat a `USER_BIN` substring (comment, unrelated line) as already-good |
| **No-op** when this product’s `VERSION` installer comments **and** the exact `export PATH="<USER_BIN>:$PATH"` line already match (file bytes unchanged) | Duplicate the exact PATH line |
| **Sibling unify:** one exact `export PATH="<USER_BIN>:$PATH"` even when another product already wrote it. Later product **MAY** add only its `# Added by ${APP_NAME} installer (${VERSION})` comment | A second PATH dialect; rewrite another app’s comments |
| After create or modify: mode readable (`0644`) | Leave a temp’s elevated owner as the published owner when a Type 1 rewrite is in play (this product is Type 0 this-login) |

### 2.3 Uninstall PATH reverse

| MUST | MUST NOT |
|------|----------|
| Remove **this** product’s `# Added by ${APP_NAME} installer` comments | Delete `# Added by` comments of other products |
| Strip the shared exact PATH line **only when** `USER_BIN` is empty (or missing) **and** it is **not** a system bin | Strip `$PREFIX/bin` / `/usr/bin` / `GLOBAL_BIN` from rc |
| Keep the PATH line when `USER_BIN` still has other files | Reckless `sed` on an OS bin string |

### 2.4 Test-purpose verb `rc-test`

| MUST | MUST NOT |
|------|----------|
| Dual-mention Type 0 `rc-test` on this file **and** the CLI-interface REQ | Treat `install` as the PATH tester |
| Accept `--root DIR` (tmp/cache fixture) and `--case create\|modify\|noop` | Write this login’s real `${HOME}/.bashrc` |
| Keep real `HOME`; set `BASHRC=${RC_TEST_ROOT}/.bashrc` | `HOME=/tmp/…` as the isolation trick for PATH tests |
| Help lists testers **apart** from operational verbs | Group `rc-test` under Self-Management as if it installed the binary |
| Sample: `timer rc-test --root DIR --case create` | Require `sudo` |

### 2.5 Implementation Notes (this project)

| Item | Value for timer |
|------|-----------------|
| **Product / binary** | `timer` (`APP_NAME`) |
| **Implementation file** | Repo root `./timer` |
| **Helpers** | `path_is_system_bin`, `path_heal_file`, `path_heal_system_bin_rc`, `path_add_bashrc`, `path_add_zshrc`, `path_add_fish`, `path_add_shell`, `path_rc_test` |
| **Config** | `USER_BIN` default `${HOME}/.local/bin`; `BASHRC` default `${HOME}/.bashrc`; `ZSHRC`; `FISH_CONFIG` |
| **Termux dest** | `USER_BIN=$PREFIX/bin` when that directory exists — **PATH ensure skipped** |
| **Call site** | `inst_perform_install_atomic_install` → child `${INSTALL_PATH}` with `TIMER_INTERNAL_PATH_ENSURE=1` (new bytes); fallback in-process heal + `path_add_shell`. `app_main` heals on ordinary commands (not `rc-test`) |
| **Reverse** | `inst_self_uninstall_cleanup_path` — this product’s comments; exact PATH only if user drawer empty |
| **Tester** | `path_rc_test`; flags `--root`, `--case`; dual mention `RQ-SHELL-CLI-INTERFACE` |
| **Version SSOT** | `VERSION` in script config (installer comment) |

#### Invocation samples

```text
timer install
timer rc-test --root DIR --case create
timer rc-test --root DIR --case modify
timer rc-test --root DIR --case noop
timer self-uninstall --force
```

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Never prepend Termux `$PREFIX/bin` (OS bin) into `.bashrc`; never corrupt an existing rc body.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): PATH ensure is a named capability with exact-line idempotency and a tester verb.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Works for missing and existing bashrc; tests retarget `BASHRC` / `--root`.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20** (https://github.com/cloudgen/ciao): Exact-line no-op and system-bin skip are sacred.  
- **CIAO Principle 9 / 10** (https://github.com/cloudgen/ciao): Type 0 this-login only; no `sudo` to write rc.

---

## Under command line for normal user only

When the program runs on Termux, Git Bash, Windows cmd, or the same class, only **this login** may use it. Admin privilege and a dedicated system-user switch stay **unused**.

**This requirement:** PATH ensure. On Termux, dest may be `$PREFIX/bin`; that dest **MUST NOT** be written into `.bashrc`. Tests retarget `BASHRC` / `--root` — they **MUST NOT** require `sudo` or the developer’s real home.

| MUST | MUST NOT |
|------|----------|
| Skip PATH ensure when `USER_BIN` is `$PREFIX/bin` | Write `$PREFIX/bin` into `.bashrc` |
| Write **this login’s** `BASHRC` for `~/.local/bin` dest | Rewrite another user’s rc; in-tool `sudo`; wrap `apt` |
| Git Bash: same ceiling | Invoke Termux `pkg` because Git Bash was detected |

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Do not break existing shell configuration; never PATH-integrate an OS bin.  
- **Intentional:** One exact PATH export per user drawer; tester is not install.  
- **Anti-fragile:** Create / modify / no-op; `BASHRC` env; `--root` fixture.  
- **Over-protect:** Exact-line check; sibling unify; empty-dir reverse; system-bin refuse.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. PATH-integrate `$PREFIX/bin`, `/usr/bin`, `/bin`, or `GLOBAL_BIN`.  
2. Treat a `USER_BIN` substring as already-good when the exact `export PATH=` line is absent.  
3. Duplicate the exact PATH export (sibling or re-run).  
4. Replace an existing bashrc body instead of appending PATH.  
5. Leave `BASHRC` missing when create-if-missing is claimed.  
6. Ignore a non-empty `BASHRC` / `ZSHRC` / `FISH_CONFIG` env.  
7. Strip a system bin from rc on uninstall, or delete another product’s installer comments.  
8. Claim bashrc PATH ensure without **TP-LC-20** / **TP-LC-21** / **TP-LC-22**.  
9. Claim path-ensure without dual-mentioning Type 0 **`rc-test --root`**.  
10. Use `install` as the only PATH tester, or write this login’s real `~/.bashrc` from the tester.  
11. Run PATH ensure after `self-update` `mv` using **in-memory old functions** (that is how 2.13.1 re-added `$PREFIX/bin` after installing 2.14.0).

**Violating this rule is a PATH/rc regression** (Termux `usr/bin` prepend is the named failure).

---

## 5. Definition of done

Work claiming PATH/rc support for timer is **not done** if any of the following fail:

1. User-drawer install writes at most one exact `export PATH="<USER_BIN>:$PATH"` line.  
2. Termux `$PREFIX/bin` dest does **not** appear in `.bashrc`.  
3. `BASHRC` env / `rc-test --root` retargets writes; real login `.bashrc` untouched in those cases.  
4. Create / modify / no-op (VERSION + exact PATH) hold.  
5. Uninstall reverse is this-product comments only; system bin never stripped.  
6. Help lists `rc-test` apart from operational verbs.  
7. Implementation changes cite `requirement-shell-path-and-shell-support`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-self-management.md` | Install call site; uninstall reverse orchestration |
| `docs/requirements/requirement-shell-idempotency.md` | Re-run / exact-line no-op peer |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention of `rc-test`; flags `--root` / `--case` |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` for PATH tips; class-C printf for rc file I/O |
| `docs/requirements/requirement-shell-modular-function-design.md` | `path_*` prefix |
| `docs/requirements/index.md` | Registry SSOT |
| `./timer` | Implementation under test |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-PATH-AND-SHELL-SUPPORT`  
**Specialized from:** `LM-PATH-AND-SHELL-SUPPORT`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-LC-20** `BASHRC` / `rc-test --root` create-if-missing | `tests/test_install_lifecycle.sh` | have |
| **TP-LC-21** modify dongle (keep body; append PATH once) | `tests/test_install_lifecycle.sh` | have |
| **TP-LC-22** VERSION + exact `export PATH=` no-op | `tests/test_install_lifecycle.sh` | have |
| **TP-LC-12** first user install PATH prep | `tests/test_install_lifecycle.sh` | have |
| **TP-LC-07** uninstall PATH reverse when user drawer empty | `tests/test_install_lifecycle.sh` | have |
| **TP-TX-09** Termux `$PREFIX/bin` dest does not write PATH into rc | `tests/test_cli.sh` | have |
| **TP-TX-10** heal removes timer `$PREFIX/bin` PATH pair; keeps sibling PATH | `tests/test_cli.sh` | have |
| **TP-CLI-03** help lists `rc-test` apart from Self-Management | `tests/test_cli.sh` | have |

**Last Updated**: 2026-09-09 (1.0.1 heal + dest-child PATH ensure)  
**Owner**: timer project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; **`LM-PATH-AND-SHELL-SUPPORT`**; CIAO Principles 1, 2, 3, 4, 9, 10, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
