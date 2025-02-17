import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Add_New_Medicine.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Refill_Medicine.dart';
import 'package:smart_medic/core/widgets/CustomBoxFilled.dart';
import 'package:smart_medic/core/widgets/CustomBoxIcon.dart';

/// **PatientMainView** represents the main home screen for the Patient user.  
/// It displays a **grid of actions**, including adding new medicine and refilling existing ones.
class PatientMainView extends StatefulWidget {
  const PatientMainView({super.key});

  @override
  State<PatientMainView> createState() => _PatientMainViewState();
}

class _PatientMainViewState extends State<PatientMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background for better contrast
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.black), // Black text for readability
        ),
        centerTitle: true, // Title centered in the AppBar
        backgroundColor: Colors.white, // White AppBar background
        elevation: 0, // Removes shadow from AppBar for a flat design
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the grid
        child: GridView.builder(
          itemCount: 8, // Total number of grid items
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Each row contains two items
            crossAxisSpacing: 12, // Spacing between grid columns
            mainAxisSpacing: 12, // Spacing between grid rows
            childAspectRatio: 1.0, // Ensures square-shaped grid items
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              /// First item in the grid - "Refill Medicine" box
              return CustomBoxFilled(
                onTap: () {
                  /// Navigates to the **Refill Medicine** screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Refill_Medicine(),
                    ),
                  );
                },
              );
            } else {
              /// All other items in the grid - "Add New Medicine" box
              return CustomBoxIcon(
                onTap: () {
                  /// Navigates to the **Add New Medicine** screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Add_new_Medicine(),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
