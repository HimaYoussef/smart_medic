import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/functions/email_validation.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';

// Stateful widget for adding a new supervisor
class Add_SuperVisor extends StatefulWidget {
  const Add_SuperVisor({super.key});

  @override
  State<Add_SuperVisor> createState() => _Add_SuperVisor();
}

// Form key for validation
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Controllers for input fields
final TextEditingController _SuperVisorNameController = TextEditingController();
final TextEditingController _SuperVisorEmailController =
    TextEditingController();

// Default selected value for supervisor type
String _SuperVisor_Type = SuperVisor_type[0];

class _Add_SuperVisor extends State<Add_SuperVisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 235, 235, 235), // Light grey background
      // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Navigates back on tap
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
              borderRadius: BorderRadius.circular(20), // Rounded corners
              color: AppColors.white, // White container background
            ),
            height: 550, // Fixed height for the form container
            child: Form(
              key: _formKey, // Assign form key for validation
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20), // Spacer

                    // Title - "Add Supervisor"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Supervisor',
                          style: getTitleStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    const Gap(30), // Spacer

                    // Name Input Field
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
                      keyboardType: TextInputType.text,
                      controller: _SuperVisorNameController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Enter The name of the Supervisor',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter The name of the Supervisor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),

                    // Email Input Field
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
                      controller: _SuperVisorEmailController,
                      style: TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter The Email of the Supervisor',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter the Email of the Supervisor';
                        } else if (!emailValidate(value)) {
                          return 'Please Enter A valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // Supervisor Type Dropdown
                    Text(
                      'Supervisor type',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 160),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.TextField,
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

                    const Gap(30), // Spacer

                    // Add Supervisor Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_SuperVisor_Type == "Choose") {
                                showErrorDialog(
                                  context,
                                  'Please select a valid Supervisor type',
                                );
                                return;
                              }
                              _formKey.currentState!.save();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.color1, // Primary button color
                            elevation: 2, // Light shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded button
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: getTitleStyle(color: AppColors.white),
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
  /*
  @override
  void dispose() {
    _SuperVisorNameController.dispose();
    _SuperVisorEmailController.dispose();
    super.dispose();
  }
  */
}
