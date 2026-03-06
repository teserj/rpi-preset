#!/bin/bash
# Verify build-time extensibility hook works

set -u

PASS=0
FAIL=0

echo "=== Test 06: User Script Hook ==="

# Create a temp user script that writes a marker file
mkdir -p user-scripts
cat > user-scripts/test-hook.sh <<'HOOK'
#!/bin/bash
touch /tmp/hook-test-marker
HOOK

# Rebuild with the user setup script
echo -n "  "
if docker compose build --build-arg USER_SETUP_SCRIPT=test-hook.sh > /dev/null 2>&1; then
    echo "PASS: rebuild with user script"
    ((PASS++))
else
    echo "FAIL: rebuild with user script"
    ((FAIL++))
fi

# Start container
docker compose up -d > /dev/null 2>&1

# Allow a moment for the container to be ready
sleep 2

# Check marker file exists
echo -n "  "
if docker exec debugbox test -f /tmp/hook-test-marker; then
    echo "PASS: marker file created by user script"
    ((PASS++))
else
    echo "FAIL: marker file created by user script"
    ((FAIL++))
fi

# Tear down
docker compose down > /dev/null 2>&1

# Clean up the test hook script
rm -f user-scripts/test-hook.sh

# Rebuild without user script to restore clean image
docker compose build > /dev/null 2>&1

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
