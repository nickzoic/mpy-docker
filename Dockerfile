FROM ubuntu:16.10
MAINTAINER nick@zoic.org

RUN apt update && apt upgrade -y && apt install -y git curl make libncurses-dev flex bison gperf python python-serial

RUN useradd -d /var -u 1000 -U bob

COPY var /var
COPY entrypoint.sh /var
RUN chown -R bob /var/micropython /var/esp-idf /var/xtensa-esp32-elf /var/entrypoint.sh

USER bob
CMD /var/entrypoint.sh
