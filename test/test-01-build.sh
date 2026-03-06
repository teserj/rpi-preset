#!/bin/bash
# Verify docker compose build succeeds and image exists

set -u

PASS=0
FAIL=0

echo "=== Test 01: Docker Build ==="

# Check 1: docker compose build succeeds
echo -n "  "
if docker compose build > /dev/null 2>&1; then
    echo "PASS: docker compose build"
    ((PASS++))
else
    echo "FAIL: docker compose build"
    ((FAIL++))
fi

# Check 2: rpi-debugbox:latest image exists
echo -n "  "
if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q '^rpi-debugbox:latest$'; then
    echo "PASS: rpi-debugbox:latest image exists"
    ((PASS++))
else
    echo "FAIL: rpi-debugbox:latest image exists"
    ((FAIL++))
fi

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
