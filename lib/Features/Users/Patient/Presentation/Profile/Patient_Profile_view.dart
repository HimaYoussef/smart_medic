import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Supervision_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Profile.dart';
import 'package:smart_medic/core/utils/Colors.dart';

// Stateful widget representing the patient's profile screen
class PatientProfileView extends StatefulWidget {
  const PatientProfileView({super.key});

  @override
  State<PatientProfileView> createState() => _PatientProfileViewState();
}

// State class to manage the PatientProfileView UI
class _PatientProfileViewState extends State<PatientProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background for contrast
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Centers the title in the AppBar
        elevation: 0, // Removes AppBar shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // Rounded edges
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, spreadRadius: 2),
                ], // Adds a subtle shadow for depth
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 8), // Spacing from the top
                      Center(
                        child: CircleAvatar(
                          radius: 40, // Avatar size
                          backgroundColor:
                              Colors.grey[300], // Placeholder color
                          child: const Icon(Icons.person,
                              size: 40,
                              color: Colors.black), // Default user icon
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ahmed Ali', // User's name
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Ahmed@gmail.com', // Email address
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Text(
                        'Age 22', // User's age
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  // Edit Icon Positioned at the Top Right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black54),
                      onPressed: () {
                        // Navigates to the Edit Profile screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Edit_Profile(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacing before settings section

            // Settings Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // Rounded edges
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, spreadRadius: 2),
                ], // Adds a subtle shadow
              ),
              child: Column(
                children: [
                  // Dark Mode Toggle
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: AppColors.color1),
                    title: const Text('Dark Mode'),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  const Divider(), // Divider for separation

                  // Supervisor Section
                  ListTile(
                    leading:
                        Icon(Icons.supervisor_account, color: AppColors.color1),
                    title: const Text('Supervisor'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigates to the Supervisors screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupervisorsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(), // Divider for separation

                  // Language Change Option
                  ListTile(
                    leading: Icon(Icons.language, color: AppColors.color1),
                    title: const Text('Change Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Add functionality for language change
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
