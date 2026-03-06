#!/bin/bash
# Verify general utility tools are installed
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

echo "=== Test 03: General Utilities ==="

check_tool "fdfind"      fdfind --version
check_tool "ripgrep"     rg --version
check_tool "git"         git --version
check_tool "ssh"         ssh -V
check_tool "openssl"     openssl version
check_tool "vim"         vim --version
check_tool "tree"        tree --version
check_tool "python3"     python3 --version
check_tool "pip3"        pip3 --version
check_tool "xxd"         which xxd
check_tool "tmux"        tmux -V
check_tool "jq"          jq --version
check_tool "curl"        curl --version
check_tool "wget"        wget --version
check_tool "file"        file --version
check_tool "strace"      strace -V
check_tool "ltrace"      ltrace --version
check_tool "visidata"    vd --version

echo ""
echo "  Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
