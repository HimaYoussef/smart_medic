import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_medic/Services/rewardsService.dart';

import 'notificationService.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference usersCollection = _firestore.collection("users");
final CollectionReference smartMedicalBoxCollection =
    _firestore.collection("smartMedicalBox");
final CollectionReference medicationsCollection =
    _firestore.collection("medications");
final CollectionReference logsCollection = _firestore.collection("logs");
final CollectionReference notificationsCollection =
    _firestore.collection("notifications");
final CollectionReference supervisionCollection =
    _firestore.collection('supervision');

class SmartMedicalDb {
  // Add User
  static Future<Map<String, dynamic>> addUser({
    required String userId,
    required String name,
    required String email,
    required String type,
  }) async {
    try {
      DocumentReference documentReferencer = usersCollection.doc(userId);

      Map<String, dynamic> data = <String, dynamic>{
        "userId": userId,
        "name": name,
        "email": email,
        "type": type,
        "createdAt": FieldValue.serverTimestamp(),
        'currentStreak': 0,
        'lastDoseStatus': '',
      };

      await documentReferencer.set(data);
      return {
        'success': true,
        'message': 'User added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding user: $e',
      };
    }
  }

  // Read Users
  static Stream<QuerySnapshot> readUsers() {
    return usersCollection.snapshots();
  }

  // Delete User
  static Future<Map<String, dynamic>> deleteUser({
    required String userId,
  }) async {
    try {
      
      DocumentReference documentReferencer = usersCollection.doc(userId);
      await documentReferencer.delete();
      return {
        'success': true,
        'message': 'User deleted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error deleting user: $e',
      };
    }
  }

  // Get User by ID
  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      print("SmartMedicalDb: Fetching user with UID: $userId");
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        print("SmartMedicalDb: User found - ${userDoc.data()}");
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User not found!');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Add a new supervisor
  static Future<Map<String, dynamic>> addSupervisor({
    required String email,
    required String type,
    required String patientId,
  }) async {
    try {
      QuerySnapshot userQuery = await usersCollection
          .where('email', isEqualTo: email)
          .where('type', isEqualTo: 'Supervisor')
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return {
          'success': false,
          'message':
              'Supervisor not found. Please ensure they are registered as a supervisor.',
        };
      }

      var supervisorDoc = userQuery.docs.first;
      String supervisorId = supervisorDoc.id;
      String supervisorName = supervisorDoc['name'] ?? 'Unknown';

      // التحقق من وجود علاقة مسبقة
      QuerySnapshot existingSupervisor = await supervisionCollection
          .where('patientId', isEqualTo: patientId)
          .where('supervisorId', isEqualTo: supervisorId)
          .limit(1)
          .get();

      if (existingSupervisor.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'This supervisor is already added for the patient.',
        };
      }

      // إنشاء document جديد بـ ID فريد
      DocumentReference supervisorRef = supervisionCollection.doc();
      await supervisorRef.set({
        'supervisorId': supervisorId,
        'name': supervisorName,
        'email': email,
        'type': type,
        'patientId': patientId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // إضافة السجل في subcollection تحت المريض
      await usersCollection
          .doc(patientId)
          .collection('supervisors')
          .doc(supervisorId)
          .set({
        'supervisorId': supervisorId,
        'addedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return {
        'success': true,
        'message': 'Supervisor added successfully',
        'supervisorId': supervisorId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding supervisor: $e',
      };
    }
  }

  // Get patient profile data
  static Future<Map<String, dynamic>> getPatientProfile(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return {
          'success': true,
          'data': doc.data(),
        };
      } else {
        return {
          'success': false,
          'message': 'User not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching user profile: $e',
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await usersCollection.doc(userId).update(updates);
      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating profile: $e',
      };
    }
  }

  /*  // Upload profile image to Firebase Storage and update Firestore
  static Future<Map<String, dynamic>> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Create a reference to the storage location
      String fileName =
          'profile_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage.ref().child(fileName);

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user's profile with the image URL
      await usersCollection.doc(userId).update({
        'photoUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Profile image uploaded successfully',
        'photoUrl': downloadUrl,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error uploading profile image: $e',
      };
    }
  }

  // Get profile image URL
  static Future<Map<String, dynamic>> getProfileImage(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('photoUrl') && data['photoUrl'] != null) {
          return {
            'success': true,
            'photoUrl': data['photoUrl'],
          };
        }
      }
      return {
        'success': false,
        'message': 'No profile image found',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching profile image: $e',
      };
    }
  }*/

