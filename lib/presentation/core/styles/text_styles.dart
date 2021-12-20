import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';

class TextStyles {
  static const TextStyle loadingTextStyle = TextStyle(
    color: AppColors.fsrYellow,
    letterSpacing: 5.0,
    fontWeight: FontWeight.bold,
    fontSize: 80.0
  );

  static const TextStyle errorTextStyle = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
  );

  static const TextStyle errorButtonTextStyle = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
  );

  static const TextStyle appBarText = TextStyle(
    color: AppColors.darkGrey,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle appBarButton = TextStyle(
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle normalTextWhite = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle normalTextBlack = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle normalTextBlackBold = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mainTextBig = TextStyle(
    color: AppColors.darkGrey,
    fontSize: 30.0,
    fontWeight: FontWeight.bold
  );

  static const TextStyle checkOutScreenText = TextStyle(
    color: AppColors.white,
    fontSize: 40.0,
    fontWeight: FontWeight.bold
  );
}