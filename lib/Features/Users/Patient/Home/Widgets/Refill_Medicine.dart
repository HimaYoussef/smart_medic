import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import '../../../../../core/widgets/Custom_button.dart';

class Refill_Medicine extends StatefulWidget {
  final int compartmentNum;
  const Refill_Medicine({super.key, required this.compartmentNum});

  @override
  State<Refill_Medicine> createState() => _nameState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _NumofPillsController = TextEditingController();

class _nameState extends State<Refill_Medicine> {
  User? user = FirebaseAuth.instance.currentUser;

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
            height: 300,
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
                          'Refill Medicine',
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
                      'Num of Pills',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _NumofPillsController,
                      decoration: const InputDecoration(
                        hintText: 'Enter The Num of pills added',
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the number of pills';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 55.0),
                    CustomButton(
                      text: 'Refill',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Update pillsLeft in Firestore for compartment 1
                          QuerySnapshot medSnapshot = await FirebaseFirestore
                              .instance
                              .collection('medications')
                              .where('patientId', isEqualTo: user!.uid)
                              .where('compartmentNumber', isEqualTo: widget.compartmentNum)
                              .get();

                          if (medSnapshot.docs.isNotEmpty) {
                            String medId = medSnapshot.docs.first.id;
                            await SmartMedicalDb.updateMedicine(
                              medicineId: medId ,
                              updates: {
                                'pillsLeft':
                                int.parse(_NumofPillsController.text),
                                'lastUpdated': FieldValue.serverTimestamp(),
                              },
                            );
                          }
                          _NumofPillsController.text='';
                          Navigator.pop(context);
                        }
                      },
                    ),
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