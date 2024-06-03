import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_service.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_service.dart';
import 'package:terminal_frontend/infrastructure/terminal_meta_data/terminal_meta_data_service.dart';
import 'package:terminal_frontend/infrastructure/user/user_serivce.dart';

class EnvironmentConfig {
  final Uri serverUri;
  final String authToken;

  final String coffeeImgPath;
  final String rfidDyLibPath;

  final bool allowManualToken;

  final String pairingUrlPrefix;

  const EnvironmentConfig(
      {required this.serverUri,
      required this.authToken,
      required this.coffeeImgPath,
      required this.rfidDyLibPath,
      required this.allowManualToken,
      required this.pairingUrlPrefix});
}

class InjectionContainer {
  static const String envRelativPath = 'assets/env.yaml';

  static const String envKey = 'environment';
  static const String assetsKey = 'assets';

  static const String schemeKey = 'scheme';
  static const String hostKey = 'host_name';
  static const String terminalTokenKey = 'terminal_token';
  static const String allowManualTokenKey = 'allow_manual_input';
  static const String basePathKey = 'base_path';
  static const String portKey = 'port';
  static const String pairingUrlPrefixKey = 'pairing_url_prefix';

  static const String rfidLibKey = 'rfid_lib_relative_path';
  static const String coffeeImgKey = 'coffee_image_relative_path';

  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;

  /// This function loads all the neccassyry config variable defined in env.yaml.
  /// The return type is dynamic since at this point the official yaml package
  /// returns some own Map implementation but in future will only support HashMap.
  /// In general the return type should support normal map functionality, so just
  /// treat it like a map.
  ///
  /// This function calls [WidgetsFlutterBinding.ensureInitialized()]!
  ///
  /// -----Start example 'env.yaml'-----
  /// environment:
  ///   scheme: "https"
  ///   terminal_token: "www.myhpi.de"
  ///   host_name: "SomePrettyLongToken"
  /// -----End example 'env.yaml'-----
  static Future<EnvironmentConfig> _getEnvConfig() async {
    final Uri currentDir = Directory.current.uri;
    final Uri envUri = Uri(path: "${currentDir.path}$envRelativPath");

    final String confYaml = await File(envUri.toFilePath()).readAsString();
    final configMap = loadYaml(confYaml);

    final envConfigs = configMap[envKey]!;
    final assetsConfigs = configMap[assetsKey];

    final Uri rfidDyLibUri =
        Uri(path: "${currentDir.path}${assetsConfigs[rfidLibKey]}");

    final Uri coffeeImgUri =
        Uri(path: "${currentDir.path}${assetsConfigs[coffeeImgKey]}");

    final bool allowManualToken = envConfigs[allowManualTokenKey] as bool;

    return EnvironmentConfig(
      serverUri: Uri(
          scheme: envConfigs[schemeKey]!,
          host: envConfigs[hostKey]!,
          path: envConfigs[basePathKey]!,
          port: envConfigs[portKey] ?? 443),
      authToken: envConfigs[terminalTokenKey]!,
      coffeeImgPath: coffeeImgUri.toFilePath(),
      rfidDyLibPath: rfidDyLibUri.toFilePath(),
      allowManualToken: allowManualToken,
      pairingUrlPrefix: envConfigs[pairingUrlPrefixKey]!,
    );
  }

  static Future<void> injectDependencies() async {
    final EnvironmentConfig envConfig = await _getEnvConfig();

    final Map<String, String> headers = <String, String>{
      'authorization': 'Bearer ${envConfig.authToken}',
      'content-type': 'application/json',
    };
    final CachedHttpClient httpClient = CachedHttpClient(
        innerClient: http.Client(), uri: envConfig.serverUri, headers: headers);

    getIt.registerSingleton(envConfig);

    getIt.registerSingleton(
        ChipScanService(rfidDyLibPath: envConfig.rfidDyLibPath));
    getIt.registerSingleton(ShoppingService(httpClient: httpClient));
    getIt.registerSingleton(TerminalMetaDataService(httpClient: httpClient));
    getIt.registerSingleton(UserService(httpClient: httpClient));

    // We only register one of the cubits since this is the only one with a
    // lifecycle that is longer than just one user session
    // Every other cubit will be destroyed after a chip scan (including the
    // ChipScanCubit itself) and will be reconstructed for another session
    // this keeps the state of different session clearly seperated
    getIt.registerSingleton(StartScreenCubit(
        terminalMetaDataService: getIt<TerminalMetaDataService>()));
  }
}
