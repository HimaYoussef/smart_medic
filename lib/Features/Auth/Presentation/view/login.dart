import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/resetPass.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/signUp.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../../core/widgets/build_text_field.dart';
import '../../../Users/Patient/Home/nav_bar.dart';
import '../../../Users/Supervisor/Home/nav_bar.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../view_model/Cubits/LoginCubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String role;

  LoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is Loading) {
          // Show loading indicator
        } else if (state is Success) {
          // Navigate based on role
          if (role == 'Patient') {
            pushAndRemoveUntil(context, const PatientHomeView());
          } else if (role == 'Supervisor') {
            pushAndRemoveUntil(context, const SupervisorHomeView());
          }
        } else if (state is Failed) {
          // Show error with option to resend verification email if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.mainColorDark
                  : AppColors.mainColor,
              duration: Duration(seconds: 3),
              action: state.errorMessage == 'Email not verified yet'
                  ? SnackBarAction(
                label: 'Resend',
                textColor: AppColors.white,
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Verification email resent. Check your inbox.',
                          style: TextStyle(color: AppColors.white),
                        ),
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.mainColorDark
                            : AppColors.mainColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to resend verification email.',
                          style: TextStyle(color: AppColors.white),
                        ),
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.mainColorDark
                            : AppColors.mainColor,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              )
                  : null,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<LoginCubit>();
        final isLoading = state is Loading;

        return Scaffold(
          body: Stack(
            children: [
              // Background gradient
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
              // Main content
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "Login",
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
                        child:Column(children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
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
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Email field
                                CustomTextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  readOnly: false,
                                  validatorText: 'Please enter a valid email',
                                  labelText: 'Enter your Email',
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 24),
                                // Password field
                                CustomTextField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.text,
                                  readOnly: false,
                                  validatorText: 'Please enter your password',
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
                                      context.read<LoginCubit>().togglePasswordVisibility();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Sign in button or loading indicator
                                isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : CustomButton(
                                  text: "SIGN IN",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().login(
                                        email: _emailController.text.trim(),
                                        pass: _passwordController.text,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),

                        ],
                        )

                      ),
                    ),
                    const SizedBox(height: 20),
                    // Forgot password link
                    GestureDetector(
                      onTap: () {
                        pushTo(context, const ResetPassPage());
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.mainColorDark
                              : AppColors.mainColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Sign up link
                    GestureDetector(
                      onTap: () {
                        pushTo(context, SignUpScreen(role: role));
                      },
                      child: Text(
                        "Don’t have an account? SIGN UP",
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