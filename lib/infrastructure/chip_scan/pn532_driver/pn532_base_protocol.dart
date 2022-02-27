import 'package:terminal_frontend/infrastructure/chip_scan/pn532_driver/pn532_constants.dart';

abstract class PN532BaseProtocol {
  void wakeUp();
  void reset();
  void waitReady({int timeout=pn532StandardTimeout});
  void writeData(List<int> data);
  List<int> readData(int length);
  void dispose();
}