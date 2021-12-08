import 'package:equatable/equatable.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';

class StartScreenState with EquatableMixin {
  final bool loaded;
  final TerminalMetaData terminalMetaData;

  StartScreenState({required this.loaded, required this.terminalMetaData});
  StartScreenState.init() : this(loaded: false, terminalMetaData: TerminalMetaData.empty());

  StartScreenState copyWith({ bool? loaded, TerminalMetaData? terminalMetaData}) {
    return StartScreenState(
      loaded: loaded ?? this.loaded, 
      terminalMetaData: terminalMetaData ?? this.terminalMetaData
    );
  }
 
  @override
  List<Object?> get props => [loaded, terminalMetaData];
}