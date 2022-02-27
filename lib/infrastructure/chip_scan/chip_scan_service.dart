import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:fpdart/fpdart.dart';
import 'package:stream_channel/isolate_channel.dart';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/rfid_reader.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/isolate_command.dart';


class ChipScanService extends ChipScanServiceInterface {
  static const Duration pauseBetweenScan = Duration(seconds: 1);

  final String rfidDyLibPath;

  bool _started = false;
  bool _stopped = false;

  Isolate? _rfidReaderIsolate;
  IsolateChannel? _rootIsolateChannel;

  Stream<ChipScanData>? _uidBroadcastStream;

  ChipScanService({required this.rfidDyLibPath});

  @override
  Future<void> startIsolate() async {
    ReceivePort receivePort = ReceivePort();
    _rootIsolateChannel = IsolateChannel.connectReceive(receivePort);
    _rfidReaderIsolate = await Isolate.spawn(_uidIsolate, receivePort.sendPort);
    _uidBroadcastStream = _rootIsolateChannel!.stream.cast<ChipScanData>().asBroadcastStream();
    
    // send the dyLibPath to the isolate as first event
    _rootIsolateChannel!.sink.add(
      IsolateCommand(
        type: IsolateCommandType.pathInformation,
        dyLibPath: rfidDyLibPath,
      )
    );

    _started = true;
  }

  /// Provides the [ChipScanData] Stream. Keep in mind that when you actually 
  /// want to receive events you have to call [startReadingFunction] after the 
  /// future of [getUidStream] finishes!
  @override
  Future<Stream<ChipScanData>> getUidStream() async {
    if (!_started) {
      await startIsolate();
    }

    return _uidBroadcastStream!;
  }

  static void _uidIsolate(SendPort sendPort) {
    late final RfidReader rfidReader;
    final IsolateChannel isolateChannel = IsolateChannel.connectSend(sendPort);
    Timer? executionTimer;

    isolateChannel.stream.cast<IsolateCommand>().listen((command) {
      switch (command.type) {
        case IsolateCommandType.pathInformation:
          rfidReader = _getRfidReader(command.dyLibPath);
          break;

        case IsolateCommandType.startReading:
          // if excution (timer is null) OR (it isn't null AND not active) => activate it
          if (
            (executionTimer == null) || 
            (executionTimer != null && !executionTimer!.isActive)) {

              executionTimer = Timer.periodic(
                pauseBetweenScan, 
                (timer) => _uidHelper(isolateChannel, rfidReader)
              );
            }
          break;

        case IsolateCommandType.stopReading:
          if (executionTimer != null) {
            executionTimer!.cancel();
          } 
          break;

        case IsolateCommandType.terminate:
          rfidReader.closeRfidReader();
          break;
      }
    });
  }

  static RfidReader _getRfidReader(String dyLibPath) {
    final RfidReader rfidReader = RfidReader(dyRfidLibPath: dyLibPath);
    Either<RfidFailure, Unit> initResult = rfidReader.initRfidReader();

    initResult.fold(
      (failure) { 
        assert(false, "RFID init error! - Not a root user or something else?");
      }, 
      (unit) => null
    );

    return rfidReader;
  }

  static void _uidHelper(IsolateChannel isolateChannel, RfidReader rfidReader) async {
    Either<RfidFailure, ChipScanData> result = rfidReader.getUid();

    result.fold(
      (rfidFailure) {
        // nothing we can do here - just skip
      }, 
      (chipScanData) {
        isolateChannel.sink.add(chipScanData);
      }
    );
  }

  @override
  Either<RfidFailure, Unit> stopReadingFunction() {
    if (_rootIsolateChannel != null && _rfidReaderIsolate != null) {
      _rootIsolateChannel!.sink.add(IsolateCommand(type: IsolateCommandType.stopReading));
      return Either.right(unit);
    }

    return Either.left(RfidReadFunctionNotInitYet());
  }

  @override
  Either<RfidFailure, Unit> startReadingFunction() {
    if (_rootIsolateChannel != null && _rfidReaderIsolate != null) {
      _rootIsolateChannel!.sink.add(IsolateCommand(type: IsolateCommandType.startReading));
      return Either.right(unit);
    }

    return Either.left(RfidReadFunctionNotInitYet());
  }


  @override
  void terminateIsolate() {
    assert(_started, "This RfidReader wasn't init yet!");
    assert(!_stopped, "This RfidReader instance was already closed!");

    _rootIsolateChannel!.sink.add(IsolateCommand(type: IsolateCommandType.terminate));
    _rfidReaderIsolate?.kill();
    _stopped = true;
  }
}