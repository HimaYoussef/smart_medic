import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/signUp.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../Users/Patient/Home/nav_bar.dart';
import '../../../Users/Supervisor/Home/nav_bar.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../view_model/Cubits/LoginCubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final String role;

  LoginScreen({super.key, required this.role});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is Loading) {
          _isLoading = true;
        }
        else if (state is Success) {
          if(role=='Patient'){
            pushAndRemoveUntil(context, const PatientHomeView(),);
          }
          else if (role=='Supervisor'){
            pushAndRemoveUntil(context, const SupervisorHomeView(),);
          }
          _isLoading = false;
        }
        else if (state is Failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage,style: TextStyle(color: AppColors.white),)),
          );
          _isLoading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      flex: 1, child: Container(color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.mainColorDark
                      : AppColors.mainColor)),
                  Expanded(flex: 2, child: Container(color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.cointainerDarkColor
                      : Colors.grey[200])),
                ],
              ),
              SingleChildScrollView(
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.cointainerDarkColor
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.ShadowColor, blurRadius: 5)
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
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your Email',
                                labelStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _passwordController,
                              obscureText: !context
                                  .watch<LoginCubit>()
                                  .isPasswordVisible,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Enter your Password',
                                labelStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    context
                                        .watch<LoginCubit>()
                                        .isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<LoginCubit>()
                                        .togglePasswordVisibility();
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              CustomButton(text: "SIGN IN", onPressed: () async {
                                final email = _emailController.text.trim();
                                final password = _passwordController.text;
                                if(email==''&&password==''){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please continue...',style: TextStyle(color: AppColors.white))),
                                  );
                                }else{
                                 await BlocProvider.of<LoginCubit>(context).login(
                                      email: email,
                                      pass: password);
                                }

                              })
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  SignUpScreen(role: role,),
                          ),
                        );
                      },
                      child: Text("Don’t have an account? SIGN UP",
                          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.mainColorDark
                              : AppColors.mainColor)),
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