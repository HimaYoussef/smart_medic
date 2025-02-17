import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

// Stateless widget for displaying an awareness card with a title and description
class AwarenessCard extends StatelessWidget {
  final String title; // Title of the awareness card
  final String description; // Description text of the card

  // Constructor to initialize title and description
  const AwarenessCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // Padding around the content
      decoration: BoxDecoration(
        color: AppColors.color1, // Background color from theme
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          // Title Text
          Text(
            title,
            style: const TextStyle(
              fontSize: 20, // Font size for title
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white, // White text color
            ),
          ),
          const SizedBox(height: 8), // Spacing between title and description
          
          // Description Text
          Text(
            description,
            style: const TextStyle(
              fontSize: 16, // Font size for description
              color: Colors.white, // White text color
            ),
          ),
        ],
      ),
    );
  }
}
