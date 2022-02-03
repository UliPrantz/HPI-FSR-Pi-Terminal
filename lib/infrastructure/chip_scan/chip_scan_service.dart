import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:fpdart/fpdart.dart';
import 'package:stream_channel/isolate_channel.dart';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/rfid_reader.dart';

// At the bottom there also is a dart cli example for the Pi
//----START---- The underlying C Code ----START----

// typedef struct _PN532 {
//     int8_t (*reset)(void);
//     int8_t (*read_data)(uint8_t* data, uint16_t count);
//     int8_t (*write_data)(uint8_t *data, uint16_t count);
//     bool (*wait_ready)(uint32_t timeout);
//     int8_t (*wakeup)(void);
//     void (*log)(const char* log);
// } PN532;

// init the pn532
//
// @ return 0 for success and -1 for failure
//int8_t initPN532(PN532 *pn532)

// the function returns the length of data written into the data array
// the data array is defined as follow
// uint8_t data[MIFARE_UID_MAX_LENGTH]; with MIFARE_UID_MAX_LENGTH = (int) 10
//
// @ return -1 for failure or the length of data
//int32_t getUid(PN532 *pn532, uint8_t data[MIFARE_UID_MAX_LENGTH])

//----END---- The underlying C Code ----END---- 

class PN532 extends Struct {
  external Pointer<NativeFunction> reset;
  external Pointer<NativeFunction> readData;
  external Pointer<NativeFunction> writeData;
  external Pointer<NativeFunction> waitReady;
  external Pointer<NativeFunction> log;
}

typedef InitPN532 = Int8 Function(Pointer<PN532> pn532);
typedef InitPN532Dart = int Function(Pointer<PN532> pn532);

typedef GetUid = Int32 Function(Pointer<PN532> pn532, Pointer<Uint8> data);
typedef GetUidDart = int Function(Pointer<PN532> pn532, Pointer<Uint8> data);

enum IsolateCommandType {
  pathInformation,
  startReading,
  stopReading,
  terminate,
}

class IsolateCommand {
  final IsolateCommandType type;
  final String dyLibPath;

  IsolateCommand({required this.type, this.dyLibPath=""});

  IsolateCommand copyWith({
    IsolateCommandType? type,
    String? dyLibPath,
  }) => IsolateCommand(
    type: type ?? this.type,
    dyLibPath: dyLibPath ?? this.dyLibPath
  );
}

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

  static void _uidHelper(IsolateChannel isolateChannel, RfidReader rfidReader) {
    Either<RfidFailure, ChipScanData> result = rfidReader.getUid();

    result.fold(
      (rfidFailure) {
        // nothing we can do here - just skip
      }, 
      (chipScanData) async {
        isolateChannel.sink.add(chipScanData);

        // Adding a delay in case of a successfull read so we don't read twice
        // and even more important we give the applicaiton layer some time to
        // react. This is good because when it interrupts an active read it can
        // happen that we get an dangling pointer which causes an
        // `corrupted size vs. prev_size flutter` error
        await Future.delayed(const Duration(seconds: 2));
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


// Example Main to Test on Pi
//int main() {

//   const String dyRfidLibPath = ""; // Add Path there to 'Library.so'
//   const int uidMaxLength = 10;
  
//   final dyRfidLib = DynamicLibrary.open(dyRfidLibPath);

//   //STILL NEED TO FREE THIS MEMORY AGAIN!!!
//   final Pointer<PN532> pn532 = calloc.allocate(sizeOf<PN532>());
//   final Pointer<Uint8> data = calloc.allocate(sizeOf<Uint8>() * uidMaxLength);
//   final InitPN532Dart initPN532 = dyRfidLib.lookupFunction<InitPN532, InitPN532Dart>('initPN532');
//   final GetUidDart getUid = dyRfidLib.lookupFunction<GetUid, GetUidDart>('getUid');

//   final initStatus = initPN532(pn532);
//   if (initStatus < 0) {
//     print('Fuck');
//     exit(initStatus);
//   }

//   while (true) {
    
//     final int uidLength = getUid(pn532, data);
//     if (uidLength > 0) {
//       StringBuffer stringBuffer = StringBuffer();
//       for (int i=0; i < uidLength; i++) {
//         int convertedData = data.elementAt(i).value;
//         stringBuffer.write(convertedData.toRadixString(16));
//       }
//       print(stringBuffer);
//     }
//   }
// }