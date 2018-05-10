A copy of the binaries can be found in the [armv6-rpi-linux-gnueabihf](https://github.com/manhluong/build_cross_toolchain_raspberry/tree/master/armv6-rpi-linux-gnueabihf/bin) folder.

## How to run

Simply build the docker image:

```
docker build .
```

The process uses [Crosstool-NG](https://crosstool-ng.github.io/) to build the toolchain.

```
Building a toolchain for:
   build  = x86_64-pc-linux-gnu
   host   = x86_64-pc-linux-gnu
   target = armv6-rpi-linux-gnueabihf
```

Base configuration is `armv6-rpi-linux-gnueabi` with `hf`, hard float.

## How to retrieve the output

At the end the image will have a zip file: `/armv6-rpi-linux-gnueabihf.zip`.

To copy, create a container from the image and run cp:
```
docker images
docker create IMAGE_ID
docker cp CONTAINER_ID:/armv6-rpi-linux-gnueabihf.zip .

```

