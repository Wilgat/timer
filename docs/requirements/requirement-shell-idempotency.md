**file**: docs/requirements/requirement-shell-idempotency.md  
**Status**: Active (Version 1.0.2 – CIAO v2.10.2 Principles 11/12/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **idempotency (re-run safety)** of state-changing operations in the **POSIX shell CLI** for selfmanaged.

It defines re-run safety for ensure-style shell lifecycle commands (install, PATH integration, self-update, self-uninstall, and related helpers). Read-only commands remain outside the “ensure-X” contract except where they must stay safe under repeat invocation.

**Scope:** Detect → ensure → success-if-done semantics; force/reinstall overrides; partial-failure re-entry; PATH and shell-config re-entry; output behavior on no-op.  
**Out of scope (cited, not re-owned):** Full CLI command table (`requirement-shell-cli-interface.md`); online-install digest algorithm detail; FSM continuous-tick design (no product FSM today).

**Informal formula:** for ensure-style operation *f* and system state *x*, **f(f(x)) ≈ f(x)** for the **desired outcome** (logs and timestamps may differ).

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 What must be idempotent

Every **state-changing** shell operation that **ensures** a desired configuration **MUST**:

1. **Detect** whether the desired state already holds.  
2. **Skip or no-op** unsafe work when it does.  
3. **Succeed** (exit 0 / non-error path) when already achieved — **MUST NOT** fail solely because state “already exists.”  
4. **Avoid duplicates** (binary installs, PATH lines, config blocks, resources).  
5. **Leave the system consistent** on every run (including partial prior installs).  
6. **Communicate** clearly when already done in human mode; still respect quiet/json via output SSOT.

### 2.2 What a second run must not do

| Forbidden when desired state already holds | Prefer |
|--------------------------------------------|--------|
| Fail with error solely because state exists | Success + “already installed / already latest / nothing to uninstall” |
| Create duplicate binaries, PATH lines, or config blocks | Existence / content checks first |
| Overwrite a correct install without force/reinstall intent | No-op unless force policy or newer version policy requires replace |
| Thrash network downloads on every “already good” re-run | Skip download when no-op path taken |
| Leave half-applied state worse than start | Atomic install steps; cleanup temps; fail loud with recovery path |

### 2.3 Already-achieved behavior (mandatory pattern)

When the desired state is already true:

| Requirement | Detail |
|-------------|--------|
| **Success** | Treat as success (CLI exit 0) |
| **Communicate** | State the current condition in non-quiet human mode |
| **Minimize work** | No unnecessary download, rewrite, or PATH append |
| **Output SSOT** | Use central `out_*` / `out_json`; respect quiet/json |

Illegal inputs, missing remote channel when required, checksum failure, and permission errors **MUST** still fail closed. Idempotency does **not** mean “never error.”

### 2.4 Force / reinstall override (portable)

Force policy (e.g. `--force` / `FORCE_REINSTALL=1`) **MAY** re-apply ensure steps that would otherwise no-op **only** when:

- Documented on the command, and  
- Security checks (e.g. digest when downloading) still apply, and  
- Downgrade / destructive reinstall policy is explicit (not silent).

Force **MUST NOT** be used as a silent way to skip integrity verification.

### 2.5 Implementation Notes (this project)

| Item | Value for selfmanaged |
|------|------------------------|
| **Product / binary** | `selfmanaged` (`APP_NAME`) |
| **Implementation file** | Repo root `./selfmanaged` |
| **Install detect SSOT** | `inst_is_installed` / `inst_get_version` |
| **Install ensure SSOT** | `inst_perform_install` (+ download/atomic helpers) |
| **Force reinstall var** | `FORCE_REINSTALL` (default `0`); CLI `--force` must set this per `requirement-shell-cli-interface.md` |
| **Remote channel** | `SCRIPT_URL` (required for version-check / self-update network steps) |
| **User PATH integration** | `path_add_*` / `path_add_shell` — append only if marker/line absent |
| **Uninstall PATH cleanup** | `inst_self_uninstall_cleanup_path` — only if `~/.local/bin` empty |

#### Command-level idempotency matrix (normative)

| Command / path | Desired state | Re-run when already good | Force / special |
|----------------|---------------|--------------------------|-----------------|
| `install` | Binary present at privilege-correct path | **Success no-op**; human: already installed; JSON success | `FORCE_REINSTALL=1` re-downloads/replaces |
| Zero-arg install-ensure (**Type O**) | Binary present (local or global) | Second zero-arg when installed: **success no-op** “already installed” (not help, not reinstall) without force | Same force rules as install; see `requirement-shell-cli-zero-arguments.md` |
| `inst_maybe_install` | Installed or user declined | Already installed → return success without re-prompt storm | — |
| `self-update` | Local version equals remote (or newer under project policy) | **Success no-op** “already latest” when versions equal and force off | When versions differ, reinstall via install path; force may force reinstall; **must not silent-downgrade** without explicit force policy (see self-management term) |
| `self-uninstall` | Binary absent | **Success no-op** “not installed / nothing to uninstall” | Force may skip interactive confirm only; still no over-delete |
| `version-check` | N/A (read/compare) | Safe to re-run; network fetch each time is allowed; must not mutate install state | — |
| `version`, `about`, `help` | N/A (read-only) | Safe to re-run; no install mutation | — |
| PATH add (`path_add_bashrc` / zsh / fish) | PATH line already present | No second identical append | — |
| PATH cleanup on uninstall | `~/.local/bin` empty **or** PATH lines already removed | No thrash; if bin dir still has files, **keep** PATH (do not strip shared dir) | — |

#### Concrete detect → act expectations (this project)

1. **Install:** If `inst_is_installed` and `FORCE_REINSTALL=0` → return 0 without download/move.  
2. **Self-update:** Fetch remote `VERSION` from `SCRIPT_URL`; if equal to local and force off → return 0 without reinstall; if remote unreadable → fail loud (not a silent “already ok”).  
3. **Self-uninstall:** If no managed binary path resolved → return 0 (not installed).  
4. **PATH ensure:** Grep/marker check before append; already present is success for the ensure intent.  
5. **Atomic install temps:** Failed download paths **MUST** remove temp files; re-run starts clean.  
6. **Partial install:** Re-run of install after partial failure **MUST** attempt to converge (re-prepare target, re-download, atomic replace) or fail loud — not leave a second half-broken binary without error.

#### Explicitly out of scope until specialized elsewhere

- Type 1 prerequisites / package ensure loops  
- Type 2 system-user / app service ensure  
- Continuous FSM `update*` tick thrash (no product FSM in current shell surface)

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Assume re-runs, CI, scripts, and `curl | sh` retries; never fail “already exists” as if it were corruption.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Clear detect vs act vs force override; no accidental reinstall.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Converge from partial installs; tolerate second run after success.  
- **CIAO Principle 11 – Safe temporary file handling** (https://github.com/cloudgen/ciao): Temps cleaned so re-entry does not pile up or race on fixed names.  
- **CIAO Principle 12 – Backup & restore** (https://github.com/cloudgen/ciao): When future ensure steps edit existing configs, backup-before-write remains required (PATH edits today use append/check patterns).  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Existence checks and no-op success paths are Protection Zone material — not “simplify away.”

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Prefer detect-before-create; fail closed on integrity and network when action is required.  
- **Intentional:** Separate already-done success from forced reinstall and from real failure.  
- **Anti-fragile:** Re-run after success is safe; re-run after partial failure converges or errors clearly.  
- **Over-protect:** Do not remove `inst_is_installed` early-exit, PATH duplicate guards, or empty-dir PATH cleanup safety.  
- **SSOT:** Installation detect via `inst_is_installed` / `inst_get_version`; output via `out_*`.  
- **Output modes:** No-op success still honors quiet/json (structured success in JSON when the command supports it).  
- **Respect old working logic:** Preserve battle-tested ensure guards; surgical fixes only when proven bugs.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove or weaken “already installed / already latest / nothing to uninstall” success paths so that re-runs fail when healthy.  
2. Make `install` always re-download when the binary is already present without force/reinstall policy.  
3. Append duplicate PATH export blocks on every re-run.  
4. Strip `~/.local/bin` from PATH when other tools still use that directory.  
5. Treat force as a way to skip checksum/digest verification.  
6. Fail uninstall solely because the tool is already absent (must be success no-op).  
7. Paper over missing remote version as “already latest.”  
8. Weaken this requirement’s re-run safety rules without explicit project approval.

**Violating this rule is a critical re-run-safety regression.**

---

## 5. Definition of done (shell idempotency)

A state-changing shell change for selfmanaged is **not done** if any of the following fail:

1. Second `install` with healthy install and force off exits success without reinstall.  
2. Second `self-update` when local equals remote and force off exits success without reinstall.  
3. Second `self-uninstall` when not installed exits success.  
4. PATH ensure does not duplicate lines when re-run.  
5. PATH cleanup does not remove shared `~/.local/bin` entries while other files remain.  
6. Force/reinstall paths remain explicit and do not skip integrity checks.  
7. Messages for already-done paths use output SSOT and respect quiet/json.  
8. Implementation changes cite this requirement key `requirement-shell-idempotency`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/requirement-shell-cli-interface.md` | Command surface, flags, force wiring |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv ensure for not-installed / local / global |
| `docs/requirements/requirement-shell-self-management.md` | Lifecycle commands; integrity + downgrade policy |
| `docs/requirements/requirement-shell-output-requirements.md` | Messages on no-op / already-done paths |
| `docs/requirements/index.md` | Registry SSOT |
| `./selfmanaged` | Implementation under test |

---

**Last Updated**: 2026-07-14
**Owner**: selfmanaged project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO Principles 1, 2, 3, 4, 11, 12, 20 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
