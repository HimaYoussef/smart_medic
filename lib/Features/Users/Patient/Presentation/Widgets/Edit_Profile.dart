import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/build_text_field.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_Profile();
}

class _Edit_Profile extends State<Edit_Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _profileEmailController = TextEditingController();
  final TextEditingController _profileAgeController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (user != null) {
      var result = await SmartMedicalDb.getPatientProfile(user!.uid);
      if (result['success']) {
        setState(() {
          _profileNameController.text =
              result['data']['name'] ?? user!.displayName ?? '';
          _profileEmailController.text =
              result['data']['email'] ?? user!.email ?? '';
          _profileAgeController.text = result['data']['age']?.toString() ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      var result = await SmartMedicalDb.updatePatientProfile(
        userId: user!.uid,
        updates: {
          'name': _profileNameController.text,
          'email': _profileEmailController.text,
          'age': int.parse(_profileAgeController.text),
        },
      );

      if (result['success']) {
        // Update Firebase Auth profile
        await user!.updateDisplayName(_profileNameController.text);
        if (_profileEmailController.text != user!.email) {
          await user!.updateEmail(_profileEmailController.text);
        }
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );

      if (result['success']) {
        Navigator.pop(context);
      }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cointainerDarkColor
                        : AppColors.cointainerColor,
                  ),
                  height: 580,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: S.of(context).Edit_Profile_Head,
                                  fonSize: 20),
                            ],
                          ),
                          const Gap(30),
                          CustomText(
                              text: S.of(context).Edit_Profile_Name,
                              fonSize: 15),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _profileNameController,
                            readOnly: false,
                            keyboardType: TextInputType.name,
                            labelText: S.of(context).Edit_Profile_labelText1,
                            validatorText:
                                S.of(context).Edit_Profile_validatorText1,
                          ),
                          const SizedBox(height: 25.0),
                          CustomText(
                              text: S.of(context).Edit_Profile_Email,
                              fonSize: 15),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _profileEmailController,
                            readOnly: false,
                            keyboardType: TextInputType.emailAddress,
                            labelText: S.of(context).Edit_Profile_labelText2,
                            validatorText:
                                S.of(context).Edit_Profile_validatorText2,
                          ),
                          const SizedBox(height: 25),
                          CustomText(
                              text: S.of(context).Edit_Profile_Age,
                              fonSize: 15),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: _profileAgeController,
                            readOnly: false,
                            keyboardType: TextInputType.number,
                            labelText: S.of(context).Edit_Profile_labelText3,
                            validatorText:
                                S.of(context).Edit_Profile_validatorText3,
                          ),
                          const SizedBox(height: 25.0),
                          CustomButton(
                              text: S.of(context).Edit_Profile_Age,
                              onPressed: _updateProfile)
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
    _profileNameController.dispose();
    _profileEmailController.dispose();
    _profileAgeController.dispose();
    super.dispose();
  }
}
