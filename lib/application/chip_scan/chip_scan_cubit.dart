import 'dart:async';

import "package:bloc/bloc.dart";

import 'package:terminal_frontend/application/chip_scan/chip_scan_state.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';

class ChipScanCubit extends Cubit<ChipScanState> {
  final ChipScanServiceInterface chipScanService;
  StreamSubscription<ChipScanData>? _chipDataStreamSubscripiton;

  ChipScanCubit({required this.chipScanService}) : super(ChipScanState.init()) {
    registerChipDataStream().whenComplete(startListingForChipData);
  }

  Future<void> registerChipDataStream() async {
    if (_chipDataStreamSubscripiton == null) {
      final Stream<ChipScanData> chipDataStream = await chipScanService.getUidStream();
      _chipDataStreamSubscripiton = chipDataStream.listen((chipScanData) { 
        final ChipScanState newState = ChipScanState(
          chipDataAvailable: true, 
          chipScanData: chipScanData
        );
        emit(newState);
      });
    }
  }

  void stopListingForChipData() {
    chipScanService.pauseReadingFunction();
  }

  void startListingForChipData() {
    chipScanService.startReadingFunction();
    emit(ChipScanState.init());
  }
}