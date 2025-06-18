import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Services/bluetoothServices.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import 'package:smart_medic/core/widgets/BuildText.dart';
import 'package:smart_medic/core/widgets/build_text_field.dart';
import '../../../../../Services/firebaseServices.dart';
import '../../../../../Services/notificationService.dart';

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
  String _commonTimeForSpecificDays = "";
  bool _isLoading = false;

  final BluetoothManager _bluetoothManager = BluetoothManager();

  @override
  void initState() {
    super.initState();
    _bluetoothManager.initBluetooth();
    _medNameController = TextEditingController(text: widget.medicineData['name'] ?? '');
    _pillsController = TextEditingController(text: widget.medicineData['pillsLeft']?.toString() ?? '');
    _dosageController = TextEditingController(text: widget.medicineData['dosage']?.toString() ?? '');
    _numTimesController = TextEditingController(text: widget.medicineData['scheduleValue']?.toString() ?? '');
    _daysIntervalController = TextEditingController(text: widget.medicineData['scheduleValue']?.toString() ?? '');
    _scheduleType = widget.medicineData['scheduleType'] + 1;
    _times = List<String>.from(widget.medicineData['times'] ?? []);
    _bitmaskDays = List<int>.from(widget.medicineData['bitmaskDays'] ?? [0, 0, 0, 0, 0, 0, 0]);

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
    } else if (_scheduleType == 3 && _times.isNotEmpty) {
      _commonTimeForSpecificDays = _times[0];
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

  Future<void> _updateMedicine() async {
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
      Map<String, dynamic> updates = {
        'name': _medNameController.text.trim(),
        'pillsLeft': pillsLeft,
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
        BluetoothManager.needsSync = true;
        await LocalNotificationService.scheduleMedicineNotifications();
        await syncMedications();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Medicine updated successfully!',
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
            'Error updating medication: $e',
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
                        CustomText(text: 'Edit Medicine', fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Compartment Number', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: TextEditingController(text: widget.compartmentNumber.toString()),
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