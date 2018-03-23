# leos
A minimal linux distro created for educational purposes

![Screenshot](https://raw.githubusercontent.com/rattrap/leos/master/screenshot.png)

## Building the image

```
docker build -t linux:latest - < Dockerfile
```

## Running the build process

```
docker run -it -v $(pwd):/data linux:latest bash
./build.sh
qemu-system-x86_64 -m 128M -cdrom leos.iso -boot d -vga std
```