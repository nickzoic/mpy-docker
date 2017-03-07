FROM ubuntu:16.10
MAINTAINER nick@zoic.org

RUN apt update && apt upgrade -y && apt install -y git curl make libncurses-dev flex bison gperf python python-serial

RUN curl -L https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz | (cd /var && tar xzf -)
RUN git clone --recursive https://github.com/espressif/esp-idf.git /var/esp-idf
RUN git clone --recursive https://github.com/micropython/micropython-esp32.git -b esp32 /var/micropython

COPY entrypoint.sh /var

CMD /var/entrypoint.sh
