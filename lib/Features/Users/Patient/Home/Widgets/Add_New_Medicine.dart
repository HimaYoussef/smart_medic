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
  State<addNewMedicine> createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<addNewMedicine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _numTimesController = TextEditingController();
  final TextEditingController _daysIntervalController = TextEditingController();

  bool _isLoading = false;
  int _scheduleType = 0;
  List<String> _times = [];
  List<TimeOfDay?> _selectedTimes = [];
  TimeOfDay? _selectedTime;
  List<int> _bitmaskDays = [0, 0, 0, 0, 0, 0, 0];
  String _commonTimeForSpecificDays = '';

  final BluetoothManager _bluetoothManager = BluetoothManager();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _bluetoothManager.initBluetooth();
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoadingOverlay(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
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

  Future<void> addMedication() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields correctly.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }

    int pillsLeft = int.parse(_pillsController.text);
    if (pillsLeft > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Total pills cannot exceed 50.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }

    if (_scheduleType == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a schedule type.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }
    if (_scheduleType == 1 && (_selectedTimes.isEmpty || _selectedTimes.contains(null))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select all times for daily schedule.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }
    if (_scheduleType == 2 && _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a time for every X days schedule.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }
    if (_scheduleType == 3 && !_bitmaskDays.contains(1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one day for specific days schedule.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }
    if (_scheduleType == 3 && _bitmaskDays.contains(1) && _commonTimeForSpecificDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a common time for the selected days.',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    _showLoadingOverlay(context);

    try {
      var result = await SmartMedicalDb.addMedication(
        patientId: user!.uid,
        name: _medNameController.text.trim(),
        dosage: int.parse(_dosageController.text),
        scheduleType: _scheduleType - 1,
        scheduleValue: _numTimesController.text.isNotEmpty
            ? int.parse(_numTimesController.text)
            : (_daysIntervalController.text.isNotEmpty
            ? int.parse(_daysIntervalController.text)
            : 0),
        times: _times,
        bitmaskDays: _bitmaskDays,
        pillsLeft: pillsLeft,
        compartmentNumber: widget.compNum,
      );

      if (result['success']) {
        BluetoothManager.needsSync = true;
        await LocalNotificationService.scheduleMedicineNotifications();
        await syncMedications();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Medicine added successfully!',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
          ),
        );
        _medNameController.clear();
        _pillsController.clear();
        _dosageController.clear();
        _numTimesController.clear();
        _daysIntervalController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding medication: $e',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
        ),
      );
    } finally {
      _hideLoadingOverlay(context);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> syncMedications() async {
    try {
      Map<String, dynamic> result = await _bluetoothManager.sendAllMedicationsToArduino();
      if (!result['success'] && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
          ),
        );
      }
      if (result['medicationsSynced'] && mounted) {
        await LocalNotificationService.showDataSyncedNotification();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unexpected error syncing medications: $e',
              style: TextStyle(color: AppColors.white),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.mainColorDark
                : AppColors.mainColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<String> daysOfWeek = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

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
                        CustomText(text: 'Add New Medicine', fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Compartment Number', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: TextEditingController(text: widget.compNum.toString()),
                      readOnly: true,
                      enablation: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Medicine Name', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _medNameController,
                      labelText: 'Enter the name of the medicine',
                      validatorText: 'Please enter a valid medicine name',
                      keyboardType: TextInputType.text,
                      readOnly: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Number of Pills', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _pillsController,
                      labelText: 'Enter the number of pills',
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText: 'Please enter a valid number of pills',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Dosage', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _dosageController,
                      labelText: 'Enter the number of pills per dose',
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText: 'Please enter a valid dosage (1-4)',
                      maxValue: 4,
                      textInputAction: TextInputAction.next,
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
                        labelText: 'Enter number of times per day (1-4)',
                        validatorText: 'Please enter a valid number of times (1-4)',
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
                                      'Number of times must be between 1 and 4.',
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                  ),
                                );
                              }
                            }
                          });
                        },
                        maxValue: 4,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 25),
                      if (_numTimesController.text.isNotEmpty &&
                          int.tryParse(_numTimesController.text) != null &&
                          int.parse(_numTimesController.text) > 0 &&
                          int.parse(_numTimesController.text) <= 6) ...[
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
                                const SizedBox(height: 1),
                                if (_selectedTimes.where((element) => element != null).length < numTimes)
                                  ActionChip(
                                    label: Text(
                                      _selectedTimes.where((element) => element != null).isEmpty
                                          ? 'Add Time'
                                          : 'Add Another Time',
                                      style: TextStyle(color: Colors.white),
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
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
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
                        validatorText: 'Please enter a valid number of days',
                        onChanged: (value) {
                          setState(() {
                            _times = [];
                            _selectedTime = null;
                          });
                        },
                        textInputAction: TextInputAction.next,
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
                                  initialTime: _selectedTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setState(() {
                                    _selectedTime = time;
                                    _times = [time.format(context)];
                                  });
                                }
                              },
                              backgroundColor: Theme.of(context).brightness == Brightness.dark
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
                                    _commonTimeForSpecificDays = '';
                                    _times = [];
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
                                    _times = [time.format(context)];
                                  });
                                }
                              },
                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.mainColorDark
                                  : AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 30),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                      text: 'Submit',
                      onPressed: addMedication,
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
          _commonTimeForSpecificDays = '';
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