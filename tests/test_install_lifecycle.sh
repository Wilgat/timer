# =============================================================================
# tests/test_install_lifecycle.sh — install / idempotency / version-check /
# self-uninstall with local HTTP channel (no public network required)
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_install_lifecycle() {
    t_header "Install lifecycle (local channel)"

    require_cmd curl
    require_cmd python3
    require_cmd sha256sum

    ci_isolated_env
    if ! ci_start_channel; then
        ci_cleanup_env
        return 1
    fi

    _app_bin="${CI_USER_BIN}/${APP_NAME}"
    _errf="${CI_HOME}/lc-err.txt"

    # --- install ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "install --json exit 0" 0 "$_ec"
    assert_contains "install --json success type" "$_out" '"type":"out_success"'
    assert_contains "install --json path" "$_out" "${_app_bin}"
    assert_file_exists "installed binary exists" "${_app_bin}"

    # --- idempotent re-install (no --force) ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    assert_eq "re-install --json (idempotent) exit 0" 0 "$_ec"
    assert_contains "re-install reports already installed" "$_out" "already installed"

    # --- zero-arg when already installed (local) = Type O Case B ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    assert_eq "zero-arg when installed (local) exit 0" 0 "$_ec"
    assert_contains "zero-arg when installed (local) says already installed" "$_out" "already installed"
    assert_not_contains "zero-arg when installed (local) must not dump help" "$_out" "Global Options"

    # --- zero-arg when already installed (global path present) = Case C ---
    _global_bin="${CI_HOME}/global-bin"
    mkdir -p "${_global_bin}"
    cp "${SCRIPT}" "${_global_bin}/${APP_NAME}"
    chmod +x "${_global_bin}/${APP_NAME}"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" GLOBAL_BIN="${_global_bin}" \
        SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    assert_eq "zero-arg when installed (global) exit 0" 0 "$_ec"
    assert_contains "zero-arg when installed (global) says already installed" "$_out" "already installed"
    assert_not_contains "zero-arg when installed (global) must not dump help" "$_out" "Global Options"
    rm -f "${_global_bin}/${APP_NAME}"

    # --- about shows installed ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --json about 2>/dev/null
    )
    _ec=$?
    assert_eq "about after install exit 0" 0 "$_ec"
    assert_contains "about installed true" "$_out" '"installed":"true"'

    # --- version-check against local channel ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json version-check 2>"${_errf}"
    )
    _ec=$?
    assert_eq "version-check --json exit 0" 0 "$_ec"
    assert_contains "version-check --json type" "$_out" '"type":"ver_check"'
    assert_contains "version-check --json local_version key" "$_out" "\"local_version\":\"${APP_VERSION}\""
    assert_contains "version-check --json remote_version key" "$_out" "\"remote_version\":\"${APP_VERSION}\""
    assert_contains "version-check --json is_latest true" "$_out" '"is_latest":"true"'
    assert_not_contains "version-check --json must not put key in message" "$_out" '"message":"local_version"'

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" version-check 2>/dev/null
    )
    _ec=$?
    assert_eq "version-check human exit 0" 0 "$_ec"
    assert_contains "version-check human local line" "$_out" "Local version"
    assert_contains "version-check human remote line" "$_out" "Latest version"

    # --- self-update already-latest ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-update 2>"${_errf}"
    )
    _ec=$?
    assert_eq "self-update already-latest exit 0" 0 "$_ec"
    assert_contains "self-update already-latest success" "$_out" '"type":"out_success"'
    assert_contains "self-update already-latest message" "$_out" "Already running the latest version"

    # --- human install transparency (companion link / expected / result) ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" --force install 2>"${_errf}"
    )
    _ec=$?
    assert_eq "human --force install exit 0" 0 "$_ec"
    assert_contains "human install companion link" "$_out" "Companion link:"
    assert_contains "human install expected digest" "$_out" "Expected SHA-256:"
    assert_contains "human install actual digest" "$_out" "Actual SHA-256:"
    assert_contains "human install PASS result" "$_out" "Automatic checksum result: PASS"
    assert_contains "human install verified flag message" "$_out" "cryptographically verified"

    # --- self-uninstall without --force fails closed ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "lifecycle self-uninstall --json no force exit 1" 1 "$_ec"
    assert_contains "lifecycle confirm_required" "$_err" "confirm_required"
    assert_file_exists "binary remains after refuse" "${_app_bin}"

    # --- self-uninstall --force removes ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-uninstall 2>"${_errf}"
    )
    _ec=$?
    assert_eq "self-uninstall --json --force exit 0" 0 "$_ec"
    assert_contains "self-uninstall force success" "$_out" '"type":"out_success"'
    assert_file_missing "binary removed after --force" "${_app_bin}"

    # --- strict CHECKSUM pin mismatch aborts ---
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        CHECKSUM="0000000000000000000000000000000000000000000000000000000000000000" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "CHECKSUM mismatch aborts (non-zero)" 1 "$_ec"
    assert_contains "CHECKSUM mismatch code" "$_err" "checksum_mismatch"
    assert_file_missing "no install after bad CHECKSUM" "${_app_bin}"

    # --- strict CHECKSUM pin match succeeds ---
    _good=$(sha256sum "${SCRIPT}" | awk '{print $1}')
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        CHECKSUM="${_good}" \
        sh "${SCRIPT}" --json install 2>"${_errf}"
    )
    _ec=$?
    assert_eq "CHECKSUM match install exit 0" 0 "$_ec"
    assert_file_exists "install with good CHECKSUM" "${_app_bin}"

    # --- downgrade refuse without --force; allow with --force ---
    _older="${CI_CHANNEL_DIR}/${APP_NAME}"
    # Replace product VERSION line (timer uses product VERSION; portable: any VERSION="x.y.z")
    sed "s/^VERSION=\"${APP_VERSION}\"/VERSION=\"0.9.0\"/" "${SCRIPT}" > "${_older}"
    printf '%s\n' "$(sha256sum "${_older}" | awk '{print $1}')" > "${CI_CHANNEL_DIR}/${APP_NAME}.sha256"
    assert_file_exists "local binary present for downgrade tests" "${_app_bin}"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json self-update 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "self-update downgrade without --force exit 1" 1 "$_ec"
    assert_contains "self-update downgrade_blocked code" "$_err" "downgrade_blocked"
    _loc=$(grep '^VERSION="' "${_app_bin}" | cut -d'"' -f2)
    assert_eq "local version unchanged after refused downgrade" "${APP_VERSION}" "$_loc"

    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-update 2>"${_errf}"
    )
    _ec=$?
    assert_eq "self-update --force downgrade exit 0" 0 "$_ec"
    _loc=$(grep '^VERSION="' "${_app_bin}" | cut -d'"' -f2)
    assert_eq "local version after forced downgrade" "0.9.0" "$_loc"

    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        PATH="${CI_USER_BIN}:${PATH}" \
        sh "${_app_bin}" --json --force self-uninstall >/dev/null 2>&1 || true

    ci_stop_channel
    ci_cleanup_env
}
