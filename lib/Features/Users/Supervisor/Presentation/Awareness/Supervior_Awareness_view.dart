import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Awareness_card.dart';

class Supervisor_Awareness_View extends StatefulWidget {
  const Supervisor_Awareness_View({super.key});

  @override
  State<Supervisor_Awareness_View> createState() => _nameState();
}

class _nameState extends State<Supervisor_Awareness_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Awareness',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AwarenessCard(
              title: "Mental Health",
              description:
                  "During the COVID-19 pandemic, young people experienced spikes in mental health difficulties, with girls taking a harder hit.",
            ),
            const SizedBox(height: 16),
            AwarenessCard(
              title: "Daily Calorie",
              description:
                  "Whether you're trying to lose weight, gain weight, or stick to your current weight, it's important to know how many calories you need to eat each day.",
            ),
          ],
        ),
      ),
    );
  }
}
