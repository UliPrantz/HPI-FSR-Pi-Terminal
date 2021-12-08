
import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/domain/user/user.dart';

abstract class UserServiceInterface {
  Future<Either<HttpFailure, User>> getUserInfo(String tokenId);
}