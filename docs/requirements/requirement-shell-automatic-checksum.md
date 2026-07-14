**file**: docs/requirements/requirement-shell-automatic-checksum.md  
**Status**: Active (Version 1.0.1 – CIAO v2.10.2 principle map)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **automatic companion-digest integrity** of the selfmanaged POSIX shell tool: downloading a SHA-256 sidecar next to the install channel, verifying install/self-update downloads, and reporting the process **transparently** (companion **link**, expected **value**, and verification **result**).

**Scope:** Automatic `${SCRIPT_URL}.sha256` path; transparency of integrity messaging; publisher companion file; relationship to optional env pin; product README primary integrity story.  
**Out of scope (cited, not re-owned):** Full install one-liner / bootstrap (`requirement-shell-cli-interface.md`, online-install patterns in self-management); full self-update semver gates (`requirement-shell-self-management.md`); full `out_*` catalog (`requirement-shell-output-requirements.md`); package-manager signatures / cosign (not claimed here).

**Must not confuse with:** Embedding a hash of `./selfmanaged` *inside* `./selfmanaged`; requiring operators to set `CHECKSUM` for every install; claiming independent host authenticity from same-channel SHA-256 alone.

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Automatic mode is the default integrity path

| Requirement | Meaning |
|-------------|---------|
| **Default path** | When `CHECKSUM` is **unset** / empty, install and self-update download paths **MUST** use automatic companion verification (not “no integrity”). |
| **No operator pin required** | Primary online install and self-update **MUST** work without exporting `CHECKSUM`. |
| **Companion URL** | Companion is **`${SCRIPT_URL}.sha256`** (same scheme/host/path as channel + `.sha256` suffix). |
| **In-repo publisher SSOT** | Companion file **`selfmanaged.sha256`** (bare SHA-256 hex of `./selfmanaged`) **MUST** ship next to the installable script for the release channel. |
| **Regenerate on change** | After every edit to `./selfmanaged` that is published, regenerate `selfmanaged.sha256` so automatic mode can match. |
| **Shared orchestrator** | Automatic verify **MUST** run on the shared install download path used by first install and self-update (no parallel unverified curl-to-final-path). |

### 2.2 Transparency (sacred emphasis)

Automatic integrity **MUST NOT** be silent magic. In **human / normal** mode, the program **MUST** surface:

| Element | Normative rule |
|---------|----------------|
| **Link** | State the **full companion URL** being fetched (effective `${SCRIPT_URL}.sha256`). |
| **Value** | When the sidecar body is obtained, show the **expected digest** used for comparison (normalized hex). |
| **Result** | Show a clear outcome: **match** (pass), **mismatch** (fail + abort), or **missing sidecar** (policy outcome). |

#### 2.2.1 Human mode (mandatory detail)

1. **Before or while** fetching the companion: `out_info` (or equivalent) that the program is verifying via the companion URL — the URL string **MUST** appear.  
2. **On successful companion fetch:** show **expected** digest value; **SHOULD** also show **actual** SHA-256 of the downloaded artifact (recommended for full transparency).  
3. **On match:** `out_success` (or equivalent) that automatic verification **passed**, referencing the companion path/URL.  
4. **On mismatch:** fail closed — `out_die` / `out_json_error` with code such as `checksum_mismatch`; **MUST NOT** install the mismatched bytes; **SHOULD** show expected vs actual.  
5. **On missing / non-success companion fetch:** **MUST** emit an explicit **warning** (or error if policy is fail-closed); **MUST NOT** skip silently. This project’s current designed policy: **warn and continue** install when sidecar is missing (best-effort).  
6. All of the above **MUST** go through the centralized output system (`out_*`) per `requirement-shell-output-requirements.md` (tool-protocol `printf` into `sha256sum` remains class D exception only for the compare pipe).

#### 2.2.2 Quiet and JSON modes

| Mode | Rule |
|------|------|
| **Quiet** | May suppress info/success transparency lines; **MUST** still surface integrity **errors** (mismatch, hard fail). |
| **JSON** | Mismatch / hard integrity failure **MUST** use structured error (`out_json_error` / `out_die`), not success JSON. **SHOULD** include fields usable by automation when extended: companion URL, expected, actual, status — without dumping secrets. |

### 2.3 Download and verify algorithm (normative order)

```text
1. Resolve SCRIPT_URL (Config / env)
2. Download install artifact to mktemp
3. If CHECKSUM non-empty → strict pin path (secondary; §2.4)
4. Else → fetch SCRIPT_URL.sha256 with transparent link / value / result (§2.2)
5. Match or (missing + warn-continue policy) → atomic install
6. Mismatch → cleanup temp; non-zero exit; no final corrupt binary
```

