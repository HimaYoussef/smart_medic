// Importing required packages for building the supervisor card.
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Supervisor.dart';
import 'package:smart_medic/core/utils/Colors.dart';

// SupervisorCard widget displays supervisor details and an "Edit" button.
class SupervisorCard extends StatelessWidget {
  final String name; // Supervisor's name.
  final String email; // Supervisor's email.
  final String type; // Supervisor's type (e.g., admin, supervisor).
  final String avatar; // Supervisor's avatar image path.

  const SupervisorCard({
    super.key,
    required this.name,
    required this.email,
    required this.type,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.color1, // Card color from the app's theme.
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title showing that this is a Supervisor card.
          const Text(
            'Supervisor',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Display supervisor's avatar.
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(avatar), // Avatar from assets.
              ),
              const SizedBox(width: 12),
              // Supervisor details (name, email, type).
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Gmail: $email',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    'Type: $type',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // "Edit" button that navigates to the Edit Supervisor screen.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Edit_SuperVisor(),
                  ),
                );
              },
              child: const Text('Edit', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
