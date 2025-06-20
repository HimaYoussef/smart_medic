import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../../../Services/firebaseServices.dart';
import '../../../../../../../core/widgets/BuildText.dart';
import '../../../../../../../core/widgets/build_text_field.dart';
import '../../../../../../core/utils/Colors.dart';
import '../../../../../../core/widgets/Custom_button.dart';
import '../../../../../../generated/l10n.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _EditProfileState();
}

class _EditProfileState extends State<Edit_Profile> {
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
      try {
        var result = await SmartMedicalDb.getPatientProfile(user!.uid);
        if (result['success']) {
          setState(() {
            _profileNameController.text = result['data']['name'] ?? user!.displayName ?? '';
            _profileEmailController.text = result['data']['email'] ?? user!.email ?? '';
            _profileAgeController.text = result['data']['age']?.toString() ?? '';
            _isLoading = false;
          });
        } else {
          throw Exception(result['message']);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load profile: ${e.toString()}',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No user is signed in.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _profileNameController.text.trim();
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Name must contain only letters and spaces.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await SmartMedicalDb.updateUserProfile(
        userId: user!.uid,
        updates: {
          'name': name,
          'email': _profileEmailController.text.trim(),
          'age': int.parse(_profileAgeController.text),
        },
      );

      if (result['success']) {
        await user!.updateDisplayName(name);
        if (_profileEmailController.text.trim() != user!.email) {
          await user!.updateEmail(_profileEmailController.text.trim());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
            duration: const Duration(seconds: 3),
          ),
        );

        _profileNameController.clear();
        _profileEmailController.clear();
        _profileAgeController.clear();
        Navigator.pop(context);
      } else {
        throw Exception(result['message']);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile: ${e.toString()}',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: const Duration(seconds: 3),
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
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 25.0),
                          CustomButton(text: S.of(context).Edit_Profile_Edit, onPressed: _updateProfile)
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