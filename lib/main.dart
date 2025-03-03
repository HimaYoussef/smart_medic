import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/Login.dart';
import 'package:smart_medic/Features/Auth/Presentation/view_model/auth_cubit.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Home.dart';
import 'dart:async';

import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

Future<void> main() async {
  //--- initilaize firebase on my app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDV-Qnv-_7vxGZ1Wa_WC7aVGLLAwZHJ5hQ',
          appId: 'com.example.smart_medic',
          messagingSenderId: '352505676305',
          projectId: 'smartmedicbox-2025'));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => AuthCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            snackBarTheme:
                SnackBarThemeData(backgroundColor: AppColors.redColor),
            appBarTheme: AppBarTheme(
              titleTextStyle: getTitleStyle(color: AppColors.white),
              centerTitle: true,
              elevation: 0.0,
              actionsIconTheme: IconThemeData(color: AppColors.color1),
              backgroundColor: AppColors.color1,
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.only(
                left: 20,
                top: 10,
                bottom: 10,
                right: 20,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide.none,
              ),
              hintStyle: getbodyStyle(color: Colors.grey),
              fillColor: AppColors.redColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.white),
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
            dividerTheme: DividerThemeData(
              color: AppColors.black,
              indent: 10,
              endIndent: 10,
            ),
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          home: RoleSelectionScreen(),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
