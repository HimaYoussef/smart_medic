import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/Sign_up.dart';
import 'package:smart_medic/Features/Auth/Presentation/view_model/auth_cubit.dart';
import 'package:smart_medic/Features/Auth/Presentation/view_model/auth_states.dart';
import 'package:smart_medic/Features/Users/Patient/Home/nav_bar.dart';
import 'package:smart_medic/core/functions/email_validation.dart';
import 'package:smart_medic/core/functions/routing.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/custom_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool _isLoggedIn = false;
  // Map _userObj = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isVisable = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          pushAndRemoveUntil(context, const PatientHomeView());
        } else if (state is LoginErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.error);
        } else {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 1, child: Container(color: AppColors.color1)),
                Expanded(flex: 2, child: Container(color: AppColors.white)),
              ],
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text("Login",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white)),
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
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // Keeps label on top

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
                            const SizedBox(height: 25.0),
                            TextFormField(
                              textAlign: TextAlign.start,
                              style: TextStyle(color: AppColors.black),
                              obscureText: isVisable,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // Keeps label on top
                                hintText: 'Enter your Password',
                                hintStyle: getbodyStyle(color: Colors.grey),
                                fillColor: AppColors.TextField,
                                filled: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisable = !isVisable;
                                    });
                                  },
                                  icon: Icon(
                                    (isVisable)
                                        ? Icons.remove_red_eye
                                        : Icons.visibility_off_rounded,
                                  ),
                                ),
                              ),
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please Enter Your password';
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
                                      await context.read<AuthCubit>().login(
                                            _emailController.text,
                                            _passwordController.text,
                                          );
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
                                    'SIGN IN',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: getbodyStyle(color: AppColors.black),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ));
                              },
                              child: Text(
                                'SIGN UP',
                                style: getbodyStyle(color: AppColors.color1),
                              ))
                        ],
                      ),
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
