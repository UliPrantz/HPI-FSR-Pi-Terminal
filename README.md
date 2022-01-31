# terminal_frontend

The frontend for wallet backend - FSR-Wallet

## Getting Started

This project is a flutter app.


# Installation on the Raspberry Pi

To install the project on a Raspberry Pi please follow the instructions in the [flutter-pi](https://github.com/ardera/flutter-pi) <br/>
When it comes to Raspberry Pi with touchscreens and raspbian a driver update should be considered (see this [repo](https://github.com/ardera/raspberrypi-fast-ts))

## Build the `flutter bundle` 

`flutter build bundle`


## Get the `engine-binaries` for the Flutter version you are building the bundle with

`git clone --depth 1 https://github.com/ardera/flutter-engine-binaries-for-arm.git engine-binaries`


## Build the app

> Some assumption here: 
> 1. The app dir is called `flutter_terminal`
> 2. The `package_name` in `pubspec.yaml` is `terminal_frontend`
> 3. We are using `flutter-elinux` instead of `flutter` (this isn't mandotory) and it's located in `/opt/flutter-elinux` and the standard flutter sdk path is `/opt/flutter-elinux/flutter/bin` (When used with normal flutter just change the last path to your flutter sdk path)

Also the folder structure look something like this (except the stuff inside the build directory we will generate it in the next steps):
```
engine_binaries/
│ 
├─ arm/
│  │ 
│  ├─ gen_snapshot_linux_x64_release
│ 
├─ install.sh
│ 
flutter_terminal/
│
├─ build/
│  ├─ flutter_assets/
│  │  ├─ app.so
│ 
├─ lib/
│  ├─ main.dart
│ 
├─ README.md
```

### Change into the flutter dir
`cd flutter_terminal`

### Build the flutter app
```
/opt/flutter-elinux/flutter/bin/cache/dart-sdk/bin/dart \
  /opt/flutter-elinux/flutter/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot \
  --sdk-root /opt/flutter-elinux/flutter/bin/cache/artifacts/engine/common/flutter_patched_sdk_product \
  --target=flutter \
  --aot \
  --tfa \
  -Ddart.vm.product=true \
  --packages .packages \
  --output-dill build\kernel_snapshot.dill \
  --verbose \
  --depfile build\kernel_snapshot.d \
  package:terminal_frontend/main.dart
```


## Now we have to switch to a x64 linux machine! (best option is to do all this stuff on a x64 linux machine)

- Execute the following command to generate the final snapshot
- When building for `arm64` add this `--sim-use-hardfp` flag

```
../engine-binaries/arm/gen_snapshot_linux_x64_release \
  --deterministic \
  --snapshot_kind=app-aot-elf \
  --elf=build/flutter_assets/app.so \
  --strip \
  build/kernel_snapshot.dill`
```

## Get the snapshot on the rapsberry pi

- Change `coffee-pi` to `pi@PI-IP`

`rsync -a ./build/flutter_assets/ coffee-pi:/home/pi/flutter_terminal/`
