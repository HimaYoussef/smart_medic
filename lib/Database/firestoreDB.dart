import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference usersCollection = _firestore.collection("users");
final CollectionReference smartMedicalBoxCollection = _firestore.collection("smartMedicalBox");
final CollectionReference medicationsCollection = _firestore.collection("medications");
final CollectionReference logsCollection = _firestore.collection("logs");
final CollectionReference notificationsCollection = _firestore.collection("notifications");

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

  // Update User
  static Future<Response> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = usersCollection.doc(userId);

    await documentReferencer.update(updates).whenComplete(() {
      response.code = 200;
      response.message = "User updated successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
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

  // Add Medication
  static Future<Response> addMedication({
    required String medId,
    required String patientId,
    required String name,
    required int dosage,
    required int scheduleType,
    required dynamic scheduleValue, // يمكن أن يكون عدد المرات أو الفاصل الزمني أو null
    required List<String> times, // قائمة الأوقات التي سيتم تناول الدواء فيها
    required List<int> bitmaskDays, // مصفوفة 7 بت للأيام المختارة
    required int pillsLeft,
    required int compartmentNumber,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = medicationsCollection.doc(medId);

    Map<String, dynamic> data = <String, dynamic>{
      "patientId": patientId,
      "name": name,
      "dosage": dosage,
      "scheduleType": scheduleType,
      "scheduleValue": scheduleValue,
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
    return medicationsCollection.where("patientId", isEqualTo: patientId).snapshots();
  }

  // Update Medication
  static Future<Response> updateMedication({
    required String medId,
    required Map<String, dynamic> updates,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = medicationsCollection.doc(medId);

    await documentReferencer.update(updates).whenComplete(() {
      response.code = 200;
      response.message = "Medication updated successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Update Medication Sync Status
  static Future<Response> updateMedicationSyncStatus({
    required String medId,
    required String syncStatus,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = medicationsCollection.doc(medId);

    await documentReferencer.update({"syncStatus": syncStatus}).whenComplete(() {
      response.code = 200;
      response.message = "Sync status updated successfully";
    }).catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  // Read Logs
  static Stream<QuerySnapshot> readLogs(String patientId) {
    return logsCollection.where("patientId", isEqualTo: patientId).orderBy("timestamp", descending: true).snapshots();
  }

  // Add Notification
  static Future<Response> addNotification({
    required String notificationId,
    required String patientId,
    required String supervisorId,
    required String message,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = notificationsCollection.doc(notificationId);

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
    return notificationsCollection.where("supervisorId", isEqualTo: supervisorId).orderBy("timestamp", descending: true).snapshots();
  }
}
