import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/SupervisorCard.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/Widgets/Supervision_card.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class Supervior_Main_view extends StatefulWidget {
  const Supervior_Main_view({super.key});

  @override
  State<Supervior_Main_view> createState() => _nameState();
}

class _nameState extends State<Supervior_Main_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supervision',),
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
            // List of Supervisors
            Expanded(
              child: ListView(
                children: [
                  SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family", supervisorId: '', onDelete: () {  },
                  ),
                  const SizedBox(height: 12),
                   SupervisorCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family", supervisorId: '', onDelete: () {  },
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
