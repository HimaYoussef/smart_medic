import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/Features/Auth/Data/Super_Visor_type.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/widgets/Custom_button.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';
import 'package:smart_medic/Database/firestoreDB.dart';

import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/build_text_field.dart';

class Edit_Supervisor extends StatefulWidget {
  final String supervisorId;
  final String name;
  final String email;
  final String type;

  const Edit_Supervisor({
    super.key,
    required this.supervisorId,
    required this.name,
    required this.email,
    required this.type,
  });

  @override
  State<Edit_Supervisor> createState() => _Edit_Supervisor();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _Edit_Supervisor extends State<Edit_Supervisor> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _supervisorType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _supervisorType = widget.type;
  }

  Future<void> _updateSupervisor() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      var result = await SmartMedicalDb.updateSupervisor(
        supervisorId: widget.supervisorId,
        updates: {
          'name': _nameController.text,
          'email': _emailController.text,
          'type': _supervisorType,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        showErrorDialog(context, result['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.black),
        ),
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cointainerDarkColor
                  : AppColors.white,
            ),
            height: 550,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: 'Edit Supervisor', fonSize: 20)
                      ],
                    ),
                    const Gap(30),
                    const CustomText(text: 'Name', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _nameController,
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      labelText: 'Enter The name of the Supervisor',
                      validatorText: 'Please Enter The name of the Supervisor',
                    ),
                    const SizedBox(height: 25.0),
                    const CustomText(text: 'Email', fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _emailController,
                      readOnly: false,
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'Enter The Email of the Supervisor',
                      validatorText:'Please Enter the Email of the Supervisor' ,
                    ),
                    const SizedBox(height: 25),
                    const CustomText(text: 'Supervisor type', fonSize: 15),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 160),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: AppColors.black,
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: _supervisorType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _supervisorType = newValue ?? _supervisorType;
                            });
                          },
                          items: SuperVisor_type.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Gap(30),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomButton(text: 'Update', onPressed: _updateSupervisor)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}