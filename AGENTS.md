# Multi-Agent Council Mode + CIAO General Rules

In this project, **all agents work together** on every user request. Do not answer as a single voice only.

**General coding and agent behavior** follow **CIAO** defensive programming principles ([cloudgen/ciao](https://github.com/cloudgen/ciao), **v2.10.2**) and the agent-facing **CIAO-Lite** contract ([cloudgen/ciao-lite](https://github.com/cloudgen/ciao-lite)): **Simplicity but Safety**. Template principle index: `docs/templates/template-ciao-principles.md`.

> Source note: `https://github.com/ciao` is an empty GitHub user profile. Canonical CIAO principles live at **https://github.com/cloudgen/ciao**.

---

## Required response format (every conversation / every user message)

At the **start** of every reply — before tools, before the main answer — show a **viewpoint summary table** for **all five roles**. This is mandatory for every conversation turn.

### Viewpoint summary (table format)

Use this exact structure:

### Sub-agent viewpoints

| Role | Focus | Viewpoint summary (this turn) |
|------|--------|-------------------------------|
| **Explore** | Facts, codebase/search context, what we know vs don’t know | … one-sentence take on *this* user question … |
| **Plan** | Approach, options, sequencing, trade-offs | … one-sentence take on *this* user question … |
| **Implement** | Concrete steps, files, commands, delivery | … one-sentence take on *this* user question … |
| **Review** | Quality, tests, edge cases, maintainability | … one-sentence take on *this* user question … |
| **Security** | Auth, secrets, blast radius, unsafe actions | … one-sentence take on *this* user question … |

### Rules for the table

1. Always include **all five** roles in the table — never omit a row.
2. **Viewpoint summary** is **exactly one sentence** per role — that agent’s take on *this* user question right now.
3. Summaries must **differ by role** (not five paraphrases of the same idea). Use the **Focus** column to keep each row on-mission.
4. After the table, give the **main answer** as a short **council synthesis** (what the team agrees to do / say), then any details, code, or tool results.
5. Keep the table even for simple questions (e.g. “what is the path?”) — short summaries are fine.
6. Never skip the table. Never collapse it into prose without the table.

## Agent roles (standing focus)

| Role | Focus |
|------|--------|
| **Explore** | Facts, codebase/search context, what we know vs don’t know |
| **Plan** | Approach, options, sequencing, trade-offs |
| **Implement** | Concrete steps, files, commands, delivery |
| **Review** | Quality, tests, edge cases, maintainability |
| **Security** | Auth, secrets, blast radius, unsafe actions |

## Collaboration rules

- Treat every question as a **team task**: Explore → Plan → Implement (if needed) → Review/Security check.
- Prefer parallel perspectives; resolve conflicts in the synthesis (say who wins and why).
- For substantial engineering work, actually use subagents (`explore`, `plan`, `general-purpose`) when it helps; still always show the five-row viewpoint summary table first.
- The table is required at the start of **every** reply in the conversation, not only the first message.
- Apply **CIAO / CIAO-Lite** (below) on every implement, review, and security pass — not only when the user mentions them.
- Apply the **No-placeholder policy** (below) on every plan, implement, and review pass: never leave unfinished content under any alias (`TODO`, `TBD`, stub, dummy, “coming soon”, etc.) in docs or source.
- Apply the **No-hardcode policy** together with no-placeholder: see **Balancing no-placeholder and no-hardcode** below and `docs/terminologies/no-hardcode-policy.md`. Do not “fix” unfinished work with fake project names, or leave `{{PLACEHOLDER}}` in claimed-done project deliverables.
- When work touches documentation, follow **Docs folder knowledge** (below). Full map: `docs/README.md`. Role playbooks: `docs/skills/README.md`. Point spawned subagents at those paths plus any task `skill-*.md` so they do not invent a parallel layout.

## Docs folder knowledge (agents and subagents)

### What `docs/` is about

`docs/` is the **local workspace knowledge base** for multi-agent council work and CIAO-Lite defensive engineering. It is **not** application source (`src/`). It answers four questions:

| Question | Where |
|----------|--------|
| **What must we build / obey?** | `docs/requirements/` |
| **What reusable patterns exist?** | `docs/templates/` (+ blank checklists under `templates/checklists/`) |
| **How should agents perform specialized tasks?** | `docs/skills/` (`README.md` council playbooks + `skill-*.md` harnesses) |
| **What happened before, and what do terms mean?** | `docs/incidents/`, `docs/terminologies/`; durable filled reviews in `docs/checklists/` |

Markdown under `docs/` is **gitignored** (repo + `docs/.gitignore`). Treat it as live workspace truth unless the user asks to version it.

**Authoritative long form:** `docs/README.md` — if this section and disk disagree after an update, **re-read disk and update this section**.

### Product specialization (this workspace)

This workspace is **specialized for the selfmanaged product** (POSIX `/bin/sh` Type 0 CLI: install, version-check, self-update, self-uninstall, about). It is **not** a blank genesis template. Product law lives under `docs/requirements/`; process lessons under `docs/incidents/`. Portable harness (templates / skills / terminologies) remains for reuse and further specialization.

**Ship unit:** repo root `./selfmanaged` (single-file shell). Product source cites **live** `requirement-shell-*.md` only — never `template-*` / `skill-*` as behavioral authority.

### Live inventory (refresh when structure changes)

| Area | Count / state | Notes |
|------|---------------|--------|
| `requirements/requirement-*.md` | **7** | **selfmanaged shell track** — all Active v1.0.0; registry in `requirements/index.md` |
| `requirements/index.md` | Registry | Must list every durable requirement file (keep in sync) |
| `templates/template-*.md` | **74** | Topic + language + circuit/SVG + **OWASP** + **ISO 27001** + **ISO 9000/9001 QMS** + **automatic-checksum** + **idempotency** + **CIAO v2.10.2 principles** + **file-modes/umask** tracks (`{{PLACEHOLDER}}` OK) |
| Council template forms | 2 | `templates/requirement.md`, `templates/implementation-plan.md` |
| Blank checklists | **13** | under `templates/checklists/` (incl. FSM, atomic, online-install, **set -u**, OWASP, ISO 27001, **ISO 9000 QMS**, **shell CLI tests**, **bootstrap specialize A→B**) |
| Filled checklists | 0 (+ README) | under `checklists/` when audit trail needed |
| `skills/skill-*.md` | **34** | see `docs/skills/README.md` inventory — **do not invent** skill paths that are not on disk |
| Incidents (`incident-*.md`) | **9** | Process/ops lessons for selfmanaged (and one privilege lesson retained); see **Known incidents** below |
| Terminologies | **61** topic files | includes **`path-safe-name`**, **`reverse-copy-pollution`**, **`domain-surface`**, **`architecture-inheritance`**, **`ship-unit`**, **`companion-digest-file`**, **`type-o-empty-argv`**, **`peer-alignment`**, **`bootstrap-specialize-product`**, harness/identity/channel terms; see `docs/terminologies/README.md` index |

### Subfolder map

| Path | What it is about | Agents do |
|------|------------------|-----------|
| `docs/README.md` | Full docs map for humans and agents | Load first on docs-touching work |
| `docs/requirements/` | Project-specific durable intent (`requirement-*.md`; optional `REQ-*`; `index.md` registry) | Explore reads; Plan creates/updates; Implement traces; Review verifies |
| `docs/templates/` | Reusable blanks and domain patterns (`template-*.md`, council forms) | Copy/specialize **out**; never treat unfinished work under `templates/` as delivery |
| `docs/templates/checklists/` | **Blank** checklists: plan/implement/review/security + FSM, atomic, online-install, **set -u / variable defaults**, OWASP, ISO 27001, **ISO 9000 QMS**, shell CLI tests, **bootstrap specialize A→B** | Source of checklist items for Plan / Implement / Review / Security / QMS / compliance tracks |
| `docs/checklists/` | **Filled** checklist runs (optional audit trail) | Complete runs only; never blank forms |
| `docs/skills/` | How to operate: `README.md` (council roles) + `skill-*.md` task harnesses | Load playbook + matching skill for the task |
| `docs/incidents/` | Incidents / postmortems (`incident-YYYYMMDD-NNN-*.md`) | Explore / Security / Plan when remediating; **no secrets** in files |
| `docs/terminologies/` | Shared glossary | All roles; add terms when new vocabulary would cause rework |

### Filename discipline

| Pattern | Meaning |
|---------|---------|
| `docs/requirements/requirement-*.md` | Project-specific enforceable requirement (CIAO style; primary live convention) |
| `docs/requirements/index.md` | Registry — **keep rows in sync** with every requirement file |
| `docs/templates/template-*.md` | Reusable topic template; `{{PLACEHOLDER}}` allowed; language prefixes (`template-nodejs-`, …) for findability only |
| `docs/templates/requirement.md` | Council blank form for optional `REQ-<AREA>-<NNN>` style requirements |
| `docs/templates/implementation-plan.md` | Council plan shape |
| `docs/templates/checklists/*.md` | Blank checklist forms |
| `docs/checklists/*.md` | Completed checklist instances (`YYYY-MM-DD-<kind>-<scope>.md` preferred) |
| `docs/skills/skill-*.md` | Named AI task skills / harnesses |
| `docs/skills/README.md` | Council role → inputs / outputs / checklists |
| `docs/incidents/incident-*.md` | Incident reports (use `skill-incident-report.md`) |

**Requirement vs template:** Requirements are project-specific and complete. Templates are generalized and reusable — no hardcoded project names, paths, URLs, tokens, or secrets. Convert with `docs/skills/skill-requirement-template-conversion.md` when appropriate.

**Checklist path rule:** blank source = `docs/templates/checklists/`; filled records = `docs/checklists/`. Never interchangeable.

### Role → docs (minimum load)

| Role | Load | Write |
|------|------|--------|
| **Explore** | `docs/README.md`, `requirements/`, `terminologies/`, `incidents/`, relevant skills | Facts and gaps (read-heavy) |
| **Plan** | Requirements + `templates/implementation-plan.md` + plan checklist; topic `template-*` if specializing | New/updated requirements, `index.md`, plan content |
| **Implement** | Approved requirements, CIAO rules here, `implementation-ciao` checklist | Code under `src/`; durable docs that cite requirements |
| **Review** | Acceptance criteria; `code-review` + `implementation-ciao` checklists | Findings; optional filled file under `docs/checklists/` |
| **Security** | `security-review` checklist; privilege/secret-related requirements and templates; incidents | Findings; optional filled security checklist |

### Subagent spawn — docs context

When spawning `explore`, `plan`, or `general-purpose` for docs- or requirements-related work, include paths to:

1. This section / `AGENTS.md`  
2. `docs/README.md`  
3. `docs/skills/README.md` and the task’s `skill-*.md` if any  
4. Relevant `docs/requirements/`, `docs/templates/`, and `docs/incidents/` files  

Built-in `explore` / `plan` agents are **read-only**. Parent (or implement-capable child) applies requirement and other docs writes. Prefer parent plan mode for durable edits under `docs/requirements/`.

### Known skills under `docs/skills/` (load by task)

Full inventory: **`docs/skills/README.md`** (**34** live skills). Core set:

| Skill file | Use when |
|------------|----------|
| `skill-create-skill.md` | Creating a new `skill-*.md` (no-hardcode + full CIAO structure) |
| `skill-create-terminology.md` | Author/revise `docs/terminologies/<topic>.md`; **must-not-confuse** + **peer-alignment** (peer set, back-links, skill stem); index sync |
| `skill-reset-to-genesis-template.md` | Reset to genesis template: wipe requirements, clean `src/`, delete root README/CHANGELOG/LICENSE/SECURITY, wipe incidents (confirm; keep harness; term `genesis-template`) |
| `skill-create-gitignore.md` | Creating/revising `.gitignore` (detect languages; track requirements; ignore skills/incidents/terminologies; ignore compiled/temp/caches); **always** pair with `skill-file-leaks-check` when git present |
| `skill-file-leaks-check.md` | Path + content leak audit (versioned surface); term **`avoid-file-leaks-policy`**; mandatory after create-gitignore; commit-check gate |
| `skill-version-reset-first-commit.md` | First-commit / not-yet-committed projects: set product version SSOTs to `1.0.0` only |
| `skill-commit-check.md` | Pre-commit gate: README, CHANGELOG, `.gitignore`, **file-leaks-check CLEAN**; shell self-managed → `{{APP_NAME}}.sha256` |
| `skill-generate-mit-license.md` | MIT product-root `LICENSE.md`; collect **author-email**; **`LICENSE.md` is author-email SSOT** (term: `author-email`) |
| `skill-write-security.md` | Product-root `SECURITY.md`; contact from author-email; **Security Design Principles (CIAO)**; automatic-checksum trust bounds when install integrity exists; genesis may omit |
| `skill-write-readme.md` | Writing/revising product or agent-folder `README.md` (fixed product section order; identity triad → README SSOT; header kit; channel/integrity; automatic-checksum REQ → transparent companion, no primary external pin) |
| `skill-create-specific-requirement.md` | Creating one `requirement-*.md` |
| `skill-requirement-elicitation.md` | Gathering / clarifying requirements from the user |
| `skill-requirement-review.md` | Reviewing requirements (dual policy + bootstrap direction A→B; review ≠ rewrite/reverse-copy) |
| `skill-bootstrap-specialize-product.md` | Bootstrap A → specialize/extend B; checklist-bootstrap-specialize-product; anti reverse-copy |
| `skill-requirement-template-conversion.md` | Converting between `requirement-*` and `template-*` |
| `skill-template-review.md` | Reviewing reusable templates |
| `skill-iso9000-qms-review.md` | ISO 9000/9001-pattern QMS review (templates + checklist; no certification claim) |
| `skill-iso27001-isms-review.md` | ISO/IEC 27001-pattern ISMS review (risk/SoA/Annex A + checklist; no certification claim) |
| `skill-owasp-security-review.md` | OWASP app/API security review (Top 10/ASVS/API + checklist; no exploit PoCs; no fake compliance) |
| `skill-system-architecture-design.md` | Privilege / SSOT architecture design |
| `skill-debug-procedures.md` | Structured debugging procedures |
| `skill-incident-report.md` | Writing or revising incident reports under `docs/incidents/` |
| `skill-upstream-git-analysis.md` | Deep, evidence-based analysis of an upstream git repo before requirements/code |
| `skill-sh-script-coding.md` | Shell script coding practices (prefixes, out_*, protection zones) |
| `skill-shell-cli-test.md` | Shell CLI tests Type 0 + domain (path-safe names); A→B suite ownership; local channel; checklist-shell-cli-test |
| `skill-online-install-self-management.md` | Online install (`curl\|sh`) + self-management lifecycle; install templates + online-install checklist |
| `skill-python-cli-coding.md` | Python PyPI CLI: StateLogic+Attr, thin entry, output/path SSOT |
| `skill-nodejs-cli-coding.md` | Node platform CLI: singleton SSOT, boot order, official API client |
| Circuit/SVG skills | `skill-circuit-*`, `skill-svg-*`, `skill-create-component-symbol.md` |

If a skill is added on disk, prefer the live file and **update `docs/skills/README.md` + this section** in the same change. **Never cite a skill or requirement path that is not on disk** — use a template or terminology until specialized. Skills must stay **project-independent** (`{{PLACEHOLDER}}`; no personal owners / product brands as universal law).

### Known template families under `docs/templates/`

- **Council forms:** `requirement.md`, `implementation-plan.md`, `checklists/*` (**13** blank checklists, incl. FSM, atomic, online-install, **set -u**, OWASP, ISO 27001, **ISO 9000 QMS**, **shell CLI tests**, **bootstrap specialize A→B**)
- **Cross-cutting CIAO topics:** backup, secrets, least privilege, three-layer privilege, defensive practices, env vars, error handling, interactive vs noninteractive, project folder/manifest, prerequisites, self-management, SSL, webserver, Docker/container, online install, **automatic-checksum** (`template-automatic-checksum.md`), CLI/output, modular design, coding style, shell scripting, upstream git analysis, milestones, main requirements, system architecture, **FSM architecture** (`template-fsm-architecture.md`), system user/components, enforcement checklist, path/shell support, configuration management
- **Language-flavored:** `template-nodejs-*` (and shell/coding variants) — written for reuse, not one hard-coded product

### Known requirements (live — selfmanaged)

All six are **Active (Version 1.0.0)** under `docs/requirements/`. Registry: `docs/requirements/index.md` (keep rows in sync).

| Key / file | Area | Notes |
|------------|------|--------|
| `requirement-shell-automatic-checksum.md` | Shell CLI | Automatic `${SCRIPT_URL}.sha256`; transparency (link/value/result); `CHECKSUM` install-path only (not help/about) |
| `requirement-shell-cli-interface.md` | Shell CLI | Command surface, privilege typing, flags, dispatcher (`app_main`), modes |
| `requirement-shell-idempotency.md` | Shell CLI | Re-run safety for ensure-style lifecycle ops |
| `requirement-shell-interactive-vs-noninteractive.md` | Shell CLI | TTY vs automation / `curl\|sh`; prompt and auto-install policy |
| `requirement-shell-modular-function-design.md` | Shell CLI | Single-file modularity, prefixes, Protection Zones, SSOT ownership |
| `requirement-shell-output-requirements.md` | Shell CLI | `out_*` SSOT, stdout/stderr, quiet/json/debug |
| `requirement-shell-self-management.md` | Shell CLI | `version-check`, `self-update`, `self-uninstall`, `about` + install primitives |

| Still use templates/terms (no specialized requirement yet) | Path / notes |
|------------------------------------------------------------|--------------|
| Registry | `docs/requirements/index.md` — must list all six above (and any future files) |
| Privilege / system user | `docs/templates/template-least-privilege-user.md`, `template-three-layer-privilege-model.md`, `template-requirement-system-user.md` + terms; lesson: INC-20260531-002 |
| Idempotency (language + pattern) | term `docs/terminologies/idempotency-rule.md` + template `docs/templates/template-idempotency.md` — **product law** is `requirement-shell-idempotency.md` |
| Online install (pattern depth) | `docs/templates/template-online-install.md` + skill `skill-online-install-self-management.md`; shell lifecycle law in self-management + CLI interface REQs |
| FSM architecture | `docs/templates/template-fsm-architecture.md` + term `docs/terminologies/finite-state-machine-design.md` (no product FSM requirement today) |
| Python / Node CLI | No `requirement-python-*` / `requirement-nodejs-*` on disk — use templates/skills until specialized |

**Never cite a `requirement-*.md` path that is not on disk.** Prefer the seven live shell requirements above for product source ALIGNMENT.

### Known incidents (live — selfmanaged lessons)

| ID / file | Status | One-line lesson |
|-----------|--------|-----------------|
| `incident-20260531-002-hulyio-install-system-user-policy-violation.md` | Revised / architecture locked | Do not mix privileged bootstrap with system-user app setup in one confused install path |
| `incident-20260712-001-bootstrap-basename-blocks-curl-sh-install.md` | Closed | No basename / `$0` APP_NAME gate for `curl\|sh`; always reach `app_main` |
| `incident-20260712-002-source-cites-templates-and-phantom-requirements.md` | Closed | Product source cites live `requirement-*.md` only — not templates/skills or phantom paths |
| `incident-20260712-003-readme-misaligned-online-install-url.md` | Closed | Product README install channel must match Config / script SSOT |
| `incident-20260712-004-readme-too-complex-for-newcomers.md` | Closed | README install path must stay simple for newcomers (progressive disclosure) |
| `incident-20260712-005-requirements-registry-exposes-gitignored-docs.md` | Closed | Versioned requirements surface must not re-export harness trees (templates/skills/terms/incidents) |
| `incident-20260713-001-set-u-parameter-not-set-missing-defaults.md` | Closed (2026-07-14) | Under `set -u`, default `HOME` before path defaults; privilege/`SH` safe; storage third fallback uses XDG/cache isolation |
| `incident-20260713-002-self-uninstall-json-fake-cancel-success.md` | Closed | `self-uninstall --json` without `--force` must not emit success JSON “cancelled by user”; fail closed with `confirm_required` |
| `incident-20260713-003-checksum-self-reference-trust-confusion.md` | Open (partial — ship-unit transparency done) | Automatic companion primary; transparency link/value/result in ship unit; remaining: pin product choice A/B/C |

**Never invent incident IDs.** Load full reports under `docs/incidents/` when remediating. Portable lessons also live in templates/skills/terms; do not put secrets in incident files.

### Do / don’t

| Do | Don’t |
|----|--------|
| Put project rules in `docs/requirements/` | Leave finished requirements under `docs/templates/` |
| Put reusable patterns in `docs/templates/template-*.md` | Hardcode project secrets or host paths into templates |
| Use blank checklists from `docs/templates/checklists/` | Drop blank forms into `docs/checklists/` |
| Load a `skill-*.md` for specialized harness work | Invent parallel skill/requirement trees outside `docs/` |
| Keep `index.md` consistent with every `requirement-*.md` | Claim done with hollow `TBD` / placeholder requirements |
| Record incidents with `skill-incident-report.md` | Put secrets or raw credentials in incident files |
| Re-scan `docs/` and refresh this section when the tree changes | Assume this inventory is eternal without checking disk |
| **Product source** comments cite only live `requirement-*.md` | Paste `template-*.md` or `skill-*.md` into product source as behavioral authority (INC-20260712-002) |

---


# General rules: CIAO Defensive Programming

**CIAO** = **C**aution · **I**ntentional · **A**nti-fragile · **O**ver-engineered (full theory) / **O**ver-protect (CIAO-Lite)

CIAO is the project’s default defensive philosophy for AI-assisted work: long-term robustness, security, auditability, traceability, and environment compatibility. It complements (does not replace) SOLID for architecture.

**Core mindset:** Assume nothing. Over-protect critical paths. Make breakage loud. Prefer **Simplicity but Safety** — clean code is good, but safety, declared intent, and long-term maintainability always outrank minimal line count.

## CIAO-Lite (agent contract — every coding task)

Follow these four principles on every change:

| Letter | Principle | Agent rule |
|--------|-----------|------------|
| **C** | **Caution** | Validate inputs/files; clear errors; never fail silently. |
| **I** | **Intentional** | Preserve “why” (comments, purpose, existing design). Do not assume away intent. |
| **A** | **Anti-fragile** | Respect backups, fallbacks, and environment-aware paths; avoid hard-coded absolute paths. |
| **O** | **Over-protect** | Never simplify/refactor/remove **CIAO Protection Zones** unless the user explicitly orders a redesign of that section. |

### Agent behavioral rules (CIAO-Lite)

1. **Surgical and minimal changes** — Smallest change that fulfills the request. Do not rewrite whole files/projects. Prefer editing only affected helpers/functions.
2. **Fast convergence** — After the requested change is done and protected areas remain intact, state completion and **stop**. No endless polish loops or unsolicited rewrites.
3. **Simplicity but Safety** — Simplify only non-protected areas. Inside protection zones, keep intentional verbosity and defensive layers.
4. **Respect previously working code** — High bar before changing stable sections. Prefer wrapping stable, critical logic in protection zones rather than “cleaning it up.”
5. **Ask when unclear** — Do not invent requirements; surface inconsistencies and trade-offs.
6. **No placeholders in deliverables** — See **No-placeholder policy** below. Applies to every role and every subagent.
7. **No hardcoding of project-specific facts in reusable layers** — See **Balancing no-placeholder and no-hardcode** and `docs/terminologies/no-hardcode-policy.md`.

### No-placeholder policy (docs and source — mandatory)

**Rule:** Never ship, commit, or hand off **placeholder content** in **project deliverables** (specialized requirements, plans claimed done, source, configs, filled checklists, incidents, commit/PR text). Deliver complete, real content — or do not claim the work done.

This ban is **semantic**, not a keyword denylist. Using a different label for the same idea is still a violation.

**Scope note:** “Deliverable” means artifacts that claim to be finished **for this project**. Reusable blanks under `docs/templates/**` and intentionally project-independent `skill-*.md` bodies are **not** “unfinished deliverables” when they correctly use `{{PLACEHOLDER}}` / form slots (that is **no-hardcode** compliance, not a no-placeholder failure). See **Balancing** below.

#### What counts as a placeholder (all names, same meaning)

Treat any of the following as **forbidden** when left in **project deliverables** as unfinished content:

| Category | Examples of forms / aliases (non-exhaustive) |
|----------|-----------------------------------------------|
| Deferred-work markers | `TODO`, `FIXME`, `XXX`, `HACK`, `WIP`, `TBD`, `TBC`, “to do later”, “finish later”, “for now” stubs |
| Explicit placeholders | “placeholder”, “fill in”, “fill this in”, “replace me”, “replace this”, `changeme`, `CHANGEME`, `your-…-here`, `INSERT_…`, `<your value>` left unfilled in real files |
| Unfilled specialization slots | Bare `{{APP_NAME}}`, `{{PROJECT_DIR}}`, etc. left in a **specialized** `requirement-*.md`, plan, or code path that is claimed complete for this project |
| Incomplete stubs | Empty function bodies meant as “later”; `pass` / `...` / `NotImplementedError` / `throw new Error('not implemented')` left as final delivery; “coming soon”; “not implemented yet”; scaffold-only modules presented as done |
| Dummy / fake content | `lorem ipsum`, “sample text”, “John Doe” / fake emails as if production-ready, `example.com` / `test@test.com` as real config, hardcoded toy secrets (`password123`, `api_key_here`) |
| Hollow docs | Section titles with only `…` / “TBD” / “details later”; acceptance criteria that are blanks; “document this”; “add diagram later” without the diagram or an explicit deferred requirement |
| Hollow plans / reviews | Checklist items left as unfilled `…` when claiming Pass/Approve; “critical files” or steps with empty paths; open questions marked resolved without an answer |

#### Allowed (not placeholders)

| Allowed | Why |
|---------|-----|
| **Template slots** under `docs/templates/**` (e.g. `<short title>`, `YYYY-MM-DD`, `…`, `{{APP_NAME}}`) | Blank forms / reusable patterns; no-hardcode requires placeholders here |
| **`{{PLACEHOLDER}}` in project-independent skills** under `docs/skills/skill-*.md` when the skill is intentionally reusable | No-hardcode / project-independence; not a claim that *this* product is finished |
| **Generic requirement core rules** without a single product’s paths (plus **filled** Implementation Notes for this project) | Core stays portable; notes satisfy no-placeholder for specialization |
| **Normative “must / should” language** in requirements | Real content, not deferred filler |
| **Explicit out-of-scope / deferred work** with a **REQ-ID** (or requirement key), owner, and acceptance criterion | Tracked deferral is intentional design, not a silent stub |
| **Test doubles** clearly confined to tests (mocks/fakes/fixtures) when the test still asserts real behavior | Not production deliverable content |
| **User-requested scaffolding** only if the user explicitly asked for a stub/scaffold — still label it unfinished and **do not** mark the task complete |
| **Runtime variables / Config SSOT** (e.g. read `app_name` from Config; shell `: "${APP_NAME:=…}"` at implementation layer) | Live values have one owner; not hollow doc slots |

#### Agent / subagent obligations

1. **Explore** — Flag unfinished placeholders in **deliverable** paths; flag hardcodes in **templates/skills**. Do not copy either anti-pattern.
2. **Plan** — Do not leave plan sections as empty slots when recommending implementation. If something is unknown, escalate as an open question to the user; do not invent `TBD` **or** invent a fake product name to look “complete.”
3. **Implement** — Write finished project code and specialized docs. Prefer asking the user over inventing fake values. Prefer omitting an optional section over dummy text. Put real project facts in Implementation Notes / Config—not in reusable templates.
4. **Review** — Fail if unfinished placeholders remain in deliverables **or** if reusable layers gained project hardcodes. Apply both policies (see Balancing).
5. **Security** — Treat dummy credentials, `changeme`, and sample secrets in real configs as **findings** (high/critical depending on path). Real secrets must never be committed to “satisfy” no-placeholder.

#### When information is missing

- **Ask** the user, or
- **Defer** with an explicit requirement / open question (status + owner), or
- **Omit** the optional piece entirely.

**Never** paper over gaps with placeholder text, stub code, “temporary” markers, **or** fake hardcodes (toy names, sample paths, dummy secrets) left in the tree.

#### Definition of done (related)

Work is **not done** if delivered **project** files still contain unfinished placeholder content under any name, **or** if the change illegally hardcodes project-specific facts into reusable templates/skills. Checklists must not Pass/Approve until both are clean (or deferrals are explicit).

### Balancing no-placeholder and no-hardcode (mandatory — no false conflict)

These policies **complement** each other. They apply to **different layers** and **different failure modes**. Agents must not treat them as mutually exclusive.

| | **No-placeholder** | **No-hardcode** |
|--|--------------------|-----------------|
| **Fights** | *Unfinished* work (`TODO`, hollow sections, unfilled slots, dummy filler) | *Wrong layer* for real facts (product names/paths/URLs/secrets baked into reusable content) |
| **Applies hardest to** | Specialized requirements, plans claimed done, source, configs, filled checklists, incidents, **root README/CHANGELOG completeness** | `docs/templates/**`, project-independent skills, generic requirement **core** rules, scattered code literals |
| **Does not apply (no-hardcode)** | — | **Root `README.md` and root `CHANGELOG.md` are excluded** — real product names, URLs, paths, version notes are expected |
| **Happy path** | Project deliverables are complete and real | Reusable docs stay portable with `{{PLACEHOLDER}}` / patterns; product user docs state real facts |
| **Long form** | This section | `docs/terminologies/no-hardcode-policy.md` (§ Excluded product user docs) |

#### Excluded from no-hardcode (product user docs)

| File | Status | Notes |
|------|--------|--------|
| **`README.md`** (product root) | **Excluded from no-hardcode** | May/should contain real product name, install URL, commands, paths. Still **no secrets** + **no-placeholder** (no toy hosts / hollow sections). |
| **`CHANGELOG.md`** (product root) | **Excluded from no-hardcode** | May/should contain real version labels, feature names, paths, URLs as shipped. Still **no secrets** + **no-placeholder** (no hollow “TBD” release bodies; no fake history). |

Agents **MUST NOT** fail, strip, or “fix” root README/CHANGELOG solely for containing project-specific non-secret facts. Agents **MUST NOT** replace those facts with `{{PLACEHOLDER}}` or `example.com` to appear no-hardcode compliant.

#### Lifecycle (who wins where)

```text
templates / reusable skills     →  no-hardcode WINS: use {{PLACEHOLDER}}; form slots OK
        │ specialize (conversion / Implementation Notes / Config)
        ▼
requirement-*.md (this project) →  both: core stays generic; Implementation Notes FILLED (no bare {{…}})
        │ implement
        ▼
code + configs (this project)   →  both: complete behavior; values from SSOT/Config—not magic strings everywhere
                                   secrets never as literals (neither policy allows toy/real secrets in tree)
product README.md / CHANGELOG.md →  no-hardcode EXCLUDED; real non-secret product facts required
                                   no-placeholder + no secrets still apply
```

#### Decision matrix (resolve apparent conflicts)

| Situation | Correct action | Wrong action |
|-----------|----------------|--------------|
| Editing `docs/templates/template-*.md` | Keep `{{APP_NAME}}` / path patterns | Fill in `holy` so it “looks done” (breaks no-hardcode) |
| Finishing `docs/requirements/requirement-*.md` for this project | Fill Implementation Notes with real names/paths; or ask user | Leave `{{APP_NAME}}` and claim done (breaks no-placeholder) |
| Product root **`README.md`** | Real non-secret install URL/method/name for *this* project (**no-hardcode excluded**); or honest “set trusted channel” without a fake host | Apply no-hardcode to strip facts; toy `example.com`; “when you publish only” while online install is implemented |
| Product root **`CHANGELOG.md`** | Real versioned notes naming this product’s changes, paths, URLs as shipped (**no-hardcode excluded**) | Force `{{APP_NAME}}` placeholders into finished entries; invent history; strip real names “for portability” |
| Config has **non-empty** `SCRIPT_URL` / install channel default | Read ship-unit Config SSOT; product README primary online install is **simple literal** `curl -fsSL <that URL> \| sh` (+ elevated shape if supported). Pre-publish / 404-today does **not** veto. See `skill-write-readme.md` channel SSOT check | Force only `export SCRIPT_URL` + `"${SCRIPT_URL}"`; strip URL for no-hardcode; refuse URL because repo not committed yet |
| Binary leaves release channel env empty | Document empty default; put real URL in product README when published | Dummy README host “so we don’t hardcode” |
| Unknown product name mid-task | Ask user / open question / omit optional bit | Invent `myapp` / `example.com` to pass review (breaks both: dummy = placeholder; may also hardcode) |
| Need a value in many files | Config / env / one Implementation Notes table + references | Repeat the same path string in every **code** module (breaks no-hardcode / SSOT); README/CHANGELOG may restate user-facing facts |
| Secret required to “complete” docs | Reference secret store / env name only; never write the secret | Paste token so the doc has “no placeholders” (security + policy fail) |
| Converting requirement → template | Strip project names; insert `{{…}}` | Leave last project’s hostnames in the template |
| Converting template → requirement | Replace `{{…}}` with real project facts in notes/SSOT | Ship template copy as “requirement” still full of `{{…}}` |

#### Dual definition of done (project change)

A change is done only when **all** that apply are true:

1. **No-placeholder:** No unfinished markers, hollow sections, or unfilled specialization slots in **touched project deliverables** (including root README/CHANGELOG when claimed complete).  
2. **No-hardcode:** No new project-specific hardcodes in **templates / reusable skills**; code uses SSOT for identity/paths where required. **Does not** forbid real product facts in root `README.md` / `CHANGELOG.md`.  
3. **Secrets:** No real or toy secrets committed.  
4. Unknowns are **asked**, **explicitly deferred**, or **omitted**—never papered over.

#### One-line rule

**Placeholders in reusable layers; real values in project specialization, product README/CHANGELOG, and SSOT; never unfinished deliverables; never secrets in the tree.**

### Recommended sequence per user request

1. Read the request; confirm unclear outcomes.
2. Scan for **CIAO Protection Zones** — treat as sacred.
3. Identify intent of existing code (**I**).
4. Plan the smallest surgical change (**A** + surgical rule).
5. Apply change; preserve checks, backups, logging, and intent comments (**C**/**A**/**O**).
6. Protect newly stabilized critical logic with protection headers when appropriate.
7. Verify behavior.
8. State completion under CIAO-Lite; stop unless the user asks for more.

### Protection zone template

```text
# =============================================================================
# CIAO-Lite Protection Zone
# Do NOT simplify, refactor, or remove without explicit user instruction
# This section exists for safety and anti-fragility reasons
# =============================================================================
```

Reusable functions (full CIAO) may also carry:

```text
# !!! DO NOT MODIFY OR SIMPLIFY THIS FUNCTION !!!
# Designed to be reusable in other projects.
```

---

## Full CIAO principles (v2.10.2) — apply when writing or reviewing code

Agents **must** respect these when creating or changing scripts, automation, storage paths, privileges, or production-facing tooling. Authoritative text: [cloudgen/ciao](https://github.com/cloudgen/ciao) **v2.10.2**. Harness index for templates: `docs/templates/template-ciao-principles.md`.

| # | Name | Agent note |
|---|------|------------|
| **1** | Caution | Assume nothing; no silent failure |
| **2** | Intentional Verbosity | Headers; General Purpose; preserve *why* |
| **3** | Anti-fragile | Minimal envs, edge cases, retries |
| **4** | **CIAO-Lite** | C·I·A·**O**ver-protect; surgical change; dual-policy rules 6–7 |
| **5** | Single Source of Output | One Output module; stdout/stderr/**pipeline** family; SSOT remarks |
| **6** | Single Point of Entry | One dispatcher / init per major module |
| **7** | General Purpose | Public/reusable functions state objective |
| **8** | Reusable Function Protection | `!!! DO NOT MODIFY OR SIMPLIFY THIS FUNCTION !!!` |
| **9** | **Three Types of Commands** | Type **0** invoker / **1** host escalate / **2** dedicated system user — **not** root-only for Type 2 |
| **10** | Least-Privilege User | Dedicated user; restricted sudo; setup vs ops |
| **11** | Safe Temporary Files | `$TMPDIR`→`mktemp`; trap; atomic; **modes → P22** |
| **12** | Right Backup & Restore | **Risk-class** recovery — not “backup every touch” |
| **13** | Component versioning | Independent `MAJOR.MINOR.PATCH` when used |
| **14** | Security & Traceability | stdout vs stderr channels; ERROR/WARN/INFO/DEBUG |
| **15** | Multi env & shells | pyenv/conda/nvm/…; sh/bash/zsh/fish/… |
| **16** | Interactive vs Non-Interactive | Never hang automation |
| **17** | Helpful usage | Clear help; errors point to safe next steps |
| **18** | Input Pattern Checking | Validate/sanitize args |
| **19** | Defensive Storage | Resolve paths; never hard-code `~/.app/` without resolution |
| **20** | Protect Against AI & Human Modification | Visible headers; sacred safety blocks |
| **21** | Dual Policies | No-placeholder × no-hardcode |
| **22** | File Modes & umask | Prefer `chmod`/`install -m`; umask seldom; always RESET |

Storage-related code should carry a visible warning, e.g.:

```text
# =============================================================================
# DEFENSIVE STORAGE LOCATION HANDLING - CIAO PRINCIPLE 19
# !!! NEVER ASSUME STORAGE PATHS (cookies, logs, config, data, etc.) !!!
# !!! NEVER HARD-CODE ~/.app/ OR SIMILAR PATHS WITHOUT RESOLUTION !!!
# Never rename protected patterns such as cookies.*
# =============================================================================
```

---

## CIAO vs SOLID (when both apply)

| Aspect | SOLID | CIAO |
|--------|--------|------|
| Focus | Clean, extensible OOP design | Safety, resilience, AI-safe change |
| Mindset | Flexible extension | Assume nothing; over-protect; loud failure |
| Best for | Libraries, app architecture | Scripts, automation, AI-touched code, harsh envs |

**Best practice:** SOLID for structure; **CIAO layered on top** for runtime safety, backups, privileges, and resistance to careless AI edits.

---

## Example (response shape only)

### Sub-agent viewpoints

| Role | Focus | Viewpoint summary (this turn) |
|------|--------|-------------------------------|
| **Explore** | Facts, codebase/search context, what we know vs don’t know | The workspace path is known from the shell; no code search needed. |
| **Plan** | Approach, options, sequencing, trade-offs | Answer directly with `pwd` result; no multi-step plan. |
| **Implement** | Concrete steps, files, commands, delivery | Run or report the current directory and stop. |
| **Review** | Quality, tests, edge cases, maintainability | Confirm the path matches the session workspace before stating it. |
| **Security** | Auth, secrets, blast radius, unsafe actions | Path disclosure is low risk in a local dev session. |

**Council synthesis:** Report the current working directory clearly.

---

## Sources

- Full principles: [https://github.com/cloudgen/ciao](https://github.com/cloudgen/ciao) (CIAO Defensive Programming Principles **v2.10.2**)
- Agent contract: [https://github.com/cloudgen/ciao-lite](https://github.com/cloudgen/ciao-lite) (CIAO-Lite — Simplicity but Safety)
- Related summary: [cloudgen/grokrec CIAO-PRINCIPLES.md](https://github.com/cloudgen/grokrec/blob/main/CIAO-PRINCIPLES.md)
