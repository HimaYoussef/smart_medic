import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_medic/Services/bluetoothServices.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/Services/notificationService.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import 'package:smart_medic/core/widgets/BuildText.dart';
import 'package:smart_medic/core/widgets/build_text_field.dart';
import 'package:smart_medic/generated/l10n.dart';
import 'package:http/http.dart' as http;

class addNewMedicine extends StatefulWidget {
  final int compNum;
  const addNewMedicine({super.key, required this.compNum});

  @override
  State<addNewMedicine> createState() => _Add_new_Medicine();
}

class _Add_new_Medicine extends State<addNewMedicine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _pillsController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _numTimesController = TextEditingController();
  final TextEditingController _daysIntervalController = TextEditingController();
  int _scheduleType = 0;
  List<String> _times = [];
  List<TimeOfDay?> _selectedTimes = [];
  TimeOfDay? _selectedTime;
  List<int> _bitmaskDays = [0, 0, 0, 0, 0, 0, 0];
  String _commonTimeForSpecificDays = "";
  final BluetoothManager _bluetoothManager = BluetoothManager();
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _apiKey = 'AIzaSyB29LATB5vUReQSnTfDcPR0HyeQX1rb6n0';
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

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

  void _showImageSourceOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Add_New_Medicine_Select_Option),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: Text(S.of(context).Add_New_Medicine_Take_Photo),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(S.of(context).Add_New_Medicine_Pick_From_Gallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: Text(S.of(context).Add_New_Medicine_Analyze_Name),
                onTap: () {
                  Navigator.pop(context);
                  _analyzeMedicineName();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
        _medNameController.clear(); // Clear previous medicine name
      });

      await _extractAndAnalyzeMedicine(File(pickedFile.path));
    }
  }

  Future<void> _analyzeMedicineName() async {
    if (_medNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).Add_New_Medicine_Please_Enter_Medicine_Name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var output = await _getMedicineAnalysis(_medNameController.text);
      if (mounted) {
        _showAnalysisResultDialog(output);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _extractAndAnalyzeMedicine(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Extract medicine name from image
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final requestBodyExtract = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'inlineData': {
                  'mimeType': 'image/png',
                  'data': base64Image,
                },
              },
              {
                'text':
                    'What is the name of the medicine shown on this label? Only respond with the medicine name if its a medicine else return not a medicine.',
              },
            ],
          },
        ],
        'generationConfig': {'temperature': 0},
      };

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBodyExtract),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to extract medicine name: ${response.reasonPhrase}');
      }

      final data = jsonDecode(response.body);
      String medicineName =
          data['candidates'][0]['content']['parts'][0]['text'].trim();

      setState(() {
        _medNameController.text = medicineName;
      });

      // Analyze the extracted medicine name
      var output = await _getMedicineAnalysis(medicineName);
      if (mounted) {
        _showAnalysisResultDialog(output);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getMedicineAnalysis(String medicineName) async {
    // Fetch existing medications from Firestore
    List<String> existingMeds = [];
    final user = _auth.currentUser;
    if (user != null) {
      final medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: user.uid)
          .get();
      existingMeds = medicationsSnapshot.docs
          .map((doc) => doc.data()['name'] as String)
          .toList();
    }

    // Define the system instruction for the Gemini API
    final systemInstruction = '''
You are given the photo of a medicine box. 
If it's not a medicine, 
make the name \"Not Medicine\" and request to scan real medicine 
in summary Your task is to analyze the image and perform the following steps in sequence:
\n\nExtract the medicine name from the photo.
\n\nIdentify up to 3 common side effects associated with the medicine, if available.
\n\nEvaluate potential drug interactions between the extracted medicine and a list of previously taken medicines provided in the form of a JSON array.
 Each entry contains only a \"name\" field.\n\nExample of the input JSON:
 \n\njson\n[\n  {\n    \"name\": \"Claritine\"\n  },\n  {\n    \"name\": \"Augmentin\"\n  }\n]\nBased on this information, 
 generate a single concise JSON output with the following structure:\n\njson\n{\n  \"name\": \"<Extracted medicine name>\",\n  \"summary\": \"<Sentence listing up to 3 side effects.
  If any medicine from the input list has known interactions with the new medicine, provide a clear and short warning.
   End the summary with either reassurance of no interaction or a recommendation to consult a professional.
   >\"\n}\nConstraints:\n\nYour response must be only a single JSON object, with no extra text before or after.
   \n\nThe language should be clear, simple, and patient-friendly.
   \n\nIf there are no probability of known side effects or interactions, explicitly state so.
   \n\nAlways begin the summary by listing the side effects, unless none are known.\n\nAlways compare the new medicine against all entries in the provided list.\n\n
''';

    // Prepare the API request
    final existingMedsJson =
        jsonEncode(existingMeds.map((name) => {"name": name}).toList());
    final requestBodyAnalyze = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  'New Medicine: $medicineName\nExisting Medicines:\n$existingMedsJson',
            },
          ],
        },
      ],
      'systemInstruction': {
        'parts': [
          {
            'text': systemInstruction,
          },
        ],
      },
      'generationConfig': {
        'temperature': 0,
        'responseMimeType': 'application/json',
      },
    };

    // Send the POST request to the Gemini API
    final analyzeResponse = await http.post(
      Uri.parse('$_apiUrl?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBodyAnalyze),
    );

    // Handle the response
    if (analyzeResponse.statusCode == 200) {
      final data = jsonDecode(analyzeResponse.body);
      final output =
          jsonDecode(data['candidates'][0]['content']['parts'][0]['text']);
      return output;
    } else {
      throw Exception(
          'Error analyzing medicine: ${analyzeResponse.reasonPhrase}');
    }
  }

  void _showAnalysisResultDialog(Map<String, dynamic> output) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Add_New_Medicine_Analysis_Result),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              children: [
                TextSpan(
                  text: 'Medicine: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${output['name']}\n'),
                TextSpan(
                  text: 'Summary: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: output['summary']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).Add_New_Medicine_OK),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).Add_New_Medicine_Error),
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 18.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).Add_New_Medicine_OK),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const List<String> daysOfWeek = [
      "Sat",
      "Sun",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri"
    ];

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text: S.of(context).Add_New_Medicine_Head,
                            fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    CustomText(
                        text: S.of(context).Add_New_Medicine_Compartment_Number,
                        fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: TextEditingController(
                          text: widget.compNum.toString()),
                      readOnly: true,
                      enablation: false,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                        text: S.of(context).Add_New_Medicine_Med_Name,
                        fonSize: 15),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _medNameController,
                            labelText:
                                S.of(context).Add_New_Medicine_labelText1,
                            validatorText:
                                S.of(context).Add_New_Medicine_validatorText1,
                            keyboardType: TextInputType.text,
                            readOnly: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                          backgroundColor: AppColors.mainColor,
                          onPressed:
                              _isLoading ? null : _showImageSourceOptions,
                          tooltip:
                              S.of(context).Add_New_Medicine_Analyze_Options,
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Pills', fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _pillsController,
                      labelText: S.of(context).Add_New_Medicine_labelText2,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText:
                          S.of(context).Add_New_Medicine_validatorText2,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                        text: S.of(context).Add_New_Medicine_Dosage,
                        fonSize: 15),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _dosageController,
                      labelText: S.of(context).Add_New_Medicine_labelText3,
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      validatorText:
                          S.of(context).Add_New_Medicine_validatorText3,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                        text: S.of(context).Add_New_Medicine_Schedule_Type,
                        fonSize: 15),
                    const SizedBox(height: 10),
                    buildDropdownButton(context),
                    const SizedBox(height: 25),
                    if (_scheduleType == 1) ...[
                      CustomText(
                          text: S
                              .of(context)
                              .Add_New_Medicine_How_many_times_per_day,
                          fonSize: 15),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _numTimesController,
                        readOnly: false,
                        labelText: S.of(context).Add_New_Medicine_labelText4,
                        validatorText:
                            S.of(context).Add_New_Medicine_validatorText4,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            if (_isValidNumTimes(value)) {
                              int numTimes = int.parse(value);
                              List<TimeOfDay?> newTimes =
                                  List<TimeOfDay?>.filled(numTimes, null);
                              for (int i = 0;
                                  i < _selectedTimes.length && i < numTimes;
                                  i++) {
                                newTimes[i] = _selectedTimes[i];
                              }
                              _selectedTimes = newTimes;
                              _updateTimesList();
                            } else {
                              _selectedTimes = [];
                              _times = [];
                              if (value.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      S.of(context).Add_New_Medicine_SnackBar,
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
                        Builder(builder: (context) {
                          int numTimes = int.parse(_numTimesController.text);
                          if (_selectedTimes.length != numTimes) {
                            _selectedTimes =
                                List<TimeOfDay?>.filled(numTimes, null);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Times',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
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
                                              label: Text(_selectedTimes[i]!
                                                  .format(context)),
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
                              if (_selectedTimes
                                      .where((time) => time != null)
                                      .length <
                                  _selectedTimes.length)
                                ActionChip(
                                  label: Text(
                                    _selectedTimes
                                            .where((time) => time != null)
                                            .isEmpty
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
                                        int firstNullIndex = _selectedTimes
                                            .indexWhere((t) => t == null);
                                        if (firstNullIndex != -1) {
                                          _selectedTimes[firstNullIndex] = time;
                                          _updateTimesList();
                                        }
                                      });
                                    }
                                  },
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.mainColorDark
                                          : AppColors.mainColor,
                                ),
                            ],
                          );
                        }),
                      ],
                    ],
                    if (_scheduleType == 2) ...[
                      CustomText(
                          text: S
                              .of(context)
                              .Add_New_Medicine_Every_how_many_days,
                          fonSize: 15),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _daysIntervalController,
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        labelText: S.of(context).Add_New_Medicine_labelText5,
                        validatorText:
                            S.of(context).Add_New_Medicine_validatorText5,
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
                                _selectedTime == null
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
                                    _selectedTime = time;
                                    _times = [time.format(context)];
                                  });
                                }
                              },
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.mainColorDark
                                  : AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                    if (_scheduleType == 3) ...[
                      CustomText(
                          text: S
                              .of(context)
                              .Add_New_Medicine_Select_Specific_Days,
                          fonSize: 15),
                      const SizedBox(height: 2),
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
                                    ? Theme.of(context).brightness ==
                                            Brightness.dark
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
                        const CustomText(
                            text: 'Select Time for Selected Days', fonSize: 15),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (_commonTimeForSpecificDays.isNotEmpty) ...[
                              Chip(
                                label: Text(_commonTimeForSpecificDays),
                                onDeleted: () {
                                  setState(() {
                                    _commonTimeForSpecificDays = "";
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
                                    _commonTimeForSpecificDays =
                                        time.format(context);
                                    _times = [
                                      time.format(context)
                                    ]; // Store in times
                                  });
                                }
                              },
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.mainColorDark
                                  : AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 30),
                    CustomButton(
                      text: S.of(context).Add_New_Medicine_Submit,
                      onPressed: () async {
                        if (_scheduleType == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S
                                    .of(context)
                                    .Add_New_Medicine_Please_select_a_schedule_type,
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
                                S
                                    .of(context)
                                    .Add_New_Medicine_Please_select_all_times_for_daily_schedule,
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 2 &&
                            _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S
                                    .of(context)
                                    .Add_New_Medicine_Please_select_a_time_for_every_X_days_schedule,
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_scheduleType == 3 &&
                            !_bitmaskDays.contains(1)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                S
                                    .of(context)
                                    .Add_New_Medicine_Please_select_at_least_one_day_for_specific_days_schedule,
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
                                S
                                    .of(context)
                                    .Add_New_Medicine_Please_select_a_time_for_specific_days_schedule,
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        } else if (_formKey.currentState!.validate()) {
                          await addMedication();
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
            S.of(context).Add_New_Medicine_Select_Type,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : AppColors.gray,
            ),
          ),
        ),
        DropdownMenuItem<int>(
            value: 1, child: Text(S.of(context).Add_New_Medicine_Daily)),
        DropdownMenuItem<int>(
            value: 2, child: Text(S.of(context).Add_New_Medicine_Every_X_Days)),
        DropdownMenuItem<int>(
            value: 3,
            child: Text(S.of(context).Add_New_Medicine_Specific_Days)),
      ],
    );
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> addMedication() async {
    var result = await SmartMedicalDb.addMedication(
      patientId: user!.uid,
      name: _medNameController.text,
      dosage: int.parse(_dosageController.text),
      scheduleType: _scheduleType - 1,
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
      await LocalNotificationService.scheduleMedicineNotifications();
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
    return result;
  }

  Future<void> sendAllMedicationsToArduino() async {
    try {
      print('Starting sendAllMedicationsToArduino...');
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: user!.uid)
          .get();

      print('Found ${medicationsSnapshot.docs.length} medications to sync.');

      List<Map<String, dynamic>> medications =
          medicationsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        String name = data["name"]?.toString() ?? "Unknown";
        int dosage = data["dosage"] ?? 0;
        int scheduleType = data["scheduleType"] ?? 0;
        int scheduleValue = data["scheduleValue"] ?? 0;
        List<String> times =
            (data["times"] as List<dynamic>?)?.cast<String>() ?? [];
        List<int> bitmaskDays =
            (data["bitmaskDays"] as List<dynamic>?)?.cast<int>() ??
                [0, 0, 0, 0, 0, 0, 0];
        int pillsLeft = data["pillsLeft"] ?? 0;
        int compartmentNumber = data["compartmentNumber"] ?? 0;

        return {
          "id": doc.id,
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

      for (var med in medications) {
        String dataToSend = jsonEncode({"medication": med}) + "\n";
        print("Sending data to Arduino: $dataToSend");
        try {
          await _bluetoothManager.sendData(dataToSend);
          print("Data sent successfully for medication: ${med['name']}");
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
          await SmartMedicalDb.updateMedicationSyncStatus(
            medId: med['id'],
            syncStatus: 'Pending',
          );
          print('Sync status remains Pending for medication: ${med['id']}');
        }
        await Future.delayed(const Duration(seconds: 2));
      }

      if (!_bluetoothManager.isConnected && mounted) {
        print('Bluetooth not connected. Showing snackbar.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bluetooth not connected. Data will be sent later."),
          ),
        );
      }

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
