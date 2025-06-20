import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Services/firebaseServices.dart';
import '../../../generated/l10n.dart';
import '../Patient/Presentation/Widgets/SupervisorCard.dart';


class SupervisorData extends StatefulWidget {
  const SupervisorData({super.key});

  @override
  State<SupervisorData> createState() => _SupervisorDataState();
}

class _SupervisorDataState extends State<SupervisorData> {
  User? user = FirebaseAuth.instance.currentUser;
  // final CollectionReference supervisionCollection =
  //     FirebaseFirestore.instance.collection('supervision');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).Supervision_view_Head,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          stream: SmartMedicalDb.readAllSupervisors(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No supervisors found."));
            }

            return SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap:
                    true, // Ensures the ListView doesn't expand infinitely
                physics:
                    const NeverScrollableScrollPhysics(), // Disables internal scrolling
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final supervisorId = doc.id;

                  return SupervisorCard(
                    name: data['name'] ?? 'N/A',
                    email: data['email'] ?? 'N/A',
                    type: data['type'] ?? 'N/A',
                    onDelete: () async {
                      final result =
                          await SmartMedicalDb.deleteUser(userId: supervisorId);
                      if (!result['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0); // Spacing between items
                  // Or use Divider(): return const Divider();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
