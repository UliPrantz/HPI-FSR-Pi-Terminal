import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:terminal_frontend/application/start_screen/start_screen_cubit.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Failed to connect to backend\nProbably couldn't reach the server or couldn't authenticate",
            textAlign: TextAlign.center,
            style: TextStyles.errorTextStyle,
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),

          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(AppColors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              )
            ),
            onPressed: GetIt.I<StartScreenCubit>().retry,
            child: const Text(
              "Retry",
              style: TextStyles.errorButtonTextStyle
            )
          )
        ],
      ),
    );
  }
}
