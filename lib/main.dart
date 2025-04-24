import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/nav_bar.dart';
import 'dart:async';
import 'Features/Auth/Presentation/view_model/Cubits/LoginCubit/login_cubit.dart';
import 'Features/Auth/Presentation/view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
import 'Services/firebaseServices.dart';
import 'Theme/themes.dart';

Future<void> main() async {
  //--- initilaize firebase on my app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDV-Qnv-_7vxGZ1Wa_WC7aVGLLAwZHJ5hQ',
          appId: 'com.example.smart_medic',
          messagingSenderId: '352505676305',
          projectId: 'smartmedicbox-2025'));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox<String>('pendingMessages');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => SignUpCubit()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: currentMode,
              home: const AuthCheck(),
              builder: (context, child) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: child!,
                );
              },
            ),
          );
        });
  }
}


class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return  RoleSelectionScreen();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return  RoleSelectionScreen();
        }

        User user = snapshot.data!;

        return FutureBuilder<Map<String, dynamic>?>(
          future: SmartMedicalDb.getUserById(user.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userSnapshot.hasError) {
              return  RoleSelectionScreen();
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return  RoleSelectionScreen();
            }

            String userType = userSnapshot.data!['type']?.toString().trim().toLowerCase() ?? 'patient';

            if (userType == 'patient') {
              return const PatientHomeView();
            } else if (userType == 'supervisor') {
              return const SupervisorHomeView();
            } else {
              return  RoleSelectionScreen();
            }
          },
        );
      },
    );
  }
}