#!/bin/bash
set -e

echo "=============================================="
echo "  RPi Embedded Debugging Toolbox  v1.0"
echo "=============================================="
echo ""
echo "--- Tool Versions ---"
echo "  gdb-multiarch : $(gdb-multiarch --version 2>/dev/null | head -1 || echo 'not found')"
# openocd prints version info to stderr, so redirect stderr to stdout with 2>&1
echo "  openocd       : $(openocd --version 2>&1 | head -1 || echo 'not found')"
echo "  sigrok-cli    : $(sigrok-cli --version 2>/dev/null | head -1 || echo 'not found')"
echo "  tshark        : $(tshark --version 2>/dev/null | head -1 || echo 'not found')"
echo "  termshark     : $(termshark --version 2>/dev/null | head -1 || echo 'not found')"
echo "  nmap          : $(nmap --version 2>/dev/null | head -1 || echo 'not found')"
echo ""
echo "--- USB Devices ---"
lsusb 2>/dev/null || true
echo ""
echo "--- Serial Ports ---"
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || echo "  No serial ports detected"
echo ""
echo "=============================================="
echo ""

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/bash
fi
