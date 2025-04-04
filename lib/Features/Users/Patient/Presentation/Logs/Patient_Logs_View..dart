import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/LogItem.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

// Stateful widget to display patient logs
class PatientLogsView extends StatefulWidget {
  const PatientLogsView({super.key});

  @override
  State<PatientLogsView> createState() => _PatientLogsViewState();
}

// State class for managing patient logs UI
class _PatientLogsViewState extends State<PatientLogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes AppBar shadow for a cleaner look
        title: const Text(
          'Logs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ], // Centers the title in the AppBar
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Adds uniform padding around content
        child: Column(
          children: [
            // Container to hold the log entries for a specific date
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cointainerDarkColor
                    : AppColors.mainColor,
                     // Background color for the log container
                borderRadius:
                    BorderRadius.circular(16), // Rounded corners for styling
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header for the logs
                  Text(
                    '22/10/2024',
                    style: getTitleStyle(color: AppColors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 25), // Spacing before the log items
                  const Divider(color: Colors.white), // Divider for visual separation

                  // List of log items (medication & health stats)
                  const LogItem(
                      time: "08:00", text: "Paracetamol", isChecked: true),
                  const Divider(
                      color: Colors.white), // Divider between log entries
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
