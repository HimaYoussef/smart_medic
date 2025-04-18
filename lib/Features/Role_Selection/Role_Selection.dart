import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/Login.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = '';

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue As..",
                  style: getTitleStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.black),
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildRoleCard('Patient', 'assets/patient.png', screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildRoleCard('Supervisor', 'assets/supervisor.png', screenWidth),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.6,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedRole.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(role: selectedRole),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, String assetPath, double screenWidth) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => selectRole(role),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          width: screenWidth * 0.6,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    selectRole(role);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.45,
                height: screenWidth * 0.35,
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                role,
                style: getbodyStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white
                      : AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}