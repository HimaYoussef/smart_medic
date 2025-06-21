import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/resetPass.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/signUp.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Maintainer/Maintainer_view.dart';
import 'package:smart_medic/core/widgets/build_text_field.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../Users/Patient/Home/nav_bar.dart';
import '../../../Users/Supervisor/Home/nav_bar.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../view_model/Cubits/LoginCubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  final String? role;

  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (_) => LoginCubit(expectedRole: widget.role ?? ''),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is AdminSuccess) {
            pushAndRemoveUntil(context, const MaintainerView());
          } else if (state is Success) {
            if (state.userRole == 'Patient') {
              pushAndRemoveUntil(context, const PatientHomeView());
            } else if (state.userRole == 'Supervisor') {
              pushAndRemoveUntil(context, const SupervisorHomeView());
            } else {
              pushAndRemoveUntil(context, const RoleSelectionScreen());
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
                action: state.errorMessage ==
                        S.of(context).Login_Email_not_verified_yet
                    ? SnackBarAction(
                        label: S.of(context).Login_Resend,
                        textColor: AppColors.white,
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  S
                                      .of(context)
                                      .Login_Verification_email_resent_Check_your_inbox,
                                  style: TextStyle(color: AppColors.white),
                                ),
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.mainColorDark
                                    : AppColors.mainColor,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  S
                                      .of(context)
                                      .Login_Failed_to_resend_verification_email,
                                  style: TextStyle(color: AppColors.white),
                                ),
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
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
                        S.of(context).Login_Head,
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
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                        S.of(context).Login_Welcome_Back,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    CustomTextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      readOnly: false,
                                      labelText: S.of(context).Login_Email,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 24),
                                    CustomTextField(
                                      controller: _passwordController,
                                      keyboardType: TextInputType.text,
                                      readOnly: false,
                                      labelText: S.of(context).Login_password,
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
                                    const SizedBox(height: 20),
                                    isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : CustomButton(
                                            text: S.of(context).Login_SIGN_IN,
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();

                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginCubit>()
                                                    .login(
                                                      email: _emailController
                                                          .text
                                                          .trim(),
                                                      pass: _passwordController
                                                          .text,
                                                    );
                                              }
                                            },
                                          ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  pushTo(context, const ResetPassPage());
                                },
                                child: Text(
                                  S.of(context).Login_Forgot_Password,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  pushTo(context, RoleSelectionScreen());
                                },
                                child: Text(
                                  S.of(context).Login_Dont_have_an_account,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
