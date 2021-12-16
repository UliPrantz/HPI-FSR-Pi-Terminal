import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class BalanceView extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  const BalanceView({Key? key, required this.shoppingCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
      bloc: shoppingCubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ihr Guthaben:",
                  style: TextStyles.mainTextBig,
                  textAlign: TextAlign.center,
                ),

                const Padding(padding: EdgeInsets.only(bottom: 12.0)),

                determineBalance(state),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget determineBalance(ShoppingState state) {
    String? text;

    switch(state.userState) {
      case UserState.loadingUser:
        return const CircularProgressIndicator();
      case UserState.loadingUserFailed:
        text = "N/A";
        break;
      case UserState.loadedaAnonymousUser:
      case UserState.loadedPairedUser:
        text = state.user.balance.toEuroString();
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyles.mainTextBig,
    );
  }
}