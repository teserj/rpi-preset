# RPi Embedded Debugging Toolbox - Test Suite

## Purpose

This test suite validates that the `rpi-debugbox` Docker container builds
correctly and that all expected tools are installed and functional.

| Script | Description |
|---|---|
| `test-01-build.sh` | Verifies `docker compose build` succeeds and the `rpi-debugbox:latest` image exists |
| `test-02-container-start.sh` | Verifies the container starts and a shell is accessible |
| `test-03-general-utils.sh` | Checks that general utility tools (ripgrep, git, python3, tmux, etc.) are installed |
| `test-04-embedded-tools.sh` | Checks that embedded debugging tools (openocd, gdb-multiarch, minicom, etc.) are installed |
| `test-05-network-tools.sh` | Checks that network tools (tshark, nmap, tcpdump, etc.) are installed |
| `test-06-user-script.sh` | Verifies the build-time user-script extensibility hook works end to end |

## Prerequisites

- Docker and Docker Compose are installed
- Run all commands from the **project root** (`rpi-docker/`)
- Tests 03-05 assume the container `debugbox` is already running (the runner handles this automatically)
- Tests 01, 02, and 06 manage their own container lifecycle

## How to Run

Run the full suite:

```bash
./test/run-all.sh
```

Or run an individual test:

```bash
./test/test-03-general-utils.sh
```

## Expected Output

Each test prints one line per check in the format:

```
  PASS: <tool or check name>
  FAIL: <tool or check name>
```

At the end of each script a summary count is printed. The runner (`run-all.sh`)
prints a final summary table and exits non-zero if any test failed.
