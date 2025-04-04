import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';

import '../../../../../core/utils/Style.dart';

/// **Add New Medicine Screen**
/// This screen allows users to input **medicine details** including:
/// - Medicine name
/// - Dosage amount
/// - Pills in compartment
/// The data is validated before submission.

class addNewMedicine extends StatefulWidget {
  final int compNum;
  const addNewMedicine({super.key, required this.compNum});

  @override
  State<addNewMedicine> createState() => _Add_new_Medicine();
}

/// **Form Key** for validation purposes
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _Add_new_Medicine extends State<addNewMedicine> {
  /// **Text Controllers** to handle input fields
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _numTimesController = TextEditingController(); // Controller for number of times
  final TextEditingController _daysIntervalController = TextEditingController(); // Controller for days interval

  int _scheduleType = 0; // 0 for daily, 1 for every x days, 2 for specific days
  List<String> _times = [];
  List<int> _bitmaskDays = [0, 0, 0, 0, 0, 0, 0]; // 7-bit days

  void _addTime(String time) {
    setState(() {
      _times.add(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
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
                    Text(
                      'Compartment Number',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: false,
                      textAlign: TextAlign.start,
                      controller: TextEditingController(
                          text: (widget.compNum + 1).toString()),
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.black,),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Med Name',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _medNameController,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: 'Enter the name of the Medicine',
                      ),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.black,),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the name of the medicine';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Pills',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: _pillsController,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.black,),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter the number of pills added',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the number of pills';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Dosage',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: _dosageController,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.black,),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter the number of pills every time',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the number of the pills';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    /// **Schedule Type Dropdown** (اختيار نوع الجدول الزمني)
                    Text(
                      'Schedule Type',
                      style: getTitleStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<int>(
                      value: _scheduleType,
                      onChanged: (newValue) {
                        setState(() {
                          _scheduleType = newValue!;
                          _times.clear();
                          _bitmaskDays = [
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0
                          ]; // Clear previous days selections
                        });
                      },
                      items:  [
                        DropdownMenuItem<int>(
                            value: 0, child: Text('Select Type',style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : AppColors.gray,),)),
                        const DropdownMenuItem<int>(value: 1, child: Text('Daily')),
                        const DropdownMenuItem<int>(
                            value: 2, child: Text('Every X Days')),
                        const DropdownMenuItem<int>(
                            value: 3, child: Text('Specific Days')),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// **Schedule Value Field** (بعد اختيار نوع الجدول الزمني)
                    if (_scheduleType == 1) ...[
                      Text(
                        'How many times per day?',
                        style: getTitleStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _numTimesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter number of times per day',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the number of the times';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      // إذا كان العدد المدخل أكبر من 0
                      if (_numTimesController.text.isNotEmpty &&
                          int.tryParse(_numTimesController.text) != null &&
                          int.parse(_numTimesController.text) > 0) ...[
                        for (int i = 0;
                            i < int.parse(_numTimesController.text);
                            i++)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _addTime(time.format(context));
                                  });
                                }
                              },
                              child: Text('Add Time ${i + 1}'),
                            ),
                          ),
                      ],
                    ],
                    if (_scheduleType == 2) ...[
                      // إذا كان النوع "كل كذا يوم"
                      Text(
                        'Every how many days?',
                        style: getTitleStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _daysIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter number of days',
                        ),
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.white
                            : AppColors.black,),
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the number of the days';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      // لو اختار "كل كذا يوم"، هيسمح له بتحديد وقت واحد فقط
                      if (_daysIntervalController.text.isNotEmpty &&
                          int.tryParse(_daysIntervalController.text) != null &&
                          int.parse(_daysIntervalController.text) > 0) ...[
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _addTime(time.format(context));
                              });
                            }
                          },
                          child: const Text('Add Time'),
                        ),
                      ],
                    ],
                    if (_scheduleType == 3) ...[
                      // إذا كان النوع "أيام معينة"
                      Text(
                        'Select Specific Days',
                        style: getTitleStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _bitmaskDays[index] =
                                    _bitmaskDays[index] == 1 ? 0 : 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _bitmaskDays[index] == 1
                                    ? AppColors.mainColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                [
                                  "Sat",
                                  "Sun",
                                  "Mon",
                                  "Tue",
                                  "Wed",
                                  "Thu",
                                  "Fri"
                                ][index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],

                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Submit',
                      onPressed: () {
                        if (_scheduleType == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please select a schedule type',style: TextStyle(color: AppColors.white))),
                          );
                        } else if (_formKey.currentState!.validate()) {
                          //SmartMedicalDb.addMedication(medId: medId, patientId: patientId, name: name, dosage: dosage, scheduleType: scheduleType, scheduleValue: _scheduleValue, times: _times, bitmaskDays: _bitmaskDays, pillsLeft: int.parse(_pillsController.text), compartmentNumber: (widget.compNum+1));
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
}
