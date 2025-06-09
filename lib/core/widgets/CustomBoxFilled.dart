import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/EditMedicine.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/MedicineView.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/Services/bluetoothServices.dart';
import '../../Services/notificationService.dart';

class CustomBoxFilled extends StatefulWidget {
  final String medicineName;
  final int compartmentNumber;
  final void Function()? onTap;

  const CustomBoxFilled({
    super.key,
    required this.medicineName,
    required this.compartmentNumber,
    this.onTap,
  });

  @override
  State<CustomBoxFilled> createState() => _CustomBoxFilledState();
}

class _CustomBoxFilledState extends State<CustomBoxFilled> {
  final BluetoothManager _bluetoothManager = BluetoothManager();
  @override
  void dispose() {
    print("CustomBoxFilledState: Disposing state.");
    _bluetoothManager.dispose(); // لو BluetoothManager عنده dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection('medications')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('compartmentNumber', isEqualTo: widget.compartmentNumber)
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
                    onPressed: widget.onTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    color: Colors.black26,
                    onPressed: () async {
                      QuerySnapshot query = await FirebaseFirestore.instance
                          .collection('medications')
                          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where('compartmentNumber', isEqualTo: widget.compartmentNumber)
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
                              compartmentNumber: widget.compartmentNumber,
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
                widget.medicineName,
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

  Future<bool> _deleteMedicine(BuildContext dialogContext) async {
    print("deleteMedicine: Querying Firestore for medication.");
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('compartmentNumber', isEqualTo: widget.compartmentNumber)
          .get();

      if (query.docs.isNotEmpty) {
        String medicineId = query.docs.first.id;
        print("deleteMedicine: Found medicine with ID: $medicineId, attempting to delete.");

        var result = await SmartMedicalDb.deleteMedicine(medicineId: medicineId);
        print("deleteMedicine: Delete result: $result");

        if (result['success']) {
          print("deleteMedicine: Delete successful, setting needsSync and syncing.");
          BluetoothManager.needsSync = true; // تصحيح المتغير لو كان _needsSync

          Map<String, dynamic> syncResult = await _bluetoothManager.sendAllMedicationsToArduino();
          print("deleteMedicine: Sync result: $syncResult");

          await LocalNotificationService.scheduleMedicineNotifications();

          print("deleteMedicine: Showing SnackBar with sync message: ${syncResult['message']}");
          ScaffoldMessenger.of(dialogContext).showSnackBar(
            SnackBar(
              content: Text(
                syncResult['success']
                    ? "Medicine deleted and synced successfully."
                    : syncResult['message'],
                style: TextStyle(color: AppColors.white),
              ),
              duration: const Duration(seconds: 3),
            ),
          );

          if (syncResult['success']) {
            print("deleteMedicine: Sync successful, showing synced notification.");
            await LocalNotificationService.showDataSyncedNotification();
          }
          return true;
        } else {
          print("deleteMedicine: Delete failed, showing error SnackBar: ${result['message']}");
          ScaffoldMessenger.of(dialogContext).showSnackBar(
            SnackBar(
              content: Text(
                result['message'],
                style: TextStyle(color: AppColors.white),
              ),
            ),
          );
          return false;
        }
      } else {
        print("deleteMedicine: No medicine found for deletion.");
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(
            content: Text(
              "No medicine found to delete.",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      print("deleteMedicine: Exception caught: $e");
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(
            "Error deleting medicine: $e",
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      return false;
    } finally {
      print("deleteMedicine: Closing dialog.");
      await Future.delayed(const Duration(milliseconds: 500)); // تأخير لضمان إظهار الـ SnackBar
      print("deleteMedicine: Attempting to close dialog.");
      Navigator.of(dialogContext, rootNavigator: true).pop();
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    bool isLoading = false; // متغير محلي للتحكم في الـ CircularProgressIndicator
    print("showDeleteConfirmation: Showing delete confirmation dialog.");
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق الـ Dialog بالضغط خارجها
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Delete Medicine'),
          content: Text('Are you sure you want to delete "${widget.medicineName}"?'),
          actions: isLoading
              ? [const Center(child: CircularProgressIndicator())]
              : [
            TextButton(
              onPressed: () {
                print("showDeleteConfirmation: Cancel pressed, closing dialog.");
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print("showDeleteConfirmation: Delete pressed, starting deletion.");
                setState(() {
                  isLoading = true; // إظهار الـ CircularProgressIndicator
                });
                await _deleteMedicine(dialogContext);
                setState(() {
                  isLoading = false; // إخفاء الـ CircularProgressIndicator (غير ضروري لأن الـ Dialog هيتقفل)
                });
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}