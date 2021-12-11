import 'package:equatable/equatable.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';

enum LoadingState {
  loading,
  loadingSucceeded,
  loadingFailed
}
class StartScreenState with EquatableMixin {
  final LoadingState loadingState;
  final TerminalMetaData terminalMetaData;

  StartScreenState({required this.loadingState, required this.terminalMetaData});
  StartScreenState.init() : this(
    loadingState: LoadingState.loading, 
    terminalMetaData: TerminalMetaData.empty()
  );

  StartScreenState copyWith({
    LoadingState? loadingState, 
    TerminalMetaData? terminalMetaData
  }) {
    return StartScreenState(
      loadingState: loadingState ?? this.loadingState, 
      terminalMetaData: terminalMetaData ?? this.terminalMetaData
    );
  }
 
  @override
  List<Object?> get props => [loadingState, terminalMetaData];
}