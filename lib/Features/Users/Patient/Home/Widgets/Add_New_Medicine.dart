import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

/// **Add New Medicine Screen**
/// This screen allows users to input **medicine details** including:
/// - Medicine name
/// - Dosage amount
/// - Pills in compartment
/// The data is validated before submission.

class Add_new_Medicine extends StatefulWidget {
  const Add_new_Medicine({super.key});

  @override
  State<Add_new_Medicine> createState() => _Add_new_Medicine();
}

/// **Form Key** for validation purposes
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

/// **Text Controllers** to handle input fields
final TextEditingController _MedNameController = TextEditingController();
final TextEditingController _DosageController = TextEditingController();
final TextEditingController _ScheduleController = TextEditingController();

class _Add_new_Medicine extends State<Add_new_Medicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 235, 235, 235), // Light grey background

      /// **App Bar with Back Button**
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
      ),

      /// **Main Content with Form**
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              color: AppColors.white, // White background for form
            ),
            height: 600, // Fixed height for the form
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),

                    /// **Title - "Add New Medicine"**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add New Medicine',
                          style: getTitleStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    const Gap(30),

                    /// **Medicine Name Field**
                    Text(
                      'Med Name',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _MedNameController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Enter the name of the Medicine',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the name of the medicine';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25.0),

                    /// **Dosage Field**
                    Text(
                      'Dosage',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: _DosageController,
                      style: TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter the amount of dosages',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the amount of dosages';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    /// **Pills in Compartment Field**
                    Text(
                      'Pills in compartment',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: _ScheduleController,
                      style: TextStyle(color: AppColors.black),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Enter the number of pills',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: AppColors.TextField,
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the schedule of the medicine';
                        }
                        return null;
                      },
                    ),

                    const Gap(30),

                    /// **Submit Button**
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
                              backgroundColor: AppColors.color1,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Add',
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

  /// **Dispose Controllers when Widget is Removed from the Tree**
  // @override
  // void dispose() {
  //   _MedNameController.dispose();
  //   _DosageController.dispose();
  //   _ScheduleController.dispose();
  //   super.dispose();
  // }
}
