import 'package:flutter/material.dart';

class CheckoutPreviewButton extends StatelessWidget {
  final VoidCallback callback;
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