import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Add_Supervisor.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/SupervisorCard.dart';
import 'package:smart_medic/core/utils/Colors.dart';

// Stateless widget for displaying the list of supervisors
class SupervisorsScreen extends StatelessWidget {
  const SupervisorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background for contrast
      appBar: AppBar(
        title: const Text(
          'Supervisors',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Centers the title in the AppBar
        elevation: 0, // Removes AppBar shadow for a cleaner UI
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          children: [
            // Button to Add a New Supervisor
            SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color1, // Primary app color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded edges
                  ),
                ),
                onPressed: () {
                  // Navigates to the Add Supervisor screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Add_SuperVisor(),
                    ),
                  );
                },
                child: const Text(
                  'Add Supervisors',
                  style:
                      TextStyle(color: Colors.white), // White text for contrast
                ),
              ),
            ),
            const SizedBox(height: 16), // Spacing before the supervisor list

            // List of Supervisors
            Expanded(
              child: ListView(
                children: const [
                  // Supervisor 1
                  SupervisorCard(
                    name: "Ahmed",
                    email: "Ahmed@gmail.com",
                    type: "Doctor",
                    avatar: 'assets/avatar1.png', // Avatar image path
                  ),
                  SizedBox(height: 12), // Spacing between supervisor cards

                  // Supervisor 2
                  SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family",
                    avatar: 'assets/avatar2.png', // Avatar image path
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
