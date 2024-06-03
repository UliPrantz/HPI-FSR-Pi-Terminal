import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/chip_scan/chip_scan_state.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_state.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_service.dart';
import 'package:terminal_frontend/injection_container.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/fsr_wallet_app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

@RoutePage()
class ChipScanScreen extends StatelessWidget {
  final ChipScanCubit chipScanCubit =
      ChipScanCubit(chipScanService: GetIt.I<ChipScanService>());

  ChipScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool allowManualTokenInput = GetIt.I<EnvironmentConfig>().allowManualToken;

    return BlocListener<ChipScanCubit, ChipScanState>(
      bloc: chipScanCubit,
      listener: _chipScanStateChanged,
      child: BlocBuilder<StartScreenCubit, StartScreenState>(
          bloc: GetIt.I<StartScreenCubit>(),
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.mainColor,
              appBar: FsrWalletAppBar(),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Please put your transponder in front of the reader",
                          style: TextStyles.mainTextBigBright,
                          textAlign: TextAlign.center),
                      allowManualTokenInput
                          ? TextField(
                              autocorrect: false,
                              onSubmitted: (value) =>
                                  manualInput(context, value),
                              decoration: const InputDecoration(
                                  labelText:
                                      "Manual input (Press ENTER to submit)",
                                  labelStyle: TextStyles.normalTextWhite),
                              style: TextStyles.normalTextWhite,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _chipScanStateChanged(BuildContext context, ChipScanState state) {
    if (state.chipDataAvailable) {
      chipScanCubit.stopListingForChipData();

      AutoRouter.of(context).push(ShopRoute(
          tokenId: state.chipScanData.uuid,
          items: GetIt.I<StartScreenCubit>().state.terminalMetaData.items,
          tag: "coffee"));
    }
  }

  void manualInput(BuildContext context, String value) {
    AutoRouter.of(context).push(ShopRoute(
        tokenId: value,
        items: GetIt.I<StartScreenCubit>().state.terminalMetaData.items,
        tag: "coffee"));
  }
}
