import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Refill_Medicine.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/CustomBoxFilled.dart';
import 'package:smart_medic/core/widgets/CustomBoxIcon.dart';
import 'package:smart_medic/generated/l10n.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../Services/firebaseServices.dart';

class PatientMainView extends StatefulWidget {
  final List<GlobalKey>
      navBarKeys; // Keys for nav bar showcases from PatientHomeView

  const PatientMainView({super.key, required this.navBarKeys});

  @override
  State<PatientMainView> createState() => _PatientMainViewState();
}

class _PatientMainViewState extends State<PatientMainView> {
  User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey _firstCompartmentKey =
      GlobalKey(); // Key for compartment 1 showcase
  bool _hasStartedShowcase = false; // Flag to prevent multiple showcase starts

  @override
  void initState() {
    super.initState();
    // Showcase will be started after data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Patient_Main_view_Home),
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: SmartMedicalDb.readMedications(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  S.of(context).Patient_Main_view_Error_loading_medications,
                ),
              );
            }

            // Extract medications from snapshot
            List<Map<String, dynamic>> medications = snapshot.data!.docs
                .map((doc) => {
                      ...doc.data() as Map<String, dynamic>,
                      'id': doc.id,
                    })
                .toList();

            // Start showcase after data is loaded and UI is built
            if (snapshot.connectionState == ConnectionState.active &&
                !_hasStartedShowcase) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  // Combine compartment key with nav bar keys
                  List<GlobalKey> showcaseKeys = [
                    _firstCompartmentKey,
                    ...widget.navBarKeys
                  ];
                  ShowCaseWidget.of(context).startShowCase(showcaseKeys);
                  setState(() {
                    _hasStartedShowcase = true;
                  });
                }
              });
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                double itemHeight = (constraints.maxHeight - 55) / 4.7;
                double itemWidth = (constraints.maxWidth - 36) / 2;
                double aspectRatio = itemWidth / itemHeight;

                return GridView.builder(
                  physics: constraints.maxHeight > 650
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    // Check if there is a medication for this compartment
                    var medForCompartment = medications.firstWhere(
                      (med) => med['compartmentNumber'] == (index + 1),
                      orElse: () => {},
                    );
                    
                    if (medForCompartment.isNotEmpty) {
                      // Show filled box if medication exists
                      return CustomBoxFilled(
                        medicineName: medForCompartment['name'] ?? 'Unknown',
                        compartmentNumber: index + 1,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Refill_Medicine(
                              compartmentNum: index + 1,
                            ),
                          ),
                        ),
                      );
                    } else if (index == 0) {
                      // Show showcase for first empty compartment
                      return Showcase(
                        key: _firstCompartmentKey,
                        description: S.of(context).Patient_Main_view_Empty_Icon,
                        tooltipBackgroundColor: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.white
                                : AppColors.black,
                        descTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        tooltipPadding: EdgeInsets.all(10),
                        child: CustomBoxIcon(index: index),
                      );
                    } else {
                      // For other compartments, if empty, show CustomBoxIcon without Showcase
                      return CustomBoxIcon(index: index);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
