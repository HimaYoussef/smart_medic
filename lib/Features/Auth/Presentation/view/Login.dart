import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Features/Auth/Presentation/view/signUp.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Maintainer/Maintainer_view.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../Users/Patient/Home/nav_bar.dart';
import '../../../Users/Supervisor/Home/nav_bar.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../view_model/Cubits/LoginCubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String? role; // Make role optional

  LoginScreen({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(expectedRole: role ?? ''),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          final role = BlocProvider.of<LoginCubit>(context).role;
          if (state is AdminSuccess) {
            pushAndRemoveUntil(context, const MaintainerView());
          }
          if (state is Success) {
            if (role == 'Patient') {
              pushAndRemoveUntil(context, const PatientHomeView());
            } else if (role == 'Supervisor') {
              pushAndRemoveUntil(context, const SupervisorHomeView());
            } else if (role == 'Maintainer') {
              pushAndRemoveUntil(context, const MaintainerView());
            }
          } else if (state is Failed) {
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
          final cubit = context.read<LoginCubit>();
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
                                  S.of(context).Login_Welcome_Back,
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
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: S.of(context).Login_Email,
                                  labelStyle: TextStyle(color: Colors.grey),
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
                                  labelText: S.of(context).Login_password,
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
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
                                      cubit.togglePasswordVisibility();
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              state is Loading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : CustomButton(
                                      text: S.of(context).Login_SIGN_IN,
                                      onPressed: () async {
                                        final email =
                                            _emailController.text.trim();
                                        final password =
                                            _passwordController.text;
                                        if (email.isEmpty || password.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                S.of(context).Login_SnackBar,
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        await cubit.login(
                                          email: email,
                                          pass: password,
                                          context: context,
                                        );
                                      },
                                    ),
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
                              builder: (context) => RoleSelectionScreen(),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).Login_Dont_have_an_account,
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
