enum IsolateCommandType {
  pathInformation,
  startReading,
  stopReading,
  terminate,
}

class IsolateCommand {
  final IsolateCommandType type;
  final String dyLibPath;

  IsolateCommand({required this.type, this.dyLibPath=""});

  IsolateCommand copyWith({
    IsolateCommandType? type,
    String? dyLibPath,
  }) => IsolateCommand(
    type: type ?? this.type,
    dyLibPath: dyLibPath ?? this.dyLibPath
  );
}