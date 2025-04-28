import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:smart_medic/Bluetooth/notificationService.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/LogItem.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:timezone/timezone.dart' as tz;


class PatientLogsView extends StatefulWidget {
  const PatientLogsView({super.key});

  @override
  State<PatientLogsView> createState() => _PatientLogsViewState();
}

class _PatientLogsViewState extends State<PatientLogsView> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize LocalNotificationService and set up the stream listener
    LocalNotificationService.init();
    LocalNotificationService.streamController.stream.listen((notificationResponse) async {
      String? payload = notificationResponse.payload;
      if (payload != null) {
        if (payload.startsWith('medicine')) {
          List<String> medData = payload.split('|')[1].split(',');
          for (String data in medData) {
            String medId = data.split(':')[0];
            int dosage = int.parse(data.split(':')[1]);
            String time = data.split(':')[2]; // Extract the time from payload

            if (notificationResponse.actionId == 'taken') {
              // Log the dose as taken
              await FirebaseFirestore.instance.collection('logs').add({
                'medicationId': medId,
                'patientId': user!.uid,
                'status': 'taken',
                'timestamp': Timestamp.now(),
              });

              // Update pillsLeft
              DocumentReference medRef = FirebaseFirestore.instance.collection('medications').doc(medId);
              DocumentSnapshot medDoc = await medRef.get();
              int pillsLeft = (medDoc.data() as Map<String, dynamic>)['pillsLeft'] ?? 0;
              await medRef.update({'pillsLeft': pillsLeft - dosage});

              // Cancel any pending missed dose checks for this medication
              await LocalNotificationService.cancelNotification('missed_$medId'.hashCode);
            } else if (notificationResponse.actionId == 'snooze') {
          print('Snooze action triggered for notification: ${notificationResponse.payload}');
          // Extract the original time from the payload
          var parts = time.split(':');
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1].split(' ')[0]);
          String period = parts[1].split(' ')[1];
          if (period == 'PM' && hour != 12) hour += 12;
          if (period == 'AM' && hour == 12) hour = 0;

          int newHour = hour;
          int newMinute = minute + 10;
          if (newMinute >= 60) {
            newHour = (newHour + 1) % 24;
            newMinute -= 60;
          }

          const AndroidNotificationDetails android = AndroidNotificationDetails(
            'medicine_channel',
            'Medicine Reminders',
            importance: Importance.max,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction('taken', 'Taken'),
              AndroidNotificationAction('snooze', 'Snooze (10 mins)'),
            ],
          );
          const NotificationDetails details = NotificationDetails(android: android);

          var snoozeTime = tz.TZDateTime.now(LocalNotificationService.localTimeZone!)
              .add(Duration(minutes: 10));
          print('Scheduling snooze notification at: $snoozeTime');

          await LocalNotificationService.flutterLocalNotificationsPlugin.zonedSchedule(
            notificationResponse.id!,
            'Snoozed: Time to take your medicine',
            'Rescheduled for ${newHour % 12 == 0 ? 12 : newHour % 12}:${newMinute.toString().padLeft(2, '0')} ${newHour >= 12 ? 'PM' : 'AM'}',
            snoozeTime,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: notificationResponse.payload,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          print('Snooze notification scheduled successfully');
        }
          }
        } else if (payload.startsWith('missed_check')) {
          await LocalNotificationService.handleMissedDose(payload);
        }
      }
    });
  }

  // Helper function to format time from minutesMidnight or timestamp
  String formatLogTime(Map<String, dynamic> log) {
    try {
      // Try using minutesMidnight first
      if (log['minutesMidnight'] != null) {
        int minutes = log['minutesMidnight'] as int;
        int hours = minutes ~/ 60;
        int remainingMinutes = minutes % 60;
        return "${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}";
      }
      // Fallback to timestamp if minutesMidnight is not available
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
                        style: getTitleStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.black
                                : AppColors.white,
                            fontSize: 20),
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
                            // Medication log - Fetch medicine name
                            return FutureBuilder<Map<String, dynamic>>(
                              future: SmartMedicalDb.getMedicineById(log['medicationId']),
                              builder: (context, medicineSnapshot) {
                                if (medicineSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (medicineSnapshot.hasError ||
                                    !medicineSnapshot.hasData ||
                                    !medicineSnapshot.data!['success']) {
                                  text = "Medicine: Not found";
                                } else {
                                  var medicineData = medicineSnapshot.data!['data'];
                                  text = "Medicine: ${medicineData['name'] ?? 'Unknown'}";
                                  isChecked = log['status'] == 'taken';
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
                              },
                            );
                          } else {
                            // Health measurement log
                            text = log['spo2'] != null ? "SpO2: ${log['spo2']}%" : "Unknown";
                            bpm = log['heartRate'] != null && log['heartRate'] != 0
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
    );
  }
}