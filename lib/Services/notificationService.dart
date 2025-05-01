import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../../../Services/firebaseServices.dart'; // Import SmartMedicalDb

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
  StreamController.broadcast();
  static tz.Location? localTimeZone;

  static Future<void> onTap(NotificationResponse notificationResponse) async {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Initialize timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    localTimeZone = tz.getLocation(timeZoneName);

    // Request permissions for Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showDataSyncedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'sync_channel',
      'Data Sync Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Data Synced',
      'Your medication data has been successfully synced.',
      details,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> scheduleMedicineNotifications() async {
    await cancelAllNotifications(); // Clear previous notifications

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
        .collection('medications')
        .where('patientId', isEqualTo: user.uid)
        .get();

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

    for (var doc in medicationsSnapshot.docs) {
      var med = doc.data() as Map<String, dynamic>;
      String medId = doc.id;
      String name = med['name'] ?? 'Unknown Medicine';
      int dosage = med['dosage'] ?? 1;
      int scheduleType = med['scheduleType'] ?? 0;
      int scheduleValue = med['scheduleValue'] ?? 1;
      List<String> times = List<String>.from(med['times'] ?? []);
      List<int> bitmaskDays = List<int>.from(med['bitmaskDays'] ?? [0, 0, 0, 0, 0, 0, 0]);

      print('Scheduling notifications for medication: $name, Schedule Type: $scheduleType');

      for (String time in times) {
        var parts = time.split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1].split(' ')[0]);
        String period = parts[1].split(' ')[1];
        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;

        tz.TZDateTime now = tz.TZDateTime.now(localTimeZone!);
        print('Current time: $now');

        if (scheduleType == 0) {
          // Daily schedule
          tz.TZDateTime scheduledDate = tz.TZDateTime(
            localTimeZone!,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
          }

          String payload = 'medicine|$medId,$dosage,$time';
          print('Scheduling daily notification for $name at $scheduledDate');
           flutterLocalNotificationsPlugin.zonedSchedule(
            '$medId-$time'.hashCode,
            'Time to take your medicine',
            'Take $dosage pill(s) of $name at $time',
            scheduledDate,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.time,
          );

          // Schedule a missed dose check 30 minutes after the dose time
          tz.TZDateTime missedCheckTime = scheduledDate.add(const Duration(minutes: 30));
          print('Scheduling missed dose check for $name at $missedCheckTime');
           flutterLocalNotificationsPlugin.zonedSchedule(
            'missed_$medId-$time'.hashCode,
            '',
            '',
            missedCheckTime,
            const NotificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'missed_check|$medId,$time',
            matchDateTimeComponents: DateTimeComponents.time,
          );
        } else if (scheduleType == 1) {
          // Every X days schedule
          tz.TZDateTime scheduledDate = tz.TZDateTime(
            localTimeZone!,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // Check if the time has already passed today
          if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(Duration(days: scheduleValue));
          } else if (scheduleValue == 1) {
            // If scheduleValue is 1, it should behave like daily
            scheduledDate = tz.TZDateTime(
              localTimeZone!,
              now.year,
              now.month,
              now.day,
              hour,
              minute,
            );
          }

          String payload = 'medicine|$medId,$dosage,$time';
          print('Scheduling every $scheduleValue days notification for $name at $scheduledDate');
          await flutterLocalNotificationsPlugin.zonedSchedule(
            '$medId-$time'.hashCode,
            'Time to take your medicine',
            'Take $dosage pill(s) of $name at $time',
            scheduledDate,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: payload,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );

          // Schedule a missed dose check 30 minutes after the dose time
          tz.TZDateTime missedCheckTime = scheduledDate.add(const Duration(minutes: 30));
          print('Scheduling missed dose check for $name at $missedCheckTime');
           flutterLocalNotificationsPlugin.zonedSchedule(
            'missed_$medId-$time'.hashCode,
            '',
            '',
            missedCheckTime,
            const NotificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'missed_check|$medId,$time',
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
        } else if (scheduleType == 2) {
          // Specific days schedule
          int currentDayOfWeek = now.weekday % 7; // 0 = Saturday, 6 = Friday
          print('Current day of week (0=Sat, 6=Fri): $currentDayOfWeek');

          for (int i = 0; i < 7; i++) {
            if (bitmaskDays[i] == 1) {
              int daysUntilNext = (i - currentDayOfWeek + 7) % 7;
              // If it's the same day and the time has passed, schedule for next week
              tz.TZDateTime scheduledDate = tz.TZDateTime(
                localTimeZone!,
                now.year,
                now.month,
                now.day,
                hour,
                minute,
              );

              if (daysUntilNext == 0 && now.isAfter(scheduledDate)) {
                daysUntilNext = 7; // Schedule for next week
              }

              scheduledDate = scheduledDate.add(Duration(days: daysUntilNext));
              print('Scheduling specific day notification for $name on day $i at $scheduledDate');

              String payload = 'medicine|$medId,$dosage,$time';
              await flutterLocalNotificationsPlugin.zonedSchedule(
                '$medId-$time-$i'.hashCode,
                'Time to take your medicine',
                'Take $dosage pill(s) of $name at $time',
                scheduledDate,
                details,
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                payload: payload,
                matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
              );

              // Schedule a missed dose check 30 minutes after the dose time
              tz.TZDateTime missedCheckTime = scheduledDate.add(const Duration(minutes: 30));
              print('Scheduling missed dose check for $name at $missedCheckTime');
               flutterLocalNotificationsPlugin.zonedSchedule(
                'missed_$medId-$time-$i'.hashCode,
                '',
                '',
                missedCheckTime,
                const NotificationDetails(),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                payload: 'missed_check|$medId,$time',
                matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
              );
            }
          }
        }
      }
    }
  }
  static Future<void> handleMissedDose(String payload) async {
    List<String> parts = payload.split('|');
    if (parts.length < 2) return;

    List<String> medData = parts[1].split(',');
    String medId = medData[0];
    String time = medData[1];

    // Check if the dose was taken
    QuerySnapshot logs = await FirebaseFirestore.instance
        .collection('logs')
        .where('medicationId', isEqualTo: medId)
        .where('status', isEqualTo: 'taken')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(
        DateTime.now().subtract(const Duration(minutes: 30))))
        .get();

    if (logs.docs.isEmpty) {
      // Dose was not taken, increment missedCount
      DocumentSnapshot medDoc =
      await FirebaseFirestore.instance.collection('medications').doc(medId).get();
      int missedCount = (medDoc.data() as Map<String, dynamic>)['missedCount'] ?? 0;
      missedCount++;

      // Update missedCount using SmartMedicalDb
      await SmartMedicalDb.updateMissedCount(medId: medId, missedCount: missedCount);

      // Log the missed dose
      await FirebaseFirestore.instance.collection('logs').add({
        'medicationId': medId,
        'patientId': FirebaseAuth.instance.currentUser!.uid,
        'status': 'missed',
        'timestamp': Timestamp.now(),
      });

      // Notify the user about the missed dose
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        'missed_dose_channel',
        'Missed Dose Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails details = NotificationDetails(android: android);

      DocumentSnapshot med = await FirebaseFirestore.instance
          .collection('medications')
          .doc(medId)
          .get();
      String name = (med.data() as Map<String, dynamic>)['name'] ?? 'Unknown Medicine';

      await flutterLocalNotificationsPlugin.show(
        'missed_$medId'.hashCode,
        'Missed Dose',
        'You missed your dose of $name at $time',
        details,
      );

      // If missedCount reaches 3, notify the supervisor and reset the count
      if (missedCount >= 3) {
        QuerySnapshot supervisors = await FirebaseFirestore.instance
            .collection('supervision')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        for (var supervisor in supervisors.docs) {
          String supervisorId = supervisor['supervisorId'];
          await SmartMedicalDb.addNotification(
            notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
            patientId: FirebaseAuth.instance.currentUser!.uid,
            supervisorId: supervisorId,
            message: 'Patient missed 3 doses of $name',
          );
        }

        // Reset missedCount using SmartMedicalDb
        await SmartMedicalDb.resetMissedCount(medId: medId);
      }
    }
  }
}