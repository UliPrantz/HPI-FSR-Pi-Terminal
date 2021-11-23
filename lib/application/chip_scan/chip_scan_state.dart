import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';

class ChipScanState with EquatableMixin {
  final bool chipDataAvailable;
  final ChipScanData chipScanData;

  ChipScanState({required this.chipDataAvailable, required this.chipScanData});

  @override
  List<Object?> get props => throw UnimplementedError();
}