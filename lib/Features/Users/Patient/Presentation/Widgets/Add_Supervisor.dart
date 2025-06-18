import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../Services/firebaseServices.dart';
import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/Custom_button.dart';
import '../../../../../core/widgets/build_text_field.dart';

class Add_SuperVisor extends StatefulWidget {
  const Add_SuperVisor({super.key});

  @override
  State<Add_SuperVisor> createState() => _AddSuperVisorState();
}

class _AddSuperVisorState extends State<Add_SuperVisor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _superVisorEmailController = TextEditingController();
  String _superVisorType = SuperVisor_type[0];
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  Future<void> _addSupervisor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_superVisorType == "Choose") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a valid Supervisor type',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await SmartMedicalDb.addSupervisor(
        email: _superVisorEmailController.text.trim(),
        type: _superVisorType,
        patientId: user!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );

      if (result['success']) {
        _superVisorEmailController.clear();
        Navigator.pop(context);
      }
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
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
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
                    const CustomText(text: 'Email', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _superVisorEmailController,
                      readOnly: false,
                      keyboardType: TextInputType.emailAddress,
                      validatorText: 'Please enter a valid email',
                      labelText: 'Enter the Email of the Supervisor',
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addSupervisor(),
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
                          value: _superVisorType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _superVisorType = newValue ?? _superVisorType;
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
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                      text: 'Add',
                      onPressed: _addSupervisor,
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
    _superVisorEmailController.dispose();
    super.dispose();
  }
}