import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Profile.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class Supervior_Profile_view extends StatefulWidget {
  const Supervior_Profile_view({super.key});

  @override
  State<Supervior_Profile_view> createState() => _nameState();
}

class _nameState extends State<Supervior_Profile_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, spreadRadius: 2),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 8), // Space from top
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person,
                              size: 40, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ahmed Ali',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Ahmed@gmail.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Text(
                        'Age 22',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  // Edit Icon Positioned Exactly at Top Right Edge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black54),
                      onPressed: () {
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
            const SizedBox(height: 20),

            // Settings Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.dark_mode, color: AppColors.color1),
                    title: const Text('Dark Mode'),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.language, color: AppColors.color1),
                    title: const Text('Change Language'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
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
