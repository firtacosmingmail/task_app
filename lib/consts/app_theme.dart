
import 'package:flutter/material.dart';
import 'package:task_app_for_daniel/consts/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.secondaryColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColors.primaryColor,
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        ),
      ),
    );
  }
}