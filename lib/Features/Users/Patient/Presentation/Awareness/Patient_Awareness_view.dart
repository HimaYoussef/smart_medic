import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Awareness_card.dart';

// A stateless widget representing the Awareness View for patients
class Patient_Awareness_View extends StatelessWidget {
  const Patient_Awareness_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow from AppBar for a cleaner look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Navigates back to the previous screen
        ),
        title: const Text(
          'Awareness',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centers the title in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          children: [
            // Awareness card about Mental Health
            AwarenessCard(
              title: "Mental Health",
              description:
                  "During the COVID-19 pandemic, young people experienced spikes in mental health difficulties, with girls taking a harder hit.",
            ),
            const SizedBox(height: 16), // Adds spacing between the cards
            // Awareness card about Daily Calorie intake
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
