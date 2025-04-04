import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/utils/Colors.dart';
import '../core/utils/Style.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.mainColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      snackBarTheme: SnackBarThemeData(backgroundColor: AppColors.mainColor),
      appBarTheme: AppBarTheme(
        titleTextStyle: getTitleStyle(color: AppColors.black),
        centerTitle: true,
        elevation: 0.0,
        actionsIconTheme: IconThemeData(color: AppColors.mainColor),
        backgroundColor: AppColors.app_parColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.only(
          left: 20,
          top: 10,
          bottom: 10,
          right: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: AppColors.black, width: 10),
        ),
        hintStyle: getbodyStyle(color: Colors.grey),
        fillColor: AppColors.textFieldColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.black),
        bodyMedium: TextStyle(color: AppColors.black),
        displayLarge: TextStyle(color: AppColors.mainColor),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.black,
        indent: 10,
        endIndent: 10,
      ),
      fontFamily: GoogleFonts.cairo().fontFamily,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.mainColor),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.mainColor,  // اللون الأساسي للزر
      textTheme: ButtonTextTheme.primary,),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(339, 49),  // تحديد حجم الزر
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.mainColor,  // لون خلفية النافبار
      selectedItemColor: AppColors.mainColor,  // اللون عند اختيار أي عنصر
      unselectedItemColor: Colors.grey,  // اللون عند عدم اختيار العنصر
      elevation: 10,  // تأثير الظل
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainColor,
      shape: const CircleBorder()
    )
  );


  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0F3A57),  // أزرق داكن
    scaffoldBackgroundColor: const Color(0xFF121212),  // خلفية داكنة
    snackBarTheme: const SnackBarThemeData(backgroundColor: Color(0xFF0F3A57),),  // لون الخلفية للـ Snackbar
    appBarTheme: AppBarTheme(
      titleTextStyle: getTitleStyle(color: Colors.white),
      centerTitle: true,
      elevation: 0.0,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF0F3A57),  // نفس اللون الأزرق الداكن
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.only(
        left: 20,
        top: 10,
        bottom: 10,
        right: 20,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      hintStyle: getbodyStyle(color: Colors.white60),
      fillColor: const Color(0xFF212121),  // لون الحقل
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFEF5050)),  // اللون الأحمر للخطأ
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFEF5050)),  // اللون الأحمر للخطأ
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      displayLarge: TextStyle(color: Color(0xFF2DA9E1)),  // اللون الأزرق الفاتح
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.white,
      indent: 10,
      endIndent: 10,
    ),
    fontFamily: GoogleFonts.cairo().fontFamily,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0xFF2DA9E1)),  // الأزرق الفاتح
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF0F3A57),  // الأزرق الداكن
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F3A57),  // الأزرق الداكن
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(339, 49),  // تحديد حجم الزر
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //backgroundColor: Color(0xFF212121),
      selectedItemColor: Color(0xFF006C8E),
      unselectedItemColor: Colors.grey,
      elevation: 10,  // تأثير الظل
    ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.mainColorDark,
          shape: const CircleBorder()
      ),

  );
}
