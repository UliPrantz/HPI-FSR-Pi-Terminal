import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';

import 'package:fpdart/fpdart.dart';

abstract class TerminalMetaDataServiceInterface {
  Future<Either<HttpFailure, TerminalMetaData>> getTerminalInfo(); 
}