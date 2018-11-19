#!/bin/sh

set -x

DEVICE_TYPE="${1-boron}"

PODIR="${HOME}/.po-util/"

GCC_ARM_VER='gcc-arm-none-eabi-5_3-2016q1'
GCC_ARM_PATH="${PODIR}/bin/gcc-arm-embedded/$GCC_ARM_VER/bin/"
FIRMWARE_PARTICLE="${HOME}/.po-util/src/particle/"

PROJECTDIR="$(pwd)"
APPDIR="${PROJECTDIR}/src"

export PATH="$PATH:$GCC_ARM_PATH"

make all -s -C "$FIRMWARE_PARTICLE/firmware/main" \
  APPDIR="$FIRMWAREDIR" TARGET_DIR="$PROJECTDIR/bin" \
  TARGET_FILE="user_firmware.$DEVICE_TYPE.bin" PLATFORM="$DEVICE_TYPE"
