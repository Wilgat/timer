#!/bin/sh
# =============================================================================
# tests/run.sh — CI entrypoint for timer
# =============================================================================
#
# GENERAL PURPOSE:
# Run the product test suite in a non-interactive, network-isolated-friendly
# way suitable for local development and GitHub Actions.
#
# Usage:
#   ./tests/run.sh
#   sh tests/run.sh
#
# Exit 0 when all assertions pass; non-zero when any fail.
#
# Requirements: POSIX sh, curl, python3 (local channel), sha256sum, grep, date
# =============================================================================

set -u

TESTS_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "${TESTS_ROOT}/.." && pwd)
export TESTS_ROOT REPO_ROOT

# Ship unit under test (bootstrap-specialized product)
APP_NAME="${APP_NAME:-timer}"
SCRIPT="${REPO_ROOT}/${APP_NAME}"
export APP_NAME SCRIPT

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"
# shellcheck source=test_cli.sh
. "${TESTS_ROOT}/test_cli.sh"
# shellcheck source=test_install_lifecycle.sh
. "${TESTS_ROOT}/test_install_lifecycle.sh"
# shellcheck source=test_timer_domain.sh
. "${TESTS_ROOT}/test_timer_domain.sh"

PASS=0
FAIL=0
SKIP=0

_cleanup() {
    ci_stop_channel 2>/dev/null || true
    ci_cleanup_env 2>/dev/null || true
    ci_cleanup_timer_domain 2>/dev/null || true
}
trap _cleanup EXIT INT HUP TERM

printf '%s CI tests\n' "${APP_NAME}"
printf 'script: %s\n' "${SCRIPT}"
printf 'version: %s\n' "${APP_VERSION}"

if [ ! -f "${SCRIPT}" ]; then
    printf 'ERROR: ship unit missing: %s\n' "${SCRIPT}" >&2
    exit 2
fi
if [ ! -x "${SCRIPT}" ]; then
    chmod +x "${SCRIPT}" 2>/dev/null || true
fi

run_test_cli
run_test_install_lifecycle
run_test_timer_domain

printf '\n== summary ==\n'
printf 'PASS=%s FAIL=%s SKIP=%s\n' "${PASS}" "${FAIL}" "${SKIP}"

if [ "${FAIL}" -gt 0 ]; then
    printf 'RESULT: FAILED\n' >&2
    exit 1
fi

printf 'RESULT: OK\n'
exit 0
