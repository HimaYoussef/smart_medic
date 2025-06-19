import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/Edit_Profile.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import '../../../../../Services/firebaseServices.dart';
import '../../../../../core/widgets/changePassPage.dart';
import '../../../../../main.dart';

class Supervior_Profile_view extends StatefulWidget {
  const Supervior_Profile_view({super.key});

  @override
  State<Supervior_Profile_view> createState() => _SuperviorProfileViewState();
}

class _SuperviorProfileViewState extends State<Supervior_Profile_view> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    setState(() {
      _isLoading = true;
    });
    user = _auth.currentUser;
    if (user != null) {
      var result = await SmartMedicalDb.getUserById(user!.uid);
      if (result != null) {
        setState(() {
          userProfile = result;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error fetching profile',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  RoleSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("Please log in to view your profile"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card
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
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/avatar1.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${userProfile?['name'] ?? user?.displayName ?? 'Unknown'}',
                          style: getbodyStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Age: ${userProfile?['age']?.toString() ?? 'Not set'}',
                          style: getbodyStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Edit_Profile(),
                        ),
                      ).then((_) => _getUser()); // Refresh profile after edit
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings Section
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cointainerDarkColor
                    : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
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
                    leading: Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                    title: const Text('Dark Mode'),
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
                  const Divider(),
                  // Language Change Option
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                    title: const Text('Change Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Add functionality for language change
                    },
                  ),
                  const Divider(),
                  // Password Change Option
                  ListTile(
                    leading: Icon(
                      Icons.lock_reset,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                    title: const Text('Change Password '),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Log out
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                    title: const Text('Log out'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _signOut,
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