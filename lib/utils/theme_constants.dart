import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../enums/color_constants.dart';


/* -------- THIS IS A THEME CONSTANTS SO THAT WE CAN HAVE A LIGHT AND DARK THEME -------- */
/* -------- 17-Jan-2023 -------- */

enum AppTheme {
  light,
}

final Map<AppTheme, ThemeData> kAppThemeData = {
  AppTheme.light: ThemeData.light().copyWith(
    primaryColor: darkPurple,
    scaffoldBackgroundColor: whiteColor,
    canvasColor: dashColor,
    splashColor: darkPurple.withOpacity(0.1),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    useMaterial3: true,
    textTheme: const TextTheme().copyWith(
      displayLarge: TextStyle(
        fontSize: 64.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      displayMedium: TextStyle(
        fontSize: 32.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 22.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 12.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          whiteColor,
        ),
        backgroundColor: MaterialStateProperty.all(
          darkPurple,
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.black.withOpacity(0.5),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: darkPurple,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: whiteColor,
      ),
      iconTheme: const IconThemeData(
        color: whiteColor,
      ),
      actionsIconTheme: const IconThemeData(
        color: whiteColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: darkPurple,
      selectedIconTheme: IconThemeData(
        color: darkPurple,
        size: 24.sp,
      ),
      elevation: 0,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),

    colorScheme: const ColorScheme.light().copyWith(
      background: greyDark,
      surface: greyLight,
      primary: darkPurple,
      secondary: lightBlue,
    ).copyWith(background: greyDark).copyWith(error: redColor),
  ),
};
