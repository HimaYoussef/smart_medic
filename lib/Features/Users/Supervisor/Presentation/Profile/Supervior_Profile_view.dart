import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import '../../../../../main.dart';

class Supervior_Profile_view extends StatefulWidget {
  const Supervior_Profile_view({super.key});

  @override
  State<Supervior_Profile_view> createState() => _nameState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;


User? user;
String? UserID;

Future<void> _getUser() async {
  user = FirebaseAuth.instance.currentUser;
  print(user?.displayName);
  UserID = user?.uid;
}


Future _signOut() async {
  await _auth.signOut();
}
class _nameState extends State<Supervior_Profile_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
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
                      backgroundColor: AppColors.mainColor,
                      child: Icon(
                        Icons.notifications_sharp,
                        color: AppColors.white,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings Options
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cointainerDarkColor
                    : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.dark_mode,
                      color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,),
                    title: const Text('Dark Mode'),
                    trailing: ValueListenableBuilder<ThemeMode>(
                      valueListenable: MainApp.themeNotifier,
                      builder: (context, currentMode, child) {
                        return Switch(
                          value: currentMode == ThemeMode.dark, // تحديث الحالة بناءً على الثيم الحالي
                          onChanged: (value) {
                            MainApp.themeNotifier.value =
                            value ? ThemeMode.dark : ThemeMode.light; // تحديث الثيم
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.language, color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,),
                    title: const Text('Change Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Add functionality for language change
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.mainColorDark
                        : AppColors.mainColor,),
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoleSelectionScreen(),
                        ),
                      );


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
