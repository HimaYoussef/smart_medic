import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/nav_bar.dart';
import 'package:smart_medic/core/functions/routing.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

/// **Home Screen**
/// This screen serves as a **selection page**, allowing users to navigate to either the **Patient** or **Supervisor** home views.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers items horizontally
        mainAxisAlignment: MainAxisAlignment.center, // Centers items vertically
        children: [
          /// **Button to Navigate to Patient Home View**
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Adds spacing around the button
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10.0), // Adds spacing inside the container
              child: SizedBox(
                width: double.infinity, // Makes button stretch to full width
                height: 45, // Sets button height
                child: ElevatedButton(
                  onPressed: () {
                    /// **Navigates to the Patient Home View**
                    pushTo(context, PatientHomeView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1, // Uses primary app color
                    elevation: 2, // Adds a slight shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'To Patient', // Button label
                    style: getbodyStyle(
                        color: AppColors.white), // Uses app's text styling
                  ),
                ),
              ),
            ),
          ),

          /// **Button to Navigate to Supervisor Home View**
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Adds spacing around the button
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10.0), // Adds spacing inside the container
              child: SizedBox(
                width: double.infinity, // Makes button stretch to full width
                height: 45, // Sets button height
                child: ElevatedButton(
                  onPressed: () {
                    /// **Navigates to the Supervisor Home View**
                    pushTo(context, SupervisorHomeView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1, // Uses primary app color
                    elevation: 2, // Adds a slight shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'To Supervisor', // Button label
                    style: getbodyStyle(
                        color: AppColors.white), // Uses app's text styling
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
