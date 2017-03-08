#!/bin/bash
set -e

export ESPIDF=/var/esp-idf
export PATH=/var/xtensa-esp32-elf/bin:$PATH

cd /var/micropython

make -j4 -C mpy-cross
make -j4 -C esp32

export FLASH_MODE=dio
export PORT=/dev/ttyUSB0

make -C esp32 deploy
