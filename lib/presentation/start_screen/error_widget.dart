import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        // TODO add better error handling
        "Failed to connect to backend",
        style: TextStyles.errorTextStyle,
      )
    );
  }
}