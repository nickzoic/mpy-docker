#!/bin/bash
set -e

export VAR=$PWD/var
mkdir -p $VAR

FETCH=${1:-esp32}

if [ ! -d $VAR/micropython ]; then
    mkdir $VAR/micropython
    git clone --recursive https://github.com/micropython/micropython-esp32.git -b esp32 $VAR/micropython
fi

if [ ! -d $VAR/esp-idf ]; then
    mkdir $VAR/esp-idf
    git clone --recursive https://github.com/espressif/esp-idf.git $VAR/esp-idf
fi

if [ ! -d $VAR/xtensa-esp32-elf ]; then
    cd $VAR
    curl -L https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz | tar xzf -
fi

echo "FETCHING MICROPYTHON $FETCH"

( cd $VAR/micropython && git fetch -f -u origin $FETCH:$FETCH && git checkout $FETCH )

export MPY_HASH=`git -C $VAR/micropython show -s --pretty=format:'%H'`
export IDF_HASH=`sed -n 's/^ESPIDF_SUPHASH := \([[:xdigit:]]\{20\}\)/\1/p' $VAR/micropython/esp32/Makefile`

echo "FOUND MICROPYTHON $MPY_HASH"
echo "FETCHING ESP-IDF $IDF_HASH"

( cd $VAR/esp-idf && git checkout -q --detach $IDF_HASH && git submodule update --init )

echo "BUILDING DOCKER"

DOCKER_TAG=nickzoic/mpy-esp32/$MPY_HASH

docker build -t $DOCKER_TAG .

docker run --network=none --device=/dev/ttyUSB0 $DOCKER_TAG
