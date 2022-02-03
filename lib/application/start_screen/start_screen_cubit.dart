import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_state.dart';

import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data_service_interface.dart';

class StartScreenCubit extends Cubit<StartScreenState> {
  final TerminalMetaDataServiceInterface terminalMetaDataService;

  StartScreenCubit({required this.terminalMetaDataService}) 
    : super(StartScreenState.init()) {
      _fetchTerminalMetaData();
  }

  void _fetchTerminalMetaData() async {
    Either<HttpFailure, TerminalMetaData> result = 
      await terminalMetaDataService.getTerminalInfo();

    result.fold(
      (httpFailure) {
        emit(state.copyWith(
          loadingState: LoadingState.loadingFailed
        ));
      }, 
      (terminalMetaData) {
        final newState = StartScreenState(
          loadingState: LoadingState.loadingSucceeded,
          terminalMetaData: terminalMetaData,
        );
        emit(newState);
      });
  }

  void updateTerminalMetaData() async {
    Either<HttpFailure, TerminalMetaData> result = 
      await terminalMetaDataService.getTerminalInfo();

      result.fold(
        (failure) {
          // nothing to do here just ignore it (because we just updating)
        },
         (result) {
           emit(
             state.copyWith(
               terminalMetaData: result
             )
           );
         }
      );
  }

  void retry() {
    emit(StartScreenState.init());
    _fetchTerminalMetaData();
  }
}