import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    // Initialize Firebase in the background isolate if not already initialized
    try {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDV-Qnv-_7vxGZ1Wa_WC7aVGLLAwZHJ5hQ',
              appId: 'com.example.smart_medic',
              messagingSenderId: '352505676305',
              projectId: 'smartmedicbox-2025'));
    } catch (e) {
      print('Firebase already initialized or error: $e');
    }

    if (notificationResponse.payload != null) {
      if (notificationResponse.actionId == 'snooze') {
        // Handle Snooze action
        await rescheduleNotification(notificationResponse.payload!);
      } else if (notificationResponse.actionId == 'taken') {
        // Handle Taken action
        List<String> parts = notificationResponse.payload!.split('|');
        if (parts[0] == 'medicine') {
          List<String> medData = parts[1].split(',');
          String medId = medData[0];
          try {
            DateTime now = DateTime.now();
            DateTime startOfYear = DateTime(now.year, 1, 1);
            int dayOfYear = now
                .difference(startOfYear)
                .inDays + 1;
            int minutesMidnight = now.hour * 60 + now.minute;

            await SmartMedicalDb.addLog(
                logId: DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString(),
                patientId: FirebaseAuth.instance.currentUser!.uid,
                medicationId: medId,
                status: 'taken',
                spo2: null,
                heartRate: null,
                dayOfYear: dayOfYear,
                minutesMidnight: minutesMidnight);

            //Decrease missedCount by 1
            DocumentSnapshot medicationDoc = await medicationsCollection.doc(
                medId).get();

            var medicationData = medicationDoc.data() as Map<String, dynamic>;
            int missedCount = medicationData['missedCount'] ?? 0;
            await medicationsCollection.doc(medId).update({
              'missedCount': missedCount > 0 ? missedCount - 1 : 0,
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          } catch (e) {
            print('Error logging taken dose: $e');
          }
        }
        else if (notificationResponse.actionId == 'ignore') {
          print('User ignored notification: ${notificationResponse.payload}');
        }
      } else {
        // Handle regular tap or other actions
        streamController.add(notificationResponse);
      }
    }
  }

  static Future<void> rescheduleNotification(String payload) async {
    List<String> parts = payload.split('|');
    if (parts[0] != 'medicine') return;

    List<String> medData = parts[1].split(',');
    String medId = medData[0];
    int dosage = int.parse(medData[1]);
    String time = medData[2];
    String name = 'Unknown Medicine'; // Default name in case of error

    // Try to get medication details
    try {
      DocumentSnapshot medDoc = await FirebaseFirestore.instance
          .collection('medications')
          .doc(medId)
          .get();
      if (medDoc.exists) {
        name = (medDoc.data() as Map<String, dynamic>)['name'] ??
            'Unknown Medicine';
      }
    } catch (e) {
      print('Error fetching medication details: $e');
    }

    // Check if localTimeZone is initialized
    if (localTimeZone == null) {
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      localTimeZone = tz.getLocation(timeZoneName);
    }

    // Schedule notification 10 minutes from now
    tz.TZDateTime now = tz.TZDateTime.now(localTimeZone!);
    tz.TZDateTime snoozeTime = now.add(const Duration(minutes: 1));

    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminders',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction('taken', 'Taken'),
        AndroidNotificationAction('snooze', 'Snooze (10 mins)'),
        AndroidNotificationAction('ignore', 'Ignore'),
      ],
    );
    const NotificationDetails details = NotificationDetails(android: android);

    print('Rescheduling snooze notification for $name at $snoozeTime');
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        'snooze_$medId-$time'.hashCode,
        'Time to take your medicine',
        'Take $dosage pill(s) of $name at $time (Snoozed)',
        snoozeTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      print('Error scheduling snooze notification: $e');
    }
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

    // Create notification channels
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
      'medicine_channel',
      'Medicine Reminders',
      importance: Importance.max,
    ));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
      'low_pills_channel',
      'Low Pills Notifications',
      importance: Importance.max,
    ));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
      'supervisor_channel',
      'Supervisor Notifications',
      importance: Importance.max,
    ));

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

    try {
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
          AndroidNotificationAction('ignore', 'Ignore'),
        ],
      );
      const NotificationDetails details = NotificationDetails(android: android);

      for (var doc in medicationsSnapshot.docs) {
        var med = doc.data() as Map<String, dynamic>;
        String medId = doc.id;
        String name = med['name'] ?? 'Unknown Medicine';
        int dosage = med['dosage'] ?? 1;
        int pillsLeft = med['pillsLeft'] ?? 0;
        int scheduleType = med['scheduleType'] ?? 0;
        int scheduleValue = med['scheduleValue'] ?? 1;
        List<String> times = List<String>.from(med['times'] ?? []);
        List<int> bitmaskDays = List<int>.from(
            med['bitmaskDays'] ?? [0, 0, 0, 0, 0, 0, 0]);

        if (pillsLeft < dosage) {
          const AndroidNotificationDetails lowPillsAndroid = AndroidNotificationDetails(
            'low_pills_channel',
            'Low Pills Notifications',
            importance: Importance.max,
            priority: Priority.high,
          );
          const NotificationDetails lowPillsDetails =
          NotificationDetails(android: lowPillsAndroid);

          await flutterLocalNotificationsPlugin.show(
            'low_pills_$medId'.hashCode,
            'Low Medication Supply',
            'You have only $pillsLeft pill(s) of $name left, but the next dose requires $dosage pill(s). Please refill.',
            lowPillsDetails,
          );
        }

        print(
            'Scheduling notifications for medication: $name, Schedule Type: $scheduleType');

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
            print(
                'Scheduling every $scheduleValue days notification for $name at $scheduledDate');
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

                scheduledDate =
                    scheduledDate.add(Duration(days: daysUntilNext));
                print(
                    'Scheduling specific day notification for $name on day $i at $scheduledDate');

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
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error scheduling notifications: $e');
    }
  }

  static Future showSupervisorNotification({ required int id, required String title, required String body, required String payload, }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'supervisor_channel', 'Supervisor Notifications',
      importance: Importance.max, priority: Priority.high,);
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}