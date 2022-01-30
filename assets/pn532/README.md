# Compiling the C driver for the PN532

## Compiling

1. Copy this whole directory `pn532` (`assets/rfid_lib/pn532`) directory to an Raspberry Pi
2. Install `pigpio` c library (if not already installed)
3. Build everything by calling `make`
5. Copy the just created `build/rfid_lib.so` back to `assets/rfid_lib`