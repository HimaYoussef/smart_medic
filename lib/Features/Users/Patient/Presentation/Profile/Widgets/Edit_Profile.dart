import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import '../../../../../../Services/firebaseServices.dart';
import '../../../../../../core/widgets/BuildText.dart';
import '../../../../../../core/widgets/build_text_field.dart';

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
            duration: Duration(seconds: 3),
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
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
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
          duration: Duration(seconds: 3),
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
            duration: Duration(seconds: 3),
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
          duration: Duration(seconds: 3),
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
                        CustomText(text: 'Edit Profile', fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Name', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _profileNameController,
                      readOnly: false,
                      keyboardType: TextInputType.name,
                      labelText: 'Please Enter Your Name',
                      validatorText: 'Please enter a valid name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Email', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _profileEmailController,
                      readOnly: false,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Please Enter Your Email',
                      validatorText: 'Please enter a valid email',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Age', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _profileAgeController,
                      readOnly: false,
                      keyboardType: TextInputType.number,
                      labelText: 'Please Enter Your Age',
                      validatorText: 'Please enter a valid age',
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _updateProfile(),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: 'Edit',
                      onPressed: _updateProfile,
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
    _profileNameController.dispose();
    _profileEmailController.dispose();
    _profileAgeController.dispose();
    super.dispose();
  }
}