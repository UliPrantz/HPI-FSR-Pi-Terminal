# Compiling the C driver for the PN532

## TODO

If somebody wants to write a Makefile or even better a CMakefile that would be great :)

## Compiling

1. Copy this `src` (`assets/rfid_lib/src`) directory to an Raspberry Pi
2. Install `pigpio` c library (if not already installed)
3. Navigate into the in (1.) copied `src` directory
4. Compile the .so library with: `gcc pn532.c pn532_rpi.c rfid_reader.c -I. -lpigpio -shared -o rfid_lib.so`
5. Copy the just created `rfid_lib.so` back to `assets/rfid_lib`