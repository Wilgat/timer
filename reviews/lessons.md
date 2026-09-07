# Lessons — timer

**Prior-report failure modes** to re-check on every product review.  
**Mandatory load** before findings.  
**Last update:** 2026-09-07 (Termux `$PREFIX/tmp`; L-TX-02)

| L-ID | Failure mode | Re-check | Source | Open? |
|------|--------------|----------|--------|-------|
| L-BOOT-01 | Basename / `$0` APP_NAME gate blocks `curl\|sh` | End of ship unit always `app_main "$@"`; no basename install gate | INC-20260712-001 | **Closed** (re-check still) |
| L-TYPEO-01 | Empty argv dumps help instead of install-ensure | Zero-arg tests not-installed / local / global | requirement-shell-cli-zero-arguments | **Closed** (suite) |
| L-UNIN-01 | self-uninstall --json without --force fakes success cancel | Exit non-zero + `confirm_required`; no success JSON | INC-20260713-002 | **Closed** (suite) |
| L-SETU-01 | `set -u` with bare HOME / privilege defaults | env -u HOME; IS_ROOT/SH defaults | INC-20260713-001 | **Closed** (suite) |
| L-CSUM-01 | CHECKSUM trust UX / overclaim authenticity | Companion primary; CHECKSUM not in help/about; SECURITY “Must not claim” + trust bound; README parity | INC-20260713-003; fix 2026-08-11 | **Closed** (suite + explicit non-claim language) |
| L-CITE-01 | Product source omits live domain/storage/temp law or cites harness as authority | Top ALIGNMENT lists live REQs only (incl. storage + temp after 2.11.0) | T-CITE-01/02 | **Closed** (re-check after re-specialize) |
| L-JSON-01 | Domain list JSON `timers` claimed as array but emitted as escaped string | `timer --json list` → `timers` is JSON array; suite **TP-TIMER-04** | T-JSON-01 | **Closed** (2026-07-16 fix) |
| L-JSON-02 | Domain elapsed/count JSON fields as quoted strings vs numbers | status/stop `@minutes`/`@seconds`/`@elapsed`; list `@count`; suite **TP-TIMER-04** | T-JSON-02 | **Closed** (2026-07-19 fix) |
| L-CLASS-01 | Software-dev product law without Active class REQ | Registry has Active `requirement-class-software-dev.md` | T-CLASS-01 | **Closed** (2026-07-19 fix) |
| L-DOM-01 | Domain surface without domain SSOT / CLI “out of scope” while handlers exist | Registry has Active `requirement-domain-timer.md`; CLI table lists domain verbs | Pre-2026-07-16 gap | **Closed** |
| L-DOM-02 | Unsafe timer names accepted | invalid_name suite + sanitize rejects path/metas | domain suite | **Closed** (suite) |
| L-DOM-03 | start overwrites running timer silently | already-running exit 1 suite | domain suite | **Closed** (suite) |
| L-ID-01 | APP_NAME only `:=` default without hard-assign line | `APP_NAME="timer"` hard-assign present | T-ID-01 | **Closed** (2026-07-16 fix) |
| L-IDN-01 | Flat legacy templates / missing RQ-*·TP-* primary citation | templates under `requirements/`+`tests/`; REQs have RQ-ID + DTV; suite TP labels | housekeeping 2026-07-24 | **Closed** |
| L-COV-01 | Core mold TP families without suite (curl/lifecycle gaps) | TP-CURL local channel + lifecycle parity with selfmanaged | housekeeping 2026-07-24 | **Closed** (PASS=187+) |
| L-STOR-01 | Shell storage resolver dead / about fields missing while claiming Type 0 parity with A | `util_resolve_storage` wired; about JSON has `effective_storage`/`storage_dir`; **TP-CLI-05** | re-specialize 2026-08-11 | **Closed** on B (A may still lag — fix on A only) |
| L-TEMP-01 | Install temps use predictable paths or ignore storage-isolated TMPDIR | `mktemp -t` under `TMPDIR=${EFFECTIVE_STORAGE_DIR}`; **RQ-SHELL-TEMP-FILE-SYSTEM** | mold peer 2026-08-11 | **Closed** (lifecycle/CSUM paths) |
| L-MOLD-01 | Domain law without named-timer mandatory peers (CLI/storage/temp/output) | Registry Active peers; domain DTV cites **LM-NAMED-TIMER-DOMAIN**; **TP-MOLD-01** | mold coverage 2026-08-11 | **Closed** |
| L-MAP-01 | Review maps claim TP-CLI-05 n/a after shell storage inheritance | `test-plan.md` + CLI DTV + RTM must agree (**have** vs **n/a**) | plan revision 2026-08-11 | **Closed** |
| L-TX-01 | Claim Termux / Git Bash support while recommending `sudo curl \| sh` or `/usr/local/bin` | Detect + user dest + about `termux`; **TP-TX-01..05** | 2026-09-06 | **Closed** (suite) |
| L-TX-02 | Termux `timer start` dies: only `/dev/shm` + `/tmp`; empty `$(resolve)` writes `/timer_*` on RO root | `$PREFIX/tmp` then cache; refuse empty/root `TIMER_FILE`; **TP-TX-08** | 2026-09-07 | **Closed** (suite) |
| L-MENU-01 | TTY empty argv / `--debug` falls through to help; `--json` no-command installs | After flag parse: TTY → menu; off-TTY → ensure; `--json` → JSON help; **TP-CLI-07/29** | 2026-09-07 | **Closed** (suite) |
| L-MENU-02 | TTY menu start/stop/status/kill/reset used `default` with no name prompt | Current-shell `prompt_ask` + `PROMPT_ASK_VALUE`; Enter = `default`; list skips; **TP-CLI-30** | 2026-09-07 | **Closed** (suite) |

## How to use

1. For each open L-*, re-verify with evidence in the new report.  
2. When fixed, set Open? to **Closed** and point to TP / commit / date.  
3. Promote new modes from reports into this table (do not rely on chat memory).  
4. Origin-A defects are **not** closed by editing B — never reverse-copy.  
