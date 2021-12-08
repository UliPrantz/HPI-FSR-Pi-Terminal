import 'package:equatable/equatable.dart';

import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';

class ChipScanState with EquatableMixin {
  final bool chipDataAvailable;
  final ChipScanData chipScanData;

  ChipScanState({required this.chipDataAvailable, required this.chipScanData});
  ChipScanState.init() : this(chipDataAvailable: false, chipScanData: ChipScanData.empty());

  @override
  List<Object?> get props => throw UnimplementedError();
}