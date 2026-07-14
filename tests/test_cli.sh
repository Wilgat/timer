# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (no network install required)
# =============================================================================
# Covers: syntax, version, help, about, unknown command, quiet/json modes,
# help must not list CHECKSUM, self-uninstall --json fail-closed,
# Type O zero-arg install failure exit, env -u HOME under set -u.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- syntax ---
    sh -n "${SCRIPT}"
    _syn=$?
    assert_eq "sh -n ${APP_NAME} (syntax)" 0 "$_syn"

    # --- companion digest matches ship unit ---
    if [ -f "${REPO_ROOT}/${APP_NAME}.sha256" ]; then
        # Allow "HASH" or "HASH  filename" formats (first field only)
        _expected=$(awk '{print $1; exit}' "${REPO_ROOT}/${APP_NAME}.sha256")
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "${APP_NAME}.sha256 matches ./${APP_NAME}" "$_expected" "$_actual"
    else
        t_fail "${APP_NAME}.sha256 missing at repo root"
    fi

    # --- version (human) ---
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "version exit 0" 0 "$_ec"
    assert_contains "version human mentions version" "$_out" "${APP_VERSION}"
    assert_contains "version human mentions app" "$_out" "${APP_NAME}"

    # --- version (json) ---
    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "version --json exit 0" 0 "$_ec"
    assert_contains "version --json type" "$_out" '"type":"version"'
    assert_contains "version --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_contains "version --json version field" "$_out" "\"version\":\"${APP_VERSION}\""

    # --- help (human): Type 0 + domain present, CHECKSUM absent ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "help exit 0" 0 "$_ec"
    assert_contains "help lists install" "$_out" "install"
    assert_contains "help lists version-check" "$_out" "version-check"
    assert_contains "help lists self-update" "$_out" "self-update"
    assert_contains "help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "help lists about" "$_out" "about"
    assert_contains "help lists start (domain)" "$_out" "start"
    assert_contains "help lists stop (domain)" "$_out" "stop"
    assert_contains "help lists list (domain)" "$_out" "list"
    assert_contains "help lists --persist" "$_out" "--persist"
    assert_contains "help lists --json" "$_out" "--json"
    assert_contains "help lists --force" "$_out" "--force"
    assert_contains "help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "help lists REPO_NAME" "$_out" "REPO_NAME"
    assert_contains "help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_not_contains "help must not list CHECKSUM" "$_out" "CHECKSUM"

    # --- help (json) ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "help --json exit 0" 0 "$_ec"
    assert_contains "help --json type success" "$_out" '"type":"success"'
    assert_contains "help --json command help" "$_out" '"command":"help"'

    # --- about (json): no CHECKSUM field ---
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "about --json exit 0" 0 "$_ec"
    assert_contains "about --json type" "$_out" '"type":"about"'
    assert_contains "about --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_not_contains "about --json must not include CHECKSUM" "$_out" "CHECKSUM"

    # --- unknown command ---
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "unknown command exit 1" 1 "$_ec"
    assert_contains "unknown command error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "unknown command --json exit 1" 1 "$_ec"
    assert_contains "unknown command --json type error" "$_err" '"type":"out_error"'

    # --- quiet: version should not print info banners ---
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "version --quiet exit 0" 0 "$_ec"
    if [ -z "$_out" ]; then
        t_pass "version --quiet suppresses human info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "version --quiet suppresses human info"
        else
            t_fail "version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi

    # --- HOME unset under set -u (INC-20260713-001 class) ---
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "env -u HOME version exit 0" 0 "$_ec"
    assert_contains "env -u HOME version still reports version" "$_out" "${APP_VERSION}"

    # --- zero-arg auto-install propagates failure (not exit 0 on download fail) ---
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/${APP_NAME}-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "zero-arg failed install exits non-zero"
    else
        t_fail "zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "zero-arg failed install left no binary" "${CI_USER_BIN}/${APP_NAME}"
    ci_cleanup_env

    # --- self-uninstall --json without force when binary present (isolated) ---
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    cp "${SCRIPT}" "${CI_USER_BIN}/${APP_NAME}"
    chmod +x "${CI_USER_BIN}/${APP_NAME}"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "self-uninstall --json without --force exit 1" 1 "$_ec"
    assert_contains "self-uninstall --json confirm_required code" "$_err" '"code":"confirm_required"'
    assert_contains "self-uninstall --json out_error type" "$_err" '"type":"out_error"'
    assert_not_contains "self-uninstall --json must not fake success cancel" "$_out$_err" "cancelled by user"
    assert_file_exists "binary remains without --force" "${CI_USER_BIN}/${APP_NAME}"
    ci_cleanup_env
}
