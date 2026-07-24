# Lessons — timer

**Prior-report failure modes** to re-check on every product review.  
**Mandatory load** before findings.  
**Last update:** 2026-07-24 (TP family IDs; RQ-* notation)

| L-ID | Failure mode | Re-check | Source | Open? |
|------|--------------|----------|--------|-------|
| L-BOOT-01 | Basename / `$0` APP_NAME gate blocks `curl\|sh` | End of ship unit always `app_main "$@"`; no basename install gate | INC-20260712-001 | **Closed** (re-check still) |
| L-TYPEO-01 | Empty argv dumps help instead of install-ensure | Zero-arg tests not-installed / local / global | requirement-shell-cli-zero-arguments | **Closed** (suite) |
| L-UNIN-01 | self-uninstall --json without --force fakes success cancel | Exit non-zero + `confirm_required`; no success JSON | INC-20260713-002 | **Closed** (suite) |
| L-SETU-01 | `set -u` with bare HOME / privilege defaults | env -u HOME; IS_ROOT/SH defaults | INC-20260713-001 | **Closed** (suite) |
| L-CSUM-01 | CHECKSUM trust UX / overclaim authenticity | Companion primary; CHECKSUM not in help/about; SECURITY bounds | INC-20260713-003 | **Partial** — suite OK; wording vigilance |
| L-CITE-01 | Product source omits live domain law or cites harness as authority | Top ALIGNMENT lists domain REQ; bootstrap cites requirements only | T-CITE-01/02 | **Closed** (2026-07-16 fix) |
| L-JSON-01 | Domain list JSON `timers` claimed as array but emitted as escaped string | `timer --json list` → `timers` is JSON array; suite **TP-TIMER-04** | T-JSON-01 | **Closed** (2026-07-16 fix) |
| L-JSON-02 | Domain elapsed/count JSON fields as quoted strings vs numbers | status/stop `@minutes`/`@seconds`/`@elapsed`; list `@count`; suite **TP-TIMER-04** | T-JSON-02 | **Closed** (2026-07-19 fix) |
| L-CLASS-01 | Software-dev product law without Active class REQ | Registry has Active `requirement-class-software-dev.md` | T-CLASS-01 | **Closed** (2026-07-19 fix) |
| L-DOM-01 | Domain surface without domain SSOT / CLI “out of scope” while handlers exist | Registry has Active `requirement-domain-timer.md`; CLI table lists domain verbs | Pre-2026-07-16 gap | **Closed** |
| L-DOM-02 | Unsafe timer names accepted | invalid_name suite + sanitize rejects path/metas | domain suite | **Closed** (suite) |
| L-DOM-03 | start overwrites running timer silently | already-running exit 1 suite | domain suite | **Closed** (suite) |
| L-ID-01 | APP_NAME only `:=` default without hard-assign line | `APP_NAME="timer"` hard-assign present | T-ID-01 | **Closed** (2026-07-16 fix) |
| L-IDN-01 | Flat legacy templates / missing RQ-*·TP-* primary citation | templates under `requirements/`+`tests/`; REQs have RQ-ID + DTV; suite TP labels | housekeeping 2026-07-24 | **Closed** |
| L-COV-01 | Core mold TP families without suite (curl/lifecycle gaps) | TP-CURL local channel + lifecycle parity with selfmanaged | housekeeping 2026-07-24 | **Closed** (PASS=187) |

## How to use

1. For each open L-*, re-verify with evidence in the new report.  
2. When fixed, set Open? to **Closed** and point to TP / commit / date.  
3. Promote new modes from reports into this table (do not rely on chat memory).  
