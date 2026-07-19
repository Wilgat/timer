**file**: docs/requirements/requirement-class-software-dev.md  
**Status**: Active (Version 1.0.0 – timer class law + residual stack)  
**Area**: class  
**Key**: `requirement-class-software-dev`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Declare this workspace as a **software-development** project class and hold the **residual collection** of software-engineering stack facts **not already owned** by more specific Active `requirement-shell-*.md` or `requirement-domain-timer.md` peers: primary language, toolchain policy, package/test tooling, and runtime OS family.

This file is **class law + residual SSOT**, not a second copy of Type 0 lifecycle, checksum, output, domain pillars, or storage tables (those stay on peer requirements).

---

## 2. Core Rules (Mandatory)

### 2.0 Project class membership

1. **MUST** treat this workspace as **software-development** (shippable software), not genesis-template and not server-maintenance.  
2. **MUST** use basename **`requirement-class-software-dev.md`** as the sole Active class-law file for this class.  
3. **MUST NOT** register an Active `requirement-class-server-maintenance.md` while class is software-development.  
4. **MUST** retain portable harness knowledge; specialized product knowledge lives in this and peer `requirement-*.md` files.  
5. **MUST** apply software-development SSOT/gate posture when claimed (identity triad, channel, ship unit, precommit when git is used — as applicable).  
6. **MUST NOT** invent hollow product docs solely to look specialized; collect real values or defer explicitly.

### 2.1 Residual collection principle (SSOT hygiene)

7. **MUST** treat this file as the **default home** for software-stack facts **not owned** by another Active requirement.  
8. **MUST NOT** duplicate full normative tables that already live in a more specific Active requirement (e.g. full Type 0 self-management, automatic-checksum law, `out_*` catalog, domain four pillars). Prefer a **one-line pointer** to the peer requirement key.  
9. When a new specialized requirement **takes ownership** of a topic previously only listed here, **MUST** update this file in the **same change**: remove or shrink the residual entry and point to the new owner.  
10. **MUST NOT** leave contradictory stack facts across this file and peer requirements (e.g. two different “primary language” claims).

### 2.2 Programming language(s)

11. **MUST** declare at least one **primary programming language** (or language family) for the ship unit / product implementation.  
12. **SHOULD** list secondary languages only when they are real product law, not incidental docs.  
13. **MUST** state whether the product is primarily: interpreted, compiled, polyglot, or package-multi-language — as a closed choice.  
14. **MUST NOT** freeze a marketing product name as if it were the language name; language identifiers are stack facts (e.g. `posix-sh`), not brands of *this* product.

### 2.3 Compilers, interpreters, and toolchains

15. **MUST** declare the **target toolchain class** used to build or run the product.  
16. **MUST** state version policy as one of: unconstrained · minimum version · range · pinned.  
17. **SHOULD** record whether cross-compilation is in scope.  
18. **MUST** fail closed in CI/docs claims: do not claim “supports all compilers” without tests or explicit unconstrained policy.

### 2.4 Project / package / build tools

19. **MUST** declare the **primary project or package tool** used for dependencies and builds.  
20. **MUST** declare how dependencies are resolved when the ecosystem supports lockfiles.  
21. **SHOULD** name the test runner and linter/formatter **classes** when they are project law.  
22. **MUST NOT** require a secret token or private registry password in this file.

### 2.5 Runtime and platform (residual)

23. **MUST** declare the intended **primary runtime/OS family** choice set when not fully owned by another architecture requirement.  
24. **SHOULD** declare minimum CPU/arch support only when it is real product law.  
25. **MUST** separate **developer machine** toolchain requirements from **end-user runtime** requirements when they differ.

### 2.6 No-hardcode / dual policy (class file)

26. **MUST NOT** hard-code a single product/app brand, one org’s production hostname, or personal owner identity as universal core law.  
27. **MUST** put live product name, repo slug, and concrete stack choices in **Implementation Notes** (and product README/Config SSOTs where applicable) after collection — complete, not stubbed, when Status is Active.  
28. **MUST NOT** store secrets, PATs, or toy credentials in this file.

### 2.7 Implementation Notes (this project)

| Field | Value (timer) |
|-------|---------------|
| **Project display name** | `timer` (product root `README.md` H1 SSOT) |
| **Project class** | software-development |
| **Class requirement basename** | `requirement-class-software-dev.md` |
| **Primary language(s)** | `posix-sh` (`/bin/sh`) |
| **Language role** | primary only — single-file shell ship unit |
| **Execution model** | **interpreted** — no compile step |
| **Toolchain / interpreter** | POSIX `/bin/sh` (dash/bash-as-sh compatible subset); no compiler |
| **Toolchain version policy** | **unconstrained** among POSIX sh implementations that pass `tests/` |
| **Cross-compile in scope?** | no |
| **Primary project/package tool** | **none** — no `package.json` / `pyproject` / language module system; ship unit is the source |
| **Lockfile policy** | not used |
| **Test runner** | `tests/run.sh` + `tests/test_cli.sh` + `tests/test_install_lifecycle.sh` + `tests/test_timer_domain.sh` (POSIX shell) |
| **Linter/formatter** | none as project law (shellcheck optional for maintainers, not required gate) |
| **Primary runtime / OS family** | POSIX Linux (and compatible UNIX where `/bin/sh` + coreutils/`sha256sum`/`mktemp` exist) |
| **Architectures supported** | any arch with a POSIX sh and the external tools the script invokes (no arch-specific binary) |
| **Git surface** | used for product publish (`github.com/Wilgat/timer`) |
| **Ship unit / install** | yes — repo root `./timer` + companion `timer.sha256`; Type 0 online install (peer shell REQs) |
| **Product version SSOT** | `VERSION="…"` hard-assign in `./timer` (align with README Version badge + CHANGELOG) |
| **Domain SSOT** | `requirement-domain-timer` — named-timer ops beyond Type 0 |

