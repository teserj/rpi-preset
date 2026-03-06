#!/bin/bash
# Verify network tools are installed
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

echo "=== Test 05: Network Tools ==="

check_tool "tshark"         tshark --version
check_tool "termshark"      termshark --version
check_tool "nmap"           nmap --version
check_tool "tcpdump"        tcpdump --version
check_tool "netcat"         which nc
check_tool "iperf3"         iperf3 --version
check_tool "socat"          socat -V
check_tool "mosquitto_pub"  mosquitto_pub --help
check_tool "iw"             iw --version

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
