import "package:bloc/bloc.dart";
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/domain/pairing/pairing_service_interface.dart';

class PairingCubit extends Cubit {
  final PairingServiceInterface pairingService;

  PairingCubit({required this.pairingService}) : super(PairingState());
}