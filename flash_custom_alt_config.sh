#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

KEYBOARD="massdrop/alt"
KEYMAP="custom_alt_config"
FIRMWARE_DIR="$SCRIPT_DIR"
BUILD_DIR="$FIRMWARE_DIR/.build"

echo "=== Building $KEYBOARD:$KEYMAP ==="
make -C "$FIRMWARE_DIR" "$KEYBOARD:$KEYMAP"

BIN_FILE=$(ls -t "$BUILD_DIR"/*.bin 2>/dev/null | head -1)
if [ -z "$BIN_FILE" ]; then
    echo "ERROR: No .bin file found in $BUILD_DIR"
    exit 1
fi

echo ""
echo "=== Put your Drop ALT into bootloader mode ==="
echo "Hold the MD_BOOT key (top-right key on function layer, or the physical reset button on the PCB bottom) for 2 seconds."
echo "The LEDS will turn off and the keyboard will be in bootloader mode."
echo ""
read -p "Press Enter when the keyboard is in bootloader mode..."

echo ""
echo "=== Flashing with mdloader ==="
mdloader --first --download "$BIN_FILE" --restart

echo ""
echo "=== Done! ==="