import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import '../../../../../Services/bluetoothServices.dart';
import '../../../../../Services/firebaseServices.dart';
import '../../../../../Services/notificationService.dart';
import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/build_text_field.dart';

class addNewMedicine extends StatefulWidget {
  final int compNum;
  const addNewMedicine({super.key, required this.compNum});

  @override
  State<addNewMedicine> createState() => _Add_new_Medicine();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _Add_new_Medicine extends State<addNewMedicine> {
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _numTimesController = TextEditingController();
  final TextEditingController _daysIntervalController = TextEditingController();

  int _scheduleType = 0;
  List<String> _times = [];
  List<TimeOfDay?> _selectedTimes = [];
  TimeOfDay? _selectedTime; // For single time in scheduleType 2 and 3
  List<int> _bitmaskDays = [0, 0, 0, 0, 0, 0, 0];
  String _commonTimeForSpecificDays = ""; // Single time for all selected days in scheduleType 3

  final BluetoothManager _bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _bluetoothManager.initBluetooth();
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

  @override
  Widget build(BuildContext context) {
    const List<String> daysOfWeek = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Add New Medicine', fonSize: 20)
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Compartment Number', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: TextEditingController(
                          text: (widget.compNum).toString()),
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
                        validatorText: 'Please enter the number of pills'),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Dosage', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: _dosageController,
                        labelText: 'Enter the number of pills every time',
                        keyboardType: TextInputType.number,
                        readOnly: false,
                        validatorText: 'Please enter the number of the pills'),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Times',
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: List.generate(numTimes, (i) {
                                    return _selectedTimes[i] != null
                                        ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Chip(
                                          label: Text(_selectedTimes[i]!.format(context)),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedTimes[i] = null;
                                              _updateTimesList();
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    )
                                        : const SizedBox.shrink();
                                  }),
                                ),
                                const SizedBox(height: 5),
                                if (_selectedTimes.where((time) => time != null).length < numTimes)
                                  ActionChip(
                                    label: Text(
                                      _selectedTimes.where((time) => time != null).isEmpty
                                          ? 'Add Time'
                                          : 'Add Another Time',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                    onPressed: () async {
                                      TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          int firstNullIndex = _selectedTimes.indexWhere((t) => t == null);
                                          if (firstNullIndex != -1) {
                                            _selectedTimes[firstNullIndex] = time;
                                            _updateTimesList();
                                          }
                                        });
                                      }
                                    },
                                    backgroundColor:
                                    Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                  ),
                              ],
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
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                            _selectedTime = null;
                          });
                        },
                        validatorText: 'Please enter the number of the days',
                      ),
                      const SizedBox(height: 25),
                      if (_daysIntervalController.text.isNotEmpty &&
                          int.tryParse(_daysIntervalController.text) != null &&
                          int.parse(_daysIntervalController.text) > 0) ...[
                        const Text(
                          'Select Time',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            if (_selectedTime != null) ...[
                              Chip(
                                label: Text(_selectedTime!.format(context)),
                                onDeleted: () {
                                  setState(() {
                                    _selectedTime = null;
                                    _times = [];
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                            ActionChip(
                              label: Text(
                                _selectedTime == null ? 'Add Time' : 'Change Time',
                                style: TextStyle(color: AppColors.white),
                              ),
                              onPressed: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _selectedTime = time;
                                    _times = [time.format(context)];
                                  });
                                }
                              },
                              backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.mainColorDark
                                  : AppColors.mainColor,
                            ),
                          ],
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
                                    ? Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.mainColorDark
                                    : AppColors.mainColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                daysOfWeek[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 25),
                      if (_bitmaskDays.contains(1)) ...[
                        const CustomText(text: 'Select Time for Selected Days', fonSize: 15),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (_commonTimeForSpecificDays.isNotEmpty) ...[
                              Chip(
                                label: Text(_commonTimeForSpecificDays),
                                onDeleted: () {
                                  setState(() {
                                    _commonTimeForSpecificDays = "";
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                            ActionChip(
                              label: Text(
                                _commonTimeForSpecificDays.isEmpty
                                    ? 'Add Time'
                                    : 'Change Time',
                                style: TextStyle(color: AppColors.white),
                              ),
                              onPressed: () async {
                                TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _commonTimeForSpecificDays = time.format(context);
                                    _times = [time.format(context)]; // Store in times
                                  });
                                }
                              },
                              backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.mainColorDark
                                  : AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Submit',
                      onPressed: () async {
                        if (_scheduleType == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a schedule type',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 1 &&
                            (_selectedTimes.isEmpty ||
                                _selectedTimes.contains(null))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select all times for daily schedule',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 3 &&
                            _bitmaskDays.contains(1) &&
                            _commonTimeForSpecificDays.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a common time for the selected days',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 3 &&
                            !_bitmaskDays.contains(1)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select at least one day for specific days schedule',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 2 && _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a time for every X days schedule',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_formKey.currentState!.validate()) {
                           addMedication();
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
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
          _commonTimeForSpecificDays = "";
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

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addMedication() async {
    var result = await SmartMedicalDb.addMedication(
      patientId: user!.uid,
      name: _medNameController.text,
      dosage: int.parse(_dosageController.text),
      scheduleType: (_scheduleType - 1),
      scheduleValue: _numTimesController.text.isNotEmpty
          ? int.parse(_numTimesController.text)
          : (_daysIntervalController.text.isNotEmpty
          ? int.parse(_daysIntervalController.text)
          : 0),
      times: _times,
      bitmaskDays: _bitmaskDays,
      pillsLeft: int.parse(_pillsController.text),
      compartmentNumber: widget.compNum,
    );

    if (result['success']) {
      // Schedule notifications after adding the medication
       LocalNotificationService.scheduleMedicineNotifications();
      // Send data to Arduino and update sync status
      await sendAllMedicationsToArduino();
      if (mounted) {
        Navigator.pop(context); // Ensure navigation happens
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'],
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }
  }

  Future<void> sendAllMedicationsToArduino() async {
    try {
      print('Starting sendAllMedicationsToArduino...');
      // Fetch all medications for the user
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: user!.uid)
          .get();

      print('Found ${medicationsSnapshot.docs.length} medications to sync.');

      // Transform data
      List<Map<String, dynamic>> medications = medicationsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // فحص الحقول اللي ممكن تكون null
        String name = data["name"]?.toString() ?? "Unknown";
        int dosage = data["dosage"] ?? 0;
        int scheduleType = data["scheduleType"] ?? 0;
        int scheduleValue = data["scheduleValue"] ?? 0;
        List<String> times = (data["times"] as List<dynamic>?)?.cast<String>() ?? [];
        List<int> bitmaskDays = (data["bitmaskDays"] as List<dynamic>?)?.cast<int>() ?? [0, 0, 0, 0, 0, 0, 0];
        int pillsLeft = data["pillsLeft"] ?? 0;
        int compartmentNumber = data["compartmentNumber"] ?? 0;

        return {
          "id": doc.id, // إضافة الـ id
          "name": name,
          "dosage": dosage,
          "scheduleType": scheduleType,
          "scheduleValue": scheduleValue,
          "times": times,
          "bitmaskDays": bitmaskDays,
          "pillsLeft": pillsLeft,
          "compartmentNumber": compartmentNumber,
        };
      }).toList();

      // Send each medication individually
      for (var med in medications) {
        String dataToSend = jsonEncode({"medication": med}) + "\n";
        print("Sending data to Arduino: $dataToSend");
        try {
          await _bluetoothManager.sendData(dataToSend);
          print("Data sent successfully for medication: ${med['name']}");
          // Update syncStatus to "Synced" only if the data was sent successfully
          await SmartMedicalDb.updateMedicationSyncStatus(
            medId: med['id'],
            syncStatus: 'Synced',
          );
          print('Sync status updated to Synced for medication: ${med['id']}');
        } catch (e) {
          print("Error sending data for medication ${med['name']}: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to send ${med['name']} to Arduino: $e",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            );
          }
          // If sending fails, ensure syncStatus remains "Pending"
          await SmartMedicalDb.updateMedicationSyncStatus(
            medId: med['id'],
            syncStatus: 'Pending',
          );
          print('Sync status remains Pending for medication: ${med['id']}');
        }
        await Future.delayed(const Duration(seconds: 2));
      }

      // Notify user if Bluetooth is not connected
      if (!_bluetoothManager.isConnected && mounted) {
        print('Bluetooth not connected. Showing snackbar.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth not connected. Data will be sent later."),
          ),
        );
      }

      // Show Data Synced Notification only if at least one medication was synced
      if (medications.isNotEmpty && _bluetoothManager.isConnected) {
        print('Showing data synced notification.');
        await LocalNotificationService.showDataSyncedNotification();
      }
    } catch (e) {
      print("Error in sendAllMedicationsToArduino: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error syncing medications: $e",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
      }

      // Ensure syncStatus is updated to "Pending" for all medications if there's a general error
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: user!.uid)
          .get();
      for (var doc in medicationsSnapshot.docs) {
        print('Updating syncStatus after error for medication: ${doc.id}');
        await SmartMedicalDb.updateMedicationSyncStatus(
          medId: doc.id,
          syncStatus: 'Pending',
        );
      }
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