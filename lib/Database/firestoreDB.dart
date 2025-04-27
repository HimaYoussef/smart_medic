import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final CollectionReference usersCollection = _firestore.collection("users");
final CollectionReference smartMedicalBoxCollection = _firestore.collection("smartMedicalBox");
final CollectionReference medicationsCollection = _firestore.collection("medications");
final CollectionReference logsCollection = _firestore.collection("logs");
final CollectionReference notificationsCollection = _firestore.collection("notifications");
final CollectionReference supervisionCollection = _firestore.collection('supervision');

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
          'message': 'Supervisor not found. Please ensure they are registered as a supervisor.',
        };
      }

      var supervisorDoc = userQuery.docs.first;
      String supervisorId = supervisorDoc.id;
      String supervisorName = supervisorDoc['name'] ?? 'Unknown';

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

      DocumentReference supervisorRef = supervisionCollection.doc(supervisorId);
      await supervisorRef.set({
        'supervisorId': supervisorId,
        'name': supervisorName,
        'email': email,
        'type': type,
        'patientId': patientId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

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


  // Read supervisors for a specific patient
  static Stream<QuerySnapshot> readSupervisors(String patientId) {
    return supervisionCollection
        .where('patientId', isEqualTo: patientId)
        .snapshots();
  }

  // Read patients supervised by a specific supervisor
  static Stream<QuerySnapshot> readPatientsForSupervisor(String supervisorId) {
    return supervisionCollection
        .where('supervisorId', isEqualTo: supervisorId)
        .snapshots();
  }

  // Delete a supervisor
  static Future<Map<String, dynamic>> deleteSupervision({
    required String supervisorId,
    required String patientId,
  }) async {
    try {
      // Delete supervisor document
      await supervisionCollection.doc(supervisorId).delete();

      // Remove supervisor from patient's supervisors sub-collection
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
    required int? heartRate,
    required int dayOfYear,
    required int minutesMidnight,
  }) async {
    try {
      DocumentReference documentReferencer = logsCollection.doc(logId);

      Map<String, dynamic> data = <String, dynamic>{
        'patientId': patientId,
        'medicationId': medicationId,
        'status': status,
        'spo2': spo2 ?? 0.0,
        'heartRate': heartRate ?? 0,
        'dayOfYear': dayOfYear,
        'minutesMidnight': minutesMidnight,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await documentReferencer.set(data);
      return {
        'success': true,
        'message': 'Log added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding log: $e',
      };
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
    return notificationsCollection
        .where("supervisorId", isEqualTo: supervisorId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}