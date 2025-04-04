import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/nav_bar.dart';
import 'dart:async';
import 'Database/firestoreDB.dart';
import 'Features/Auth/Presentation/view_model/Cubits/LoginCubit/login_cubit.dart';
import 'Features/Auth/Presentation/view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
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
              home: AuthCheck(),
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

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    getCurrentUserType();
  }

  void getCurrentUserType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? role = await getUserType(user.uid);
      setState(() {
        userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('there is no user111111111111111');
      return RoleSelectionScreen();
    }
/*
    if (userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // لعرض مؤشر تحميل أثناء جلب البيانات
      );
    }*/

    if (userRole == 'Patient') {
      return const PatientHomeView();
    } else if (userRole == 'Supervisor') {
      return const SupervisorHomeView();
    } else {
      print('there is user111111111111111++++$userRole');
      return RoleSelectionScreen();
    }
  }
}



Future<String?> getUserType(String userId) async {
  try {
    DocumentSnapshot documentSnapshot = await usersCollection.doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.get("type"); // استرجاع التايب
    } else {
      return null; // المستخدم غير موجود
    }
  } catch (e) {
    print("Error getting user type: $e");
    return null; // حدث خطأ أثناء جلب البيانات
  }
}


Future<String> getUserRole() async {
  User user = FirebaseAuth.instance.currentUser!;
  // استرجاع مستند المستخدم من Firestore
  DocumentSnapshot userDoc =
  await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (userDoc.exists) {
    print('${userDoc['type']}+1111111111111111111111111111111');
    return userDoc['type'];
    // استرجاع الدور (role)
  } else {
    print('guest111111111111111111111');
    return 'guest'; // في حالة عدم وجود مستخدم أو مستند
  }
}

