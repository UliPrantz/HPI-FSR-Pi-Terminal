import 'dart:ffi';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';

class ChipScanDto {
  final List<int> uidData;

  ChipScanDto({required this.uidData});

  factory ChipScanDto.fromData({required Pointer<Uint8> dataArrPointer, required int uidLength}) {
    List<int> tmpUidData = List.generate(uidLength, (index) {
      return dataArrPointer.elementAt(index).value;
    });
    
    return ChipScanDto(uidData: tmpUidData);
  }

  ChipScanData toDomain() {
    final StringBuffer stringBuffer = StringBuffer('0x');
    for (int x in uidData) {
      final String tmpString = x.toRadixString(16).padLeft(0, '0');
      stringBuffer.write(tmpString);
    }
    return ChipScanData(uuid: stringBuffer.toString());
  }
}