import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../Services/firebaseServices.dart';
import '../../../../../core/utils/Colors.dart';
import '../../../../../core/utils/Style.dart';
import '../../../../../core/widgets/Custom_button.dart';
import '../../../../../core/widgets/build_text_field.dart';
import '../../../../../generated/l10n.dart';

class Refill_Medicine extends StatefulWidget {
  final int compartmentNum;
  const Refill_Medicine({super.key, required this.compartmentNum});

  @override
  State<Refill_Medicine> createState() => _RefillMedicineState();
}


class _RefillMedicineState extends State<Refill_Medicine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _numOfPillsController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  void dispose() {
    _numOfPillsController.dispose();
    super.dispose();
  }

  Future<void> _refillMedicine() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot medSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: user!.uid)
          .where('compartmentNumber', isEqualTo: widget.compartmentNum)
          .get();

      if (medSnapshot.docs.isNotEmpty) {
        String medId = medSnapshot.docs.first.id;
        int pillsNow = medSnapshot.docs.first['pillsLeft'];
        int addedPills = int.parse(_numOfPillsController.text);

        // Check if total pills exceed 50
        if (pillsNow + addedPills > 50) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Total pills cannot exceed 50. Current: $pillsNow, Adding: $addedPills.',
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.mainColorDark
                  : AppColors.mainColor,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await SmartMedicalDb.updateMedicine(
          medicineId: medId,
          updates: {
            'pillsLeft': pillsNow + addedPills,
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Medicine refilled successfully! Total pills: ${pillsNow + addedPills}',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No medicine found for this compartment.',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
            duration: Duration(seconds: 3),
          ),
        );
      }

      _numOfPillsController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cointainerDarkColor
                  : AppColors.white,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Refill_Medicine_Head,
                          style: getTitleStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Text(
                      S.of(context).Refill_Medicine_Num_of_Pills,
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _numOfPillsController,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText: 'Please enter the number of pills',
                      labelText: 'Enter the number of pills to add',
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _refillMedicine(),
                      maxValue: 50,
                    ),
                    const SizedBox(height: 55),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                      text: 'Refill',
                      onPressed: _refillMedicine,
                    ),
                    const SizedBox(height: 8,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
