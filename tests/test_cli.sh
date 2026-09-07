# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (PM-SHELL-CLI-TEST-PLAN / TP-CLI-*)
# =============================================================================
# Portable families: TP-CLI, TP-CSUM-01/05, TP-U-01, TP-TX-01..05, TP-TX-08, TP-CLI-16/17/29/30.
# Primary REQs: RQ-SHELL-CLI-INTERFACE, RQ-SHELL-CLI-DEFAULT-INTERACTION, RQ-SHELL-OUTPUT-REQUIREMENTS, RQ-SHELL-AUTOMATIC-CHECKSUM, RQ-SHELL-CLI-ZERO-ARGUMENTS, RQ-SHELL-SCRIPT-CODING.
# Labels MUST include TP-IDs (policy-harness-id-notation / PM-SHELL-CLI-TEST-PLAN).
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface (TP-CLI / TP-CSUM / TP-U)"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- TP-CLI-01: syntax + companion Shape A ---
    sh -n "${SCRIPT}"
    _syn=$?
    assert_eq "TP-CLI-01 sh -n timer (syntax)" 0 "$_syn"

    if [ -f "${REPO_ROOT}/timer.sha256" ]; then
        _expected=$(awk '{print $1; exit}' "${REPO_ROOT}/timer.sha256")
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "TP-CLI-01 TP-CSUM-01 timer.sha256 matches ./timer" "$_expected" "$_actual"
    else
        t_fail "TP-CLI-01 TP-CSUM-01 timer.sha256 missing at repo root"
    fi

    # --- TP-CLI-02: version human + JSON ---
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version human mentions version" "$_out" "${APP_VERSION}"
    assert_contains "TP-CLI-02 version human mentions app" "$_out" "timer"

    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version --json type" "$_out" '"type":"version"'
    assert_contains "TP-CLI-02 version --json app" "$_out" '"app":"timer"'
    assert_contains "TP-CLI-02 version --json version field" "$_out" "\"version\":\"${APP_VERSION}\""
    assert_contains "TP-CLI-02 version human via app_version" "$(sh "${SCRIPT}" version 2>/dev/null)" "${APP_VERSION}"

    # --- TP-CLI-03: help Type 0 surface (CHECKSUM absent → TP-CSUM-05) ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 help lists install" "$_out" "install"
    assert_contains "TP-CLI-03 help lists version-check" "$_out" "version-check"
    assert_contains "TP-CLI-03 help lists self-update" "$_out" "self-update"
    assert_contains "TP-CLI-03 help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "TP-CLI-03 help lists about" "$_out" "about"
    assert_contains "TP-CLI-03 help lists start (domain)" "$_out" "start"
    assert_contains "TP-CLI-03 help lists stop (domain)" "$_out" "stop"
    assert_contains "TP-CLI-03 help lists list (domain)" "$_out" "list"
    assert_contains "TP-CLI-03 help lists menu" "$_out" "menu"
    assert_contains "TP-CLI-03 help lists --persist" "$_out" "--persist"
    assert_contains "TP-CLI-03 help lists --json" "$_out" "--json"
    assert_contains "TP-CLI-03 help lists --force" "$_out" "--force"
    assert_contains "TP-CLI-03 help lists --debug" "$_out" "--debug"
    assert_contains "TP-CLI-03 help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "TP-CLI-03 help lists REPO_NAME" "$_out" "REPO_NAME"
    assert_contains "TP-CLI-03 help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_not_contains "TP-CLI-03 TP-CSUM-05 help must not list CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-04: help/about JSON purity ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 help --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 help --json type success" "$_out" '"type":"success"'
    assert_contains "TP-CLI-04 help --json command help" "$_out" '"command":"help"'

    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 about --json type" "$_out" '"type":"about"'
    assert_contains "TP-CLI-04 about --json app" "$_out" '"app":"timer"'
    assert_not_contains "TP-CLI-04 TP-CSUM-05 about --json must not include CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-05: shell about storage fields (RQ-SHELL-CLI-STORAGE; inherited from selfmanaged) ---
    # Shell scratch/cache resolve is separate from domain timer file storage (RQ-DOMAIN-TIMER).
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-05 about --json type" "$_out" '"type":"about"'
    assert_contains "TP-CLI-05 about --json effective_storage" "$_out" '"effective_storage"'
    assert_contains "TP-CLI-05 about --json storage_dir" "$_out" '"storage_dir"'
    assert_contains "TP-CLI-05 about --json storage includes app name" "$_out" "${APP_NAME:-timer}"
    assert_not_contains "TP-CLI-05 about --json must not include CHECKSUM" "$_out" "CHECKSUM"

    ci_isolated_env 2>/dev/null || true
    if [ -n "${CI_HOME:-}" ]; then
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN:-${CI_HOME}/.local/bin}" \
            sh "${SCRIPT}" --json about 2>/dev/null)
        assert_contains "TP-CLI-05 isolated about effective_storage has app" "$_out" "${APP_NAME:-timer}"
        case "$_out" in
            *'"effective_storage":"'*"${APP_NAME:-timer}"*) t_pass "TP-CLI-05 effective_storage path contains ${APP_NAME:-timer}" ;;
            *) t_fail "TP-CLI-05 effective_storage missing app isolation in: $_out" ;;
        esac
        assert_contains "TP-CLI-05 storage_dir field present under isolation" "$_out" '"storage_dir"'
        _custom="${CI_HOME}/custom-storage-root"
        _out=$(HOME="${CI_HOME}" STORAGE_DIR="${_custom}" \
            sh "${SCRIPT}" --json about 2>/dev/null)
        assert_contains "TP-CLI-05 storage_dir honors STORAGE_DIR env" "$_out" "custom-storage-root"
        _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
        if [ -n "$_eff" ] && [ -d "$_eff" ]; then
            t_pass "TP-CLI-05 effective_storage directory exists after resolve"
        else
            t_fail "TP-CLI-05 effective_storage missing or not a directory: '${_eff:-empty}'"
        fi
        _who=$(id -un 2>/dev/null || echo "unknown")
        case "$_out" in
            *'"effective_storage":"'*"${_who}"*|*'"effective_storage":"'*"unknown"*) \
                t_pass "TP-CLI-05 effective_storage includes user segment" ;;
            *) t_fail "TP-CLI-05 effective_storage missing user segment for '${_who}': $_out" ;;
        esac
        ci_cleanup_env 2>/dev/null || true
    else
        _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
        _eff=$(printf '%s' "$_out" | sed -n 's/.*"effective_storage":"\([^"]*\)".*/\1/p' | head -n1)
        if [ -n "$_eff" ] && [ -d "$_eff" ]; then
            t_pass "TP-CLI-05 effective_storage directory exists after resolve"
        else
            t_fail "TP-CLI-05 effective_storage missing or not a directory: '${_eff:-empty}'"
        fi
    fi

    # --- TP-CLI-06: unknown command ---
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command --json exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command --json type error" "$_err" '"type":"out_error"'

    # --- TP-CLI-07: quiet mode (--quiet and -q) ---
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version --quiet exit 0" 0 "$_ec"
    if [ -z "$_out" ]; then
        t_pass "TP-CLI-07 version --quiet suppresses human info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "TP-CLI-07 version --quiet suppresses human info"
        else
            t_fail "TP-CLI-07 version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi
    _out=$(sh "${SCRIPT}" -q version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version -q exit 0" 0 "$_ec"
    _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
    if [ -z "$_trim" ]; then
        t_pass "TP-CLI-07 version -q suppresses human info"
    else
        t_fail "TP-CLI-07 version -q expected empty stdout, got '$(_trunc "$_out")'"
    fi

    # --- --debug does not break version ---
    _out=$(sh "${SCRIPT}" --debug version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 --debug version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 --debug version still reports version" "$_out" "${APP_VERSION}"

    # --- TP-CLI-08 / TP-U-01: HOME unset under set -u ---
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 TP-U-01 env -u HOME version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-08 TP-U-01 env -u HOME version still reports version" "$_out" "${APP_VERSION}"

    # --- TP-CLI-09 / TP-LC-09 / TP-U-02: zero-arg bad channel ---
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/timer-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-09 TP-LC-09 TP-U-02 zero-arg failed install exits non-zero"
    else
        t_fail "TP-CLI-09 zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "TP-CLI-09 zero-arg failed install left no binary" "${CI_USER_BIN}/timer"
    # Not silent: stderr or stdout has content
    if [ -n "$_err" ] || [ -n "$_out" ]; then
        t_pass "TP-CLI-09 zero-arg fail is not silent"
    else
        t_fail "TP-CLI-09 zero-arg fail was silent (0-byte out+err)"
    fi
    ci_cleanup_env

    # --- TP-CLI-11: self-uninstall --json without force ---
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    cp "${SCRIPT}" "${CI_USER_BIN}/timer"
    chmod +x "${CI_USER_BIN}/timer"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CLI-11 self-uninstall --json without --force exit 1" 1 "$_ec"
    assert_contains "TP-CLI-11 self-uninstall --json confirm_required code" "$_err" '"code":"confirm_required"'
    assert_contains "TP-CLI-11 self-uninstall --json out_error type" "$_err" '"type":"out_error"'
    assert_not_contains "TP-CLI-11 self-uninstall --json must not fake success cancel" "$_out$_err" "cancelled by user"
    assert_file_exists "TP-CLI-11 binary remains without --force" "${CI_USER_BIN}/timer"
    ci_cleanup_env

    # --- TP-CLI-12: out_json @key raw nested (requirement-shell-output-requirements) ---
    # Product has no public command emitting @* yet; lock the SSOT helper contract.
    _harness=$(mktemp "${TMPDIR:-/tmp}/sm-outjson.XXXXXX")
    {
        printf '%s\n' 'JSON=1'
        sed -n '/^util_json_escape()/,/^}/p' "${SCRIPT}"
        sed -n '/^out_json()/,/^}/p' "${SCRIPT}"
        printf '%s\n' 'out_json "t" "m" "plain" "v" "@nested" "{\"a\":1,\"b\":\"x\"}"'
    } > "${_harness}"
    _out=$(sh "${_harness}" 2>/dev/null)
    _ec=$?
    rm -f "${_harness}"
    assert_eq "TP-CLI-12 out_json @key harness exit 0" 0 "$_ec"
    assert_contains "TP-CLI-12 out_json type" "$_out" '"type":"t"'
    assert_contains "TP-CLI-12 out_json plain string key" "$_out" '"plain":"v"'
    assert_contains "TP-CLI-12 out_json @nested unquoted object" "$_out" '"nested":{"a":1,"b":"x"}'
    assert_not_contains "TP-CLI-12 out_json must not double-quote nested blob" "$_out" '"nested":"{'

    # --- TP-CLI-16: do-not-capture-read (no $() of prompt_* in live code) ---
    _hits=$(grep -nE '\$\(prompt_|`prompt_' "${SCRIPT}" | grep -v '^[^:]*:[[:space:]]*#' || true)
    if [ -z "${_hits}" ]; then
        t_pass "TP-CLI-16 no live \$(prompt_ / backtick prompt_ capture"
    else
        t_fail "TP-CLI-16 live prompt capture: ${_hits}"
    fi

    # --- TP-CLI-29 / TP-CLI-07: empty argv overlay; --json is JSON help ---
    _out=$(sh "${SCRIPT}" --json 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --json no command exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --json no command is JSON help" "$_out" '"type":"success"'
    assert_contains "TP-CLI-29 --json no command help command field" "$_out" '"command":"help"'
    assert_not_contains "TP-CLI-29 --json no command not numbered list" "$_out" "9. Exit"

    ci_isolated_env
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" install >/dev/null 2>&1 || true
    _errf="${CI_HOME}/dbg-empty.err"
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --debug </dev/null 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CLI-29 --debug no command off-TTY exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --debug no command off-TTY ensure" "$_out" "already installed"
    assert_not_contains "TP-CLI-29 --debug no command off-TTY not help dump" "$_out" "Usage:"
    assert_not_contains "TP-CLI-29 --debug no command off-TTY not numbered list" "$_out" "9. Exit"
    assert_contains "TP-CLI-29 --debug no command off-TTY debug tag" "$_err" "[DEBUG]"
    assert_contains "TP-CLI-29 --debug no command off-TTY dispatch ensure" "$_err" "command=ensure"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --quiet </dev/null 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --quiet no command off-TTY exit 0" 0 "$_ec"
    assert_not_contains "TP-CLI-29 --quiet no command off-TTY not help dump" "$_out" "Usage:"
    assert_not_contains "TP-CLI-29 --quiet no command off-TTY not numbered list" "$_out" "9. Exit"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --json --debug 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --json --debug no command exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --json --debug no command is JSON help" "$_out" '"type":"success"'
    assert_not_contains "TP-CLI-29 --json --debug no command not numbered list" "$_out" "9. Exit"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" menu </dev/null 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-17 off-TTY menu is help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-17 off-TTY menu is help" "$_out" "Usage:"
    assert_not_contains "TP-CLI-17 off-TTY menu not CSI" "$_out" "$(printf '\033')"

    if command -v python3 >/dev/null 2>&1; then
        _bold=$(printf '\033[1m')
        _italic=$(printf '\033[3m')
        _gray_italic=$(printf '\033[3;37m')
        _ident="${APP_NAME}(${APP_VERSION})"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-07 TTY empty argv is numbered list" "$_out" "9. Exit"
        assert_contains "TP-CLI-07 TTY empty argv start first" "$_out" "1. start:"
        assert_not_contains "TP-CLI-07 TTY empty argv no install row" "$_out" "install:"
        assert_not_contains "TP-CLI-07 TTY empty argv not help dump" "$_out" "Usage:"
        assert_contains "TP-CLI-17 TTY header bold APP_NAME" "$_out" "${_bold}"
        assert_contains "TP-CLI-17 TTY header italic VERSION" "$_out" "${_italic}"
        assert_contains "TP-CLI-17 TTY header nametag APP_NAME(VERSION)" "$_stripped" "${_ident}"
        assert_contains "TP-CLI-17 TTY number and short-descript unstyled" "$_out" "1. start: "
        assert_contains "TP-CLI-17 TTY desc is italic + light gray (SGR 3+37)" "$_out" "${_gray_italic}"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}" --debug)
        assert_contains "TP-CLI-29 TTY --debug no command is numbered list" "$_out" "9. Exit"
        assert_contains "TP-CLI-29 TTY --debug no command start first" "$_out" "1. start:"
        assert_contains "TP-CLI-29 TTY --debug no command dispatch menu" "$_out" "command=menu"
        assert_not_contains "TP-CLI-29 TTY --debug no command not help dump" "$_out" "Usage:"
        _jout=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}" --json)
        assert_contains "TP-CLI-07 TTY --json no command is JSON help" "$_jout" '"type":"success"'
        assert_not_contains "TP-CLI-07 TTY --json no command not numbered list" "$_jout" "9. Exit"
        unset _jout _bold _italic _gray_italic _ident

        # --- TP-CLI-30: TTY menu extra name field (Enter = default; list skips) ---
        mkdir -p "${CI_HOME}/vol"
        _vol="${CI_HOME}/vol"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="4" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu list still lists" "$_out" "4. list:"
        assert_not_contains "TP-CLI-30 TTY menu list does not prompt for name" "$_out" "Timer name"
        assert_contains "TP-CLI-30 TTY menu list runs without name" "$_out" "No running timers found."

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu start prompts for name" "$_out" "Timer name"
        assert_contains "TP-CLI-30 TTY menu start shows default" "$_out" "Default: default"
        assert_contains "TP-CLI-30 TTY menu start Enter uses default name" "$_out" "Timer 'default' started"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\nwork" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu start typed name" "$_out" "Timer 'work' started"
        assert_not_contains "TP-CLI-30 TTY menu start typed name not default" "$_out" "Timer 'default' started"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="2\\nnosuch" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu stop prompts for name" "$_out" "Timer name"
        assert_contains "TP-CLI-30 TTY menu stop uses typed name" "$_out" "No timer 'nosuch' running"
        unset _vol
    else
        t_skip "TP-CLI-07 TTY empty argv (no python3 for PTY)"
        t_skip "TP-CLI-17 TTY header (no python3 for PTY)"
        t_skip "TP-CLI-29 TTY --debug no command (no python3 for PTY)"
        t_skip "TP-CLI-07 TTY --json no command (no python3 for PTY)"
        t_skip "TP-CLI-30 TTY menu name prompt (no python3 for PTY)"
    fi
    ci_cleanup_env

    # --- TP-TX-*: Termux target (command line for this login only) ---
    _stub=$(mktemp -d "${TMPDIR:-/tmp}/tm-pkgstub.XXXXXX")
    printf '#!/bin/sh\necho pkg-called >> "%s/pkg.log"\nexit 0\n' "${_stub}" > "${_stub}/pkg"
    chmod +x "${_stub}/pkg"
    _out=$(env -u PREFIX -u TERMUX_VERSION PATH="${_stub}:${PATH}" \
        sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-TX-01 about termux false off detect" "$_out" '"termux":"false"'
    assert_file_missing "TP-TX-01 TP-LC-15 pkg stub not invoked off Termux" "${_stub}/pkg.log"

    ci_isolated_env
    _tx_prefix="${CI_HOME}/data/com.termux/files/usr"
    mkdir -p "${_tx_prefix}/bin" "${_tx_prefix}/tmp"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        PATH="${_stub}:${PATH}" \
        env -u USER_BIN sh "${SCRIPT}" --json about 2>/dev/null
    )
    assert_contains "TP-TX-02 about termux true on PREFIX detect" "$_out" '"termux":"true"'
    assert_contains "TP-TX-02 about prefix field" "$_out" "com.termux"
    assert_contains "TP-TX-04 user_bin is PREFIX/bin" "$_out" "${_tx_prefix}/bin"
    assert_file_missing "TP-TX-05 pkg stub not invoked on Termux (no pkg companion)" "${_stub}/pkg.log"
    _help=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        env -u USER_BIN sh "${SCRIPT}" help 2>/dev/null
    )
    assert_not_contains "TP-TX-03 help must not recommend sudo on Termux" "$_help" "sudo curl"
    assert_contains "TP-TX-03 help install names this login" "$_help" "this login"

    # --- TP-TX-08: Termux volatile records use $PREFIX/tmp when /dev/shm is unusable ---
    # Real Termux: /dev/shm missing, Android /tmp often read-only. Simulate by
    # pointing VOLATILE_DIR at a missing path; apply_termux retargets to PREFIX/tmp.
    _tx_name="tx-pref-tmp"
    _u=$(id -un 2>/dev/null || echo "unknown")
    _tx_file="${_tx_prefix}/tmp/${APP_NAME}_${_u}_${_tx_name}"
    _errf="${CI_HOME}/tx-stor.err"
    rm -f "${_tx_file}"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u USER_BIN sh "${SCRIPT}" start "${_tx_name}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_eq "TP-TX-08 termux start with unusable VOLATILE_DIR exit 0" 0 "$_ec"
    assert_not_contains "TP-TX-08 must not die on missing /dev/shm /tmp" "$_all" "No writable temporary storage"
    assert_not_contains "TP-TX-08 must not write timer file at filesystem root" "$_all" "cannot create /${APP_NAME}_"
    assert_file_exists "TP-TX-08 volatile file under PREFIX/tmp" "${_tx_file}"
    _stop=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u USER_BIN sh "${SCRIPT}" stop "${_tx_name}" 2>/dev/null
    )
    _sec=$?
    assert_eq "TP-TX-08 termux stop of PREFIX/tmp timer exit 0" 0 "$_sec"
    rm -f "${_tx_file}"

    _errf="${CI_HOME}/tx-zero-arg.err"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        SCRIPT_URL="http://127.0.0.1:1/timer-unreachable" \
        env -u USER_BIN sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_not_contains "TP-TX-03 empty-argv recommend has no sudo curl" "$_all" "sudo curl"
    assert_contains "TP-TX-03 empty-argv still shows curl | sh" "$_all" "curl -fsSL"
    ci_cleanup_env
    rm -rf "${_stub}"
}
