import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/functions/email_validation.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';

// Stateful widget for editing a user's profile
class Edit_SuperVisor extends StatefulWidget {
  const Edit_SuperVisor({super.key});

  @override
  State<Edit_SuperVisor> createState() => _Edit_Profile();
}

// Form key for validation
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Controllers for handling user input fields
final TextEditingController _ProfileNameController = TextEditingController();
final TextEditingController _ProfileEmailController = TextEditingController();
final TextEditingController _ProfileAgeController = TextEditingController();

// State class for handling profile editing
class _Edit_Profile extends State<Edit_SuperVisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 235, 235, 235), // Light gray background
      appBar: AppBar(
        backgroundColor: AppColors.white, // Transparent app bar
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Navigate back on tap
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
        padding: const EdgeInsets.all(15), // Outer padding
        child: SingleChildScrollView(
          // Allows scrolling if content overflows
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              color: AppColors.white, // White background for the form
            ),
            height: 550, // Fixed height
            child: Form(
              key: _formKey, // Assigning the form key for validation
              child: Padding(
                padding: const EdgeInsets.all(10), // Inner padding
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align elements to the left
                  children: [
                    const Gap(20), // Adds spacing

                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
                          style: getTitleStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    const Gap(30), // Spacing

                    // Name Field
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
                        fillColor:  AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter A valid Name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25.0),

                    // Email Field
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
                      textAlign: TextAlign.start,
                      controller: _ProfileEmailController,
                      style: TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Please Enter Your Email',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor:  AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter your Email';
                        } else if (!emailValidate(value)) {
                          return 'Please Enter A valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // Age Field
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
                        fillColor:  AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Age';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25.0),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.color1, // Primary button color
                              elevation: 2, // Slight elevation for depth effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners
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

  // **Dispose Controllers when Widget is Removed from the Tree**
  // @override
  // void dispose() {
  //   _ProfileNameController.dispose();
  //   _ProfileEmailController.dispose();
  //   _ProfileAgeController.dispose();
  //   super.dispose();
  // }
}
