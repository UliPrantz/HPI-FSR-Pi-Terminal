import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/styles.dart';

class PairingSucceededOverlay extends StatelessWidget {
  const PairingSucceededOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.0)),

            // Adding a DefaultTextStyle here because there is no material
            // ancestor in the overlay which would provide one
            child: const DefaultTextStyle(
              style: TextStyles.mainTextBigBright,
              child: Text(
                "Successfully paired!",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
