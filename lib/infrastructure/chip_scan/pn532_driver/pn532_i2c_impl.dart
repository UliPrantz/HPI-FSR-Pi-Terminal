import 'package:dart_periphery/dart_periphery.dart';

import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_base_protocol.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_constants.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_exceptions.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/utils.dart';


class PN532I2CImpl extends PN532BaseProtocol {
  final I2C i2c;

  PN532I2CImpl({
    int busNumber = 1,
    int? resetPin,
    int? irqPin,
  }) : i2c = I2C(busNumber),
       super(resetPin: resetPin, irqPin: irqPin);


  @override
  List<int> readData(int length) {
    int readyByte = i2c.readByte(pn532I2CAddress);
    if (readyByte != pn532I2CReady) {
      throw PN532NotReadyException();
    }

    List<int> response = i2c.readBytes(pn532I2CAddress, length + 1);

    // convert the int to a uint8 to get the actual value 
    // (negative values are actually the only problem here)
    response = response.map((integer) => Uint8(integer).value).toList();

    return response.getRange(1, response.length).toList();
  }


  @override
  void reset() {
    // Not working with I2C (at least not with 4 wires)
    throw UnimplementedError();
  }


  @override
  void wakeUp() {
    // Not working with I2C (at least not with 4 wires)
    throw UnimplementedError();
  }


  @override
  void writeData(List<int> data) {
    i2c.writeBytes(pn532I2CAddress, data);
  }

  @override
  bool isReady(int attemptCount) {
    int ready = i2c.readByte(pn532I2CAddress);
    return ready == pn532I2CReady;
  }

  @override
  void dispose() {
    super.dispose();
    i2c.dispose();
  }
}