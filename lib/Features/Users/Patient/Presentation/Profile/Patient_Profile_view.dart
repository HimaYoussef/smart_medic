import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/Login.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Supervision_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Profile.dart';
import 'package:smart_medic/core/functions/routing.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

class PatientProfileView extends StatefulWidget {
  const PatientProfileView({super.key});

  @override
  State<PatientProfileView> createState() => _PatientProfileViewState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

User? user;
String? UserID;

Future<void> _getUser() async {
  user = FirebaseAuth.instance.currentUser;
  print(user?.displayName);
  UserID = user?.uid;
}

@override
void initState() {
  _getUser();
}

Future _signOut() async {
  await _auth.signOut();
}

class _PatientProfileViewState extends State<PatientProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Light grey background
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Updated Profile Card (Matches Image)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Profile Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Rounded image
                    child: Image.asset(
                      'assets/avatar2.png', // Replace with actual profile image
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing

                  // User Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name : Mayada',
                        style: getbodyStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        'Age : 21',
                        style: getbodyStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.color1,
                      child: Icon(
                        Icons.notifications_sharp,
                        color: AppColors.white,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacing before settings section

            // Settings Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dark Mode Toggle
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: AppColors.color1),
                    title: const Text('Dark Mode'),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  const Divider(),

                  // Supervisor Section
                  ListTile(
                    leading:
                        Icon(Icons.supervisor_account, color: AppColors.color1),
                    title: const Text('Supervisor'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupervisorsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // Language Change Option
                  ListTile(
                    leading: Icon(Icons.language, color: AppColors.color1),
                    title: const Text('Change Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Add functionality for language change
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: Icon(Icons.logout, color: AppColors.color1),
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      pushAndRemoveUntil(context, RoleSelectionScreen());

                      _signOut();
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
