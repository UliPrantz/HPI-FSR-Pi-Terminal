import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/pairing_screen/pairing_screen.dart';
import 'package:terminal_frontend/presentation/shop_screen/shop_screen.dart';
import 'package:terminal_frontend/presentation/start_scan_screen/start_scan_screen.dart';

void main() {
  runApp(const WalletTerminalApp());
}

class WalletTerminalApp extends StatelessWidget {
  const WalletTerminalApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AlwaysDragScrollBehavior(),
      title: 'FSR-Wallet-Terminal',
      home: const PairingScreen(),
    );
  }
}

class AlwaysDragScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}