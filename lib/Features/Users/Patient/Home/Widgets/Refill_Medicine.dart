import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Home.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

// Stateful widget for handling medicine refill
class Refill_Medicine extends StatefulWidget {
  const Refill_Medicine({super.key});

  @override
  State<Refill_Medicine> createState() => _nameState();
}

// Form key for validating user input
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Controller to handle input for the number of pills
final TextEditingController _NumofPillsController = TextEditingController();

class _nameState extends State<Refill_Medicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context), // Navigate back when tapped
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.white,
            ),
            height: 300,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(20),
                    // Centered title
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
                    Gap(30),
                    // Label for number of pills input
                    Text(
                      'Num of Pills',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Text input for entering the number of pills
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _NumofPillsController,
                      decoration: InputDecoration(
                        hintText: 'Enter The Num of pills added',
                        hintStyle: getbodyStyle(color: Colors.black),
                        fillColor: Color.fromARGB(255, 248, 248, 248),
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the number of pills';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),
                    // Submit button for refilling medicine
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
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
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
                              'Refill',
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

  // Dispose controller to prevent memory leaks
  // @override
  // void dispose() {
  //   _NumofPillsController.dispose();
  //   super.dispose();
  // }
}
