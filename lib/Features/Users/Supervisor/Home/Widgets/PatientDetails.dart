import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/LogItem.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import '../../../../../core/utils/Colors.dart';
import '../../../../../core/utils/Style.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class PatientDetailsView extends StatefulWidget {
  final String patientId;
  final String patientName;

  const PatientDetailsView({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatLogTime(Map<String, dynamic> log) {
    try {
      if (log['minutesMidnight'] != null) {
        int minutes = log['minutesMidnight'] as int;
        int hours = minutes ~/ 60;
        int remainingMinutes = minutes % 60;
        return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
      }
      Timestamp? timestamp = log['timestamp'];
      if (timestamp != null) {
        return DateFormat('HH:mm').format(timestamp.toDate());
      }
      return "Unknown";
    } catch (e) {
      print('Error formatting time: $e');
      return "Unknown";
    }
  }

  String getScheduleText(int scheduleType, int scheduleValue,
      List<dynamic>? times, List<dynamic>? bitmaskDays) {
    if (times == null || times.isEmpty) {
      return 'Schedule: Not Set';
    }

    String timesText = times.join(', ');

    if (scheduleType == 0) {
      return 'Daily at $timesText';
    } else if (scheduleType == 1) {
      return 'Every $scheduleValue days at $timesText';
    } else if (scheduleType == 2) {
      if (bitmaskDays == null ||
          bitmaskDays.isEmpty ||
          bitmaskDays.length != 7) {
        return 'On: None Selected at $timesText';
      }

      const List<String> dayAbbreviations = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat'
      ];
      List<String> selectedDays = [];

      for (int i = 0; i < bitmaskDays.length; i++) {
        if (bitmaskDays[i] == 1) {
          selectedDays.add(dayAbbreviations[i]);
        }
      }

      if (selectedDays.isEmpty) {
        return 'On: None Selected at $timesText';
      }

      String daysText = selectedDays.join(', ');
      return 'On $daysText at $timesText';
    }
    return 'Schedule: Unknown';
  }

  Future<void> generateAndDownloadPDF() async {
    try {
      final pdf = pw.Document();
      final logsSnapshot =
          await SmartMedicalDb.readLogs(widget.patientId).first;
      final medicationsSnapshot =
          await SmartMedicalDb.readMedications(widget.patientId).first;

      Map<String, List<Map<String, dynamic>>> logsByDate = {};
      for (var doc in logsSnapshot.docs) {
        try {
          var log = doc.data() as Map<String, dynamic>;
          Timestamp? timestamp = log['timestamp'];
          if (timestamp != null) {
            String date = DateFormat('dd/MM/yyyy').format(timestamp.toDate());
            if (!logsByDate.containsKey(date)) {
              logsByDate[date] = [];
            }
            logsByDate[date]!.add(log);
          }
        } catch (err) {
          print('Error processing log ${doc.id}: $err');
        }
      }

      Map<String, String> medicationNames = {};
      for (var doc in logsSnapshot.docs) {
        var log = doc.data() as Map<String, dynamic>;
        if (log['medicationId'] != null &&
            !medicationNames.containsKey(log['medicationId'])) {
          try {
            var medicineData =
                await SmartMedicalDb.getMedicineById(log['medicationId']);
            medicationNames[log['medicationId']] = medicineData['success']
                ? medicineData['data']['name'] ?? 'Unknown'
                : 'Not found';
          } catch (err) {
            print('Error fetching medicine ${log['medicationId']}: $err');
            medicationNames[log['medicationId']] = 'Error';
          }
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: pw.PdfPageFormat.a4,
          build: (pw.Context context) {
            List<pw.Widget> content = [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Patient Medication and Health Log Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Paragraph(
                text: 'Patient Name: ${widget.patientName}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.Paragraph(
                text:
                    'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
            ];

            if (logsByDate.isNotEmpty) {
              content.add(pw.Header(
                level: 1,
                child: pw.Text('Logs',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ));
              for (var entry in logsByDate.entries) {
                String date = entry.key;
                List<Map<String, dynamic>> logs = entry.value;
                List<pw.Widget> logWidgets = [];

                for (var log in logs) {
                  String time = formatLogTime(log);
                  String text;
                  String? bpm;

                  if (log['medicationId'] != null) {
                    text =
                        "${medicationNames[log['medicationId']] ?? 'Unknown'} ${log['status']}";
                  } else {
                    text = log['spo2'] != null
                        ? "SpO2: ${log['spo2']}%"
                        : "Unknown";
                    bpm = log['heartRate'] != null && log['heartRate'] != 0
                        ? "Heart Rate: ${log['heartRate']}"
                        : null;
                  }

                  logWidgets.add(
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '$time - $text${bpm != null ? ' - $bpm' : ''}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.Divider(),
                      ],
                    ),
                  );
                }

                content.add(
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Header(
                        level: 2,
                        child: pw.Text(
                          date,
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      ...logWidgets,
                      pw.SizedBox(height: 10),
                    ],
                  ),
                );
              }
            } else {
              content.add(pw.Text('No logs available',
                  style: const pw.TextStyle(fontSize: 14)));
            }

            if (medicationsSnapshot.docs.isNotEmpty) {
              content.add(pw.SizedBox(height: 20));
              content.add(pw.Header(
                level: 1,
                child: pw.Text('Medications',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ));

              for (var med in medicationsSnapshot.docs) {
                final name = med['name'] ?? 'Unknown';
                final dosage = med['dosage']?.toString() ?? 'N/A';
                final scheduleType = med['scheduleType'] ?? 0;
                final scheduleValue = med['scheduleValue'] ?? 1;
                final times = med['times'] as List<dynamic>?;
                final bitmaskDays = med['bitmaskDays'] as List<dynamic>?;
                final pillsLeft = med['pillsLeft']?.toString() ?? 'N/A';
                final compartmentNumber =
                    med['compartmentNumber']?.toString() ?? 'N/A';

                content.add(
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Medicine: $name',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Dosage: $dosage',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text(
                        getScheduleText(
                            scheduleType, scheduleValue, times, bitmaskDays),
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text('Pills Left: $pillsLeft',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Compartment: $compartmentNumber',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Divider(),
                    ],
                  ),
                );
              }
            } else {
              content.add(pw.Text('No medications available',
                  style: const pw.TextStyle(fontSize: 14)));
            }

            return content;
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File(
          "${output.path}/patient_details_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf");
      await file.writeAsBytes(await pdf.save());

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open PDF: ${result.message}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF report generated and opened')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.patientName}\'s Details'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download Report as PDF',
            onPressed: generateAndDownloadPDF,
          ),
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
        bottom: TabBar(
          labelColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.gray
              : AppColors.black,
          indicatorColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.gray
              : AppColors.mainColor,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Logs'),
            Tab(text: 'Medications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: SmartMedicalDb.readLogs(widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}');
                  return const Center(child: Text("Error loading logs"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No logs available"));
                }

                Map<String, List<Map<String, dynamic>>> logsByDate = {};
                for (var doc in snapshot.data!.docs) {
                  try {
                    var log = doc.data() as Map<String, dynamic>;
                    Timestamp? timestamp = log['timestamp'];
                    if (timestamp != null) {
                      String date =
                          DateFormat('dd/MM/yyyy').format(timestamp.toDate());
                      if (!logsByDate.containsKey(date)) {
                        logsByDate[date] = [];
                      }
                      logsByDate[date]!.add(log);
                    } else {
                      print('Log skipped: Missing timestamp for doc ${doc.id}');
                    }
                  } catch (e) {
                    print('Error processing log ${doc.id}: $e');
                  }
                }

                if (logsByDate.isEmpty) {
                  return const Center(child: Text("No valid logs available"));
                }

                return ListView(
                  children: logsByDate.entries.map((entry) {
                    String date = entry.key;
                    List<Map<String, dynamic>> logs = entry.value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.cointainerDarkColor
                            : AppColors.mainColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: getTitleStyle(
                                color: AppColors.white, fontSize: 20),
                          ),
                          const SizedBox(height: 25),
                          const Divider(color: Colors.white),
                          ...logs.map((log) {
                            try {
                              String time = formatLogTime(log);
                              bool? isChecked;
                              String? bpm;
                              String text;

                              if (log['medicationId'] != null) {
                                return FutureBuilder<Map<String, dynamic>>(
                                  future: SmartMedicalDb.getMedicineById(
                                      log['medicationId']),
                                  builder: (context, medicineSnapshot) {
                                    if (medicineSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (medicineSnapshot.hasError ||
                                        !medicineSnapshot.hasData ||
                                        !medicineSnapshot.data!['success']) {
                                      return const SizedBox.shrink();
                                    } else {
                                      var medicineData =
                                          medicineSnapshot.data!['data'];
                                      text =
                                          "${medicineData['name'] ?? 'Unknown'}";
                                      isChecked = log['status'] == 'taken';
                                      return Column(
                                        children: [
                                          LogItem(
                                            time: time,
                                            text: text,
                                            isChecked: isChecked,
                                            bpm: bpm,
                                          ),
                                          const Divider(color: Colors.white),
                                        ],
                                      );
                                    }
                                  },
                                );
                              } else {
                                text = log['spo2'] != null
                                    ? "SpO2: ${log['spo2']}%"
                                    : "Unknown";
                                bpm = log['heartRate'] != null &&
                                        log['heartRate'] != 0
                                    ? log['heartRate'].toString()
                                    : null;
                                return Column(
                                  children: [
                                    LogItem(
                                      time: time,
                                      text: text,
                                      isChecked: isChecked,
                                      bpm: bpm,
                                    ),
                                    const Divider(color: Colors.white),
                                  ],
                                );
                              }
                            } catch (e) {
                              print('Error rendering log: $e');
                              return const SizedBox.shrink();
                            }
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: SmartMedicalDb.readMedications(widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading medications'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No medications found'));
                }

                final medications = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final med = medications[index];
                    final name = med['name'] ?? 'Unknown';
                    final dosage = med['dosage']?.toString() ?? 'N/A';
                    final scheduleType = med['scheduleType'] ?? 0;
                    final scheduleValue = med['scheduleValue'] ?? 1;
                    final times = med['times'] as List<dynamic>?;
                    final bitmaskDays = med['bitmaskDays'] as List<dynamic>?;
                    final pillsLeft = med['pillsLeft']?.toString() ?? 'N/A';
                    final compartmentNumber =
                        med['compartmentNumber']?.toString() ?? 'N/A';
                    bool isLowStock =
                        (med['pillsLeft'] != null && med['pillsLeft'] < 5);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.cointainerDarkColor
                            : AppColors.mainColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.medical_services,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: getTitleStyle(
                                            color: AppColors.white,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Dosage: $dosage',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  getScheduleText(scheduleType, scheduleValue,
                                      times, bitmaskDays),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  'Pills Left: $pillsLeft',
                                  style: TextStyle(
                                    color: isLowStock
                                        ? Colors.redAccent
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Compartment: $compartmentNumber',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}