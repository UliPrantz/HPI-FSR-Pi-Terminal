import 'package:flutter/material.dart';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

import 'package:terminal_frontend/domain/terminal_meta_data/item.dart';
import 'package:terminal_frontend/presentation/checkout_screen/checkout_screen.dart';
import 'package:terminal_frontend/presentation/chip_scan_screen/scan_screen.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_screen.dart';
import 'package:terminal_frontend/presentation/shop_screen/shop_screen.dart';
import 'package:terminal_frontend/presentation/start_screen/start_screen.dart';

part 'app_router.gr.dart'; // .gr.dart is needed (doesn't work with .g.dart)
  
@MaterialAutoRouter(     
  routes: <AutoRoute>[        
    AutoRoute(page: StartScreen, initial: true),
    AutoRoute(page: ChipScanScreen),
    AutoRoute(page: ShopScreen),
    AutoRoute(page: PairingScreen),            
    AutoRoute(page: CheckoutScreen),
  ],        
) 
class AppRouter extends _$AppRouter {}

void logoutRoute(BuildContext context) {
  AutoRouter.of(context).replace(ChipScanScreenRoute());
}