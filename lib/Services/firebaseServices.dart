import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
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
  static Future<Map<String, dynamic>> deleteUser(
      {required String userId}) async {
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

  // // Add a new supervisor
  // static Future<Map<String, dynamic>> addSupervisor({
  //   required String email,
  //   required String type,
  //   required String patientId,
  // }) async {
  //   try {
  //     QuerySnapshot userQuery = await usersCollection
  //         .where('email', isEqualTo: email)
  //         .where('type', isEqualTo: 'Supervisor')
  //         .limit(1)
  //         .get();

  //     if (userQuery.docs.isEmpty) {
  //       return {
  //         'success': false,
  //         'message':
  //             'Supervisor not found. Please ensure they are registered as a supervisor.',
  //       };
  //     }

  //     var supervisorDoc = userQuery.docs.first;
  //     String supervisorId = supervisorDoc.id;
  //     String supervisorName = supervisorDoc['name'] ?? 'Unknown';

  //     QuerySnapshot existingSupervisor = await supervisionCollection
  //         .where('patientId', isEqualTo: patientId)
  //         .where('supervisorId', isEqualTo: supervisorId)
  //         .limit(1)
  //         .get();

  //     if (existingSupervisor.docs.isNotEmpty) {
  //       return {
  //         'success': false,
  //         'message': 'This supervisor is already added for the patient.',
  //       };
  //     }

  //     DocumentReference supervisorRef = supervisionCollection.doc(supervisorId);
  //     await supervisorRef.set({
  //       'supervisorId': supervisorId,
  //       'name': supervisorName,
  //       'email': email,
  //       'type': type,
  //       'patientId': patientId,
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: true));

  //     await usersCollection
  //         .doc(patientId)
  //         .collection('supervisors')
  //         .doc(supervisorId)
  //         .set({
  //       'supervisorId': supervisorId,
  //       'addedAt': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: true));

  //     return {
  //       'success': true,
  //       'message': 'Supervisor added successfully',
  //       'supervisorId': supervisorId,
  //     };
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'Error adding supervisor: $e',
  //     };
  //   }
  // }
  // Add a new supervisor
  static Future<Map<String, dynamic>> addSupervisor({
    required String email,
    required String type,
    required String patientId,
  }) async {
    try {
      // Find the supervisor by email and type
      QuerySnapshot supervisorQuery = await usersCollection
          .where('email', isEqualTo: email)
          .where('type', isEqualTo: 'Supervisor')
          .limit(1)
          .get();

      if (supervisorQuery.docs.isEmpty) {
        return {
          'success': false,
          'message':
              'Supervisor not found. Please ensure they are registered as a supervisor.',
        };
      }

      var supervisorDoc = supervisorQuery.docs.first;
      String supervisorId = supervisorDoc.id;
      String supervisorName = supervisorDoc['name'] ?? 'Unknown';

      // Fetch the patient's document
      DocumentSnapshot patientDoc = await usersCollection.doc(patientId).get();
      if (!patientDoc.exists) {
        return {
          'success': false,
          'message': 'Patient not found.',
        };
      }
      String patientName = patientDoc['name'] ?? 'Unknown';

      // Check if the supervision relationship already exists
      QuerySnapshot existingSupervision = await supervisionCollection
          .where('supervisorId', isEqualTo: supervisorId)
          .where('patientId', isEqualTo: patientId)
          .limit(1)
          .get();

      if (existingSupervision.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'This supervisor is already added for the patient.',
        };
      }

      // Create a new document in supervision collection
      DocumentReference supervisionRef =
          supervisionCollection.doc(); // Generate unique ID
      String supervisionId = supervisionRef.id;

      await supervisionRef.set({
        'supervisionId': supervisionId,
        'supervisorId': supervisorId,
        'patientId': patientId,
        'supervisorName': supervisorName,
        'patientName': patientName,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Add to the patient's supervisors subcollection
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
        'supervisionId': supervisionId,
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

  // Read patients supervised by a specific supervisor
  static Stream<QuerySnapshot> readPatientsForSupervisor(String supervisorId) {
    return supervisionCollection
        .where('supervisorId', isEqualTo: supervisorId)
        .snapshots();
  }

// Fetch all users of type 'Supervisor'
  static Stream<QuerySnapshot> readAllSupervisors() {
    return usersCollection.where('type', isEqualTo: 'Supervisor').snapshots();
  }
  
// Fetch all users of type 'Patient'
static Stream<QuerySnapshot> readAllPatients() {
  return usersCollection
      .where('type', isEqualTo: 'Patient')
      .snapshots();
}
// Delete a supervision relationship
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
