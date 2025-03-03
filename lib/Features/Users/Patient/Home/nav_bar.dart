import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Patient_Main_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Awareness/Patient_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Logs/Patient_Logs_View..dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Patient_Profile_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const PatientMainView(),
    const PatientLogsView(),
    const PatientAwarenessView(),
    const PatientProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          height: 53,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.white,
              currentIndex: currentIndex,
              selectedItemColor: Colors.blue, // Active icon color
              unselectedItemColor: Colors.grey, // Inactive icon color
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Home.svg', 0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Logs.svg', 1),
                  label: 'Logs',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Awareness.svg', 2),
                  label: 'Awareness',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Profile.svg', 3),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        body: screens[currentIndex]);
  }

  Widget _buildNavItem(String asset, int index) {
    bool isSelected = index == currentIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          asset,
          height: 18,
          width: 18,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.blue : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
