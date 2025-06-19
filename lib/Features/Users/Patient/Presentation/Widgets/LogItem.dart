// Importing required Flutter packages for creating the log item.
import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

// LogItem widget displays a single log entry with time, text, BPM, and checkbox icon.
class LogItem extends StatelessWidget {
  final String time; // Time of the log entry.
  final String text; // The log message.
  final bool? isChecked; // Optional checkbox for task completion.
  final String? bpm; // Optional BPM value (e.g., heart rate).

  const LogItem({
    super.key,
    required this.time,
    required this.text,
    this.isChecked,
    this.bpm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Displaying time and log text in one row.
          Text(
            '$time - $text',
            style: getbodyStyle(color: AppColors.white, fontSize: 18),
          ),
          // Display BPM if available.
          if (bpm != null) ...[
            const Spacer(),
            Text(
              'BPM: $bpm', // Display BPM.
              style: getbodyStyle(color: AppColors.white, fontSize: 18),
            ),
          ],
          // Display checkbox or clock icon based on the task status.
          if (isChecked != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                isChecked! ? Icons.check : Icons.close_rounded,
                color: Colors.grey,
                size: 15,
              ),
            ),
          ],

        ],
      ),
    );
  }
}
