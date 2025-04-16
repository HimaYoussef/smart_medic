import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/LogItem.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

class PatientLogsView extends StatefulWidget {
  const PatientLogsView({super.key});

  @override
  State<PatientLogsView> createState() => _PatientLogsViewState();
}

class _PatientLogsViewState extends State<PatientLogsView> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Logs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: SmartMedicalDb.readLogs(user!.uid),
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

            // Group logs by date
            Map<String, List<Map<String, dynamic>>> logsByDate = {};
            for (var doc in snapshot.data!.docs) {
              try {
                var log = doc.data() as Map<String, dynamic>;
                Timestamp? timestamp = log['timestamp'];
                if (timestamp != null) {
                  String date = DateFormat('dd/MM/yyyy').format(timestamp.toDate());
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
                        style: getTitleStyle(color: AppColors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 25),
                      const Divider(color: Colors.white),
                      ...logs.map((log) {
                        try {
                          String time = log['minutesMidnight'] != null
                              ? "${(log['minutesMidnight'] ~/ 60).toString().padLeft(2, '0')}:${(log['minutesMidnight'] % 60).toString().padLeft(2, '0')}"
                              : "Unknown";
                          String text;
                          bool? isChecked;
                          String? bpm;

                          if (log['medicationId'] != null) {
                            // Medication log
                            text = log['medicationId'].toString();
                            isChecked = log['status'] == 'taken';
                          } else {
                            // Health measurement log
                            text = log['spo2'] != null ? "SpO2: ${log['spo2']}%" : "Unknown";
                            bpm = log['heartRate'] != null && log['heartRate'] != 0
                                ? log['heartRate'].toString()
                                : null;
                          }

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
    );
  }
}