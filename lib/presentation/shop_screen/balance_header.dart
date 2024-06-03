import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/shopping/shopping_cubit.dart';
import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/user/user.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/format_extensions.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class BalanceHeader extends StatelessWidget {
  final ShoppingCubit shoppingCubit;

  const BalanceHeader({super.key, required this.shoppingCubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCubit, ShoppingState>(
        bloc: shoppingCubit,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: determineUsername(state, context: context)),
              determineBalance(state, context: context),
            ],
          );
        });
  }

  Widget determineBalance(ShoppingState state,
      {required BuildContext context}) {
    String? text;

    switch (state.userState) {
      case UserState.loadingUser:
        return const CircularProgressIndicator();
      case UserState.loadingUserFailed:
        text = "N/A";
        break;
      case UserState.missingUser:
        AutoRouter.of(context)
            .push<User>(PairingRoute(tokenId: state.user.tokenId));
        text = "User not found";
        break;
      case UserState.loadedPairedUser:
        text = state.user.balance.toEuroString();
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyles.boldTextMediumBright,
    );
  }

  Widget determineUsername(ShoppingState state,
      {required BuildContext context}) {
    String text = "";

    switch (state.userState) {
      case UserState.loadingUser:
        return const CircularProgressIndicator();
      case UserState.loadingUserFailed:
        text = "ERROR";
        break;
      case UserState.missingUser:
        text = "N/A";
        break;
      case UserState.loadedPairedUser:
        if (state.user.username != null) text = state.user.username!;
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyles.boldTextMediumBright,
    );
  }
}
