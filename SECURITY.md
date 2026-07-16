# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 2.10.0 (current) | Yes |
| Older releases | Best-effort only; please upgrade to the current version when possible |

## Reporting a Vulnerability

Please **do not** open a public issue for security-sensitive reports when a private channel is available.

**Maintainer contact (email):** `wilgat.wong@gmail.com`

- Source of contact: product **author-email** SSOT in [`LICENSE.md`](./LICENSE.md) (Copyright line).
- Prefer email for vulnerability details, reproduction steps, and impact.
- You should receive an acknowledgment when the report is received and actionable.
- Do not include exploit weaponization guides in public channels.

## Security Design Principles (CIAO)

This project follows **[CIAO](https://github.com/cloudgen/ciao)** / **CIAO-Lite** defensive design. Security-relevant intent:

| Letter | Principle | Security application |
|--------|-----------|----------------------|
| **C** | **Caution** | Assume hostile input, hostile networks, and misconfiguration. Validate timer names and boundaries; fail closed on integrity **mismatch** when a companion digest is present; never fail silently on hard integrity errors. |
| **I** | **Intentional** | Privilege boundaries, install channel, and integrity modes are deliberate. **Automatic companion-checksum** is the default integrity path; optional `CHECKSUM` env pin is secondary (CI / out-of-band), not a public `help` / `about` setting. Prefer clear “why” over silent magic. |
| **A** | **Anti-fragile** | Survive harsh environments (minimal containers, missing tools, non-interactive `curl \| sh`). Prefer transparent automatic SHA-256 sidecar checks, least privilege for day-to-day use, and recoverable failure over brittle trust. Missing-sidecar policy is explicit (warn and continue)—never silent skip. |
| **O** | **Over-protect** | Defense in depth on critical paths (integrity verify before install/update when designed, Protection Zones, loud failure). Do not “simplify away” safety or transparency for brevity. |

Full principles: [CIAO Defensive Programming](https://github.com/cloudgen/ciao) · agent contract: [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

This section describes **design posture**. It is **not** a claim of third-party certification (ISO, OWASP “compliant”, etc.).

## Install integrity and trust

`timer` implements the **automatic checksum mechanism**: the program fetches a companion digest next to the install artifact when no operator pin is set.

| Fact | Honest statement |
|------|------------------|
| **Default path** | Automatic companion verification at `${SCRIPT_URL}.sha256` when `CHECKSUM` is unset — **no** env pin required for normal install / self-update. |
| **Algorithm** | SHA-256 (via `sha256sum` / equivalent helpers in the script). |
| **Transparency** | Human mode is designed to show companion **link**, expected **value**, and verification **result** (match / mismatch / missing). |
| **Mismatch** | Abort — do not install mismatched bytes. |
| **Missing sidecar** | **Warn and continue** install (best-effort). Do **not** claim “always verified” when the companion is absent. |
| **Optional pin** | Process-env `CHECKSUM` is **secondary** (CI / out-of-band freeze). Same-origin pin fetch is **not** stronger than automatic mode. Not advertised in `help` / `about`. |
| **Trust bound** | Same-channel SHA-256 proves **byte consistency** (wrong blob / bit-flip / stale companion vs artifact). It is **not** independent authenticity (signing / separate trust root) by itself. |
| **Forbidden pattern** | Embedding the expected digest of the installable file **inside** that same file as “self-verify.” |

In-repo companion file: [`timer.sha256`](./timer.sha256) (published beside `./timer` for the release channel).

Operator-facing install steps, one-liners, and full integrity outcomes live in [`README.md`](./README.md). This section states **security trust posture** only.

## Scope notes

- Preferred language for reports: English.
- Out of scope: social engineering of third parties, physical attacks, spam.
- Related product docs: [`README.md`](./README.md), [`LICENSE.md`](./LICENSE.md).
