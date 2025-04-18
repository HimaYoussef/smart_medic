import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/Custom_button.dart';
import '../../../../../core/widgets/build_text_field.dart';

class Add_SuperVisor extends StatefulWidget {
  const Add_SuperVisor({super.key});

  @override
  State<Add_SuperVisor> createState() => _Add_SuperVisor();
}



class _Add_SuperVisor extends State<Add_SuperVisor> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _SuperVisorNameController = TextEditingController();
  final TextEditingController _SuperVisorEmailController = TextEditingController();
  String _SuperVisor_Type = SuperVisor_type[0];

  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  Future<void> _addSupervisor() async {

    setState(() {
      _isLoading = true;
    });

    var result = await SmartMedicalDb.addSupervisor(
      name: _SuperVisorNameController.text,
      email: _SuperVisorEmailController.text,
      type: _SuperVisor_Type,
      patientId: user!.uid,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      showErrorDialog(context, result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.white
              : AppColors.black,),
        ),
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cointainerDarkColor
                  : AppColors.cointainerColor,
            ),
            height: 550,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Add Supervisor', fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Name', fonSize: 15,),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _SuperVisorNameController,
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      labelText: 'Enter The name of the Supervisor',
                      validatorText: 'Please Enter The name of the Supervisor',
                    ),
                    const SizedBox(height: 25.0),
                    const CustomText(text:'Email', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _SuperVisorEmailController,
                      readOnly: false,
                      keyboardType:TextInputType.emailAddress ,
                      validatorText: 'Please Enter the Email of the Supervisor',
                      labelText: 'Enter The Email of the Supervisor',
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Supervisor type', fonSize: 15),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 160),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: AppColors.black,
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: _SuperVisor_Type,
                          onChanged: (String? newValue) {
                            setState(() {
                              _SuperVisor_Type = newValue ?? _SuperVisor_Type;
                            });
                          },
                          items: SuperVisor_type.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Gap(30),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomButton(
                        text: 'Add',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_SuperVisor_Type == "Choose") {
                              showErrorDialog(
                                context,
                                'Please select a valid Supervisor type',
                              );
                              return;
                            }
                            _formKey.currentState!.save();
                            _addSupervisor();
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

  @override
  void dispose() {
    _SuperVisorNameController.dispose();
    _SuperVisorEmailController.dispose();
    super.dispose();
  }
}