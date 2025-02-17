import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Profile.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/LogItem.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class Logs_view extends StatefulWidget {
  const Logs_view({super.key});

  @override
  State<Logs_view> createState() => _Logs_viewState();
}

class _Logs_viewState extends State<Logs_view> {
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
              child: Column(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.color1,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '22/10/2024',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white),
                  const LogItem(
                      time: "08:00", text: "Paracetamol", isChecked: true),
                  const Divider(color: Colors.white),
                  const LogItem(time: "10:00", text: "SpO2 : 98%", bpm: "72"),
                  const Divider(color: Colors.white),
                  const LogItem(
                      time: "12:00", text: "Paracetamol", isChecked: false),
                  const Divider(color: Colors.white),
                  const LogItem(
                      time: "14:30", text: "Vitamin D", isChecked: true),
                  const Divider(color: Colors.white),
                  const LogItem(
                      time: "20:00", text: "Paracetamol", isChecked: false),
                  const Divider(color: Colors.white),
                  const LogItem(time: "22:00", text: "SpO2 : 97%", bpm: "70"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
