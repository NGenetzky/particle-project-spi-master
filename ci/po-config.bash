#!/bin/bash

BASE_DIR="${HOME}/.po-util/src"
PARTICLE_FIRMWARE_URL='https://github.com/particle-iot/firmware.git'
FIRMWARE_PARTICLE="${HOME}/.po-util/src/particle"
FIRMWARE_DUO="${HOME}/.po-util/src/redbearduo"
FIRMWARE_PI="${HOME}/.po-util/src/pi"
export PARTICLE_DEVELOP=1
# BRANCH=release/stable
BRANCH='v0.8.0-rc.25-mesh'
BRANCH_DUO='duo'
AUTO_HEADER=false

_is_po_supported_device(){
  local device
  device="${1?}"
  case $device in
    core|photon|P1|electron \
    |duo|pi \
    |boron|xenon|argon \
      )
      return 0
    ;;
    *) return 1
    ;;
  esac
}

# This overides the function in "/usr/local/po-common" "line 182"
validateDevicePlatform()
{
  # Make sure we are using photon, P1, electron, pi, core, or duo
    # if [ "$1" == "photon" ] || [ "$1" == "P1" ] || [ "$1" == "electron" ] || [ "$1" == "pi" ] || [ "$1" == "core" ] || [ "$1" == "duo" ]; then
    if _is_po_supported_device ${1?}; then
        DEVICE_TYPE="$1"

        if [ "$DEVICE_TYPE" == "duo" ]; then
            cd "$FIRMWARE_DUO/firmware" || exit
            switch_branch "$BRANCH_DUO" &> /dev/null

        elif [ "$DEVICE_TYPE" == "pi" ]; then
            cd "$FIRMWARE_PI/firmware" || exit
            switch_branch "feature/raspberry-pi"  &> /dev/null

        else
            cd "$FIRMWARE_PARTICLE/firmware" || exit
            switch_branch &> /dev/null
        fi

    else
        echo
        if [ "$1" == "redbear" ] || [ "$1" == "bluz" ] || [ "$1" == "oak" ]; then
            red_echo "This compound is not supported yet. Find out more here: https://git.io/vMTAw"
            echo
        fi
        red_echo "Plz choose \"photon\", \"P1\", \"electron\", \"core\", \"pi\", or \"duo\",
    or choose a proper command."
        common_commands
        exit 1
    fi

    if [ "$DEVICE_TYPE" == "photon" ]; then
        DFU_ADDRESS1="2b04:d006"
        DFU_ADDRESS2="0x080A0000"
    fi
    if [ "$DEVICE_TYPE" == "P1" ]; then
        DFU_ADDRESS1="2b04:d008"
        DFU_ADDRESS2="0x080A0000"
    fi
    if [ "$DEVICE_TYPE" == "electron" ]; then
        DFU_ADDRESS1="2b04:d00a"
        DFU_ADDRESS2="0x08080000"
    fi
    if [ "$DEVICE_TYPE" == "core" ]; then
        DFU_ADDRESS1="1d50:607f"
        DFU_ADDRESS2="0x08005000"
    fi
    if [ "$DEVICE_TYPE" == "duo" ]; then
        DFU_ADDRESS1="2b04:d058"
        DFU_ADDRESS2="0x80C0000"
    fi
}
