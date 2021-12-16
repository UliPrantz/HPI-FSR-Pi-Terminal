import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart' show rootBundle;

import 'package:yaml/yaml.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_service.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_service.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_service.dart';
import 'package:terminal_frontend/infrastructure/terminal_meta_data/terminal_meta_data_service.dart';
import 'package:terminal_frontend/infrastructure/user/user_serivce.dart';

class InjectionContainer {
  static const String envPath = 'assets/env.yaml';
  static const String envKey = 'environment';
  static const String schemeKey = 'scheme';
  static const String hostKey = 'host_name';
  static const String tokenKey = 'terminal_token';

  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;

  /// This function loads all the neccassyry config variable defined in env.yaml.
  /// The return type is dynamic since at this point the official yaml package
  /// returns some on Map implementation but in future will only support HashMap.
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
  static Future<dynamic> _getEnvConfig() async {
    WidgetsFlutterBinding.ensureInitialized();
    final String confYaml = await rootBundle.loadString(envPath);
    return loadYaml(confYaml);
  }

  static Future<void> injectDependencies() async {
    // TODO change BACK!!!! //final configMap = await _getEnvConfig();
    final configMap = {envKey: {schemeKey:"https", hostKey: "hpi-wallet-backend.test", tokenKey: "47umEV6vcla51g40rfvW6cvwQfP36m7nSNMElBtD"}};
    final envConfigs = configMap[envKey]!;

    final Uri uri = Uri(
      scheme: envConfigs[schemeKey]!, 
      host: envConfigs[hostKey]!
    );
    final Map<String, String> headers = <String, String>{
      'Authorization' : 'Bearer ${envConfigs[tokenKey]!}'
    };
    final CachedHttpClient httpClient = 
      CachedHttpClient(innerClient: http.Client(), uri: uri, headers: headers);

    getIt.registerSingleton(ChipScanService());
    getIt.registerSingleton(PairingService(httpClient: httpClient));
    getIt.registerSingleton(ShoppingService(httpClient: httpClient));
    getIt.registerSingleton(TerminalMetaDataService(httpClient: httpClient));
    getIt.registerSingleton(UserService(httpClient: httpClient));

    // We only register one of the cubits since this is the only one with a 
    // lifecycle that is longer than just one user session
    // Every other cubit will be destroyed after a chip scan (including the 
    // ChipScanCubit itself) and will be reconstructed for another session 
    // this keeps the state of different session clearly seperated
    getIt.registerSingleton(StartScreenCubit(terminalMetaDataService: getIt<TerminalMetaDataService>()));
  }
}