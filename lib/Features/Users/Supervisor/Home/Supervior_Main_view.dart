import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import '../../../../Services/firebaseServices.dart';
import 'Widgets/PatientDetails.dart';
import 'Widgets/Patients_card.dart';

class Supervior_Main_view extends StatefulWidget {
  const Supervior_Main_view({super.key});

  @override
  State<Supervior_Main_view> createState() => _SuperviorMainViewState();
}

class _SuperviorMainViewState extends State<Supervior_Main_view> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervision'),
        centerTitle: true,
        elevation: 0,
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
        child: Column(
          children: [
            // List of Patients
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: SmartMedicalDb.readPatientsForSupervisor(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading patients'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No patients found'));
                  }

                  final supervisionDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: supervisionDocs.length,
                    itemBuilder: (context, index) {
                      final supervisionDoc = supervisionDocs[index];
                      final patientId = supervisionDoc['patientId'];

                      // Fetch patient details from users collection
                      return FutureBuilder<DocumentSnapshot>(
                        future: usersCollection.doc(patientId).get(),
                        builder: (context, patientSnapshot) {
                          if (patientSnapshot.hasError) {
                            return const Center(
                                child: Text('Error loading patient details'));
                          }
                          if (patientSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!patientSnapshot.hasData ||
                              !patientSnapshot.data!.exists) {
                            return const Center(
                                child: Text('Patient not found'));
                          }

                          final patientData = patientSnapshot.data!.data()
                              as Map<String, dynamic>;
                          final name = patientData['name'] ?? 'Unknown';
                          final email = patientData['email'] ?? 'No email';
                          final type = patientData['type'] ?? 'Unknown';

                          return StreamBuilder<QuerySnapshot>(
                            stream: SmartMedicalDb.readNotifications(user!.uid),
                            builder: (context, notificationSnapshot) {
                              int notificationsCount = 0;
                              if (notificationSnapshot.hasData) {
                                notificationsCount = notificationSnapshot
                                    .data!.docs
                                    .where((doc) =>
                                        doc['status'] == 'sent' &&
                                        doc['patientId'] == patientId)
                                    .length;
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: PatientCard(
                                  name: name,
                                  email: email,
                                  type: type,
                                  notificationsCount: notificationsCount,
                                  onDelete: () async {
                                    final result =
                                        await SmartMedicalDb.deleteSupervision(
                                      supervisorId: user!.uid,
                                      patientId: patientId,
                                    );
                                    if (result['success']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(result['message'])),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(result['message'])),
                                      );
                                    }
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PatientDetailsView(
                                          patientId: patientId,
                                          patientName: name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
