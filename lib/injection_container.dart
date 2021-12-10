import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/domain/chip_scan/chip_scan_service_interface.dart';
import 'package:terminal_frontend/domain/pairing/pairing_service_interface.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data_service_interface.dart';
import 'package:terminal_frontend/domain/user/user_service_interface.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_service.dart';
import 'package:terminal_frontend/infrastructure/core/http_client/http_client.dart';
import 'package:terminal_frontend/infrastructure/pairing/pairing_service.dart';
import 'package:terminal_frontend/infrastructure/shopping/shopping_service.dart';
import 'package:terminal_frontend/infrastructure/terminal_meta_data/terminal_meta_data_service.dart';
import 'package:terminal_frontend/infrastructure/user/user_serivce.dart';

class InjectionContainer {
  // Terminal Constants
  static const String scheme = "https";
  static const String host = "www.myhpi.de";
  static const Map<String, String> headers = {
    'Bearer' : "some_token"
  };

  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;


  static Future<void> injectDependencies() async {
    final Uri uri = Uri(scheme: scheme, host: host);
    final CachedHttpClient httpClient = 
      CachedHttpClient(innerClient: http.Client(), uri: uri, headers: headers);

    final ChipScanServiceInterface chipScanService = ChipScanService();
    final PairingServiceInterface pairingService = PairingService(httpClient: httpClient);
    final ShoppingServiceInterface shoppingService = ShoppingService(httpClient: httpClient);
    final TerminalMetaDataServiceInterface terminalMetaDataService = TerminalMetaDataService(httpClient: httpClient);
    final UserServiceInterface userService = UserService(httpClient: httpClient);

    getIt.registerSingleton(ChipScanCubit(chipScanService: chipScanService));
    getIt.registerSingleton(PairingCubit(pairingService: pairingService,));
    getIt.registerSingleton(ShoppingCubit(shoppingService: shoppingService, userService: userService));
    getIt.registerSingleton(StartScreenCubit(terminalMetaDataService: terminalMetaDataService));
  }
}