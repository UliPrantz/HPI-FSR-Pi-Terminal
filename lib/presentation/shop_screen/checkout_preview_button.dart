import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';

class CheckoutPreviewButton extends StatelessWidget {
  final VoidCallback? callback;
  final Widget child;

  const CheckoutPreviewButton({
    Key? key,
    required this.callback,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.disabled)) {
            return AppColors.fsrYellow;
          }
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          )
        )
      ),
      child: child
    );
  }
}