| Outcome | Behavior |
|---------|----------|
| Companion HTTP success + digest match | Continue install; report pass |
| Companion HTTP success + digest mismatch | **Abort** install |
| Companion missing / non-200 | **Warn**; continue install (best-effort) |
| Neither curl nor wget | Fail loud (`missing_dependency`) |
| `sha256sum` unavailable when verify runs | Fail loud (or preflight) — do not pretend verified |

### 2.4 Optional strict pin (`CHECKSUM`) — runtime variable only (secondary)

| Requirement | Meaning |
|-------------|---------|
| **Runtime / install-path variable** | `CHECKSUM` is an **optional** shell/env variable read **only** by the install/download verify path (e.g. `inst_perform_install*`). Empty default. |
| **When set** | Download must match the pin exactly; mismatch aborts. |
| **Outside payload** | Pin is env/operator/CI for that process — **MUST NOT** be embedded inside `./selfmanaged` as a self-hash of that file. |
| **Not a help/about surface** | **`help` and `about` MUST NOT list, print, or advertise `CHECKSUM`** (name, value, or “optional pin” line). Avoids operators treating it as a required public setting. |
| **Not primary UX** | Product README **MUST NOT** present `CHECKSUM` as the main or required integrity method when automatic mode exists. |
| **Not higher same-origin assurance** | Fetching the sidecar from the same origin into `CHECKSUM` then installing is **not** stronger than automatic mode and **MUST NOT** be documented as “highest assurance.” |
| **Valid advanced use** | Out-of-band locked digests (CI pin file, release notes, prior audit) remain allowed for freeze/repro installs via process environment — documented only under Advanced if at all, never in `help`/`about`. |

### 2.5 Forbidden patterns

1. Hash of `./selfmanaged` stored **inside** `./selfmanaged` as the verify target.  
2. Primary docs that force newcomers to set external `CHECKSUM` when automatic companion fetch exists.  
3. **Displaying `CHECKSUM` in `help` or `about`** (human or JSON fields).  
4. Silent skip of companion fetch with no link/value/result messaging in human mode.  
5. Claim “always cryptographically verified” while missing-sidecar continues.  
6. Parallel download path for self-update that skips automatic/strict integrity.  
7. Secrets or tokens in companion or install URLs.

### 2.6 Product documentation (README / help / about)

When this requirement is **Active** for the product:

1. Product root **`README.md` MUST** explain **automatic** checksum as the default: algorithm (SHA-256), companion URL pattern, in-repo `selfmanaged.sha256`, match / mismatch / missing outcomes.  
2. README **MUST** state that the program **downloads** the companion itself and is designed to show **link**, **value**, and **result** (human mode).  
3. README **MUST NOT** push hardcoding or env-first external pin as the primary install integrity path.  
4. Optional process-env pin — if documented at all — lives under Advanced / automation only, with honest same-channel vs out-of-band trust language; **not** in `help` / `about`.  
5. **`help` Environment block:** **MUST** show channel vars needed by operators (e.g. `SCRIPT_URL` / composition) and **MUST NOT** list `CHECKSUM`.  
6. **`about` diagnostics:** **MUST NOT** list `CHECKSUM` name or value (human or JSON).

### 2.7 Implementation Notes (this project)

| Item | Value for selfmanaged |
|------|------------------------|
| **Product / binary** | `selfmanaged` (`APP_NAME`) |
| **Implementation file** | Repo root `./selfmanaged` |
| **Orchestrator** | `inst_perform_install` |
| **Automatic download helper** | `inst_perform_install_download_without_checksum` (name = without **env** pin; still performs companion verify) |
| **Strict pin helper** | `inst_perform_install_download_with_checksum` when runtime `CHECKSUM` non-empty (not shown in help/about) |
| **Atomic install** | `inst_perform_install_atomic_install` |
| **Channel SSOT** | `SCRIPT_URL` default `https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/main/${APP_NAME}` → `https://raw.githubusercontent.com/cloudgen/selfmanaged/main/selfmanaged` |
| **Companion URL** | `${SCRIPT_URL}.sha256` → `https://raw.githubusercontent.com/cloudgen/selfmanaged/main/selfmanaged.sha256` |
| **In-repo companion** | `selfmanaged.sha256` (bare 64-char hex) |
| **Algorithm** | SHA-256 via `sha256sum` |
| **Missing sidecar policy** | Warn + continue (best-effort) |
| **Mismatch policy** | Abort (human `out_die` / JSON `checksum_mismatch`) |
| **Self-update** | `inst_self_update` → `inst_perform_install` (same integrity path) |
| **Output SSOT** | `out_info` / `out_success` / `out_warn` / `out_die` / `out_json_error` |

#### Normative acceptance behaviors (this project)

