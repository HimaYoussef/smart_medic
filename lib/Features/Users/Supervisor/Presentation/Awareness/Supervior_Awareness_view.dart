import 'package:flutter/material.dart';
import '../../../../../core/utils/Colors.dart';
import '../../../../../core/utils/Style.dart';
import '../../../../../generated/l10n.dart';

class Supervisor_Awareness_View extends StatefulWidget {
  const Supervisor_Awareness_View({super.key});

  @override
  State<Supervisor_Awareness_View> createState() => _nameState();
}

class _nameState extends State<Supervisor_Awareness_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Removes shadow from AppBar
        title: Text(
          S.of(context).Awareness_view_Awareness,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
                  title: S.of(context).Awareness_view_title3,
                  description: S.of(context).Awareness_view_description3,
                  context: context),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                  title: S.of(context).Awareness_view_title4,
                  description: S.of(context).Awareness_view_description4,
                  context: context),
              const SizedBox(height: 12), // Space between cards
              _buildAwarenessCard(
                  title: S.of(context).Awareness_view_title2,
                  description: S.of(context).Awareness_view_description2,
                  context: context),
              const SizedBox(height: 12), // Space between cards
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
