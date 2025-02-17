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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Supervision',
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
            // Supervisor List
            Expanded(
              child: ListView(
                children: const [
                  SupervisionCard(
                    name: "Ahmed",
                    email: "Ahmed@gmail.com",
                    type: "Doctor",
                    avatar: 'assets/avatar1.png',
                  ),
                  SizedBox(height: 12),
                  SupervisionCard(
                    name: "Omar",
                    email: "Omar@gmail.com",
                    type: "Family",
                    avatar: 'assets/avatar2.png',
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
