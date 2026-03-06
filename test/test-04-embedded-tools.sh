#!/bin/bash
# Verify embedded debugging tools are installed
# Requires: container 'debugbox' is running

set -u

PASS=0
FAIL=0

check_tool() {
    local name="$1"
    shift
    if docker exec debugbox "$@" > /dev/null 2>&1; then
        echo "  PASS: $name"
        ((PASS++))
        return 0
    else
        echo "  FAIL: $name"
        ((FAIL++))
        return 1
    fi
}

echo "=== Test 04: Embedded Debugging Tools ==="

check_tool "minicom"       minicom --version
check_tool "picocom"       which picocom
check_tool "openocd"       which openocd
check_tool "gdb-multiarch" gdb-multiarch --version
check_tool "sigrok-cli"    sigrok-cli --version
check_tool "i2cdetect"     i2cdetect -V
check_tool "lsusb"         lsusb --version
check_tool "sz (lrzsz)"   which sz
check_tool "rz (lrzsz)"   which rz

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
