import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/pairing/pairing_data.dart';
import 'package:terminal_frontend/domain/user/user.dart';

abstract class PairingServiceInterface {
  Future<Either<HttpFailure, User>> pairUser(PairingData pairingData);
}