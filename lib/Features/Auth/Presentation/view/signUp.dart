import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../../core/widgets/build_text_field.dart';
import '../view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added Form key
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final String role;

  SignUpScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          _isLoading = true;
        } else if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Account created successfully! Please verify your email.",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          );
          // Send email verification
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          if (role == 'Patient') {
            pushTo(context, LoginScreen(role: 'Patient'));
          } else if (role == 'Supervisor') {
            pushTo(context, LoginScreen(role: 'Supervisor'));
          }
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: TextStyle(color: AppColors.white),
              ),
            ),
          );
          _isLoading = false;
        }
      },
      builder: (context, state) {
        final cubit = context.watch<SignUpCubit>();

        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.mainColorDark
                          : AppColors.mainColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.cointainerDarkColor
                          : Colors.grey[200],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.cointainerDarkColor
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ShadowColor,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.medical_services,
                                    color: AppColors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Center(
                                child: Text(
                                  'Hello',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              CustomTextField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                readOnly: false,
                                validatorText: 'Please enter your name',
                                labelText: 'Enter your Name',
                                onChanged: (value) {
                                  // Optional: Real-time validation if needed
                                },
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                readOnly: false,
                                validatorText: 'Please enter a valid email',
                                labelText: 'Enter your Email',
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                readOnly: false,
                                validatorText: 'Password must be at least 6 characters',
                                labelText: 'Enter your Password',
                                obscureText: !cubit.isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    cubit.isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    cubit.togglePasswordVisibility();
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                keyboardType: TextInputType.text,
                                readOnly: false,
                                validatorText: 'Please confirm your password',
                                labelText: 'Confirm your Password',
                                obscureText: !cubit.isConfirmPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    cubit.isConfirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    cubit.toggleConfirmPasswordVisibility();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_isLoading)
                                const Center(child: CircularProgressIndicator())
                              else
                                CustomButton(
                                  text: "SIGN UP",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final name = _nameController.text.trim();
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text;
                                      final confirmPassword = _confirmPasswordController.text;
                                      if (password != confirmPassword) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Passwords do not match",
                                              style: TextStyle(color: AppColors.white),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      BlocProvider.of<SignUpCubit>(context).signUp(
                                        name: name,
                                        email: email,
                                        password: password,
                                        type: role,
                                      );
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Already have an account? SIGN IN",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.mainColorDark
                              : AppColors.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}