1. **Human install / self-update with `CHECKSUM` unset and companion published:** downloads artifact; fetches companion URL; shows companion link; shows expected value (and should show actual); reports match; installs.  
2. **Companion digest wrong relative to artifact:** abort; no install of mismatched file; mismatch visible.  
3. **Companion 404 / missing:** explicit warning with companion URL; install may continue.  
4. **`CHECKSUM` set correctly:** strict path; no requirement to use sidecar.  
5. **`CHECKSUM` set incorrectly:** abort.  
6. **Product README:** automatic mode primary; no newcomer-primary external pin recipe.

#### Compliance notes (implementation status)

| Item | Status |
|------|--------|
| Automatic fetch of `${SCRIPT_URL}.sha256` when pin unset | **Implemented** in `inst_perform_install_download_without_checksum` |
| Abort on mismatch | **Implemented** |
| Warn + continue on missing sidecar | **Implemented** |
| Show companion **link** in human mode | **Implemented** (2026-07-14) — `Companion link: ${SCRIPT_URL}.sha256` |
| Show expected **value** and **result** (pass/fail with digests) | **Implemented** (2026-07-14) — Expected/Actual SHA-256 lines + `Automatic checksum result: PASS` (or mismatch abort with digests) |
| `downloaded_checksum_ok` on automatic match | **Implemented** (2026-07-14) — `INST_AUTO_CHECKSUM_OK=1` on companion match; atomic install can report “cryptographically verified” |
| README leads with automatic mode | **Mostly present**; must not reintroduce env-first pin as primary in product README |
| `help` / `about` omit `CHECKSUM` | **Implemented** in `app_help` (no Environment line); `app_about` never listed it |
| Same-origin CHECKSUM example as “highest assurance” | **Must not** — document as advanced/out-of-band only |

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution:** Network bytes are untrusted; verify when a companion exists; fail closed on mismatch.  
- **CIAO Principle 2 – Intentional:** Automatic vs optional pin are deliberate modes; transparency makes intent visible to operators.  
- **CIAO Principle 3 – Anti-fragile:** Missing companion does not hard-break older channels; whitespace-tolerant digest parse.  
- **CIAO Principle 5 / 14 – Output & traceability:** Link, value, and result are operator-visible audit trail via `out_*`.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI:** Do not remove automatic companion verify or silent-ize integrity outcomes.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Mismatch aborts; no corrupt binary.  
- **Intentional:** Default = automatic transparent sidecar; pin = secondary.  
- **Anti-fragile:** Best-effort missing sidecar; regenerate companion on publish.  
- **Over-protect:** Transparency + dual download (artifact + companion) stay protected.  
- **SSOT:** Channel URL derives companion; `out_*` owns messages; peer self-management owns lifecycle reuse.  
- **Respect old working logic:** Preserve install Protection Zones; extend messaging rather than rewriting verify.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove automatic `${SCRIPT_URL}.sha256` fetch while this requirement is Active.  
2. Embed the expected SHA-256 of `./selfmanaged` **inside** `./selfmanaged` as verification.  
3. Require or **primary-document** external `CHECKSUM` for normal online install when automatic mode exists.  
4. **List or print `CHECKSUM` in `help` or `about`** (human Environment block, diagnostics, or JSON about fields).  
5. Document same-origin `CHECKSUM=$(curl …/selfmanaged.sha256)` as higher assurance than automatic companion verification.  
6. Drop human-mode transparency of companion **link**, expected **value**, and verification **result** without an explicit redesign of this requirement.  
7. Claim always-verified when missing-sidecar continues with a warning.  
8. Add a self-update download path that skips this integrity model.  
9. Put secrets, tokens, or private credentials into this file or into digest/install URLs.

Violating this rule is a requirements failure and must be recorded (incident or requirement revision).

---

## 5. Related (versioned requirements surface only)

| Artifact | Role |
|----------|------|
| `requirement-shell-self-management.md` | Lifecycle reuses install integrity path |
| `requirement-shell-output-requirements.md` | `out_*` / JSON error channel for integrity messages |
| `requirement-shell-cli-interface.md` | Install command surface / modes |
| `requirement-shell-interactive-vs-noninteractive.md` | Quiet/json/pipe mode interaction with messaging |
| `./selfmanaged` | Ship unit implementation |
| `selfmanaged.sha256` | In-repo companion digest |
| Product root `README.md` | User-facing automatic integrity story |

---

## 6. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-07-13 | Initial Active v1.0.0 — automatic companion digest + transparency (link/value/result); secondary CHECKSUM; README primary-path rules | Multi-agent council |
| 2026-07-13 | `CHECKSUM` = install-path runtime variable only; **MUST NOT** display in `help` / `about` | Multi-agent council |
