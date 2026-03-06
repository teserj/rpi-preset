# RPi Embedded Debugging Toolbox

A Docker container for headless Raspberry Pi 4+ that provides a comprehensive
embedded systems debugging environment. It targets ARM32, AArch64, and RISC-V
devices, running on Ubuntu 24.04 in privileged mode with host networking and
full `/dev` access.

## Tool List

### General Utilities

| Tool | Command | Description |
|------|---------|-------------|
| fd-find | `fdfind` | Fast file finder |
| ripgrep | `rg` | Fast recursive grep |
| git | `git` | Version control |
| ssh | `ssh` | Secure shell client |
| openssl | `openssl` | TLS/SSL toolkit |
| vim | `vim` | Text editor |
| tree | `tree` | Directory tree listing |
| python3 | `python3` | Python interpreter |
| pip3 | `pip3` | Python package manager |
| xxd | `xxd` | Hex dump / reverse hex dump |
| tmux | `tmux` | Terminal multiplexer |
| jq | `jq` | JSON processor |
| curl | `curl` | URL transfer tool |
| wget | `wget` | File downloader |
| file | `file` | File type identifier |
| strace | `strace` | System call tracer |
| ltrace | `ltrace` | Library call tracer |
| telnet | `telnet` | Telnet client |
| visidata | `vd` | Terminal data explorer |

### Embedded Device Debugging

| Tool | Command | Description |
|------|---------|-------------|
| minicom | `minicom` | Serial terminal emulator |
| picocom | `picocom` | Minimal serial terminal |
| screen | `screen` | Terminal multiplexer / serial console |
| lrzsz | `sz` / `rz` | XMODEM/YMODEM/ZMODEM file transfer |
| openocd | `openocd` | On-chip debugger (JTAG/SWD) |
| gdb-multiarch | `gdb-multiarch` | Multi-architecture GDB |
| binutils-multiarch | `objdump`, `readelf`, etc. | Cross-architecture binary utilities |
| i2c-tools | `i2cdetect`, `i2cget`, `i2cset` | I2C bus inspection |
| spi-tools | `spi-pipe`, `spi-config` | SPI bus utilities |
| can-utils | `candump`, `cansend` | CAN bus utilities |
| usbutils | `lsusb` | USB device listing |
| sigrok-cli | `sigrok-cli` | Logic analyzer / protocol decoder CLI |

### Network Tools

| Tool | Command | Description |
|------|---------|-------------|
| tshark | `tshark` | CLI packet analyzer (Wireshark engine) |
| termshark | `termshark` | TUI packet analyzer |
| nmap | `nmap` | Network scanner |
| tcpdump | `tcpdump` | Packet capture |
| iperf3 | `iperf3` | Network bandwidth tester |
| socat | `socat` | Multipurpose relay / socket tool |
| netcat | `nc` | TCP/UDP connection tool |
| mosquitto-clients | `mosquitto_pub`, `mosquitto_sub` | MQTT client tools |
| aircrack-ng | `aircrack-ng`, `airmon-ng` | WiFi security auditing |
| iw | `iw` | Wireless device configuration |
| wireless-tools | `iwconfig`, `iwlist` | Legacy wireless utilities |

## Quick Start

```bash
git clone <repo> && cd rpi-docker
docker compose build
docker compose up -d
docker exec -it debugbox bash
```

## Building with a Custom Toolchain

The `USER_SETUP_SCRIPT` build argument lets you run a custom shell script
during the Docker build to install additional toolchains or packages.

1. Place your script in the `user-scripts/` directory.
2. Build the container with the script name:

```bash
docker compose build --build-arg USER_SETUP_SCRIPT=my-script.sh
```

Or set it in `docker-compose.yml`:

```yaml
services:
  debugbox:
    build:
      args:
        USER_SETUP_SCRIPT: "my-script.sh"
```

See `user-scripts/example-riscv-toolchain.sh` for a working example that
installs a RISC-V cross-compiler.

## WiFi Monitor Mode Prerequisites

Monitor mode requires the following on the **host** Raspberry Pi (outside the
container):

- **External USB WiFi adapter** with monitor mode support (e.g., Atheros AR9271,
  Ralink RT5370).
- **Host kernel driver** for the adapter must be loaded. Verify with
  `lsusb` and `dmesg` on the host.
- The container already runs with `--privileged` and `network_mode: host`, which
  gives it access to host network interfaces.

To enable monitor mode inside the container:

```bash
airmon-ng check kill
airmon-ng start wlan1
```

Replace `wlan1` with the name of your external WiFi interface.

## Common Usage Examples

**Serial console:**

```bash
minicom -D /dev/ttyUSB0 -b 115200
```

**JTAG debugging with OpenOCD:**

```bash
openocd -f interface/ftdi/olimex-arm-usb-ocd-h.cfg -f target/stm32f4x.cfg
```

**GDB multi-arch session:**

```bash
gdb-multiarch -ex "target remote :3333" firmware.elf
```

**Packet capture:**

```bash
tshark -i eth0 -f "port 1883"
termshark -i eth0
```

**I2C bus scan:**

```bash
i2cdetect -y 1
```

**Logic analyzer capture:**

```bash
sigrok-cli --driver=fx2lafw --config samplerate=1m --samples 1000
```

## Running Tests

The project includes a test suite that validates the container build and verifies
that all tools are installed. See `test/README.md` for details.

```bash
./test/run-all.sh
```
