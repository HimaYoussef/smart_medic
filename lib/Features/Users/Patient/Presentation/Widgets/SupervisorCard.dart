import 'package:flutter/material.dart';
import '../../../../../core/utils/Colors.dart';
import '../../../../../core/utils/Style.dart';

class SupervisorCard extends StatelessWidget {
  final String name;
  final String email;
  final String type;
  final VoidCallback onDelete;

  const SupervisorCard({
    super.key,
    required this.name,
    required this.email,
    required this.type,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cointainerDarkColor
            : AppColors.mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/avatar1.png'),
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
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}