  // Read supervisors for a specific patient
  static Stream<QuerySnapshot> readSupervisors(String patientId) {
    return supervisionCollection
        .where('patientId', isEqualTo: patientId)
        .snapshots();
  }

  // Fetch all users of type 'Supervisor'
  static Stream<QuerySnapshot> readAllSupervisors() {
    return usersCollection.where('type', isEqualTo: 'Supervisor').snapshots();
  }

  static Stream<QuerySnapshot> readAllPatients() {
    return usersCollection.where('type', isEqualTo: 'Patient').snapshots();
  }

  // Read patients supervised by a specific supervisor
  static Stream<List<Map<String, dynamic>>> readPatientsForSupervisor(
      String supervisorId) async* {
    // جلب البيانات من supervision collection
    await for (QuerySnapshot supervisionSnapshot in supervisionCollection
        .where('supervisorId', isEqualTo: supervisorId)
        .snapshots()) {
      List<Map<String, dynamic>> patientsWithDetails = [];

      // جلب بيانات كل مريض من users collection
      List<Future<Map<String, dynamic>>> futures =
          supervisionSnapshot.docs.map((doc) async {
        String patientId = doc['patientId'];
        Map<String, dynamic> supervisionData =
            doc.data() as Map<String, dynamic>;
        supervisionData['id'] = doc.id; // إضافة ID الـ document

        try {
          DocumentSnapshot patientDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(patientId)
              .get();
          if (patientDoc.exists) {
            Map<String, dynamic> patientData =
                patientDoc.data() as Map<String, dynamic>;
            return {
              ...supervisionData,
              'patientEmail': patientData['email'] ?? 'No email',
              'patientName': patientData['name'] ?? 'Unknown',
            };
          } else {
            return {
              ...supervisionData,
              'patientEmail': 'No email',
              'patientName': 'Unknown',
            };
          }
        } catch (e) {
          print('Error fetching patient details for $patientId: $e');
          return {
            ...supervisionData,
            'patientEmail': 'No email',
            'patientName': 'Unknown',
          };
        }
      }).toList();

      // الانتظار لجلب كل البيانات
      List<Map<String, dynamic>> results = await Future.wait(futures);
      patientsWithDetails.addAll(results);

      yield patientsWithDetails; // إرجاع القائمة المحدثة
    }
  }

