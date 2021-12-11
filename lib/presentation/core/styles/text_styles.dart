import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';

class TextStyles {
  static const TextStyle loadingTextStyle = TextStyle(
    color: AppColors.fsrYellow,
    letterSpacing: 5.0,
    fontWeight: FontWeight.bold,
    fontSize: 80.0
  );

  static const TextStyle appBarText = TextStyle(
    color: AppColors.darkGrey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mainTextBig = TextStyle(
    color: AppColors.darkGrey,
    fontSize: 30.0,
    fontWeight: FontWeight.bold
  );
}