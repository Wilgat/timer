# =============================================================================
# tests/test_timer_domain.sh — timer product domain commands
# =============================================================================
# Covers: start/stop/status/list, --json, --persist, kill/reset, invalid name,
# already-running, no-timer errors. Uses isolated HOME for persistent storage;
# cleans volatile /dev/shm (or /tmp) timer files for this user after the suite.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_timer_domain() {
    t_header "Timer domain"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_timer_domain

    # Prefer invoking ship unit from checkout with isolated HOME (persist paths)
    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" "$@"
    }

    # --- start / status / list / stop (human, volatile) ---
    _out=$(_run start ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain start exit 0" 0 "$_ec"
    assert_contains "domain start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain status exit 0" 0 "$_ec"
    assert_contains "domain status shows name" "$_out" "ci-smoke"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list exit 0" 0 "$_ec"
    assert_contains "domain list includes timer" "$_out" "ci-smoke"

    # already running fails
    _out=$(_run start ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain start already-running exit 1" 1 "$_ec"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain stop exit 0" 0 "$_ec"
    assert_contains "domain stop elapsed text" "$_out" "stopped"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list after stop exit 0" 0 "$_ec"
    # empty list message or no ci-smoke
    case "$_out" in
        *ci-smoke*) t_fail "domain list after stop still shows ci-smoke" ;;
        *) t_pass "domain list after stop has no ci-smoke" ;;
    esac

    # --- JSON start / status / stop ---
    _out=$(_run --json start json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json start exit 0" 0 "$_ec"
    assert_contains "domain json start type success" "$_out" '"type":"success"'
    assert_contains "domain json start name" "$_out" '"name":"json-t"'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json status exit 0" 0 "$_ec"
    assert_contains "domain json status type" "$_out" '"type":"status"'
    # T-JSON-02: status elapsed fields are JSON numbers (not strings)
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
for k in ("minutes","seconds","elapsed"):
    assert isinstance(o.get(k), int), "%s type=%s" % (k, type(o.get(k)).__name__)
' 2>/dev/null; then
            t_pass "domain json status elapsed fields are numbers"
        else
            t_fail "domain json status elapsed fields are numbers"
        fi
    else
        case "$_out" in
            *'"elapsed":'*) case "$_out" in *'"elapsed":"'*) t_fail "domain json status elapsed fields are numbers (shape)" ;; *) t_pass "domain json status elapsed fields are numbers (shape)" ;; esac ;;
            *) t_fail "domain json status elapsed fields are numbers (shape)" ;;
        esac
    fi

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "domain json list exit 0" 0 "$_ec"
    assert_contains "domain json list type" "$_out" '"type":"list"'
    # T-JSON-01 / TP-JSON-01: timers must be a nested JSON array, not a stringified field
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
t=o.get("timers")
assert isinstance(t,list), "timers type=%s" % type(t).__name__
assert isinstance(o.get("count"), int), "count type=%s" % type(o.get("count")).__name__
assert any(x.get("name")=="json-t" for x in t if isinstance(x,dict)), "json-t missing"
row=next(x for x in t if isinstance(x,dict) and x.get("name")=="json-t")
for k in ("minutes","seconds","elapsed"):
    assert isinstance(row.get(k), int), "timers[].%s type=%s" % (k, type(row.get(k)).__name__)
' 2>/dev/null; then
            t_pass "domain json list timers is nested array"
            t_pass "domain json list count and elapsed fields are numbers"
        else
            t_fail "domain json list timers is nested array"
            t_fail "domain json list count and elapsed fields are numbers"
        fi
    else
        # Fallback shape check without python: array open after "timers":
        case "$_out" in
            *'"timers":['*) t_pass "domain json list timers is nested array (shape)" ;;
            *) t_fail "domain json list timers is nested array (shape)" ;;
        esac
        case "$_out" in
            *'"count":'*) case "$_out" in *'"count":"'*) t_fail "domain json list count is number (shape)" ;; *) t_pass "domain json list count is number (shape)" ;; esac ;;
            *) t_fail "domain json list count is number (shape)" ;;
        esac
    fi

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json stop exit 0" 0 "$_ec"
    assert_contains "domain json stop elapsed" "$_out" '"elapsed":'
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
for k in ("minutes","seconds","elapsed"):
    assert isinstance(o.get(k), int), "%s type=%s" % (k, type(o.get(k)).__name__)
' 2>/dev/null; then
            t_pass "domain json stop elapsed fields are numbers"
        else
            t_fail "domain json stop elapsed fields are numbers"
        fi
    else
        case "$_out" in
            *'"elapsed":'*) case "$_out" in *'"elapsed":"'*) t_fail "domain json stop elapsed fields are numbers (shape)" ;; *) t_pass "domain json stop elapsed fields are numbers (shape)" ;; esac ;;
            *) t_fail "domain json stop elapsed fields are numbers (shape)" ;;
        esac
    fi

    # --- no_timer errors ---
    _err=$(_run --json status gone 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain status missing exit 1" 1 "$_ec"
    assert_contains "domain status no_timer code" "$_err" "no_timer"

    # --- kill / reset ---
    _run start kill-me >/dev/null 2>&1
    _out=$(_run kill kill-me 2>/dev/null)
    _ec=$?
    assert_eq "domain kill exit 0" 0 "$_ec"

    _run start reset-me >/dev/null 2>&1
    _out=$(_run reset reset-me 2>/dev/null)
    _ec=$?
    assert_eq "domain reset exit 0" 0 "$_ec"
    assert_contains "domain reset text" "$_out" "reset"

    # --- invalid name ---
    _err=$(_run start 'bad/name' 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name exit 1" 1 "$_ec"

    _err=$(_run --json start 'bad/name' 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name json exit 1" 1 "$_ec"
    assert_contains "domain invalid_name code" "$_err" "invalid_name"

    # --- persistent mode ---
    _out=$(_run start --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "domain persist start exit 0" 0 "$_ec"
    assert_contains "domain persist mode note or success" "$_out" "started"

    _out=$(_run list --persist 2>/dev/null)
    _ec=$?
    assert_eq "domain persist list exit 0" 0 "$_ec"
    assert_contains "domain persist list name" "$_out" "persist-t"

    _out=$(_run stop --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "domain persist stop exit 0" 0 "$_ec"

    # cleanup domain artifacts for this user
    ci_cleanup_timer_domain
    # also wipe persistent under isolated HOME
    rm -rf "${CI_HOME}/.cache/${APP_NAME}" 2>/dev/null || true

    ci_cleanup_env
}
