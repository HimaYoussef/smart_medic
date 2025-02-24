import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Add_Supervisor.dart';
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
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0, // Removes shadow for a clean UI
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
        child: const Icon(Icons.add, color: Colors.white), // Plus icon
      ),
    );
  }
}

// Custom Supervisor Card Widget
class SupervisorCard extends StatelessWidget {
  final String name;
  final String email;
  final String type;

  const SupervisorCard({
    super.key,
    required this.name,
    required this.email,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.color1, // Matches image design
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/avatar2.png'), // Avatar image
        ),
        title: Text(
          'Name: $name',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gmail: $email',
              style: getsmallStyle(color: Colors.white),
            ),
            Text(
              'Type: $type',
              style: getsmallStyle(color: Colors.white),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
