import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/pairing_screen/numpad.dart';
import 'package:terminal_frontend/presentation/pairing_screen/pairing_code_input.dart';
import 'package:terminal_frontend/presentation/pairing_screen/qr_code_info.dart';

class PairingScreen extends StatelessWidget {
  const PairingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(),
      body: Row(
        children: [
          Expanded(child: QrCodeInfo()),
    
          Container(
            color: AppColors.darkGrey,
            width: 1,  
          ),
    
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PairingCodeInput(numberOfDigits: 4,),
                Numpad(
                  onKeyboardTap: (String key) {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}