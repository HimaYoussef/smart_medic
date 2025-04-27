import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Database/firestoreDB.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/Add_Supervisor.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Widgets/SupervisorCard.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/generated/l10n.dart';


class SupervisorsScreen extends StatelessWidget {
  const SupervisorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
         S.of(context).Supervision_view_Head,
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
              return  Center(child: Text( S.of(context).Supervision_view_Error_loading_supervisors));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return  Center(child: Text(S.of(context).Supervision_view_No_supervisors_found));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                var supervisor = doc.data() as Map<String, dynamic>;
                String supervisorId = supervisor['supervisorId'] ?? doc.id;
                return Column(
                  children: [
                    GestureDetector(
                      child: SupervisorCard(
                        name: supervisor['name'] ?? 'Unknown',
                        email: supervisor['email'] ?? 'Unknown',
                        type: supervisor['type'] ?? 'Unknown',
                        onDelete: () async {
                          var result = await SmartMedicalDb.deleteSupervision(
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