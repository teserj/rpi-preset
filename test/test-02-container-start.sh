#!/bin/bash
# Verify container starts and shell is accessible

set -u

PASS=0
FAIL=0

echo "=== Test 02: Container Start ==="

# Check 1: docker compose up -d succeeds
echo -n "  "
if docker compose up -d > /dev/null 2>&1; then
    echo "PASS: docker compose up -d"
    ((PASS++))
else
    echo "FAIL: docker compose up -d"
    ((FAIL++))
fi

# Check 2: container is running
echo -n "  "
RUNNING=$(docker inspect -f '{{.State.Running}}' debugbox 2>/dev/null)
if [ "$RUNNING" = "true" ]; then
    echo "PASS: container is running"
    ((PASS++))
else
    echo "FAIL: container is running (got: ${RUNNING:-not found})"
    ((FAIL++))
fi

# Check 3: shell is accessible
echo -n "  "
if docker exec debugbox echo OK > /dev/null 2>&1; then
    echo "PASS: shell access via docker exec"
    ((PASS++))
else
    echo "FAIL: shell access via docker exec"
    ((FAIL++))
fi

# Tear down
docker compose down > /dev/null 2>&1

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
