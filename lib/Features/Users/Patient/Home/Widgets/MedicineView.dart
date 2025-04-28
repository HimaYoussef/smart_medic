import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class MedicineDetailsPopup {
  static String getScheduleText(int scheduleType, int scheduleValue, List<dynamic>? times, List<dynamic>? bitmaskDays) {
    if (times == null || times.isEmpty) {
      return 'Schedule: Not Set';
    }

    String timesText = times.join(', ');

    if (scheduleType == 0) {
      return 'DAILY at $timesText';
    } else if (scheduleType == 1) {
      return 'EVERY $scheduleValue DAYS at $timesText';
    } else if (scheduleType == 2) {
      if (bitmaskDays == null || bitmaskDays.isEmpty || bitmaskDays.length != 7) {
        return 'SPECIFIC DAYS at $timesText';
      }

      const List<String> dayAbbreviations = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      List<String> selectedDays = [];

      for (int i = 0; i < bitmaskDays.length; i++) {
        if (bitmaskDays[i] == 1) {
          selectedDays.add(dayAbbreviations[i]);
        }
      }

      if (selectedDays.isEmpty) {
        return 'SPECIFIC DAYS at $timesText';
      }

      String daysText = selectedDays.join(', ');
      return 'SPECIFIC DAYS\nOn $daysText at $timesText';
    }
    return 'Schedule: Unknown';
  }

  static void showMedicineDetailsDialog(BuildContext context, Map<String, dynamic> med) {
    final name = med['name']?.toString().toUpperCase() ?? 'Unknown';
    final dosage = med['dosage']?.toString() ?? 'N/A';
    final scheduleType = med['scheduleType'] ?? 0;
    final scheduleValue = med['scheduleValue'] ?? 1;
    final times = med['times'] as List<dynamic>?;
    final bitmaskDays = med['bitmaskDays'] as List<dynamic>?;
    final pillsLeft = med['pillsLeft']?.toString() ?? 'N/A';
    final compartmentNumber = med['compartmentNumber']?.toString() ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.gray
                        : AppColors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style:  TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Dosage: $dosage',
                style:  TextStyle(color: AppColors.white, fontSize: 16),
              ),
              Text(
                getScheduleText(scheduleType, scheduleValue, times, bitmaskDays),
                style:  TextStyle(color: AppColors.white, fontSize: 16),),
              Text(
                'Pills Left: $pillsLeft',
                style:  TextStyle(color: AppColors.white, fontSize: 16),),
              Text(
                'Compartment: $compartmentNumber',
                style:  TextStyle(color: AppColors.white, fontSize: 16),),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(
              'Close',
              style: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold,fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}