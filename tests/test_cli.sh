# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (PM-SHELL-CLI-TEST-PLAN / TP-CLI-*)
# =============================================================================
# Portable families: TP-CLI, TP-CSUM-01/05, TP-U-01.
# Primary REQs: RQ-SHELL-CLI-INTERFACE, RQ-SHELL-OUTPUT-REQUIREMENTS, RQ-SHELL-AUTOMATIC-CHECKSUM, RQ-SHELL-CLI-ZERO-ARGUMENTS.
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

    # --- TP-CLI-05: shell about storage fields ---
    # timer product: about JSON has no effective_storage/storage_dir (domain storage is
    # owned by RQ-DOMAIN-TIMER / timer_* paths). Mark shell storage mold fields N/A;
    # domain suite proves volatile/persistent storage (TP-TIMER-09).
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-05 about --json type present (shell storage fields n/a)" "$_out" '"type":"about"'
    assert_not_contains "TP-CLI-05 timer about has no shell storage_dir field (domain owns storage)" "$_out" '"storage_dir"'
    t_pass "TP-CLI-05 shell storage resolve n/a for timer (see TP-TIMER-09)"

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
}
