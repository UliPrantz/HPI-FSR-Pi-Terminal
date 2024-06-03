import 'package:flutter/material.dart' hide ErrorWidget;

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_state.dart';
import 'package:terminal_frontend/presentation/app_router.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';
import 'package:terminal_frontend/presentation/start_screen/error_widget.dart';
import 'package:terminal_frontend/presentation/start_screen/loading_widget.dart';

@RoutePage()
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartScreenCubit, StartScreenState>(
      bloc: GetIt.I<StartScreenCubit>(),
      listener: (context, state) {
        if (state.loadingState == LoadingState.loadingSucceeded) {
          AutoRouter.of(context).replace(ChipScanRoute());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkGrey,
          body: state.loadingState != LoadingState.loadingFailed
              ? const LoadingWidget()
              : const ErrorWidget(),
        );
      },
    );
  }
}
