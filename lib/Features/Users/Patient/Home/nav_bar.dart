import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Patient_Main_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Awareness/Patient_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Logs/Patient_Logs_View..dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Patient_Profile_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smart_medic/generated/l10n.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  _PatientHomeViewState createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  int currentIndex = 0;
  final GlobalKey _homeKey = GlobalKey(); // Key for Home tab showcase
  final GlobalKey _logsKey = GlobalKey(); // Key for Logs tab showcase
  final GlobalKey _awarenessKey = GlobalKey(); // Key for Awareness tab showcase
  final GlobalKey _profileKey = GlobalKey(); // Key for Profile tab showcase

  // Pass all nav bar keys to PatientMainView
  late final List<Widget> screens = [
    PatientMainView(
        navBarKeys: [_homeKey, _logsKey, _awarenessKey, _profileKey]),
    const PatientLogsView(),
    const PatientAwarenessView(),
    const PatientProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045, // 4.5% of screen width
          vertical: screenHeight * 0.025, // 2.5% of screen height
        ),
        height: screenHeight * 0.0706, // 7% of screen height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.nav_parColor
                : AppColors.nav_parColor,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Showcase(
                  key: _homeKey,
                  description: S.of(context).Nav_bar_Home,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.black,
                  descTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04, // 4% of screen width
                    fontWeight: FontWeight.bold,
                  ),
                  tooltipPadding: EdgeInsets.all(screenWidth * 0.025),
                  child: SizedBox(
                    height: screenHeight * 0.03, // 3% of screen height
                    child: const Icon(Icons.home),
                  ),
                ),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: _logsKey,
                  description: S.of(context).Nav_bar_Logs,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.black,
                  descTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  tooltipPadding: EdgeInsets.all(screenWidth * 0.025),
                  child: SizedBox(
                    height: screenHeight * 0.03,
                    child: const Icon(Icons.access_time),
                  ),
                ),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: _awarenessKey,
                  description: S.of(context).Nav_bar_Awar,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.black,
                  descTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  tooltipPadding: EdgeInsets.all(screenWidth * 0.025),
                  child: SizedBox(
                    height: screenHeight * 0.03,
                    child: const Icon(Icons.article),
                  ),
                ),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
              BottomNavigationBarItem(
                icon: Showcase(
                  key: _profileKey,
                  description: S.of(context).Nav_bar_Profile,
                  tooltipBackgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.black,
                  descTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  tooltipPadding: EdgeInsets.all(screenWidth * 0.025),
                  child: SizedBox(
                    height: screenHeight * 0.03,
                    child: const Icon(Icons.person),
                  ),
                ),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
            ],
          ),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