  // Delete a supervisor
  static Future<Map<String, dynamic>> deleteSupervision({
    required String supervisorId,
    required String patientId,
  }) async {
    try {
      // Find the supervision document
      QuerySnapshot supervisionQuery = await supervisionCollection
          .where('supervisorId', isEqualTo: supervisorId)
          .where('patientId', isEqualTo: patientId)
          .limit(1)
          .get();

      if (supervisionQuery.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Supervision relationship not found.',
        };
      }

      String supervisionId = supervisionQuery.docs.first.id;

      // Delete the supervision document
      await supervisionCollection.doc(supervisionId).delete();

      // Remove from the patient's supervisors subcollection
      await usersCollection
          .doc(patientId)
          .collection('supervisors')
          .doc(supervisorId)
          .delete();

      return {
        'success': true,
        'message': 'Supervisor deleted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error deleting supervisor: $e',
      };
    }
  }

  // Get a specific supervisor by ID
  static Future<Map<String, dynamic>> getSupervisor(String supervisorId) async {
    try {
      DocumentSnapshot doc =
          await supervisionCollection.doc(supervisorId).get();
      if (doc.exists) {
        return {
          'success': true,
          'data': doc.data(),
        };
      } else {
        return {
          'success': false,
          'message': 'Supervisor not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching supervisor: $e',
      };
    }
  }

  // Add Medication
  static Future<Map<String, dynamic>> addMedication({
    required String patientId,
    required String name,
    required int dosage,
    required int scheduleType,
    required int scheduleValue,
    required List<String> times,
    required List<int> bitmaskDays,
    required int pillsLeft,
    required int compartmentNumber,
  }) async {
    try {
      DocumentReference documentReferencer = medicationsCollection.doc();
      String medId = documentReferencer.id;

      dynamic adjustedScheduleValue = scheduleType == 2 ? null : scheduleValue;
      Map<String, dynamic> data = <String, dynamic>{
        "medId": medId,
        "patientId": patientId,
        "name": name,
        "dosage": dosage,
        "scheduleType": scheduleType,
        "scheduleValue": adjustedScheduleValue,
        "times": times,
        "bitmaskDays": bitmaskDays,
        "pillsLeft": pillsLeft,
        "compartmentNumber": compartmentNumber,
        "lastUpdated": FieldValue.serverTimestamp(),
        "syncStatus": "Pending",
        "missedCount": 0,
      };

      await documentReferencer.set(data);
      return {
        'success': true,
        'message': 'Medication added successfully',
        'medId': medId,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding medication: $e',
      };
    }
  }

  // Read Medications
  static Stream<QuerySnapshot> readMedications(String patientId) {
    return medicationsCollection
        .where("patientId", isEqualTo: patientId)
        .snapshots();
  }

  // Get a specific medicine by ID
  static Future<Map<String, dynamic>> getMedicineById(String medicineId) async {
    try {
      DocumentSnapshot doc = await medicationsCollection.doc(medicineId).get();
      if (doc.exists) {
        return {
          'success': true,
          'data': doc.data(),
        };
      } else {
        return {
          'success': false,
          'message': 'Medicine not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching medicine: $e',
      };
    }
  }

  // Update a medicine
  static Future<Map<String, dynamic>> updateMedicine({
    required String medicineId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await medicationsCollection.doc(medicineId).update(updates);
      return {
        'success': true,
        'message': 'Medicine updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating medicine: $e',
      };
    }
  }

  // Update Medication Sync Status
  static Future<Map<String, dynamic>> updateMedicationSyncStatus({
    required String medId,
    required String syncStatus,
  }) async {
    try {
      DocumentReference documentReferencer = medicationsCollection.doc(medId);
      await documentReferencer.update({"syncStatus": syncStatus});
      return {
        'success': true,
        'message': 'Sync status updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating sync status: $e',
      };
    }
  }

  // Update Missed Count for a Medication
  static Future<Map<String, dynamic>> updateMissedCount({
    required String medId,
    required int missedCount,
  }) async {
    try {
      DocumentReference documentReferencer = medicationsCollection.doc(medId);
      await documentReferencer.update({"missedCount": missedCount});
      return {
        'success': true,
        'message': 'Missed count updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating missed count: $e',
      };
    }
  }

  // Reset Missed Count for a Medication
  static Future<Map<String, dynamic>> resetMissedCount({
    required String medId,
  }) async {
    try {
      DocumentReference documentReferencer = medicationsCollection.doc(medId);
      await documentReferencer.update({"missedCount": 0});
      return {
        'success': true,
        'message': 'Missed count reset successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error resetting missed count: $e',
      };
    }
  }

  // Delete a medicine
  static Future<Map<String, dynamic>> deleteMedicine({
    required String medicineId,
  }) async {
    try {
      await medicationsCollection.doc(medicineId).delete();
      return {
        'success': true,
        'message': 'Medicine deleted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error deleting medicine: $e',
      };
    }
  }

  // Add Medication Log (Status + SpO2 + HeartRate)
  static Future<Map<String, dynamic>> addLog({
    required String logId,
    required String patientId,
    required String? medicationId,
    required String? status,
    required double? spo2,
    required double? heartRate,
    required int dayOfYear,
    required int minutesMidnight,
  }) async {
    try {
      await logsCollection.doc(logId).set({
        'patientId': patientId,
        'medicationId': medicationId,
        'status': status,
        'spo2': spo2,
        'heartRate': heartRate,
        'dayOfYear': dayOfYear,
        'minutesMidnight': minutesMidnight,
        'timestamp': Timestamp.now(),
      });

      // Handle currentStreak for rewards
      DocumentReference userRef = usersCollection.doc(patientId);
      DocumentSnapshot userDoc = await userRef.get();
      int currentStreak = userDoc.exists
          ? (userDoc.data() as Map<String, dynamic>)['currentStreak'] ?? 0
          : 0;

      if (status == 'taken') {
        currentStreak++;
      } else if (status == 'missed') {
        currentStreak = 0;
      }

      await userRef.set({
        'currentStreak': currentStreak,
        'lastDoseStatus': status ?? '',
      }, SetOptions(merge: true));

      // Check for reward eligibility
      await RewardsService().checkRewardEligibility(patientId, currentStreak);

      if (medicationId != null && status == "missed") {
        DocumentSnapshot medicationDoc =
            await medicationsCollection.doc(medicationId).get();

        if (!medicationDoc.exists) {
          return {
            'success': false,
            'message': 'Medication not found for ID: $medicationId',
          };
        }
        var medicationData = medicationDoc.data() as Map<String, dynamic>;
        int missedCount = medicationData['missedCount'] ?? 0;
        String name = medicationData['name'] ?? 'Unknown Medicine';

        await medicationsCollection.doc(medicationId).update({
          'missedCount': missedCount + 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        if (missedCount >= 2) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(patientId)
              .get();
          String patientName = userDoc.exists
              ? (userDoc.data() as Map<String, dynamic>)['name'] ??
                  'Unknown Patient'
              : 'Unknown Patient';

          QuerySnapshot supervisors = await FirebaseFirestore.instance
              .collection('supervision')
              .where('patientId', isEqualTo: patientId)
              .get();

          for (var supervisor in supervisors.docs) {
            String supervisorId = supervisor['supervisorId'];
            await SmartMedicalDb.addNotification(
              notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
              patientId: patientId,
              supervisorId: supervisorId,
              message: '$patientName missed 3 doses of $name',
            );
          }

          await logsCollection
              .doc(DateTime.now().millisecondsSinceEpoch.toString())
              .set({
            'patientId': patientId,
            'medicationId': medicationId,
            'status': 'supervisor_notified',
            'spo2': null,
            'heartRate': null,
            'dayOfYear': dayOfYear,
            'minutesMidnight': minutesMidnight,
            'timestamp': Timestamp.now(),
          });

          await medicationsCollection.doc(medicationId).update({
            'missedCount': 0,
            'lastUpdated': FieldValue.serverTimestamp(),
          });

          // Add notification to queue for supervisor
          LocalNotificationService.notificationQueue.add({
            'id': logId.hashCode,
            'title': 'Patient Alert',
            'body': '$patientName missed 3 doses of $name',
            'payload': 'supervisor|$logId,$patientId',
          });
        }
      }

      return {'success': true, 'message': 'Log added successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Error adding log: $e'};
    }
  }

  // Read Logs
  static Stream<QuerySnapshot> readLogs(String patientId) {
    return logsCollection
        .where("patientId", isEqualTo: patientId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Add Notification
  static Future<Map<String, dynamic>> addNotification({
    required String notificationId,
    required String patientId,
    required String supervisorId,
    required String message,
  }) async {
    try {
      DocumentReference documentReferencer =
          notificationsCollection.doc(notificationId);

      Map<String, dynamic> data = {
        "patientId": patientId,
        "supervisorId": supervisorId,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "sent",
      };

      await documentReferencer.set(data);
      return {
        'success': true,
        'message': 'Notification added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding notification: $e',
      };
    }
  }

  // Read Notifications
  static Stream<QuerySnapshot> readNotifications(String supervisorId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('supervisorId', isEqualTo: supervisorId)
        .where('status', isEqualTo: 'sent')
        .snapshots();
  }

  static Stream<QuerySnapshot> readNotificationsForPatient(String patientId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('patientId', isEqualTo: patientId)
        .snapshots();
  }

  static Future<Map<String, dynamic>> markRewardAsUsed(String rewardId) async {
    try {
      await FirebaseFirestore.instance
          .collection('rewards')
          .doc(rewardId)
          .update({
        'status': 'used',
      });
      return {'success': true, 'message': 'Reward marked as used'};
    } catch (e) {
      return {'success': false, 'message': 'Error marking reward as used: $e'};
    }
  }

  Future<void> initializeUserFields() async {
    QuerySnapshot users =
        await FirebaseFirestore.instance.collection('users').get();
    for (var user in users.docs) {
      await user.reference.set({
        'currentStreak': 0,
        'lastDoseStatus': '',
      }, SetOptions(merge: true));
    }
  }
}
