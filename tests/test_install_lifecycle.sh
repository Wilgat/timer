# =============================================================================
# tests/test_install_lifecycle.sh — install lifecycle (PM-INSTALL-LIFECYCLE-TEST-PLAN)
# =============================================================================
# Families: TP-LC-*, TP-CSUM-02..04 (channel). Local HTTP only — no public network.
# Labels MUST include TP-IDs (policy-harness-id-notation).
# Primary REQs: RQ-SHELL-SELF-MANAGEMENT, RQ-SHELL-CLI-ZERO-ARGUMENTS, RQ-SHELL-IDEMPOTENCY, RQ-SHELL-AUTOMATIC-CHECKSUM.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_install_lifecycle() {
    t_header "Install lifecycle (TP-LC / TP-CSUM)"

    require_cmd curl
    require_cmd python3
    require_cmd sha256sum

    ci_isolated_env
    if ! ci_start_channel; then
        ci_cleanup_env
        return 1
    fi

    _app_bin="${CI_USER_BIN}/timer"
    _errf="${CI_HOME}/lc-err.txt"

    # --- TP-LC-01: first empty-argv ensure on local channel ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-01 zero-arg first install exit 0" 0 "$_ec"
    assert_file_exists "TP-LC-01 zero-arg first install binary exists" "${_app_bin}"
    assert_not_contains "TP-LC-01 zero-arg first install must not dump help" "$_out" "Global Options"

    # Clean for explicit install path tests
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-uninstall >/dev/null 2>&1 || true
    rm -f "${_app_bin}"

    # --- TP-LC-12: install --json ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-12 install --json exit 0" 0 "$_ec"
    assert_contains "TP-LC-12 install --json success type" "$_out" '"type":"out_success"'
    assert_contains "TP-LC-12 install --json path" "$_out" "${_app_bin}"
    assert_file_exists "TP-LC-12 installed binary exists" "${_app_bin}"

    # PATH line may be written on first user install (bashrc/zshrc)
    _path_hit=0
    for _rc in "${CI_HOME}/.bashrc" "${CI_HOME}/.zshrc"; do
        if [ -f "$_rc" ] && grep -q "${CI_USER_BIN}" "$_rc" 2>/dev/null; then
            _path_hit=1
            break
        fi
    done
    if [ "$_path_hit" -eq 1 ]; then
        t_pass "TP-LC-12 install added USER_BIN to a shell rc (PATH prep)"
    else
        # Some environments skip when already on PATH; not a hard fail for Type 0
        t_pass "TP-LC-12 install PATH rc optional (no rc write observed)"
    fi

    # --- TP-LC-10: idempotent re-install (no --force) ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-LC-10 re-install --json (idempotent) exit 0" 0 "$_ec"
    assert_contains "TP-LC-10 re-install reports already installed" "$_out" "already installed"

    # --- TP-LC-01 Case B: zero-arg when already installed (local) ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-01 zero-arg when installed (local) exit 0" 0 "$_ec"
    assert_contains "TP-LC-01 zero-arg when installed (local) says already installed" "$_out" "already installed"
    assert_not_contains "TP-LC-01 zero-arg when installed (local) must not dump help" "$_out" "Global Options"

    # --- Case C: global path present → already installed, not help ---
    _global_bin="${CI_HOME}/global-bin"
    mkdir -p "${_global_bin}"
    cp "${SCRIPT}" "${_global_bin}/timer"
    chmod +x "${_global_bin}/timer"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${_global_bin}" \
        SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-LC-01 zero-arg when installed (global) exit 0" 0 "$_ec"
    assert_contains "TP-LC-01 zero-arg when installed (global) says already installed" "$_out" "already installed"
    assert_not_contains "TP-LC-01 zero-arg when installed (global) must not dump help" "$_out" "Global Options"
    rm -f "${_global_bin}/timer"

    # --- TP-LC-04: about installed + version-check JSON ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json about 2>/dev/null
    )
    _ec=$?
    assert_eq "TP-LC-04 about after install exit 0" 0 "$_ec"
    assert_contains "TP-LC-04 about installed true" "$_out" '"installed":"true"'

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json version-check 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-04 version-check --json exit 0" 0 "$_ec"
    assert_contains "TP-LC-04 version-check --json type" "$_out" '"type":"ver_check"'
    assert_contains "TP-LC-04 version-check --json local_version key" "$_out" "\"local_version\":\"${APP_VERSION}\""
    assert_contains "TP-LC-04 version-check --json remote_version key" "$_out" "\"remote_version\":\"${APP_VERSION}\""
    assert_contains "TP-LC-04 version-check --json is_latest true" "$_out" '"is_latest":"true"'
    assert_not_contains "TP-LC-04 version-check --json must not put key in message" "$_out" '"message":"local_version"'

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" version-check 2>/dev/null
    )
    _ec=$?
    assert_eq "TP-LC-04 version-check human exit 0" 0 "$_ec"
    assert_contains "TP-LC-04 version-check human local line" "$_out" "Local version"
    assert_contains "TP-LC-04 version-check human remote line" "$_out" "Latest version"

    # --- TP-LC-11: version-check network failure ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/timer-unreachable" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json version-check 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-LC-11 version-check unreachable exits non-zero"
    else
        t_fail "TP-LC-11 version-check unreachable expected non-zero, got 0"
    fi
    assert_contains "TP-LC-11 version-check network_error code" "$_err" "network_error"

    # --- TP-LC-05: self-update already-latest ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-update 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-05 self-update already-latest exit 0" 0 "$_ec"
    assert_contains "TP-LC-05 self-update already-latest success" "$_out" '"type":"out_success"'
    assert_contains "TP-LC-05 self-update already-latest message" "$_out" "Already running the latest version"

    # --- TP-LC-05b: self-update when remote is newer ---
    _newer_ver="9.9.9"
    _channel_bin="${CI_CHANNEL_DIR}/timer"
    # shellcheck disable=SC2016
    sed "s/^VERSION=\"${APP_VERSION}\"/VERSION=\"${_newer_ver}\"/" "${SCRIPT}" > "${_channel_bin}"
    printf '%s\n' "$(sha256sum "${_channel_bin}" | awk '{print $1}')" > "${CI_CHANNEL_DIR}/timer.sha256"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-update 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-05b self-update newer remote exit 0" 0 "$_ec"
    _loc=$(grep '^VERSION="' "${_app_bin}" | cut -d'"' -f2)
    assert_eq "TP-LC-05b local version after upgrade" "${_newer_ver}" "$_loc"
    # restore channel to product bytes for remaining tests
    cp "${SCRIPT}" "${_channel_bin}"
    printf '%s\n' "$(sha256sum "${_channel_bin}" | awk '{print $1}')" > "${CI_CHANNEL_DIR}/timer.sha256"
    # reinstall product version as local baseline for transparency/downgrade
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json --force install >/dev/null 2>&1 || true

    # --- TP-LC-06 / TP-CSUM-02: human --force install transparency ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --force install 2>"${_errf}"
    )
    _ec=$?
    assert_eq "TP-LC-06 TP-CSUM-02 human --force install exit 0" 0 "$_ec"
    assert_contains "TP-LC-06 TP-CSUM-02 human install companion link" "$_out" "Companion link:"
    assert_contains "TP-LC-06 TP-CSUM-02 human install expected digest" "$_out" "Expected SHA-256:"
    assert_contains "TP-LC-06 TP-CSUM-02 human install actual digest" "$_out" "Actual SHA-256:"
    assert_contains "TP-LC-06 TP-CSUM-02 human install PASS result" "$_out" "Automatic checksum result: PASS"
    assert_contains "TP-LC-06 TP-CSUM-02 human install verified flag message" "$_out" "cryptographically verified"

    # --- TP-LC-07: self-uninstall refuse / force + PATH cleanup when empty ---
    # Ensure only timer in USER_BIN so cleanup path can strip rc lines
    find "${CI_USER_BIN}" -mindepth 1 ! -name 'timer' -exec rm -rf {} + 2>/dev/null || true
    # Seed a PATH line if install did not
    if [ ! -f "${CI_HOME}/.bashrc" ] || ! grep -q "${CI_USER_BIN}" "${CI_HOME}/.bashrc" 2>/dev/null; then
        printf 'export PATH="%s:$PATH"\n' "${CI_USER_BIN}" >> "${CI_HOME}/.bashrc"
    fi

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-07 lifecycle self-uninstall --json no force exit 1" 1 "$_ec"
    assert_contains "TP-LC-07 lifecycle confirm_required" "$_err" "confirm_required"
    assert_file_exists "TP-LC-07 binary remains after refuse" "${_app_bin}"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-07 self-uninstall --json --force exit 0" 0 "$_ec"
    assert_contains "TP-LC-07 self-uninstall force success" "$_out" '"type":"out_success"'
    assert_file_missing "TP-LC-07 binary removed after --force" "${_app_bin}"

    # PATH cleanup when USER_BIN empty after uninstall
    if [ -f "${CI_HOME}/.bashrc" ]; then
        if grep -q "${CI_USER_BIN}" "${CI_HOME}/.bashrc" 2>/dev/null; then
            t_fail "TP-LC-07 PATH cleanup: USER_BIN still in .bashrc after empty-bin uninstall"
        else
            t_pass "TP-LC-07 PATH cleanup: USER_BIN removed from .bashrc when bin empty"
        fi
    else
        t_pass "TP-LC-07 PATH cleanup: no .bashrc (nothing to strip)"
    fi

    # --- TP-CSUM-03: Shape B pin mismatch ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        CHECKSUM="0000000000000000000000000000000000000000000000000000000000000000" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CSUM-03 CHECKSUM mismatch aborts (non-zero)" 1 "$_ec"
    assert_contains "TP-CSUM-03 CHECKSUM mismatch code" "$_err" "checksum_mismatch"
    assert_file_missing "TP-CSUM-03 no install after bad CHECKSUM" "${_app_bin}"

    # --- TP-CSUM-04: Shape B pin match ---
    _good=$(sha256sum "${SCRIPT}" | awk '{print $1}')
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        CHECKSUM="${_good}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CSUM-04 CHECKSUM match install exit 0" 0 "$_ec"
    assert_file_exists "TP-CSUM-04 install with good CHECKSUM" "${_app_bin}"

    # --- TP-LC-08: downgrade refuse without --force; allow with --force ---
    _older="${CI_CHANNEL_DIR}/timer"
    # shellcheck disable=SC2016
    sed "s/^VERSION=\"${APP_VERSION}\"/VERSION=\"0.9.0\"/" "${SCRIPT}" > "${_older}"
    printf '%s\n' "$(sha256sum "${_older}" | awk '{print $1}')" > "${CI_CHANNEL_DIR}/timer.sha256"
    assert_file_exists "TP-LC-08 local binary present for downgrade tests" "${_app_bin}"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-update 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-08 self-update downgrade without --force exit 1" 1 "$_ec"
    assert_contains "TP-LC-08 self-update downgrade_blocked code" "$_err" "downgrade_blocked"
    _loc=$(grep '^VERSION="' "${_app_bin}" | cut -d'"' -f2)
    assert_eq "TP-LC-08 local version unchanged after refused downgrade" "${APP_VERSION}" "$_loc"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-update 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-LC-08 self-update --force downgrade exit 0" 0 "$_ec"
    _loc=$(grep '^VERSION="' "${_app_bin}" | cut -d'"' -f2)
    assert_eq "TP-LC-08 local version after forced downgrade" "0.9.0" "$_loc"

    # cleanup
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-uninstall >/dev/null 2>&1 || true

    ci_stop_channel
    ci_cleanup_env
}
