#!/bin/bash
set -e

export MPY_DIR=/var/micropython
export ESPIDF=/var/esp-idf
export PATH=/var/xtensa-esp32-elf/bin:$PATH

cd $MPY_DIR
git pull --ff-only

if [ -n "$FETCH" ]; then
    git fetch origin $FETCH:$FETCH
    git checkout $FETCH
fi

git submodule update --init
export MPY_HASH=`git -C $MPY_DIR show -s --pretty=format:'%H'`
export IDF_HASH=`sed -n 's/^ESPIDF_SUPHASH := \([[:xdigit:]]\{20\}\)/\1/p' $MPY_DIR/esp32/Makefile`
echo ">>> FOUND MICROPYTHON $MPY_HASH"

cd $ESPIDF
echo ">>> CHECKOUT ESP-IDF $IDF_HASH"
git fetch -a
git checkout -q --detach $IDF_HASH
git submodule update --init

cd $MPY_DIR
make -j4 -C mpy-cross
make -j4 -C esp32

export FLASH_MODE=dio
export PORT=/dev/ttyUSB0

make -C esp32 deploy
