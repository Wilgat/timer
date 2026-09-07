# CLI routed-verb table — timer

Human-readable column is **`{{short-descript}}: {{explain}}`**. Menu labels **MUST** match this column.

**Last update:** 2026-09-07

| Verb | Handler | Privilege | Live since | Human-readable |
|------|---------|-----------|------------|----------------|
| start | `timer_start` | you (Type 0) | 2026-07-16 | `start: Start a named timer` |
| stop | `timer_stop` | you (Type 0) | 2026-07-16 | `stop: Stop a named timer and show elapsed` |
| status | `timer_status` | you (Type 0) | 2026-07-16 | `status: Show elapsed without stopping` |
| list | `timer_list` | you (Type 0) | 2026-07-16 | `list: List running timers` |
| kill | `timer_kill_or_reset kill` | you (Type 0) | 2026-07-16 | `kill: Discard a running timer` |
| reset | `timer_kill_or_reset reset` | you (Type 0) | 2026-07-16 | `reset: Reset a running timer` |
| menu | `app_default` | you (Type 0) | 2026-09-07 | `menu: Show the numbered list of live commands` |
| main | `app_default` | you (Type 0) | 2026-09-07 | `main: Same as menu` |
| install | `inst_perform_install` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| version | `app_version` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| about | `app_about` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| help | `app_help` | you (Type 0) | 2026-07-14 | *(off main menu)* |
| version-check | `ver_check` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| self-update | `inst_self_update` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| self-uninstall | `inst_self_uninstall` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |

Main menu lists **start … reset** then **Exit 9**. **MUST NOT** list install / self-managed / version / about / help / menu / main.
