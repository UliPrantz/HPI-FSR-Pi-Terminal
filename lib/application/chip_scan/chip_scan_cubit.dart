import 'dart:async';

import 'package:fpdart/fpdart.dart';
import "package:bloc/bloc.dart";

import 'package:terminal_frontend/application/chip_scan/chip_scan_state.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';

class ChipScanCubit extends Cubit<ChipScanState> {
  final ChipScanServiceInterface chipScanService;
  StreamSubscription<ChipScanData>? _chipDataStreamSubscripiton;

  ChipScanCubit({required this.chipScanService}) : super(ChipScanState.init()) {
    Either<RfidFailure, Unit> initResult = chipScanService.initRfidReader();
    initResult.fold(
      (failure) {
        // TODO Add Error Handling! (InitFailure) - means basically fucked up
      }, 
      (unit) {
        // nothing we can do here - just success
      }
    );
  }
  
  void listenForChipData() async {
    if (_chipDataStreamSubscripiton != null) {
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
    _chipDataStreamSubscripiton?.cancel();
  }
}