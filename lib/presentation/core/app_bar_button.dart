import 'package:flutter/material.dart';

import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class AppBarButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const AppBarButton({ 
    Key? key, 
    required this.text, 
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.fsrYellow.withOpacity(0.5)
        ),

        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: AppColors.white)
          )
        )
      ),
      onPressed: callback, 
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 9.0
        ),
        child: Text(
          text,
          style: TextStyles.appBarButton
        ),
      ),
    );
  }
}