import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Bluetooth/BluetoothManager.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import 'package:smart_medic/core/widgets/BuildText.dart';
import 'package:smart_medic/core/widgets/build_text_field.dart';

class EditMedicine extends StatefulWidget {
  final String medicineId;
  final Map<String, dynamic> medicineData;
  final int compartmentNumber;

  const EditMedicine({
    super.key,
    required this.medicineId,
    required this.medicineData,
    required this.compartmentNumber,
  });

  @override
  State<EditMedicine> createState() => _EditMedicineState();
}

class _EditMedicineState extends State<EditMedicine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _medNameController;
  late TextEditingController _pillsController;
  late TextEditingController _dosageController;
  late TextEditingController _numTimesController;
  late TextEditingController _daysIntervalController;
  late int _scheduleType;
  late List<String> _times;
  late List<TimeOfDay?> _selectedTimes;
  TimeOfDay? _selectedTime;
  late List<int> _bitmaskDays;
  bool _isLoading = false;

  final BluetoothManager _bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _bluetoothManager.initBluetooth();
    // Initialize fields with existing medicine data
    _medNameController = TextEditingController(text: widget.medicineData['name'] ?? '');
    _pillsController = TextEditingController(text: widget.medicineData['pillsLeft']?.toString() ?? '');
    _dosageController = TextEditingController(text: widget.medicineData['dosage']?.toString() ?? '');
    _numTimesController = TextEditingController(text: widget.medicineData['scheduleValue']?.toString() ?? '');
    _daysIntervalController = TextEditingController(text: widget.medicineData['scheduleValue']?.toString() ?? '');
    _scheduleType = widget.medicineData['scheduleType'] + 1; // Adjust for dropdown (0-based to 1-based)
    _times = List<String>.from(widget.medicineData['times'] ?? []);
    _bitmaskDays = List<int>.from(widget.medicineData['bitmaskDays'] ?? [0, 0, 0, 0, 0, 0, 0]);

    // Initialize times based on scheduleType
    if (_scheduleType == 1) {
      _selectedTimes = _times.map((time) {
        final parts = time.split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1].split(' ')[0]);
        String period = parts[1].split(' ')[1];
        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }).toList();
    } else if (_scheduleType == 2 && _times.isNotEmpty) {
      final parts = _times[0].split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1].split(' ')[0]);
      String period = parts[1].split(' ')[1];
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    }
  }

  void _updateTimesList() {
    _times = _selectedTimes
        .where((time) => time != null)
        .map((time) => time!.format(context))
        .toList();
  }

  bool _isValidNumTimes(String value) {
    int? num = int.tryParse(value);
    return num != null && num > 0 && num <= 4;
  }

  Future<void> _updateMedicine() async {
    if (_scheduleType == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a schedule type',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      return;
    }
    if (_scheduleType == 1 && (_selectedTimes.isEmpty || _selectedTimes.contains(null))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select all times for daily schedule',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      return;
    }
    if (_scheduleType == 2 && _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a time for every X days schedule',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      return;
    }
    if (_scheduleType == 3 && !_bitmaskDays.contains(1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one day for specific days schedule',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> updates = {
        'name': _medNameController.text,
        'pillsLeft': int.parse(_pillsController.text),
        'dosage': int.parse(_dosageController.text),
        'scheduleType': _scheduleType - 1,
        'scheduleValue': _numTimesController.text.isNotEmpty
            ? int.parse(_numTimesController.text)
            : (_daysIntervalController.text.isNotEmpty
            ? int.parse(_daysIntervalController.text)
            : 0),
        'times': _times,
        'bitmaskDays': _bitmaskDays,
        'compartmentNumber': widget.compartmentNumber,
      };

      var result = await SmartMedicalDb.updateMedicine(
        medicineId: widget.medicineId,
        updates: updates,
      );

      if (result['success']) {
        await sendAllMedicationsToArduino();
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
        title: const Text('Edit Medicine'),
        centerTitle: true,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Edit Medicine', fonSize: 20)
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Compartment Number', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: TextEditingController(text: widget.compartmentNumber.toString()),
                      readOnly: true,
                      enablation: false,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Med Name', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _medNameController,
                      labelText: 'Enter the name of the Medicine',
                      validatorText: 'Please enter the name of the medicine',
                      keyboardType: TextInputType.text,
                      readOnly: false,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Pills', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _pillsController,
                      labelText: 'Enter the number of pills added',
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText: 'Please enter the number of pills',
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Dosage', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _dosageController,
                      labelText: 'Enter the number of pills every time',
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText: 'Please enter the number of the pills',
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Schedule Type', fonSize: 15),
                    const SizedBox(height: 10),
                    buildDropdownButton(context),
                    const SizedBox(height: 25),
                    if (_scheduleType == 1) ...[
                      const CustomText(text: 'How many times per day?', fonSize: 15),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _numTimesController,
                        readOnly: false,
                        labelText: 'Enter number of times per day',
                        validatorText: 'Please enter the number of the times',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                            _selectedTimes = [];
                            if (!_isValidNumTimes(value)) {
                              if (value.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Number of times must be between 1 and 4',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        maxValue: 4,
                      ),
                      const SizedBox(height: 25),
                      if (_numTimesController.text.isNotEmpty &&
                          int.tryParse(_numTimesController.text) != null &&
                          int.parse(_numTimesController.text) > 0 &&
                          int.parse(_numTimesController.text) <= 4) ...[
                        Builder(
                          builder: (context) {
                            int numTimes = int.parse(_numTimesController.text);
                            if (_selectedTimes.length != numTimes) {
                              _selectedTimes = List<TimeOfDay?>.filled(numTimes, null);
                            }
                            return Column(
                              children: List.generate(numTimes, (i) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: _selectedTimes[i] ?? TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          _selectedTimes[i] = time;
                                          _updateTimesList();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedTimes[i] != null
                                          ? Theme.of(context).brightness == Brightness.dark
                                          ? AppColors.mainColorDark
                                          : AppColors.mainColor
                                          : null,
                                    ),
                                    child: Text(
                                      _selectedTimes[i] != null
                                          ? _selectedTimes[i]!.format(context)
                                          : 'Add Time ${i + 1}',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ],
                    if (_scheduleType == 2) ...[
                      const CustomText(text: 'Every how many days?', fonSize: 15),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _daysIntervalController,
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        labelText: 'Enter number of days',
                        validatorText: 'Please enter the number of the days',
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                            _selectedTime = null;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      if (_daysIntervalController.text.isNotEmpty &&
                          int.tryParse(_daysIntervalController.text) != null &&
                          int.parse(_daysIntervalController.text) > 0) ...[
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _selectedTime = time;
                                _times = [time.format(context)];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedTime != null
                                ? Theme.of(context).brightness == Brightness.dark
                                ? AppColors.mainColorDark
                                : AppColors.mainColor
                                : null,
                          ),
                          child: Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : 'Add Time',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ],
                    ],
                    if (_scheduleType == 3) ...[
                      const CustomText(text: 'Select Specific Days', fonSize: 15),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _bitmaskDays[index] = _bitmaskDays[index] == 1 ? 0 : 1;
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
                                ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"][index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Update',
                      onPressed: _updateMedicine,
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<int> buildDropdownButton(BuildContext context) {
    return DropdownButton<int>(
      value: _scheduleType,
      onChanged: (newValue) {
        setState(() {
          _numTimesController.text = '';
          _daysIntervalController.text = '';
          _scheduleType = newValue!;
          _times.clear();
          _selectedTimes = [];
          _selectedTime = null;
          _bitmaskDays = [0, 0, 0, 0, 0, 0, 0];
        });
      },
      items: [
        DropdownMenuItem<int>(
          value: 0,
          child: Text(
            'Select Type',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : AppColors.gray,
            ),
          ),
        ),
        const DropdownMenuItem<int>(value: 1, child: Text('Daily')),
        const DropdownMenuItem<int>(value: 2, child: Text('Every X Days')),
        const DropdownMenuItem<int>(value: 3, child: Text('Specific Days')),
      ],
    );
  }

  Future<void> sendAllMedicationsToArduino() async {
    try {
      // Fetch all medications for the user
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Transform data
      List<Map<String, dynamic>> medications = medicationsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          "name": data["name"],
          "dosage": data["dosage"],
          "scheduleType": data["scheduleType"],
          "scheduleValue": data["scheduleValue"],
          "times": data["times"],
          "bitmaskDays": data["bitmaskDays"],
          "pillsLeft": data["pillsLeft"],
          "compartmentNumber": data["compartmentNumber"],
        };
      }).toList();

      // Send each medication individually
      for (var med in medications) {
        String dataToSend = jsonEncode({"medication": med});
        print("Data to send: $dataToSend");
        await _bluetoothManager.sendData(dataToSend);
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Notify user if Bluetooth is not connected
      if (!_bluetoothManager.isConnected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth not connected. Data will be sent later."),
          ),
        );
      }

      // Update syncStatus to "Synced" for all sent medications
      for (var doc in medicationsSnapshot.docs) {
        await SmartMedicalDb.updateMedicationSyncStatus(
          medId: doc.id,
          syncStatus: 'Synced',
        );
      }
    } catch (e) {
      print("Error sending medications: $e");
    }
  }

  @override
  void dispose() {
    _medNameController.dispose();
    _pillsController.dispose();
    _dosageController.dispose();
    _numTimesController.dispose();
    _daysIntervalController.dispose();
    super.dispose();
  }
}