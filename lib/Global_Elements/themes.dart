import 'package:flutter/material.dart';
import 'colors.dart';

class AppThemes {
  static final ThemeData defaultTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.navBar,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.menuIconUnclicked,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.fontColor),
      bodyMedium: TextStyle(color: AppColors.fontColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.deleteButton,
    ),
  );

  static final ThemeData tropicalGardenTheme = ThemeData(
    primaryColor: AppColorsAlternativeTropicalGarden.primaryColor,
    scaffoldBackgroundColor: AppColorsAlternativeTropicalGarden.primaryColor,
    appBarTheme: const AppBarTheme(
      color: AppColorsAlternativeTropicalGarden.navBar,
    ),
    iconTheme: const IconThemeData(
      color: AppColorsAlternativeTropicalGarden.menuIconUnclicked,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColorsAlternativeTropicalGarden.fontColor),
      bodyMedium:
          TextStyle(color: AppColorsAlternativeTropicalGarden.fontColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColorsAlternativeTropicalGarden.deleteButton,
    ),
  );
}
