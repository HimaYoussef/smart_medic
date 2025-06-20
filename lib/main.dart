import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/login.dart';
import 'package:smart_medic/Features/Users/Maintainer/Maintainer_view.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/nav_bar.dart';
import 'package:smart_medic/LocalProvider.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/Services/notificationService.dart';
import 'package:smart_medic/ShowcaseProvider.dart';
import 'package:smart_medic/generated/l10n.dart';
import 'package:workmanager/workmanager.dart';
import 'Features/Auth/Presentation/view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
import 'Theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyDV-Qnv-_7vxGZ1Wa_WC7aVGLLAwZHJ5hQ',
          appId: 'com.example.smart_medic',
          messagingSenderId: '352505676305',
          projectId: 'smartmedicbox-2025',
        ),
      );
      await LocalNotificationService.init();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        LocalNotificationService.processQueuedNotifications();
      }
    } catch (e) {
      print('Error in background task: $e');
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDV-Qnv-_7vxGZ1Wa_WC7aVGLLAwZHJ5hQ',
      appId: 'com.example.smart_medic',
      messagingSenderId: '352505676305',
      projectId: 'smartmedicbox-2025',
    ),
  );

  final appDocumentDir = await getApplicationDocumentsDirectory();

  // تنفيذ جميع المهام المتوازية دفعة واحدة
  await Future.wait([
    initHive(appDocumentDir.path),
    initNotifications(),
    initWorkManager(),
    setOrientation(),
  ]);

  // تسجيل تاسك WorkManager
  Workmanager().registerPeriodicTask(
    "check-notifications",
    "checkNotificationsTask",
    frequency: const Duration(minutes: 15),
  );

  // runApp(
  //   ChangeNotifierProvider(
  //     create: (BuildContext context) => LocaleProvider(),
      
  //     child: const MainApp(),
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => ShowcaseProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

Future<void> initHive(String path) async {
  await Hive.initFlutter(path);
  await Hive.openBox<String>('pendingMessages');
}

Future<void> initNotifications() async {
  await LocalNotificationService.init();
}

Future<void> initWorkManager() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
}

Future<void> setOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MainApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => SignUpCubit()),
          ],
          child: ShowCaseWidget(
            builder: (context) => MaterialApp(
              locale: localeProvider.locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: currentMode,
              home: const AuthCheck(),
              builder: (context, child) {
                return Directionality(
                  textDirection: localeProvider.locale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: child!,
                );
              },
            ),
          ),
        );
      },
    );
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

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return LoginScreen();
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

            if (userSnapshot.hasError ||
                !userSnapshot.hasData ||
                userSnapshot.data == null) {
              return LoginScreen();
            }

            String userType =
                userSnapshot.data!['type']?.toString().trim().toLowerCase() ??
                    'patient';

            if (userType == 'patient') {
              return const PatientHomeView();
            } else if (userType == 'supervisor') {
              return const SupervisorHomeView();
            } else if (userType == 'maintainer') {
              return const MaintainerView();
            } else {
              return LoginScreen();
            }
          },
        );
      },
    );
  }
}
