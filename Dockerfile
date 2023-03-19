FROM debian:stable-slim AS common

RUN \
  apt-get -y update \
  && apt-get -y install --no-install-recommends \
  device-tree-compiler \
  git \
  ninja-build \
  python3 \
  python3-pip \
  python3-venv \
  && pip3 install cmake \
  && apt-get remove -y --purge \
  python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /root/Desktop/Downloads

FROM common AS toolchain

ARG ARCHITECTURE=x86_64
ARG ZEPHYR_SDK_VERSION=0.15.1
ARG ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk

WORKDIR /root

RUN \
  export sdk_file_name="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-$(uname -m)_minimal.tar.gz" \
  && apt-get -y update \
  && apt-get -y install --no-install-recommends \
  file \
  wget \
  xz-utils \
  && wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/${sdk_file_name}" \
  && mkdir -p ${ZEPHYR_SDK_INSTALL_DIR} && \
  tar -xvf ${sdk_file_name} -C ${ZEPHYR_SDK_INSTALL_DIR} --strip-components=1 \
  && ${ZEPHYR_SDK_INSTALL_DIR}/setup.sh -h -c -t arm-zephyr-eabi -t xtensa-espressif_esp32_zephyr-elf -t xtensa-espressif_esp32s2_zephyr-elf \
  && rm ${sdk_file_name} \
  && apt-get remove -y --purge \
  file wget xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
