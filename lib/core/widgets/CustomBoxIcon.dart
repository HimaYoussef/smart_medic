import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Add_New_Medicine.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class CustomBoxIcon extends StatelessWidget {
  final int index;

  const CustomBoxIcon({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cointainerDarkColor
            : AppColors.white,
        child: InkWell(
          onTap: () {
            _alert(context);
          },
          splashColor: Colors.blue.withOpacity(0.5),
          child: Icon(
            Icons.add_box_outlined,
            size: 150,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF006C8E)
                : AppColors.mainColor,
          ),
        ),
      ),
    );
  }

  Future<void> _alert(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert!!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Are you sure you want to add a new medication?',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => addNewMedicine(
                      compNum: index + 1,
                    ),
                  ),
                );
              },
              child: Text(
                'Yes',
                style: TextStyle(color: AppColors.mainColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: AppColors.mainColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
