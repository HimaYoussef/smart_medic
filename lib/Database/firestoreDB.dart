import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
final CollectionReference usersCollection = _firestore.collection("users");
final CollectionReference smartMedicalBoxCollection = _firestore.collection("smartMedicalBox");
final CollectionReference medicationsCollection = _firestore.collection("medications");
final CollectionReference logsCollection = _firestore.collection("logs");
final CollectionReference notificationsCollection = _firestore.collection("notifications");
final CollectionReference supervisorsCollection = _firestore.collection('supervisors');

class SmartMedicalDb {
  // Add User
  static Future<Response> addUser({
    required String userId,
    required String name,
    required String type,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = usersCollection.doc(userId);

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "name": name,
      "type": type,
      "createdAt": FieldValue.serverTimestamp()
    };

    await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "User added successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Read Users
  static Stream<QuerySnapshot> readUsers() {
    return usersCollection.snapshots();
  }

  // Delete User
  static Future<Response> deleteUser({
    required String userId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = usersCollection.doc(userId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "User deleted successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
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
    required String name,
    required String email,
    required String type,
    required String patientId,
  }) async {
    try {
      DocumentReference supervisorRef = supervisorsCollection.doc();
      String supervisorId = supervisorRef.id;

      await supervisorRef.set({
        'supervisorId': supervisorId,
        'name': name,
        'email': email,
        'type': type,
        'patientId': patientId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Link supervisor to patient
      await usersCollection
          .doc(patientId)
          .collection('supervisors')
          .doc(supervisorId)
          .set({
        'supervisorId': supervisorId,
        'addedAt': FieldValue.serverTimestamp(),
      });

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

  // Update patient profile
  static Future<Map<String, dynamic>> updatePatientProfile({
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
    return supervisorsCollection
        .where('patientId', isEqualTo: patientId)
        .snapshots();
  }

  // Update supervisor data
  static Future<Map<String, dynamic>> updateSupervisor({
    required String supervisorId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await supervisorsCollection.doc(supervisorId).update(updates);
      return {
        'success': true,
        'message': 'Supervisor updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating supervisor: $e',
      };
    }
  }

  // Delete a supervisor
  static Future<Map<String, dynamic>> deleteSupervisor({
    required String supervisorId,
    required String patientId,
  }) async {
    try {
      // Delete supervisor document
      await supervisorsCollection.doc(supervisorId).delete();

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

  // Get a specific supervisor by ID
  static Future<Map<String, dynamic>> getSupervisor(String supervisorId) async {
    try {
      DocumentSnapshot doc =
          await supervisorsCollection.doc(supervisorId).get();
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
  static Future<Response> addMedication({
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
    Response response = Response();
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
      "syncStatus": "Pending"
    };

    await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Medication added successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Read Medications
  static Stream<QuerySnapshot> readMedications(String patientId) {
    return medicationsCollection
        .where("patientId", isEqualTo: patientId)
        .snapshots();
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
  static Future<Response> updateMedicationSyncStatus({
    required String medId,
    required String syncStatus,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = medicationsCollection.doc(medId);

    await documentReferencer
        .update({"syncStatus": syncStatus}).whenComplete(() {
      response.code = 200;
      response.message = "Sync status updated successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
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
  static Future<Response> addLog({
    required String logId,
    required String patientId,
    required String? medicationId,
    required String? status,
    required double? spo2,
    required int? heartRate,
    required int dayOfYear,
    required int minutesMidnight,
  }) async {
    Response response = Response();
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

    await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Log added successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Read Logs
  static Stream<QuerySnapshot> readLogs(String patientId) {
    return logsCollection
        .where("patientId", isEqualTo: patientId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Add Notification
  static Future<Response> addNotification({
    required String notificationId,
    required String patientId,
    required String supervisorId,
    required String message,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
        notificationsCollection.doc(notificationId);

    Map<String, dynamic> data = {
      "patientId": patientId,
      "supervisorId": supervisorId,
      "message": message,
      "timestamp": FieldValue.serverTimestamp(),
      "status": "sent"
    };

    await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Notification added successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Read Notifications
  static Stream<QuerySnapshot> readNotifications(String supervisorId) {
    return notificationsCollection
        .where("supervisorId", isEqualTo: supervisorId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
