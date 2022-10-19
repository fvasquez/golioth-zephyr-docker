# Docker container for Golioth + Zephyr

[![Dev Container](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/beriberikix/golioth-zephyr-docker/actions/workflows/docker-publish.yml)

Develop Golioth applications with Zephyr locally using Docker. No other tools required* besides `docker` & `git`! The container includes all the tools needed to fetch, build and flash, while the application source code stays on the local machine.

*_mostly_, depends on OS.

# Supported targets

Currently the container includes compilers for the following targets:
* arm-zephyr-eabi
* xtensa-espressif_esp32_zephyr-elf
* xtensa-espressif_esp32s2_zephyr-elf

# Building with Docker CLI

_To build an image for v3.2.0 and Arm Cortex-M targets:_

```
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.15.1 --build-arg ZEPHYR_VERSION=v3.2.0 -t golioth-zephyr:v3.2.0_0.15.1SDK .
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
docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest west init -m https://github.com/beriberikix/golioth-zephyr-hello
docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest west update
```

You can also create an alias to reduce typing.

```
alias west="docker run --rm -v ${PWD}:/workdir golioth-zephyr:latest west"
west update
```

Now build the sample.

```
west build -b esp32 app -p
```

## Using pre-built image

Fetch the latest pre-built image.

```
docker pull ghcr.io/beriberikix/golioth-zephyr:v3.2.0-0.15.1sdk
```

Alias `west` to reduce typing.

```
alias west="docker run --rm -v ${PWD}:/workdir -w /workdir ghcr.io/beriberikix/golioth-zephyr:v3.2.0-0.15.1sdk west"
```

Create a local working directory and initialize a Zephyr workspace with Golioth.

```
mkdir build-with-docker && cd build-with-docker
west init -m https://github.com/golioth/golioth-zephyr-sdk.git --mf west-zephyr.yml
west update
```

Build the Golioth `hello` sample.

```
cd modules/lib/golioth/
west build -b esp32 samples/hello -p
```
