#!/bin/sh
# =============================================================================
# tests/run.sh — CI entrypoint for timer (PM-SHELL-CLI-SUITE-TEST-PLAN)
# =============================================================================
# Order: CLI → install lifecycle → online curl (local) → domain
# Assert labels use TP-IDs (TP-CLI / TP-LC / TP-CSUM / TP-U / TP-CURL / TP-TIMER).
# Product map: reviews/test-plan.md · RTM: reviews/requirement-test-matrix.md
# =============================================================================

set -u

TESTS_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "${TESTS_ROOT}/.." && pwd)
export TESTS_ROOT REPO_ROOT
: "${APP_NAME:=timer}"
export APP_NAME
SCRIPT="${REPO_ROOT}/${APP_NAME}"
export SCRIPT

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"
# shellcheck source=test_cli.sh
. "${TESTS_ROOT}/test_cli.sh"
# shellcheck source=test_install_lifecycle.sh
. "${TESTS_ROOT}/test_install_lifecycle.sh"
# shellcheck source=test_online_curl_install.sh
. "${TESTS_ROOT}/test_online_curl_install.sh"
# shellcheck source=test_timer_domain.sh
. "${TESTS_ROOT}/test_timer_domain.sh"

PASS=0
FAIL=0
SKIP=0

_cleanup() {
    ci_stop_channel 2>/dev/null || true
    ci_cleanup_timer_domain 2>/dev/null || true
    ci_cleanup_env 2>/dev/null || true
}
trap _cleanup EXIT INT HUP TERM

printf 'timer CI tests\n'
printf 'script: %s\n' "${SCRIPT}"

if [ ! -f "${SCRIPT}" ]; then
    printf 'ERROR: ship unit missing: %s\n' "${SCRIPT}" >&2
    exit 2
fi
if [ ! -x "${SCRIPT}" ]; then
    chmod +x "${SCRIPT}" 2>/dev/null || true
fi

run_test_cli
run_test_install_lifecycle
run_test_online_curl_install
run_test_timer_domain

printf '\n== summary ==\n'
printf 'PASS=%s FAIL=%s SKIP=%s\n' "${PASS}" "${FAIL}" "${SKIP}"

if [ "${FAIL}" -gt 0 ]; then
    printf 'RESULT: FAILED\n' >&2
    exit 1
fi

printf 'RESULT: OK\n'
exit 0
