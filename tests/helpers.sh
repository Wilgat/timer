# =============================================================================
# tests/helpers.sh — shared assertions for timer CI tests
# =============================================================================
# Source from test scripts (POSIX /bin/sh). Does not modify product code.
# Parameterized ship unit: APP_NAME (default timer), SCRIPT, APP_VERSION.
# =============================================================================

# shellcheck disable=SC2034
: "${TESTS_ROOT:=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"
: "${REPO_ROOT:=$(CDPATH= cd -- "${TESTS_ROOT}/.." && pwd)}"
: "${APP_NAME:=timer}"
: "${SCRIPT:=${REPO_ROOT}/${APP_NAME}}"
: "${PASS:=0}"
: "${FAIL:=0}"
: "${SKIP:=0}"

# Product version SSOT from ship unit (grep '^VERSION="')
if [ -z "${APP_VERSION:-}" ] && [ -f "${SCRIPT}" ]; then
    APP_VERSION=$(grep '^VERSION="' "${SCRIPT}" 2>/dev/null | head -n1 | cut -d'"' -f2)
fi
: "${APP_VERSION:=unknown}"

# --- output ---
t_info()  { printf '  · %s\n' "$*"; }
t_pass()  { PASS=$((PASS + 1)); printf '  PASS  %s\n' "$*"; }
t_fail()  { FAIL=$((FAIL + 1)); printf '  FAIL  %s\n' "$*" >&2; }
t_skip()  { SKIP=$((SKIP + 1)); printf '  SKIP  %s\n' "$*"; }
t_header() { printf '\n== %s ==\n' "$*"; }

# --- assertions ---
assert_eq() {
    _lab="$1"; _exp="$2"; _act="$3"
    if [ "$_exp" = "$_act" ]; then
        t_pass "$_lab"
    else
        t_fail "$_lab (expected='$(_trunc "$_exp")' actual='$(_trunc "$_act")')"
    fi
}

assert_contains() {
    _lab="$1"; _hay="$2"; _ndl="$3"
    case "$_hay" in
        *"$_ndl"*) t_pass "$_lab" ;;
        *) t_fail "$_lab (missing '$(_trunc "$_ndl")' in '$(_trunc "$_hay")')" ;;
    esac
}

assert_not_contains() {
    _lab="$1"; _hay="$2"; _ndl="$3"
    case "$_hay" in
        *"$_ndl"*) t_fail "$_lab (unexpected '$(_trunc "$_ndl")')" ;;
        *) t_pass "$_lab" ;;
    esac
}

assert_exit() {
    _lab="$1"; _exp="$2"; shift 2
    "$@" >/dev/null 2>&1
    _act=$?
    assert_eq "$_lab" "$_exp" "$_act"
}

assert_file_exists() {
    _lab="$1"; _path="$2"
    if [ -e "$_path" ]; then
        t_pass "$_lab"
    else
        t_fail "$_lab (missing $_path)"
    fi
}

assert_file_missing() {
    _lab="$1"; _path="$2"
    if [ -e "$_path" ]; then
        t_fail "$_lab (still exists: $_path)"
    else
        t_pass "$_lab"
    fi
}

_trunc() {
    printf '%s' "$1" | tr '\n' ' ' | cut -c1-160
}

# --- isolation helpers ---
# Start a local HTTP channel serving SCRIPT as APP_NAME (+ derived .sha256).
# Sets: CI_HTTP_PID, CI_SCRIPT_URL, CI_CHANNEL_DIR, CI_PORT
ci_start_channel() {
    CI_CHANNEL_DIR=$(mktemp -d "${TMPDIR:-/tmp}/tm-channel.XXXXXX")
    cp "${SCRIPT}" "${CI_CHANNEL_DIR}/${APP_NAME}"
    sha256sum "${CI_CHANNEL_DIR}/${APP_NAME}" | awk '{print $1}' > "${CI_CHANNEL_DIR}/${APP_NAME}.sha256"

    CI_PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()')
    (
        cd "${CI_CHANNEL_DIR}" || exit 1
        exec python3 -m http.server "${CI_PORT}" --bind 127.0.0.1
    ) >/dev/null 2>&1 &
    CI_HTTP_PID=$!
    CI_SCRIPT_URL="http://127.0.0.1:${CI_PORT}/${APP_NAME}"

    _i=0
    while [ "$_i" -lt 50 ]; do
        if curl -fsS "${CI_SCRIPT_URL}" >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.1
        _i=$((_i + 1))
    done
    t_fail "local channel failed to start on port ${CI_PORT}"
    return 1
}

ci_stop_channel() {
    if [ -n "${CI_HTTP_PID:-}" ]; then
        kill "${CI_HTTP_PID}" 2>/dev/null || true
        wait "${CI_HTTP_PID}" 2>/dev/null || true
        CI_HTTP_PID=
    fi
    if [ -n "${CI_CHANNEL_DIR:-}" ] && [ -d "${CI_CHANNEL_DIR}" ]; then
        rm -rf "${CI_CHANNEL_DIR}"
        CI_CHANNEL_DIR=
    fi
}

# Isolated HOME + USER_BIN. Sets CI_HOME, CI_USER_BIN.
ci_isolated_env() {
    CI_HOME=$(mktemp -d "${TMPDIR:-/tmp}/tm-home.XXXXXX")
    CI_USER_BIN="${CI_HOME}/.local/bin"
    mkdir -p "${CI_USER_BIN}"
    export HOME="${CI_HOME}"
    export USER_BIN="${CI_USER_BIN}"
    unset CHECKSUM 2>/dev/null || true
}

ci_cleanup_env() {
    if [ -n "${CI_HOME:-}" ] && [ -d "${CI_HOME}" ]; then
        rm -rf "${CI_HOME}"
        CI_HOME=
        CI_USER_BIN=
    fi
}

# Remove this user's volatile timer files (best-effort; domain suite).
ci_cleanup_timer_domain() {
    _u=$(id -un 2>/dev/null || echo "unknown")
    rm -f /dev/shm/${APP_NAME}_"${_u}"_* 2>/dev/null || true
    rm -f /tmp/${APP_NAME}_"${_u}"_* 2>/dev/null || true
}

ci_run() {
    sh "${SCRIPT}" "$@"
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        t_fail "required command missing: $1"
        return 1
    fi
    return 0
}
