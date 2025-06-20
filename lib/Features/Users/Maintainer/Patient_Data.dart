import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/generated/l10n.dart';

class PatientData extends StatefulWidget {
  const PatientData({super.key});

  @override
  State<PatientData> createState() => _nameState();
}

class _nameState extends State<PatientData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).Role_Selection_patient,
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
          stream: SmartMedicalDb.readAllPatients(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return  Center(child: Text(S.of(context).Patient_Data_No_patients_found));
            }

            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final patientId = doc.id;

                return PatientCard(
                  name: data['name'] ?? 'N/A',
                  email: data['email'] ?? 'N/A',
                  type: data['type'] ?? 'N/A',
                  onDelete: () async {
                    final result =
                        await SmartMedicalDb.deleteUser(userId: patientId);
                    if (!result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'])),
                      );
                    }
                  },
                );
              },
              separatorBuilder: (context, index) {
                // You can customize the separator here, e.g., a Divider or SizedBox
                return const SizedBox(height: 8.0); // horizontal divider
                // Or use SizedBox for spacing:
              },
            );
          },
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;
  final String email;
  final String type;
  final VoidCallback onDelete;

  const PatientCard({
    super.key,
    required this.name,
    required this.email,
    required this.type,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cointainerDarkColor
            : AppColors.mainColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(
                'assets/avatar2.png'), // Use different avatar for patients
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Email: $email',
                  style: getsmallStyle(color: Colors.white),
                ),
                Text(
                  'Type: $type',
                  style: getsmallStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
