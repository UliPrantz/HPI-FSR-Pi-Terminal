import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/chip_scan/chip_scan_cubit.dart';
import 'package:terminal_frontend/application/chip_scan/chip_scan_state.dart';
import 'package:terminal_frontend/domain/terminal_meta_data/terminal_meta_data.dart';
import 'package:terminal_frontend/infrastructure/chip_scan/chip_scan_service.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/app_bar.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ChipScanScreen extends StatelessWidget {
  final ChipScanCubit chipScanCubit = ChipScanCubit(
    chipScanService: GetIt.I<ChipScanService>()
  );

  ChipScanScreen({ Key? key }) : super(key: key) {
    chipScanCubit.resumeListingForChipData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChipScanCubit, ChipScanState>(
      bloc: chipScanCubit,
      listener: _chipScanStateChanged,
      child: Scaffold(
        appBar: FsrWalletAppBar(),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Text(
              "Bitte den Transponder an das Lesegerät halten",
              style: TextStyles.mainTextBig,
              textAlign: TextAlign.center
            ),
          ),
        ),
      ),
    );
  }

  void _chipScanStateChanged(BuildContext context, ChipScanState state) {
    if (state.chipDataAvailable) {
      chipScanCubit.stopListingForChipData();
      AutoRouter.of(context).push(
        ShopScreenRoute(
          tokenId: state.chipScanData.uuid,
          items: GetIt.I<TerminalMetaData>().items,
          tag: "coffee"
        )
      );
    }
  }
}