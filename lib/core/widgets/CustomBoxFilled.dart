import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/EditMedicine.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/MedicineView.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class CustomBoxFilled extends StatelessWidget {
  final String medicineName;
  final int compartmentNumber;
  final void Function()? onTap;

  const CustomBoxFilled({
    super.key,
    required this.medicineName,
    required this.compartmentNumber,
    this.onTap,
  });

  Future<void> _deleteMedicine(BuildContext context) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('medications')
        .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('compartmentNumber', isEqualTo: compartmentNumber)
        .get();

    if (query.docs.isNotEmpty) {
      String medicineId = query.docs.first.id;
      var result = await SmartMedicalDb.deleteMedicine(medicineId: medicineId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete "$medicineName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteMedicine(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection('medications')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('compartmentNumber', isEqualTo: compartmentNumber)
            .get();
        if (query.docs.isNotEmpty) {
          Map<String, dynamic> medicineData = query.docs.first.data() as Map<String, dynamic>;
          MedicineDetailsPopup.showMedicineDetailsDialog(context, medicineData);
        }
      },
      onLongPress: () => _showDeleteConfirmation(context),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey
              : AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColors.ShadowColor,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_circle_filled_rounded),
                    color: Colors.black26,
                    onPressed: onTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    color: Colors.black26,
                    onPressed: () async {
                      QuerySnapshot query = await FirebaseFirestore.instance
                          .collection('medications')
                          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('compartmentNumber', isEqualTo: compartmentNumber)
                          .get();

                      if (query.docs.isNotEmpty) {
                        String medicineId = query.docs.first.id;
                        Map<String, dynamic> medicineData = query.docs.first.data() as Map<String, dynamic>;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMedicine(
                              medicineId: medicineId,
                              medicineData: medicineData,
                              compartmentNumber: compartmentNumber,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                medicineName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}