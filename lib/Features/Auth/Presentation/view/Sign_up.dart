import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/Login.dart';
import 'package:smart_medic/Features/Auth/Presentation/view_model/auth_cubit.dart';
import 'package:smart_medic/Features/Auth/Presentation/view_model/auth_states.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/core/functions/email_validation.dart';
import 'package:smart_medic/core/functions/routing.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Verify Email',
            desc: 'Please verify your email',
            btnOkOnPress: () {
              pushTo(context, LoginScreen());
            },
          ).show();
          context.read<AuthCubit>().Verify(_emailController.text);
        } else if (state is RegisterErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 1, child: Container(color: AppColors.color1)),
                Expanded(flex: 2, child: Container(color: Colors.grey[200])),
              ],
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: AppColors.color2, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.color1,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(Icons.medical_services,
                                    color: AppColors.white, size: 30),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Center(
                              child: Text(
                                'Hello!',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _displayNameController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter your Full Name',
                                hintStyle: getbodyStyle(color: Colors.grey),
                                fillColor: AppColors.TextField,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter your Email Address',
                                hintStyle: getbodyStyle(color: Colors.grey),
                                fillColor: AppColors.TextField,
                                filled: true,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter your Email';
                                } else if (!emailValidate(value)) {
                                  return 'Please Enter A valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isVisible,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Enter Your Password',
                                hintStyle: getbodyStyle(color: Colors.grey),
                                fillColor: AppColors.TextField,
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: isVisible,
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Confirm Your Password',
                                hintStyle: getbodyStyle(color: Colors.grey),
                                fillColor: AppColors.TextField,
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please confirm your password';
                                } else if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (_passwordController.text !=
                                          _confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Passwords do not match')),
                                        );
                                        return;
                                      }
                                      context.read<AuthCubit>().registerUser(
                                          _displayNameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                          _confirmPasswordController.text);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.color1,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    'SIGN UP',
                                    style: getbodyStyle(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: getbodyStyle(color: AppColors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'SIGN IN',
                            style: getbodyStyle(color: AppColors.color1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
