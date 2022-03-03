# Setting up the Raspberry Pi 

## WiFi
### Corporate wifi setup for `eduroam` (802.1X Standard)
1. First setup the `wpa_supplicant.conf` which is located in `/etc/wpa_supplicant` (full path is `/etc/wpa_supplicant/wpa_supplicant.conf`)<br>
    Past the following content into the file:
    ```
    network={
        ssid="eduroam"
        password="[PLAIN-TEXT-PASSWORD-UNI-POTSDAM]"
        identity="[SHORT-VERSION-USERNAME(UNI-POTSDAM-LOGIN)]@uni-potsdam.de"
        anonymous_identity="eduroam@uni-potsdam.de"
        key_mgmt=WPA-EAP
        eap=PEAP
        phase2="auth=MSCHAPV2"
    }
    ```
    **Replace the [...] with your Username and Password!**

2. Reboot the pi

### Troubleshooting
1. Sometimes you may also have to edit `/etc/network/interfaces` and add the following lines:
    ```bash
    allow-hotplug wlan0
    iface wlan0 inet manual
        wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
    iface wlan0 inet dhcp
    ```
2.  - First kill all the `wpa_supplicant` services and bring down all the ethernet devices with the following commands:
        ```bash
        ifdown wlan0
        ifdown wlan0
        killall wpa_supplicant
        ```
    - You can now debug the newly made configuraiton with `sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf`. (Optionally you can add -B for deamon mode or -d for debug infos (-dd even more debug infos))
3. Extra infos on this [website](https://inrg.soe.ucsc.edu/howto-connect-raspberry-to-eduroam/)


# Setting up `flutter-pi`

## Fast installation of `flutter-pi`

Detail instructions can be found [here](https://github.com/ardera/flutter-pi).

1. Just copy and past the following script which is based on the official instructions (script last updated: 03.03.2022)

    ```bash
    #!/bin/bash

    # Update the pi
    echo "Updating Pi"
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt dist-upgrade -y


    # Install the engine binaries from `https://github.com/ardera/flutter-engine-binaries-for-arm`
    echo "Installing newest flutter engine binaries from 'https://github.com/ardera/flutter-engine-binaries-for-arm'"
    git clone --depth 1 https://github.com/ardera/flutter-engine-binaries-for-arm.git engine-binaries
    cd engine-binaries
    sudo ./install.sh
    cd ..


    # Install flutter-pi from source from `https://github.com/ardera/flutter-pi`
    echo "Installing flutter-pi"
    sudo apt install -y git vim cmake libgl1-mesa-dev \
    libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev \
    ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev \
    libudev-dev libxkbcommon-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad gstreamer1.0-libav

    sudo fc-cache

    git clone https://github.com/ardera/flutter-pi
    cd flutter-pi

    mkdir build
    cd build
    cmake ..
    make -j`nproc`
    sudo make install

    cd ../..
    sudo usermod -a -G render pi


    # Some Information for the user
    echo ""
    echo ""
    echo "After script termination open 'sudo raspi-config' and set Autologin Shell, SPI enabled and GPU Memory 64"
    echo "Than you can start deploying the flutter app stated in 'https://github.com/ardera/flutter-pi'"
    echo "You have to start at 'Building the asset bundle'"
    ```

2. Open raspi-config:
    ```bash
    sudo raspi-config
    ```
    
3. Switch to console mode:
   `System Options -> Boot / Auto Login` and select `Console (Autologin)`.

4. **Raspbian buster only, skip this if you're on bullseye (or newer - which is normally the case)**  
    Enable the V3D graphics driver:  
   `Advanced Options -> GL Driver -> GL (Fake KMS)`

5. Configure the GPU memory
   `Performance Options -> GPU Memory` and enter `64`.

6. Leave `raspi-config`.

7. Give the `pi` permission to use 3D acceleration. (**NOTE:** potential security hazard. If you don't want to do this, launch `flutter-pi` using `sudo` instead.)
    ```bash
    usermod -a -G render pi
    ```

8. Finish and reboot.


# Compiling the Flutter App for Raspberry Pi   ====== TODO

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

`rsync -a ./build/flutter_assets/ pi@raspberrypi.local:~/FsrTerminal`


# End TODO ============================

# Enabling app start after boot up

## Creating the `systemd` entry

1. Create a new file in `/etc/systemd` called `fsr-terminal.service` with `touch /etc/systemd/fsr-terminal.service`

2. Past in the following content:

    ```apache
    [Unit]
    Description=The service starting and controlling the FSR Terminal Flutter App
    After=multi-user.target

    [Service]
    User=pi
    ExecStart=flutter-pi --release ~/FsrTerminal
    ExecStop=/usr/bin/killall flutter-pi

    # Getting a little fancy with the restart rules
    Restart=always  

    # The next 3 options are tightly connected to each other
    # Give up restarting and exec StartLimitAction - if it fails 2 times (=StartLimitBurst) within 30 (=StartLimitIntervalSec) seconds
    StartLimitBurst=2 
    StartLimitIntervalSec=30
    # wait 10 second2 between restart
    RestartSec=10                 
    StartLimitAction=sudo reboot

    # Useful during debugging; remove it once the service is working
    #StandardOutput=console

    [Install]
    WantedBy=multi-user.target
    ```

3. Enable the service by executing `systemctl enable fsr-terminal`
4. After a restart the system should automatically open the FSR Terminal

## Troubleshooting

- Check the output of `systemctl status fsr-terminal`
- Debug the serive by uncommenting the last line of the `[Service]` section in the `/etc/systemd/fsr-terminal.service` file and start the service with `systemctl start fsr-terminal` (if it's somehow already/still running kill it with `systemctl stop fsr-terminal`)