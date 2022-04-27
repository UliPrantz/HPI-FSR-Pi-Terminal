import 'package:flutter_test/flutter_test.dart';

import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_dto.dart';

void main() {
  test('Chip scan dto formatting test', () {
    final List<int> uidData = [1, 2, 3, 4, 10, 15, 255, 255];
    const String uidDataExpectedFormat = '010203040a0fffff';

    final String actualDtoOutput = ChipScanDto(uidData: uidData).toDomain().uuid;

    expect(actualDtoOutput, uidDataExpectedFormat);
  });
}