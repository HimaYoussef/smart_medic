import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Patient_Main_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Awareness/Patient_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Logs/Patient_Logs_View..dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Patient_Profile_view.dart';

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
      body: SafeArea(
        child: screens[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
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
    );
  }

  Widget _buildNavItem(String asset, int index) {
    bool isSelected = index == currentIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          asset,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.blue : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
