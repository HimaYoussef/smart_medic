import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Add_Supervisor.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/SupervisorCard.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

class SupervisorsScreen extends StatelessWidget {
  const SupervisorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Matches design background
      appBar: AppBar(
        title: const Text(
          'Supervisors',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ], // Removes shadow for a clean UI
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of Supervisors
            Expanded(
              child: ListView(
                children: const [
                  SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family",
                  ),
                  SizedBox(height: 12),
                  SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family",
                  ),
                  SizedBox(height: 12),
                  SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.color1,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Add_SuperVisor(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        shape: const CircleBorder(), // Ensures it remains a perfect circle
      ),
    );
  }
}

// Custom Supervisor Card Widget
