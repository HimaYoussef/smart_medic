import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9, // Adapts width dynamically
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/avatar2.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
