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

6. Enable SPI:
   `Interface Options -> SPI -> Yes`

7. Leave `raspi-config`.

8. Give the `pi` permission to use 3D acceleration - normally this is already done in the script but doing it again does no harm. (**NOTE:** potential security hazard. If you don't want to do this, launch `flutter-pi` using `sudo` instead.)
    ```bash
    sudo usermod -a -G render pi
    ```

8. Finish and reboot: `sudo shutdown -r now`


# Compiling the Flutter App for Raspberry Pi

> **IMPORTANT:** Do all this on a Linux `x86_64` machine which is **not** the Raspberry Pi (since the Pi is `arm`!) <br>
> For performance reason you could also execute every command on any development machine **except for the third step in `Compiling the app`** since the `gen_snapshot_linux_x64_release` executable is only compiled for `x64` as the name says

## Setting up the dependencies

We want create a file structure that looks like the following:
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

1. Install flutter on the system (just follow the instructions [here](https://docs.flutter.dev/get-started/install/linux)) - basically just: `sudo snap install flutter --classic`

2. Now clone the engine binaries: `git clone --depth 1 https://github.com/ardera/flutter-engine-binaries-for-arm.git engine-binaries` <br>
**Important check that the engine binaries version equals the used flutter verion (`flutter --version`)**

3. After that actual clone the project `git clone https://gitlab.hpi.de/fachschaftsrat/wallet/flutter_terminal flutter_terminal`

4. Change into the project with: `cd flutter_terminal`

5. Edit the `env.example.yaml` in a way that it works for you and copy/rename it to `env.yaml` for example with: `mv env.example.yaml env.yaml`

6. Generate all the files that need code generation with: `flutter pub run build_runner build`

7. Build the flutter bundle with: `flutter build bundle`

## Compiling the app

> Now we should have the following setup: 
> 1. The app dir is called `flutter_terminal`
> 2. The engine binaries are in `engine-binaries`
> 3. The `name` in `flutter_terminal/pubspec.yaml` is `terminal_frontend`
> 4. The Flutter SDK should be downloaded and reachable with `flutter sdk-path` **(execute this or any other Flutter command at least once to trigger the SDK download)**

1. If you **aren't already** in the flutter project directory change into it with: `cd flutter_terminal`

2. Execute the following to build the kernel snapshot:
    ```bash
    $(flutter sdk-path)/bin/cache/dart-sdk/bin/dart \
    $(flutter sdk-path)/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot \
    --sdk-root $(flutter sdk-path)/bin/cache/artifacts/engine/common/flutter_patched_sdk_product \
    --target=flutter \
    --aot \
    --tfa \
    -Ddart.vm.product=true \
    --packages .packages \
    --output-dill build/kernel_snapshot.dill \
    --verbose \
    --depfile build/kernel_snapshot.d \
    package:terminal_frontend/main.dart
    ```

3. Build the `app.so` with the `gen_snapshot_linux_x64_release` from the [engine binaries repo](https://github.com/ardera/flutter-engine-binaries-for-arm)
**(When building for `arm64` add the `--sim-use-hardfp` flag)**
    ```bash
    ../engine-binaries/arm/gen_snapshot_linux_x64_release \
    --deterministic \
    --snapshot_kind=app-aot-elf \
    --elf=build/flutter_assets/app.so \
    --strip \
    build/kernel_snapshot.dill
    ```
    **(Be aware that for this step the engine binaries must be located inside the parent directory as shown in the folder structure at the top)**
## Copy the `flutter_assets` (with `app.so` snapshot in it) to the Raspberry Pi

- Copying everything into `~/FsrTerminal` on the Pi by executing `rsync -a ./build/flutter_assets/ pi@raspberrypi.local:~/FsrTerminal/`

# Enabling app start after boot up

## Creating the `systemd` entry

1. Create a new file in `/etc/systemd/system` called `fsr-terminal.service` with `sudo touch /etc/systemd/system/fsr-terminal.service`

2. Past in the following content (with `sudo vim /etc/systemd/system/fsr-terminal.service`):

    ```apache
    [Unit]
    Description=The service starting and controlling the FSR Terminal Flutter App
    After=multi-user.target

    # Getting a little fancy with the restart options here
    # The next 3 options are tightly connected to each other
    # Give up restarting and exec StartLimitAction - if it fails 2 times (=StartLimitBurst) within 60 (=StartLimitIntervalSec) seconds
    StartLimitBurst=2 
    StartLimitIntervalSec=60
    StartLimitAction=reboot-force

    [Service]
    User=pi
    # Sometimes the flutter-pi path must be given in absolute form
    ExecStart=flutter-pi --release %h/FsrTerminal
    ExecStop=/usr/bin/killall flutter-pi

    # Always try to restart
    Restart=always
    # Retry restart after 10s
    RestartSec=10 

    # Useful during debugging; remove it once the service is working
    #StandardOutput=console

    [Install]
    WantedBy=multi-user.target
    ```

3. Reload the service-files though the new service will be found `sudo systemctl daemon-reload` 

4. Enable the service by executing `sudo systemctl enable fsr-terminal`

5. When starting the service with `sudo systemctl start fsr-terminal` the app should start as normal otherwise see the `Troubleshooting` section below

6. After a restart the system should automatically open the FSR Terminal

## Troubleshooting

- Check the output of `systemctl status fsr-terminal`

- Make sure the `~/FsrTerminal` got the `755` permission with `sudo chmod 755 ~/FsrTerminal`

- Sometimes you also have to change the `ExecStart` of the `fsr-terminal.service` file directive so that you use an absolute path for `flutter-pi`

- Debug the serive by uncommenting the last line of the `[Service]` section in the `/etc/systemd/system/fsr-terminal.service` file and start the service with `systemctl start fsr-terminal` (if it's somehow already/still running kill it with `systemctl stop fsr-terminal`)

- Verifying the corectness of the config file with `sudo systemd-analyze verify /etc/systemd/system/fsr-terminal.service`