import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Add_Supervisor.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Edit_Supervisor.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/SupervisorCard.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class SupervisorsScreen extends StatelessWidget {
  const SupervisorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supervisors',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: SmartMedicalDb.readSupervisors(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading supervisors"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No supervisors found"));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                var supervisor = doc.data() as Map<String, dynamic>;
                String supervisorId = supervisor['supervisorId'] ?? doc.id;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Edit_Supervisor(
                              supervisorId: supervisorId,
                              name: supervisor['name'] ?? 'Unknown',
                              email: supervisor['email'] ?? 'Unknown',
                              type: supervisor['type'] ?? 'Unknown',
                            ),
                          ),
                        );
                      },
                      child: SupervisorCard(
                        supervisorId: supervisorId,
                        name: supervisor['name'] ?? 'Unknown',
                        email: supervisor['email'] ?? 'Unknown',
                        type: supervisor['type'] ?? 'Unknown',
                        onDelete: () async {
                          var result = await SmartMedicalDb.deleteSupervisor(
                            supervisorId: supervisorId,
                            patientId: user.uid,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['message'],
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Add_SuperVisor(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}