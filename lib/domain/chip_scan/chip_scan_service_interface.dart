import 'package:fpdart/fpdart.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';

abstract class ChipScanServiceInterface {
  Future<void> startIsolate();
  Future<Stream<ChipScanData>> getUidStream();
  Either<RfidFailure, Unit> pauseReadingFunction();
  Either<RfidFailure, Unit> startReadingFunction();
  void stopIsolate();
}