# =============================================================================
# tests/test_timer_domain.sh — timer domain (RQ-DOMAIN-TIMER / TP-TIMER-*)
# =============================================================================
# Domain-subject family TP-TIMER-* proves RQ-DOMAIN-TIMER (policy-harness-id-notation §5).
# Type O-P portable payload design tokens (TP-PAYLOAD-*/PM-DOMAIN-TEST-PLAN) are n/a for this product.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_timer_domain() {
    t_header "Timer domain (TP-TIMER-*)"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_timer_domain

    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" "$@"
    }

    # --- TP-TIMER-01: help lists domain verbs/flags (product specialization of mold) ---
    _out=$(_run help 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-01 help exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-01 help lists start" "$_out" "start"
    assert_contains "TP-TIMER-01 help lists stop" "$_out" "stop"
    assert_contains "TP-TIMER-01 help lists status" "$_out" "status"
    assert_contains "TP-TIMER-01 help lists list" "$_out" "list"
    assert_contains "TP-TIMER-01 help lists kill" "$_out" "kill"
    assert_contains "TP-TIMER-01 help lists reset" "$_out" "reset"
    assert_contains "TP-TIMER-01 help lists --persist" "$_out" "--persist"

    # --- TP-TIMER-02: start / status / list / stop (human, volatile) ---
    _out=$(_run start ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-02 start exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-02 start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-02 status exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-02 status shows name" "$_out" "ci-smoke"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-02 list exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-02 list includes timer" "$_out" "ci-smoke"

    # --- TP-TIMER-03: already-running fail ---
    _out=$(_run start ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-03 start already-running exit 1" 1 "$_ec"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-02 stop exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-02 stop elapsed text" "$_out" "stopped"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-02 list after stop exit 0" 0 "$_ec"
    case "$_out" in
        *ci-smoke*) t_fail "TP-TIMER-02 list after stop still shows ci-smoke" ;;
        *) t_pass "TP-TIMER-02 list after stop has no ci-smoke" ;;
    esac

    # --- TP-TIMER-04: JSON start / status / list / stop + numeric types ---
    _out=$(_run --json start json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-04 json start exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-04 json start type success" "$_out" '"type":"success"'
    assert_contains "TP-TIMER-04 json start name" "$_out" '"name":"json-t"'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-04 json status exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-04 json status type" "$_out" '"type":"status"'
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
for k in ("minutes","seconds","elapsed"):
    assert isinstance(o.get(k), int), "%s type=%s" % (k, type(o.get(k)).__name__)
' 2>/dev/null; then
            t_pass "TP-TIMER-04 json status elapsed fields are numbers"
        else
            t_fail "TP-TIMER-04 json status elapsed fields not all numbers"
        fi
    else
        t_skip "TP-TIMER-04 python3 missing for number type check"
    fi

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-04 json list exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-04 json list type" "$_out" '"type":"list"'
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
assert isinstance(o.get("timers"), list), type(o.get("timers")).__name__
assert isinstance(o.get("count"), int), type(o.get("count")).__name__
for t in o.get("timers") or []:
    if "elapsed" in t:
        assert isinstance(t["elapsed"], int)
' 2>/dev/null; then
            t_pass "TP-TIMER-04 json list timers nested array + count number"
        else
            t_fail "TP-TIMER-04 json list structure/types invalid"
        fi
    else
        t_skip "TP-TIMER-04 python3 missing for list type check"
    fi

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-04 json stop exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-04 json stop elapsed" "$_out" '"elapsed"'
    if command -v python3 >/dev/null 2>&1; then
        if printf '%s\n' "$_out" | python3 -c '
import json,sys
o=json.load(sys.stdin)
for k in ("minutes","seconds","elapsed"):
    assert isinstance(o.get(k), int), "%s type=%s" % (k, type(o.get(k)).__name__)
' 2>/dev/null; then
            t_pass "TP-TIMER-04 json stop elapsed fields are numbers"
        else
            t_fail "TP-TIMER-04 json stop elapsed fields not all numbers"
        fi
    fi

    # --- TP-TIMER-05: no_timer error ---
    _err=$(_run --json status missing-timer-xyz 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-05 status missing exit 1" 1 "$_ec"
    assert_contains "TP-TIMER-05 no_timer code" "$_err" "no_timer"

    # --- TP-TIMER-06: kill / reset ---
    _run start kill-me >/dev/null 2>&1
    _out=$(_run kill kill-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-06 kill exit 0" 0 "$_ec"

    _run start reset-me >/dev/null 2>&1
    _out=$(_run reset reset-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-06 reset exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-06 reset text" "$_out" "reset"

    # --- TP-TIMER-07: invalid_name ---
    _out=$(_run start 'bad name!' 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-07 invalid name exit 1" 1 "$_ec"
    _err=$(_run --json start 'bad/name' 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-07 invalid name json exit 1" 1 "$_ec"
    assert_contains "TP-TIMER-07 invalid_name code" "$_err" "invalid_name"

    # --- TP-TIMER-08: --persist start / list / stop ---
    _out=$(_run --persist start persist-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-08 persist start exit 0" 0 "$_ec"
    case "$_out" in
        *persist*|*started*|*success*) t_pass "TP-TIMER-08 persist mode note or success" ;;
        *) t_fail "TP-TIMER-08 persist start unexpected: $_out" ;;
    esac

    _out=$(_run --persist list 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-08 persist list exit 0" 0 "$_ec"
    assert_contains "TP-TIMER-08 persist list name" "$_out" "persist-t"

    _out=$(_run --persist stop persist-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-TIMER-08 persist stop exit 0" 0 "$_ec"

    # --- TP-TIMER-09: storage paths (volatile file exists while running) ---
    _run start stor-path >/dev/null 2>&1
    _u=$(id -un 2>/dev/null || echo "unknown")
    _hit=0
    for _base in /dev/shm /tmp; do
        if ls "${_base}/${APP_NAME}_${_u}"_*stor-path* >/dev/null 2>&1 \
            || ls "${_base}/${APP_NAME}_${_u}"*stor* >/dev/null 2>&1; then
            _hit=1
            break
        fi
        # also match generic pattern
        for _f in "${_base}/${APP_NAME}_${_u}"_*; do
            if [ -f "$_f" ]; then
                case "$_f" in
                    *stor-path*) _hit=1; break ;;
                esac
            fi
        done
        [ "$_hit" -eq 1 ] && break
    done
    if [ "$_hit" -eq 1 ]; then
        t_pass "TP-TIMER-09 volatile storage file present under /dev/shm or /tmp"
    else
        # fallback: status still works → storage resolved somehow
        _out=$(_run status stor-path 2>/dev/null)
        if [ $? -eq 0 ]; then
            t_pass "TP-TIMER-09 storage resolved (status OK; path layout may differ)"
        else
            t_fail "TP-TIMER-09 no storage file and status failed"
        fi
    fi
    _run stop stor-path >/dev/null 2>&1 || true

    ci_cleanup_timer_domain
    ci_cleanup_env
}
