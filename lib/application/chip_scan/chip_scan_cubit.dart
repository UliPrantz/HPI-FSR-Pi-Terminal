import 'dart:async';

import "package:bloc/bloc.dart";
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_state.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_data.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';

class ChipScanCubit extends Cubit<ChipScanState> {
  static const int updateIntervall = 30;
  late final Timer updateTimer;

  final ChipScanServiceInterface chipScanService;
  StreamSubscription<ChipScanData>? _chipDataStreamSubscripiton;

  ChipScanCubit({required this.chipScanService}) : super(ChipScanState.init()) {
    registerChipDataStream().whenComplete(startListingForChipData);
    updateTimer = Timer.periodic(
      const Duration(seconds: updateIntervall),
      updateTerminalMetaData
    );
  }

  Future<void> registerChipDataStream() async {
    if (_chipDataStreamSubscripiton == null) {
      final Stream<ChipScanData> chipDataStream = await chipScanService.getUidStream();

      _chipDataStreamSubscripiton = chipDataStream.listen((chipScanData) { 
        stopListingForChipData();
        updateTimer.cancel();

        final ChipScanState newState = ChipScanState(
          chipDataAvailable: true, 
          chipScanData: chipScanData
        );
        
        emit(newState);
      });
    }
  }

  void updateTerminalMetaData(Timer timer) {
    GetIt.I<StartScreenCubit>().updateTerminalMetaData();
  }

  void stopListingForChipData() {
    chipScanService.stopReadingFunction();
  }

  void startListingForChipData() {
    chipScanService.startReadingFunction();
    emit(ChipScanState.init());
  }
}