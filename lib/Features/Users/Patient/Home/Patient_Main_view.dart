import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Refill_Medicine.dart';
import 'package:smart_medic/core/widgets/CustomBoxFilled.dart';
import 'package:smart_medic/core/widgets/CustomBoxIcon.dart';
import '../../../../Services/firebaseServices.dart';

class PatientMainView extends StatefulWidget {
  const PatientMainView({super.key});

  @override
  State<PatientMainView> createState() => _PatientMainViewState();
}

class _PatientMainViewState extends State<PatientMainView> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: SmartMedicalDb.readMedications(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading medications"));
            }

            // Extract medications from snapshot
            List<Map<String, dynamic>> medications = snapshot.data!.docs
                .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id, // Store document ID for deletion/edit
            })
                .toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                double itemHeight = (constraints.maxHeight - 55) / 4.7;
                double itemWidth = (constraints.maxWidth - 36) / 2;
                double aspectRatio = itemWidth / itemHeight;

                return GridView.builder(
                  physics: constraints.maxHeight > 650
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    // Check if there is a medication for this compartment
                    var medForCompartment = medications.firstWhere(
                          (med) => med['compartmentNumber'] == (index + 1),
                      orElse: () => {},
                    );

                    if (medForCompartment.isNotEmpty) {
                      // If there is a medication, show CustomBoxFilled
                      return CustomBoxFilled(
                        key: ValueKey(medForCompartment['id']), // إضافة Key لتحسين التحديث
                        medicineName: medForCompartment['name'] ?? 'Unknown',
                        compartmentNumber: index + 1,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Refill_Medicine(compartmentNum: index + 1),
                          ),
                        ),
                      );
                    } else {
                      // If no medication, show CustomBoxIcon
                      return CustomBoxIcon(index: index);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}