**Residual ownership table:**

| Topic | Owner | Notes |
|-------|-------|--------|
| Project class membership | **this file** | Fixed |
| Primary language + toolchain policy | **this file** | posix-sh, unconstrained |
| Package/build tool + lockfile | **this file** | none / not used |
| Type 0 CLI surface / flags / dispatch | `requirement-shell-cli-interface` | Do not duplicate |
| Empty argv Type O install-ensure | `requirement-shell-cli-zero-arguments` | Do not duplicate |
| Self-management lifecycle | `requirement-shell-self-management` | Do not duplicate |
| Automatic companion digest | `requirement-shell-automatic-checksum` | Do not duplicate |
| Output SSOT (`out_*`) | `requirement-shell-output-requirements` | Do not duplicate |
| Idempotency / re-run safety | `requirement-shell-idempotency` | Do not duplicate |
| Interactive vs non-interactive | `requirement-shell-interactive-vs-noninteractive` | Do not duplicate |
| Modular prefixes / single-file layout | `requirement-shell-modular-function-design` | Do not duplicate |
| Named-timer domain (four pillars) | `requirement-domain-timer` | Do not duplicate |

---

## 3. Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional Verbosity & Transparency** (https://github.com/cloudgen/ciao): Class and stack choices are explicit, not assumed from folder names.  
- **CIAO Principle 5 – Single Source of Output** (https://github.com/cloudgen/ciao): Residual stack facts have one home until specialized requirements take ownership (SSOT hygiene for law surfaces).  
- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Version and toolchain policies are declared; agents do not invent compilers or package managers.  
- **CIAO Principle 21 – Dual Policies** (https://github.com/cloudgen/ciao): Portable core; filled Implementation Notes; no product brand hardcode in core rules.  
- **CIAO Principle 4 (O) + Principle 20** (https://github.com/cloudgen/ciao): Protection Rule against dual stack SSOTs and wrong-class pollution.

---

## 4. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Assume toolchain and package tools are missing until declared and verified.  
- **Intentional**: Residual collection is deliberate — not a dump of every possible tool.  
- **Anti-fragile**: Unconstrained POSIX sh policy survives multi-env runs when tests pass.  
- **Over-protect**: Protection rule prevents dual stack SSOTs and genesis/class confusion.

---

## 5. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Delete this file while the workspace remains **software-development** with other Active product requirements.  
2. Rename the specialized basename away from `requirement-class-software-dev.md` without an explicit class-model change.  
3. Hard-code secrets, personal owner identity, or production host FQDNs into core rules as universal law.  
4. Duplicate full peer shell- or domain-requirement bodies into this residual section.  
5. Leave Implementation Notes as hollow stubs when Status claims Active.  
6. Claim multi-language / multi-compiler support without tests or explicit policy.  
7. Treat this file as server-maintenance allowlist law, or register an Active server-maintenance class file in parallel.  
8. Invent a second primary language SSOT that contradicts peer modular/CLI requirements.  
9. Wipe domain SSOT while domain surface remains on the ship unit.

**Violating any of these is considered a critical regression.**

---

## 6. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Active registered `requirement-class-software-dev.md` matches software-development class |
| AC-2 | Primary language + toolchain policy + package tool declared in Implementation Notes (complete) |
| AC-3 | Residual ownership table honest: no silent dual SSOT with peer shell/domain REQs |
| AC-4 | Core rules remain free of frozen secret/host hardcodes |
| AC-5 | No class file conflict with `requirement-class-server-maintenance` |
| AC-6 | Ship unit identity (posix-sh single-file Type 0 + domain) consistent with peer REQs |

---

## 7. Related requirements (peer keys only)

| Key | Relationship |
|-----|--------------|
| `requirement-shell-cli-interface` | Command surface, flags, dispatch |
| `requirement-shell-cli-zero-arguments` | Type O empty argv |
| `requirement-shell-self-management` | Lifecycle |
| `requirement-shell-automatic-checksum` | Companion integrity |
| `requirement-shell-output-requirements` | `out_*` SSOT |
| `requirement-shell-idempotency` | Re-run safety |
| `requirement-shell-interactive-vs-noninteractive` | Mode policy |
| `requirement-shell-modular-function-design` | Prefixes / single-file modularity |
| `requirement-domain-timer` | Named-timer domain product law |
| `docs/requirements/index.md` | Registry SSOT |

---

## 8. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-07-19 | Active | Class gate fix (software-development missing Active class REQ) |

---

**Last Updated**: 2026-07-19  
**Owner**: timer maintainers  
**Alignment**: software-development class; peer shell + domain REQs; dual policies; registry discipline.
