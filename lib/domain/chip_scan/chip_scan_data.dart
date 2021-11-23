import 'package:equatable/equatable.dart';

class ChipScanData with EquatableMixin {
  final String uuid;

  ChipScanData({required this.uuid});
  ChipScanData.empty() : this(uuid: "");

  @override
  List<Object?> get props => [uuid];
}