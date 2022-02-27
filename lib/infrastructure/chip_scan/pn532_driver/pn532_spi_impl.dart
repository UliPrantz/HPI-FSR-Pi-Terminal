import 'dart:io';

import 'package:dart_periphery/dart_periphery.dart';

import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_base_protocol.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_constants.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_exceptions.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/utils.dart';



class PN532SpiImpl extends PN532BaseProtocol {

  final GPIO? resetGpio;
  final GPIO? irqGpio;
  final GPIO? chipSelectGpio;
  
  final SPI spi;

  /// The `irqPin` and the `resetPin` are both optional!
  /// Actually the `irqPin` isn't used at all and the `resetPin` doesn't seem
  /// to work (at least at my board - I always have to power it off once it hangs).
  /// 
  /// The `spiBus` and `spiChip` corresponds to /dev/spidev`[spiBus]`.`[spiChip]`.
  /// 
  /// The connection are the following:
  /// The `SCK/SCLK` of PN532 must be connected to `SCK/SCLK` of the Pi.
  /// The `MOSI` of PN532 must be connected to `MOSI` of the Pi.
  /// The `MISO` of PN532 must be connected to `MISO` of the Pi.
  /// The `SS/NSS` of PN532 must be connected to `CE0` or the one specifed in `chipSelectPin`.
  /// OPTIONAL: The `IRQ` of PN532 should be connected to a `GPIO` pin of your choice (default: 16) of the Pi.
  /// OPTIONAL: The `RSTO` of PN532 should be connected to a `GPIO` pin of your choice (default: 12) of the Pi.
  /// For the `IRQ`, `RSTO` and `chipSelectPin` pin you can choose any 
  /// GPIO pin of the pi just be aware that it seems like that the used dart 
  /// package `dart_periphery` can't open all GPIOs 
  /// (like in my test GPIO09) - then just use a different one.
  PN532SpiImpl({
    int? resetPin,
    int? irqPin,
    int? chipSelectPin,
    int spiBus = 0,
    int spiChip = 0,
  }) : resetGpio = resetPin == null ? null : GPIO(resetPin, GPIOdirection.GPIO_DIR_OUT),
       irqGpio = irqPin == null ? null : GPIO(irqPin, GPIOdirection.GPIO_DIR_IN),
       chipSelectGpio = chipSelectPin == null ? null : GPIO(chipSelectPin, GPIOdirection.GPIO_DIR_IN),
       spi = SPI(spiBus, spiChip, SPImode.MODE0, 500000) 
  {
    reset();
    wakeUp();
  }

  List<int> reverseUint8List(List<int> list) {
    return list.map((integer) => Uint8(integer).reverseByte().value).toList();
  }

  List<int> readWriteHelper(List<int> message) {

    // pull the chipSelect low to start communication
    if (chipSelectGpio != null) {
      chipSelectGpio!.write(false);
      sleep(const Duration(microseconds: 1));
    }

    // reverse bytes (since MSB and LSB differences)
    final List<int> reversedMessage = reverseUint8List(message);

    // transfer the message and read euqally big response
    final List<int> reversedResponse = spi.transfer(reversedMessage, false);

    // get the actual response data
    final List<int> response = reverseUint8List(reversedResponse);

    // pull the chipSelect high to stop communicaiton
    if (chipSelectGpio != null) {
      chipSelectGpio!.write(true);
      sleep(const Duration(microseconds: 1));
    }

    return response;
  }


  @override
  List<int> readData(int length) {
    // generate a list of length + 1 and the first element is 
    // `pn532SpiDataRead` and the rest is filled with zeros
    final List<int> frame = [pn532SpiDataRead, ...List.filled(length, 0)];

    sleep(const Duration(milliseconds: 5));

    // transfer the list and read into it at the same time
    final List<int> response = readWriteHelper(frame);

    // get the response of the frame (without the added first byte) and return it
    return response.sublist(1);
  }


  @override
  void reset() {
    resetGpio?.write(true);
    sleep(const Duration(milliseconds: 100));
    resetGpio?.write(false);
    sleep(const Duration(milliseconds: 500));
    resetGpio?.write(true);
    sleep(const Duration(milliseconds: 100));
  }


  @override
  void waitReady({int timeout = pn532StandardTimeout}) {
    final int timeStart = DateTime.now().millisecondsSinceEpoch;
    sleep(const Duration(milliseconds: 10));

    List<int> statusRequest = [pn532SpiStartRead, 0x00];
    statusRequest = readWriteHelper(statusRequest);
    
    while (statusRequest[1] != pn532SpiReady) {
      // this sleep is extremly important!
      // without you read the pn532 to often which curses to many interrupts
      // on the pn532 board which results in to little execution time for the
      // actual command/firmware on the pn532 which ends up in only getting
      // PN532TimeoutException because the pn532 can't process the actual command
      // (this can be avoided by only using the IRQ pin!)
      sleep(const Duration(milliseconds: 20));
      statusRequest = readWriteHelper(statusRequest);

      final int timeDelta = DateTime.now().millisecondsSinceEpoch - timeStart;
      if (timeDelta >= timeout) {
        throw PN532TimeoutExcepiton(timeout: timeout);
      }
    }
  }

  @override
  void wakeUp() {
    // Send any special commands/data to wake up PN532

    if (chipSelectGpio != null) {
      sleep(const Duration(milliseconds: 1000));
      chipSelectGpio!.write(false);
      sleep(const Duration(milliseconds: 2));// T_osc_start
    }

    List<int> data = [0x00];
    readWriteHelper(data);
    sleep(const Duration(milliseconds: 1000));
  }


  @override
  void writeData(List<int> data) {
    // generate a list of length + 1 and the first element is 
    // `pn532SpiDataRead` and the rest is filled with zeros
    final List<int> frame = [pn532SpiDataWrite, ...data];
    readWriteHelper(frame);
  }

  @override
  void dispose() {
    resetGpio?.dispose();
    irqGpio?.dispose();
    chipSelectGpio?.dispose();
    spi.dispose();
  }
}