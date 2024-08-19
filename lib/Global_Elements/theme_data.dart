import 'package:flutter/material.dart';
import 'package:terra_tutor/Global_Elements/colors.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  static final ThemeData defaultTheme = ThemeData(
    primaryColor: AppColors.navBar,
    scaffoldBackgroundColor: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.navBar,
      iconTheme: IconThemeData(color: AppColors.menuIconClicked),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.deleteButton,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColorsAlternativeTropicalGarden.fontColor),
      headlineLarge: TextStyle(color: Colors.black, fontSize: 24),
    ),
    cardColor:
        AppColors.menuIconHighLight, // Needs to stay menuIconHighLight variable
  ); // Set ui tiles to proper color

  static final ThemeData tropicalGardenTheme = ThemeData(
      primaryColor: AppColorsAlternativeTropicalGarden.navBar,
      scaffoldBackgroundColor: AppColorsAlternativeTropicalGarden.primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsAlternativeTropicalGarden.navBar,
        iconTheme: IconThemeData(
            color: AppColorsAlternativeTropicalGarden.menuIconClicked),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColorsAlternativeTropicalGarden.deleteButton,
      ),
      textTheme: const TextTheme(
        bodyLarge:
            TextStyle(color: AppColorsAlternativeTropicalGarden.fontColor),
        headlineLarge:
            TextStyle(color: AppColorsAlternativeTropicalGarden.fontColor),
      ),
      cardColor: AppColorsAlternativeTropicalGarden.uiTile,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
      ));

  static final ThemeData woodlandForestTheme = ThemeData(
      primaryColor: AppColorsAlternativeWoodlandForest.navBar,
      scaffoldBackgroundColor:
          AppColorsAlternativeWoodlandForest.scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsAlternativeWoodlandForest.navBar,
        iconTheme: IconThemeData(
            color: AppColorsAlternativeWoodlandForest.menuIconClicked),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColorsAlternativeWoodlandForest.deleteButton,
      ),
      textTheme: const TextTheme(
        bodyLarge:
            TextStyle(color: AppColorsAlternativeWoodlandForest.fontColor),
        headlineLarge:
            TextStyle(color: AppColorsAlternativeWoodlandForest.whiteFont),
      ),
      cardColor: AppColorsAlternativeWoodlandForest.uiTile,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
      ));

  static final ThemeData highDesertTheme = ThemeData(
      primaryColor: AppColorsAlternativeHighDesert.navBar,
      scaffoldBackgroundColor:
          AppColorsAlternativeHighDesert.scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsAlternativeHighDesert.navBar,
        iconTheme: IconThemeData(
            color: AppColorsAlternativeHighDesert.menuIconClicked),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColorsAlternativeHighDesert.deleteButton,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColorsAlternativeHighDesert.fontColor),
        headlineLarge:
            TextStyle(color: AppColorsAlternativeHighDesert.fontColor),
      ),
      cardColor: AppColorsAlternativeHighDesert.uiTile,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
      ));

  static final ThemeData redwoodForestTheme = ThemeData(
      primaryColor: AppColorsAlternativeRedwoodForest.navBar,
      scaffoldBackgroundColor:
          AppColorsAlternativeRedwoodForest.scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsAlternativeRedwoodForest.navBar,
        iconTheme: IconThemeData(
            color: AppColorsAlternativeRedwoodForest.menuIconClicked),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColorsAlternativeRedwoodForest.deleteButton,
      ),
      textTheme: const TextTheme(
        bodyLarge:
            TextStyle(color: AppColorsAlternativeRedwoodForest.fontColor),
        headlineLarge:
            TextStyle(color: AppColorsAlternativeRedwoodForest.fontColor),
      ),
      cardColor: AppColorsAlternativeRedwoodForest.uiTile,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
      ));

  static final ThemeData arcticGardenTheme = ThemeData(
      primaryColor: AppColorsAlternativeArcticGarden.navBar,
      scaffoldBackgroundColor:
          AppColorsAlternativeArcticGarden.scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColorsAlternativeArcticGarden.navBar,
        iconTheme: IconThemeData(
            color: AppColorsAlternativeArcticGarden.menuIconClicked),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColorsAlternativeArcticGarden.fontColor),
        headlineLarge:
            TextStyle(color: AppColorsAlternativeArcticGarden.fontColor),
      ),
      cardColor: AppColorsAlternativeArcticGarden.uiTile,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Color.fromRGBO(255, 255, 255, 1)),
      ));
}
