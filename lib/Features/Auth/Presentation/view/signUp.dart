import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../core/functions/email_validation.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final String role;

  SignUpScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).signUp_SnackBar,
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            );
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
                        S.of(context).signUp_Head,
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                              Center(
                                child: Text(
                                  S.of(context).signUp_Hello,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: S.of(context).signUp_Name,
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: S.of(context).signUp_Email,
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: _passwordController,
                                obscureText: !cubit.isPasswordVisible,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: S.of(context).signUp_password,
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: !cubit.isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText:
                                      S.of(context).signUp_Confirm_Password,
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              state is SignUpLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : CustomButton(
                                      text: S.of(context).signUp_SIGN_UP,
                                      onPressed: () async {
                                        final name = _nameController.text;
                                        final email =
                                            _emailController.text.trim();
                                        final password =
                                            _passwordController.text;
                                        final confirmPassword =
                                            _confirmPasswordController.text;
                                        if (email.isEmpty ||
                                            password.isEmpty ||
                                            confirmPassword.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S
                                                    .of(context)
                                                    .signUp_SnackBar_Please_Continue,
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          );
                                        } else if (!emailValidate(email)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S
                                                    .of(context)
                                                    .signUp_Please_enter_a_valid_email,
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          );
                                        } else if (password !=
                                            confirmPassword) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S
                                                    .of(context)
                                                    .signUp_Passwords_do_not_match,
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          );
                                        } else {
                                          await BlocProvider.of<SignUpCubit>(
                                                  context)
                                              .signUp(
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
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          pushTo(context, LoginScreen());
                          ;
                        },
                        child: Text(
                          S.of(context).signUp_Already_have_an_account_SIGN_IN,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
      ),
    );
  }
}
