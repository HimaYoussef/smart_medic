import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Patient_Main_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Awareness/Patient_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Logs/Patient_Logs_View..dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Patient_Profile_view.dart';
import 'package:smart_medic/Features/Users/Supervisor/Presentation/Awareness/Supervior_Awareness_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';

/// This is the main home screen for the **Patient** user,
/// containing a bottom navigation bar with multiple sections.
class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  /// Keeps track of the currently selected index in the bottom navigation bar.
  /// Default is set to `1` (Home page).
  int currentIndex = 1;

  /// List of screens associated with each navigation item.
  final List<Widget> screens = [
    const Patient_Awareness_View(), // Awareness Page (Index 0)
    const PatientMainView(), // Home Page (Index 1)
    const PatientLogsView(), // Logs Page (Index 2)
    const PatientProfileView(), // Profile Page (Index 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Displays the currently selected screen based on `currentIndex`
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
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2), // Moves shadow above navigation bar
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// The main Bottom Navigation Bar
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: false, // Hide text labels for a clean UI
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              selectedItemColor: AppColors.color1, // Active item color
              unselectedItemColor: Colors.grey, // Inactive items color
              elevation: 0, // Removes default shadow
              onTap: (index) {
                if (index == 2) return; // Pills Icon is not selectable
                setState(() {
                  /// If index > 2, adjust it to keep `Pills` icon static.
                  currentIndex = index > 2 ? index - 1 : index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Awareness.svg', 0),
                  label: 'Awareness',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Home.svg', 1),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const SizedBox(width: 50), // Space for Pills icon
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Logs.svg', 2),
                  label: 'Logs',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItem('assets/Profile.svg', 3),
                  label: 'Profile',
                ),
              ],
            ),

            /// Pills Icon floating above the navigation bar
            Positioned(
              bottom: 25, // Adjusted for better alignment
              child: _buildPillsIcon(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds each individual navigation item (icon + indicator if selected).
  Widget _buildNavItem(String asset, int index) {
    bool isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (index == 2) return; // Prevent selecting Pills icon
        setState(() {
          currentIndex = index > 2 ? index - 1 : index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Navigation icon (SVG image)
          SvgPicture.asset(
            asset,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? AppColors.color1
                  : Colors.grey, // Change color if selected
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
                shape: BoxShape.circle, // Small dot indicator for active tab
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the floating Pills icon in the center of the navigation bar.
  Widget _buildPillsIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Slight shadow for contrast
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/pills.svg', // Ensure this file exists in assets
        height: 30, // Adjusted size for better visibility
      ),
    );
  }
}
