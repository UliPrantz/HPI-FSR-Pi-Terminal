import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/presentation/checkout_screen/checkout_screen.dart';
import 'package:terminal_frontend/presentation/chip_scan_screen/scan_screen.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_screen.dart';
import 'package:terminal_frontend/presentation/shop_screen/shop_screen.dart';
import 'package:terminal_frontend/presentation/start_screen/start_screen.dart';

part 'app_router.gr.dart'; // .gr.dart is needed (doesn't work with .g.dart)

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: ChipScanRoute.page),
        AutoRoute(page: ShopRoute.page),
        AutoRoute(page: PairingRoute.page),
        AutoRoute(page: CheckoutRoute.page),
      ];
}

void logoutRoute(BuildContext context) {
  AutoRouter.of(context).replace(ChipScanRoute());
}
