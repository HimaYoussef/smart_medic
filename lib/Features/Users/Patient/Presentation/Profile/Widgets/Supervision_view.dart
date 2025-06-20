import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart'; // Import showcaseview
import '../../../../../../Services/firebaseServices.dart';
import '../../../../../../core/utils/Colors.dart';
import '../../../../../../generated/l10n.dart';
import '../../Widgets/Add_Supervisor.dart';
import '../../Widgets/SupervisorCard.dart';

class SupervisorsScreen extends StatefulWidget {
  const SupervisorsScreen({super.key});

  @override
  _SupervisorsScreenState createState() => _SupervisorsScreenState();
}

class _SupervisorsScreenState extends State<SupervisorsScreen> {
  // Define a GlobalKey for the FloatingActionButton showcase
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Trigger the showcase after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([_fabKey]);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
          stream: SmartMedicalDb.readSupervisors(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(S
                      .of(context)
                      .Supervision_view_Error_loading_supervisors));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                      S.of(context).Supervision_view_No_supervisors_found));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                var supervision = doc.data() as Map<String, dynamic>;
                String supervisorId = supervision['supervisorId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: usersCollection.doc(supervisorId).get(),
                  builder: (context, supervisorSnapshot) {
                    if (supervisorSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (supervisorSnapshot.hasError) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                            child: Text('Error loading supervisor details')),
                      );
                    }
                    if (!supervisorSnapshot.hasData ||
                        !supervisorSnapshot.data!.exists) {
                      return const SizedBox.shrink(); // Skip this log
                    }

                    var supervisorData =
                        supervisorSnapshot.data!.data() as Map<String, dynamic>;
                    String name = supervisorData['name'] ?? 'Unknown';
                    String email = supervisorData['email'] ?? 'Unknown';
                    String type = supervision['type'] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SupervisorCard(
                        name: name,
                        email: email,
                        type: type,
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
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Showcase(
        key: _fabKey,
        tooltipBackgroundColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.white
            : AppColors.black,
        descTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        tooltipPadding: const EdgeInsets.all(10),
        description: S
            .of(context)
            .Add_Supervisor_Add_Supervisor, // Description for the showcase
        child: FloatingActionButton(
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
      ),
    );
  }
}
