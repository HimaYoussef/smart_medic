import 'package:flutter/material.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAwarenessCard(
                title: "Why It’s Important to Take Your Medicine on Time",
                description:
                    "Your medicine works best when taken at the right time every day. Missing a dose can make it harder to manage conditions like high blood pressure or diabetes. That’s why your smart medical box gives you friendly reminders. It helps you stay safe and keeps your health on the right track. Trust the system—it’s here to support you.",
                  context: context
              ),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                title: "What Happens If You Skip a Dose?",
                description:
                "Sometimes we forget to take a pill, but skipping medicine can be risky. It may cause problems like dizziness, high sugar levels, or breathing trouble—depending on your condition. That’s why your smart box alerts you gently, so you never miss an important dose. Following your medication plan can keep you out of the hospital and feeling better every day. One small habit can protect your whole body.",
                context: context
              ),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                  title: "Easy Ways to Remember Your Pills",
                  description:
                  "We all forget things from time to time. That’s why your smart medical box is designed to make life easier. It lights up, makes a sound, and even sends a message to your phone when it’s time for your medicine. No need to memorize anything—just follow the gentle alert. Let the technology take care of remembering, so you can focus on living well.",
                  context: context
              ),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                  title: "Always Finish Your Antibiotics—Even If You Feel Better",
                  description:
                  "If your doctor gives you antibiotics, it’s important to finish the full course. Even if you feel better after a few days, stopping early can cause the infection to return—stronger than before. Your smart box keeps track of how many days are left and reminds you until the last pill. It’s a simple way to protect yourself from future illness. Let’s treat the infection right the first time.",
                  context: context
              ),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                  title: "Are You Taking Multiple Medications? Stay Safe",
                  description:
                  "Many older adults take more than one medicine a day—and that’s okay, but it needs care. Some pills don’t mix well together. Your smart medical box and app help organize everything so you take the right pills at the right time. If anything ever feels off, always call your doctor. Staying informed is one of the best ways to stay healthy.",
                  context: context
              ),
              const SizedBox(height: 60),
            ],
          ),
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
