import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

class PatientAwarenessView extends StatelessWidget {
  const PatientAwarenessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes shadow from AppBar
        title: const Text(
          'Awareness', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            _buildAwarenessCard(
              title: "Mental Health",
              description:
                  "During the COVID-19 pandemic, young people experienced spikes in mental health difficulties, with girls taking a harder hit.",
                context: context
            ),
            const SizedBox(height: 12), // Space between cards
            _buildAwarenessCard(
              title: "Daily Calorie",
              description:
                  "Whether you're trying to lose weight, gain weight, or stick to your current weight, it's important to know how many calories you need to eat each day.",
              context: context
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAwarenessCard(
      {required String title, required String description, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cointainerDarkColor
            : AppColors.mainColor,// Card background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTitleStyle(color: AppColors.white),
          ),
          const SizedBox(height: 8), // Space between title & description
          Text(
            description,
            style: getbodyStyle(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
