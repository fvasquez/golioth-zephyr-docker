# Docker container for Golioth & Zephyr

Develop Golioth applications with Zephyr on macOS using Docker Desktop. No other tools required besides Docker Desktop and Git! The container has everything needed to fetch and build, while the application source code stays on your host machine.

  * [Build](#build)
  * [Install](#install)
  * [Develop](#develop)

Prebuilt container image releases of this project are available on [Docker Hub](https://hub.docker.com/repository/docker/st8l3ss/zephyr-sdk-x86_64/general).

## Build

To build this project, make sure you have Git and Docker installed on your host machine.

Clone the repo and buikd a release of the container image:

``` shell
git clone https://github.com/beriberikix/golioth-zephyr-docker .
cd golioth-zephyr-docker
docker build --build-arg ARCHITECTURE=x86_64 --build-arg ZEPHYR_SDK_VERSION=0.15.2 -t zephyr-sdk-x86_64:v15.2 .
```

This command builds an x86_64 container image for version 0.15.2 of the Zephyr SDK.

Both build arguments are optional:

* **ARCHITECTURE** - CPU architecture for the Docker container. Not to be confused with the target architecture for Zephyr.
* **ZEPHYR_SDK_VERSION** - SDK version. Must be 0.14.1 or later.

If either build argument is missing from the command line the build defaults to the value defined inside the `Dodkerfile`.

## Install

To fetch and run this project, make sure you have Git and Docker Desktop installed on your host machine.

Before running the container image, create a `projects` directory inside your home directory. This is where you will do all your Zephyr-related work.

Clone the repo and start the `west` service:

``` shell
git clone https://github.com/beriberikix/golioth-zephyr-docker .
cd golioth-zephyr-docker
docker compose up -d
```

After some time, a container named `golioth` should now appear as "Running" in Docker Desktop.

Alternatively, the `west` service can be started from within VS Code as a Dev Container:

1. Launch VS Code.
2. Slect *Open Folder ...* from the *File* menu.
3. Browse for the directory where you cloned this repo and click the *Open* button.
3. Select *Command Palette ...* from the *View* menu.
5. Enter *Dev Containers: Reopen in Container* in the Command Palette.

Once a connection with the Dev Container has been established, you can open a *New Terminal* inside the running container from within VS Code.

## Develop

To open a terminal inside the running container:

```
docker exec -it golioth /bin/bash
```

The `projects` directory you created in your home directory is mounted as `/root` inside the container. This way you can execute Git commands and use VS Code to edit source code on your host machine.

All project builds are done inside the container as `root` using Python virtual environments. To build Golioth's magtag-demo, follow the instructions in the [README](https://github.com/golioth/magtag-demo).

To create a dedicated Python virtual environment for the magtag-demo:

``` bash
cd ~
mkdir magtag-demo
python3 -m venv magtag-demo/.venv
source magtag-demo/.venv/bin/activate
pip install wheel
pip install west
pip install esptool
```

To clone the golioth/magtag-demo repository and install Zephyr along with all necessary modules:

``` bash
cd ~
west init -m https://github.com/golioth/magtag-demo.git magtag-demo
cd magtag-demo
west update
west zephyr-export
pip install -r ~/magtag-demo/deps/zephyr/scripts/requirements.txt
west blobs fetch hal_espressif
```

**Note**: When using a Python virtual environment, remember to re-enable it with each new terminal session:

``` bash
source ~/magtag-demo/.venv/bin/activate
```

Add a `credentials.conf` file and populate the various fields as shown in the [Golioth Developer Training](https://training.golioth.io/docs/golioth-exercises/compile-golioth-demo).

To build the magtag-demo:

``` bash
cd ~/magtag-demo/app
west build -b esp32s2_saola golioth-demo -p
```

Once the build is finished, the binary artifacts can be bundled and saved to the `Downloads` folder on your host machine  like so:

``` bash
cd ~/magtag-demo/app
west kasm download
```

To flash the MagTag with your build bundle, first install `esptool.py` on your host machine:

``` bash
pip3 install esptool
```

Then flash the last build bundle saved to your `Downloads` folder:

``` bash
cd ~/Downloads
esptool.py --chip esp32s2 --port /dev/tty.usbmodem01 write_flash 0x0 merged_<appfolder>_<hhmmss>.bin
```

Replace `<appfolder>` and `<hhmmss>` with the actual values from the most recent magtag-demo build bundle in your `Downloads` folder.

**Note**: The USB-A to Micro USB cable I used to flash my MagTag appeared as `/dev/tty.usbmodem01` on my MacBook Pro. Your cable may be different.
