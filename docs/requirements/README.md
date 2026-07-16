# Requirements

Authoritative product and engineering requirements for this project live here.

**Current state (2026-07-16 — timer specialization):** **Nine** live requirement files: eight `requirement-shell-*.md` (automatic-checksum, CLI interface, CLI zero-arguments, idempotency, interactive vs noninteractive, modular design, output, self-management) plus **domain SSOT** `requirement-domain-timer.md` (named-timer subcommands / storage / help-about domain rows). Status **Active**; versions per file header. Registry: `index.md` (must stay in sync). Type 0 lifecycle remains composition of zero-arguments + CLI + checksum + self-management + interactive + idempotency. No Type 1/2. Do **not** invent additional requirement paths without a real ownership gap — verify on disk and register new files in `index.md` in the same change.

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
| `docs/requirements/<area>/<REQ-ID>.md` | Optional council-style `REQ-<AREA>-<NNN>` files |

Suggested areas (if using subdirs): `product/`, `platform/`, `security/`, `ops/` — create as needed.

## ID scheme

- Format: `REQ-<AREA>-<NNN>` (example: `REQ-PLAT-001`).
- IDs are stable. Prefer status/`supersedes` over renumbering.
- Record every ID in `index.md` when created or status changes.

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
4. Session plan (`plan.md`) must list affected REQ-IDs and whether each is create / update / no-change.
5. Do not implement against unstated intent — if behavior is required, it belongs in a requirement file.

## Implementation rules

- Every non-trivial PR/change set cites one or more REQ-IDs in commit/PR/summary when requirements exist.
- Do not invent requirements only in code comments; promote durable intent here.
- **No placeholders** in requirement files: no `TBD`/`TODO` acceptance criteria, hollow sections, or stub “later” text (no-placeholder / dual-policy hygiene; deliver complete criteria or explicit deferred ownership).
- Product source comments cite only **live** `requirement-*.md` files (never invent basenames).

## Review rules

- Requirements changes and code/docs delivery use the project’s plan/implement/code-review/security checklist process.
- Empty registry is valid for genesis; do not invent requirements to “fill” the index.
