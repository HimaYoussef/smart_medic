import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/Supervior_Main_view.dart';
import 'package:smart_medic/Features/Users/Supervisor/Presentation/Awareness/Supervior_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Supervisor/Presentation/Profile/Supervior_Profile_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class Supervisor_HomeView extends StatefulWidget {
  const Supervisor_HomeView({super.key});

  @override
  State<Supervisor_HomeView> createState() => _Supervisor_HomeViewState();
}

class _Supervisor_HomeViewState extends State<Supervisor_HomeView> {
  int currentIndex = 1; // Home is selected by default

  final List<Widget> screens = [
    const Supervior_Main_view(), // Home Page
    const Supervisor_Awareness_View(), // Awareness Page
    const Supervior_Profile_view(), // Profile Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screens[currentIndex],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Ensures Pills icon is not clipped
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              selectedItemColor: Colors.blue, // Active item color
              unselectedItemColor: Colors.grey, // Inactive items
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
                  icon: _buildNavItem('assets/Awareness.svg', 1),
                  label: 'Awareness',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Profile.svg', 2),
                  label: 'Profile',
                ),
              ],
            ),
          ),
          // Pills Icon Positioned Above the Navigation Bar
          // Positioned(
          //   bottom: 35, // Ensures it's correctly floating
          //   child: _buildPillsIcon(),
          // ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String asset, int index) {
    bool isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            asset,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColors.color1 : Colors.grey, // Blue for selected
              BlendMode.srcIn,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.color1,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildPillsIcon() {
  //   return Container(
  //     width: 20, // Increased width to match design
  //     height: 60, // Adjusted height for better visibility
  //     padding: const EdgeInsets.all(12), // Ensures spacing
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 10,
  //           spreadRadius: 3,
  //         ),
  //       ],
  //     ),
  //     child: SvgPicture.asset(
  //       'assets/pills.svg', // Ensure this file exists in assets
  //       height: 32, // Adjusted size for correct visibility
  //     ),
  //   );
  // }
}
