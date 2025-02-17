// Importing required Flutter packages for creating the log item.
import 'package:flutter/material.dart';

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
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          // Display BPM if available.
          if (bpm != null) ...[
            const Spacer(),
            Text(
              'BPM: $bpm', // Display BPM.
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
          // Display checkbox or clock icon based on the task status.
          if (isChecked != null) ...[
            const Spacer(),
            Icon(
              isChecked! ? Icons.check_box : Icons.access_time,
              color: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}
