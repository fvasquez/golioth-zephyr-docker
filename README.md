# Docker container for Golioth + Zephyr

[![Dev Container](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml)

Develop Golioth applications with Zephyr locally using Docker. No other tools required*! The container includes all the tools needed to fetch, build and flash, while the application source code stays on the local machine.

*_mostly_, depends on OS.

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
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.14.2 --build-arg ZEPHYR_VERSION=v3.1.0 -t golioth-zephyr:v3.1.0_0.14.2 .
```

## Important build arguments

* ARCHITECTURE - Architecture for the docker container. Not to be confused with target architecture.
* ZEPHYR_SDK_VERSION - SDK version. Must be 0.14.1 or later.
* ZEPHYR_VERSION - Zephyr version. Can be a tag or branch, including `main`

If some or none of the arguments are missing the build will default to the latest stable version.

```
docker build -t golioth-zephyr:latest .
```

# Develop with Docker

## Using local image

It's recommended that to build Docker images locally.

```
git clone https://github.com/beriberikix/golioth-zephyr-docker
cd golioth-zephyr-docker
docker build -t golioth-zephyr:latest .
```

This container is optimized for developing standalone applications. We'll use https://github.com/beriberikix/golioth-zephyr-hello as an example, but it should work with your own applications.

```
mkdir build-with-docker && cd build-with-docker
docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest init -m https://github.com/beriberikix/golioth-zephyr-hello
docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest update
```

You can also create an alias to reduce typing.

```
alias west="docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest"
west update
```

Now build the sample.

```
west build -b esp32 app -p
```

## Using pre-built image

TODO