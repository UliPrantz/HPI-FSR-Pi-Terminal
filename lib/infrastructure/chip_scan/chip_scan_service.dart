import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';


import 'package:fpdart/fpdart.dart';
import 'package:stream_channel/isolate_channel.dart';
import 'package:ffi/ffi.dart';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_dto.dart';

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

class ChipScanService extends ChipScanServiceInterface {
  static const String dyRfidLibPath = "";
  static const int uidMaxLength = 10;

  static bool _didInit = false;
  static bool _closed = false;

  static final Pointer<PN532> _pn532Pointer = calloc.allocate(sizeOf<PN532>());
  static final Pointer<Uint8> _dataArrPointer = calloc.allocate(sizeOf<Uint8>() * uidMaxLength);

  static late final GetUidDart _getUidFunction;

  Isolate? rfidReaderIsolate;
  IsolateChannel? rootIsolateChannel;
  
  /// This class must be called before the RfidReader can be used!
  /// There is no underlying class RfidReader since it would be completely obsolete.
  /// Such a class could be added later.
  /// 
  /// @throws DynamicLibrary.open() and the .lookup function can throw!
  ///         These errors aren't handeled for a good reason. If this happens
  ///         the provided driver C library is broken or couldn't be found. 
  ///         Then you need to put it in the right place or recompile it!
  @override
  Either<RfidFailure, Unit> initRfidReader() {
    assert(!_didInit, "This RfidReader was already init!");
    assert(!_closed, "This RfidReader instance was already closed!");

    final dyRfidLib = DynamicLibrary.open(dyRfidLibPath);
    final InitPN532Dart initPN532 = 
      dyRfidLib.lookupFunction<InitPN532, InitPN532Dart>('initPN532');
    _getUidFunction = dyRfidLib.lookupFunction<GetUid, GetUidDart>('getUid');
    
    final initStatus = initPN532(_pn532Pointer);
    
    if (initStatus < 0) {
      return Either.left(InitFailure()); 
    }

    _didInit = true;
    return Either.right(unit);
  }


  @override
  static Either<RfidFailure, ChipScanData> _getUid() {
    assert(_didInit, "This RfidReader wasn't init yet!");
    assert(!_closed, "This RfidReader instance was already closed!");

    final int uidLength = _getUidFunction(_pn532Pointer, _dataArrPointer);

    if (uidLength > 0) {
      ChipScanDto dto = ChipScanDto.fromData(
        dataArrPointer: _dataArrPointer, 
        uidLength: uidLength
      );
      return Either.right(dto.toDomain());
    }
    return Either.left(NothingRead());
  }

  @override
  Future<Stream<ChipScanData>> getUidStream() async {
    if (rfidReaderIsolate == null) {
      ReceivePort receivePort = ReceivePort();
      rootIsolateChannel = IsolateChannel.connectReceive(receivePort);
      rfidReaderIsolate = await Isolate.spawn(_uidIsolate, receivePort.sendPort);
    }

    return rootIsolateChannel!.stream.cast<ChipScanData>();
  }

  static void _uidIsolate(SendPort sendPort) {
    final IsolateChannel isolateChannel = IsolateChannel.connectSend(sendPort);
    Timer executionTimer = Timer(Duration.zero, () => _uidHelper(isolateChannel));

    isolateChannel.stream.cast<bool>().listen((event) {
      if (event) { // when event is true = start execution
        if (!executionTimer.isActive) { // when timer isn't active anymore reactivate
          Timer(Duration.zero, () => _uidHelper(isolateChannel));
        }
      } else {
        executionTimer.cancel();
      }
    });
  }

  static void _uidHelper(IsolateChannel isolateChannel) {
    Either<RfidFailure, ChipScanData> result = _getUid();
    
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
  Either<RfidFailure, Unit> pauseReadingFunction() {
    if (rootIsolateChannel != null && rfidReaderIsolate != null) {
      rootIsolateChannel!.sink.add(false);
      return Either.right(unit);
    }

    return Either.left(RfidReadFunctionNotInitYet());
  }

  @override
  Either<RfidFailure, Unit> resumeReadingFunction() {
    if (rootIsolateChannel != null && rfidReaderIsolate != null) {
      rootIsolateChannel!.sink.add(true);
      return Either.right(unit);
    }

    return Either.left(RfidReadFunctionNotInitYet());
  }


  @override
  void closeRfidReader() {
    assert(_didInit, "This RfidReader wasn't init yet!");
    assert(!_closed, "This RfidReader instance was already closed!");

    calloc.free(_pn532Pointer);
    calloc.free(_dataArrPointer);
    rfidReaderIsolate?.kill();
    _closed = true;
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