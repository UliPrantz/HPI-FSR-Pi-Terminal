import 'package:flutter/material.dart';
import 'package:terminal_frontend/presentation/core/styles/colors.dart';

class TextStyles {
  static const TextStyle loadingTextStyle = TextStyle(
      color: AppColors.mainColor,
      fontFamily: 'Montserrat',
      letterSpacing: 5.0,
      fontWeight: FontWeight.bold,
      fontSize: 80.0);

  static const TextStyle errorTextStyle = TextStyle(
    color: AppColors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
  );

  static const TextStyle errorButtonTextStyle = TextStyle(
    color: AppColors.darkTextColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
  );

  static const TextStyle appBarText = TextStyle(
    color: AppColors.brightTextColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle appBarButton = TextStyle(
    color: AppColors.darkTextColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle normalTextWhite = TextStyle(
    color: AppColors.white,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle normalTextBlack = TextStyle(
    color: AppColors.darkTextColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle normalTextBlackBold = TextStyle(
    color: AppColors.darkTextColor,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mainTextBigBright = TextStyle(
      color: AppColors.brightTextColor,
      fontSize: 30.0,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold);

  static const TextStyle mainTextBigDark = TextStyle(
      color: AppColors.darkTextColor,
      fontFamily: 'Montserrat',
      fontSize: 30.0,
      fontWeight: FontWeight.bold);

  static const TextStyle boldTextMediumDark = TextStyle(
      color: AppColors.darkTextColor,
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold);

  static const TextStyle boldTextMediumBright = TextStyle(
      color: AppColors.brightTextColor,
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold);

  static const TextStyle normalTextMediumDark = TextStyle(
      color: AppColors.darkTextColor, fontFamily: 'Montserrat', fontSize: 20.0);

  static const TextStyle checkOutScreenText = TextStyle(
      fontFamily: 'Montserrat',
      color: AppColors.white,
      fontSize: 40.0,
      fontWeight: FontWeight.bold);

  static const TextStyle priceText =
      TextStyle(fontFamily: 'Montserrat', fontSize: 16);
}
