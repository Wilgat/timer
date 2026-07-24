# Requirements

Authoritative product and engineering requirements for this project live here.

**Current state (2026-07-24 — timer specialization + ID notation):** **Ten** live requirement files: class law `requirement-class-software-dev` (`RQ-CLASS-SOFTWARE-DEV`), eight `requirement-shell-*.md` with `RQ-SHELL-*` IDs, plus **domain SSOT** `requirement-domain-timer` (`RQ-DOMAIN-TIMER`). Status **Active**. Registry: `index.md` (Requirement-ID + key). Each file has **Design-time verification** (TP-IDs + `tests/*` + `reviews/*` only). Type 0 lifecycle remains composition of zero-arguments + CLI + checksum + self-management + interactive + idempotency. No Type 1/2. Do **not** invent additional requirement paths without a real ownership gap.

## Naming law (filename discipline)

| Family | Pattern | Notes |
|--------|---------|-------|
| Shell / Type 0 | `requirement-shell-*.md` | Lifecycle, output, modular structure, integrity — **not** domain product law |
| **Domain SSOT** | `requirement-domain-<subject>.md` | Exactly **one Active** when domain surface exists; `<subject>` = **domain knowledge** (here: `timer`) |
| Other topics | `requirement-` or `requirement-<lang>-` | Language prefix when the law is stack-specific |

**Domain subject rule (agents / subagents):** Before creating a **new** domain requirement:

1. Name the domain knowledge subject in plain language.  
2. Propose `requirement-domain-<subject>.md` (kebab-case subject).  
3. **Confirm the subject** with the user when ambiguous — do not invent.  
4. Prefer updating the existing Active domain SSOT over a second Active peer.  
5. **Forbidden** for domain law: `requirement-shell-domain*`, bare `requirement-domain.md`, subjects that are only stack words (`shell`, `cli`, …).

Registry: Area `domain`, key = basename without `.md`.

## Purpose

- **Plan mode** designs work by reading and **updating** these docs — not only the session `plan.md`.
- **Implement** delivers code and docs that **trace** to requirement IDs.
- **Review** verifies delivery against requirements **and** defensive (CIAO) checklists.

## Layout

| Path | Role |
|------|------|
| `docs/requirements/index.md` | Registry of all requirements (IDs, status, owners) — keep in sync with files |
| `docs/requirements/requirement-*.md` | CIAO-style project requirements (flat; primary live convention) |
| `docs/requirements/<area>/…` | Optional council-style files (prefer flat `requirement-*.md` + `RQ-*`) |

Suggested areas (if using subdirs): `product/`, `platform/`, `security/`, `ops/` — create as needed.

## ID scheme (harness ID notation)

| Kind | Form | Scope |
|------|------|--------|
| **Requirement-ID** | `RQ-<UPPER-KEBAB-STEM>` matching file stem after `requirement-` | **This product only** (not portable harness) |
| Example | `requirement-shell-cli-interface.md` → **`RQ-SHELL-CLI-INTERFACE`** | Cite `RQ-*` first on product surfaces; path secondary |
| Optional council files | `REQ-<AREA>-<NNN>` under subdirs | Legacy optional; prefer flat `requirement-*.md` + `RQ-*` |

- IDs are stable. Prefer status/`supersedes` over renumbering.
- Record every **Requirement-ID** and key in `index.md` when created or status changes.
- **Never** freeze product `RQ-*` into portable templates/skills/terminologies (policy-harness-id-notation).
- Test cases use **`TP-*`**; skills **`SK-*`**; law molds **`LM-*`**; proof molds **`PM-*-TEST-PLAN`**.

## Status values

| Status | Meaning |
|--------|---------|
| `draft` | Proposed; not yet approved for implementation |
| `approved` | Ready to implement |
| `in-progress` | Implementation underway |
| `done` | Delivered and reviewed against checklists |
| `deprecated` | No longer active; keep file for history |
| `superseded` | Replaced by another REQ-ID (link it) |

## Plan-mode rules (mandatory)

When planning non-trivial work:

1. Search `docs/requirements/` (and `index.md`) for related requirements.
2. Decide: **new requirement**, **update existing**, or **no requirements impact** (state why).
3. Apply requirement file changes **before** or as part of finishing the plan.
4. Session plan (`plan.md`) must list affected Requirement-IDs (`RQ-*`) and whether each is create / update / no-change.
5. Do not implement against unstated intent — if behavior is required, it belongs in a requirement file.

## Implementation rules

- Every non-trivial PR/change set cites one or more Requirement-IDs (`RQ-*`) in commit/PR/summary when requirements exist.
- Do not invent requirements only in code comments; promote durable intent here.
- **No placeholders** in requirement files: no `TBD`/`TODO` acceptance criteria, hollow sections, or stub “later” text (no-placeholder / dual-policy hygiene; deliver complete criteria or explicit deferred ownership).
- Product source comments cite only **live** `requirement-*.md` files (never invent basenames).

## Review rules

- Requirements changes and code/docs delivery use the project’s plan/implement/code-review/security checklist process.
- Empty registry is valid for genesis; do not invent requirements to “fill” the index.
