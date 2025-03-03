// Import necessary packages for creating the edit profile screen.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/functions/email_validation.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';

// Stateful widget for editing profile information (name, email, and age).
class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_Profile();
}

// Global keys for managing form state and controllers for input fields.
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _ProfileNameController = TextEditingController();
final TextEditingController _ProfileEmailController = TextEditingController();
final TextEditingController _ProfileAgeController = TextEditingController();

// Stateful widget's state class for editing profile.
class _Edit_Profile extends State<Edit_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color of the screen.
      backgroundColor: Color.fromARGB(255, 235, 235, 235),

      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          // Add a back button that navigates to the previous screen.
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white,
            ),
            height: 580,
            child: Form(
              key:
                  _formKey, // Linking the form with the form key for validation.
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile', // Title text for the profile editing screen.
                          style: getTitleStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Gap(30),
                    // TextField for the user's name with validation.
                    Text(
                      'Name',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _ProfileNameController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Please Enter Your Name',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter A valid Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25.0),
                    // TextField for the user's email with validation.
                    Text(
                      'Email',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _ProfileEmailController,
                      style: TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Please Enter Your Email',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Email';
                        } else if (!emailValidate(value)) {
                          return 'Please Enter A valid email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    // TextField for the user's age with validation.
                    Text(
                      'Age',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _ProfileAgeController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Please Enter Your Age',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Age';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 25.0),
                    // Button to submit the form after validation.
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 50),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // If validation passes, save form data.
                                _formKey.currentState!.save();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.color1,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Edit',
                              style: getTitleStyle(color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
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
