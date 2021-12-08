import 'package:fpdart/fpdart.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data_service_interface.dart';
import 'package:terminal_frontend/domain/core/basic_failures.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/terminal_meta_data/terminal_meta_data_dto.dart';

class TerminalMetaDataService extends TerminalMetaDataServiceInterface {
  static const String endpoint = "/pos/terminal";

  final CachedHttpClient httpClient;

  TerminalMetaDataService({required this.httpClient});

  @override
  Future<Either<HttpFailure, TerminalMetaData>> getTerminalInfo() async {
    Response response;

    try {
      response = await httpClient.get(endpoint);
    } catch (e) {
      return Either.left(ConnectionFailure());
    }

    if (response.statusCode == 401) {
      return Either.left(AuthFailure());
    }

    TerminalMetaDataDto dto = TerminalMetaDataDto.fromJson(response.bodyAsMap);
    return Either.right(dto.toDomain());
  }

}