#!/bin/bash
# Run all tests in sequence, report summary

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOTAL_PASS=0
TOTAL_FAIL=0
RESULTS=()

run_test() {
    local script="$1"
    local label
    label="$(basename "$script")"

    echo ""
    echo "----------------------------------------------"
    bash "$script"
    local rc=$?

    if [ "$rc" -eq 0 ]; then
        RESULTS+=("PASS  $label")
        ((TOTAL_PASS++))
    else
        RESULTS+=("FAIL  $label")
        ((TOTAL_FAIL++))
    fi
}

echo "=============================================="
echo "  RPi Debugbox - Test Suite"
echo "=============================================="

# --- Phase 1: Build ---
run_test "$SCRIPT_DIR/test-01-build.sh"

# --- Phase 2: Container start (does its own up/down) ---
run_test "$SCRIPT_DIR/test-02-container-start.sh"

# --- Phase 3: Tool verification (needs running container) ---
echo ""
echo "----------------------------------------------"
echo "Starting container for tool-check tests..."
if ! docker compose up -d > /dev/null 2>&1; then
    echo "FATAL: docker compose up -d failed. Cannot run tool tests."
    exit 1
fi
for i in $(seq 1 30); do docker exec debugbox true 2>/dev/null && break; sleep 1; done

run_test "$SCRIPT_DIR/test-03-general-utils.sh"
run_test "$SCRIPT_DIR/test-04-embedded-tools.sh"
run_test "$SCRIPT_DIR/test-05-network-tools.sh"

echo ""
echo "----------------------------------------------"
echo "Stopping container..."
docker compose down > /dev/null 2>&1

# --- Phase 4: User script hook (does its own build/up/down) ---
run_test "$SCRIPT_DIR/test-06-user-script.sh"

# --- Summary ---
echo ""
echo "=============================================="
echo "  Summary"
echo "=============================================="
for r in "${RESULTS[@]}"; do
    echo "  $r"
done
echo ""
echo "  Total: $((TOTAL_PASS + TOTAL_FAIL)) tests, $TOTAL_PASS passed, $TOTAL_FAIL failed"
echo "=============================================="

if [ "$TOTAL_FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
