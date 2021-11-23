import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';
import 'package:terminal_frontend/presentation/shop_screen/balance_view.dart';
import 'package:terminal_frontend/presentation/shop_screen/checkout_preview.dart';
import 'package:terminal_frontend/presentation/shop_screen/item_list.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FsrWalletAppBar(),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ItemList()
          ),
    
          Container(
            color: AppColors.darkGrey,
            width: 1,  
          ),
    
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 10,
                  child: BalanceView(),
                ),
                Divider(color: AppColors.darkGrey,),
                Expanded(
                  flex: 5,
                  child: CheckoutPreview()
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}