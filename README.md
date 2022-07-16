# Docker container for Golioth + Zephyr

[![Dev Container](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml)

Develop Golioth applications with Zephyr locally using Docker. No other tools required*!

*_mostly_, depends on OS.

# Important build arguments

* ARCHITECTURE - Architecture for the docker container. Not to be confused with target architecture.
* ZEPHYR_SDK_VERSION - SDK version. Must be 0.14.1 or later.
* ZEPHYR_VERSION - Zephyr version. Can be a tag or branch, including `main`

If some or none of the arguments are missing the build will default to the latest stable version.

# Supported targets

Currently the container includes compilers for the following targets:
* aarch64-zephyr-elf
* arm-zephyr-eabi
* riscv64-zephyr-elf
* x86_64-zephyr-elf
* xtensa-espressif_esp32_zephyr-elf
* xtensa-espressif_esp32s2_zephyr-elf

# Building with Docker CLI

_To build an image for v3.1.0 and Arm Cortex-M targets:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.14.2 --build-arg ZEPHYR_VERSION=v3.1.0 -t golioth-zephyr:v3.1.0 .
```

Use `--build-arg ZEPHYR_VERSION=main` to use upstream Zephyr.