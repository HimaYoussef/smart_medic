import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/login.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Maintainer/Patient_Data.dart';
import 'package:smart_medic/Features/Users/Maintainer/Superviosr_Data.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/Supervision_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/Edit_Profile.dart';
import 'package:smart_medic/LocalProvider.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../main.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart'; // Import ShowcaseView

class MaintainerView extends StatefulWidget {
  const MaintainerView({super.key});

  @override
  State<MaintainerView> createState() => _MaintainerViewState();
}

class _MaintainerViewState extends State<MaintainerView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey _logoutKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();
  final GlobalKey _darkModeKey = GlobalKey();
  final GlobalKey _SupervisorData = GlobalKey();
  final GlobalKey _PatientData = GlobalKey();

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _SupervisorData,
        _PatientData,
        _darkModeKey,
        _languageKey,
        _logoutKey,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Patient_Profile_view_Profile),
        centerTitle: true,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
              ),
            ],
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cointainerDarkColor
                : AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Showcase(
                key: _SupervisorData,
                tooltipBackgroundColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black,
                descTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                tooltipPadding: EdgeInsets.all(10),
                description: S.of(context).Admin_Profile_Supervisor_Data,
                child: ListTile(
                  leading: Icon(
                    Icons.manage_accounts_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,
                  ),
                  title:
                      Text(S.of(context).Admin_Profile_Supervisor_Data_Display),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SupervisorData(),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              Showcase(
                key: _PatientData,
                tooltipBackgroundColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black,
                descTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                tooltipPadding: EdgeInsets.all(10),
                description: S.of(context).Admin_Profile_Patient_Data,
                child: ListTile(
                  leading: Icon(
                    Icons.manage_accounts_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,
                  ),
                  title: Text(S.of(context).Admin_Profile_Patient_Data_Display),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientData(),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
              Showcase(
                key: _darkModeKey,
                tooltipBackgroundColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black,
                descTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                tooltipPadding: EdgeInsets.all(10),
                description: S
                    .of(context)
                    .Patient_Profile_view_Toggle_between_light_and_dark_themes,
                child: ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,
                  ),
                  title: Text(S.of(context).Patient_Profile_view_Dark_Mode),
                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: MainApp.themeNotifier,
                    builder: (context, currentMode, child) {
                      return Switch(
                        value: currentMode == ThemeMode.dark,
                        onChanged: (value) {
                          MainApp.themeNotifier.value =
                              value ? ThemeMode.dark : ThemeMode.light;
                        },
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              Showcase(
                key: _languageKey,
                tooltipBackgroundColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black,
                descTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                tooltipPadding: EdgeInsets.all(10),
                description:
                    S.of(context).Patient_Profile_view_Switch_between_languages,
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,
                  ),
                  title:
                      Text(S.of(context).Patient_Profile_view_Change_Language),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    if (localeProvider.locale.languageCode == 'en') {
                      localeProvider.setLocale(const Locale('ar'));
                    } else {
                      localeProvider.setLocale(const Locale('en'));
                    }
                  },
                ),
              ),
              const Divider(),
              Showcase(
                key: _logoutKey,
                tooltipBackgroundColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.black,
                descTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                tooltipPadding: EdgeInsets.all(10),
                description:
                    S.of(context).Patient_Profile_view_Sign_out_of_your_account,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,
                  ),
                  title: Text(S.of(context).Patient_Profile_view_Log_out),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _signOut,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
