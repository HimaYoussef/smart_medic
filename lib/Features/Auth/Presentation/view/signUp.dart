import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/functions/email_validation.dart';
import '../../../../core/functions/routing.dart';
import '../../../../core/utils/Colors.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../../generated/l10n.dart';
import '../view_model/Cubits/SignUpCubit/sign_up_cubit.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  final String role;

  const SignUpScreen({super.key, required this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:  TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).signUp_SnackBar,
                  style:  TextStyle(color: AppColors.white),
                ),
              ),
            );
            pushAndRemoveUntil(
              context,
              LoginScreen(role: widget.role),
            );
          } else if (state is SignUpFailure) {
            showErrorSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          final cubit = context.watch<SignUpCubit>();
          final isLoading = state is SignUpLoading;

          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
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
                        Container(
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
                              children: [
                                _buildIcon(context),
                                const SizedBox(height: 24),
                                Text(
                                  S.of(context).signUp_Hello,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                _buildTextField(_nameController, TextInputType.name, S.of(context).signUp_Name),
                                const SizedBox(height: 24),
                                _buildTextField(_emailController, TextInputType.emailAddress, S.of(context).signUp_Email),
                                const SizedBox(height: 24),
                                _buildPasswordField(
                                  controller: _passwordController,
                                  label: S.of(context).signUp_password,
                                  isVisible: cubit.isPasswordVisible,
                                  toggleVisibility: cubit.togglePasswordVisibility,
                                ),
                                const SizedBox(height: 24),
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  label: S.of(context).signUp_Confirm_Password,
                                  isVisible: cubit.isConfirmPasswordVisible,
                                  toggleVisibility: cubit.toggleConfirmPasswordVisibility,
                                ),
                                const SizedBox(height: 20),
                                isLoading
                                    ? const CircularProgressIndicator()
                                    : CustomButton(
                                  text: S.of(context).signUp_SIGN_UP,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    final name = _nameController.text.trim();
                                    final email = _emailController.text.trim();
                                    final pass = _passwordController.text;
                                    final confirm = _confirmPasswordController.text;

                                    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
                                      showErrorSnackBar(context, S.of(context).signUp_SnackBar_Please_Continue);
                                    } else if (!emailValidate(email)) {
                                      showErrorSnackBar(context, S.of(context).signUp_Please_enter_a_valid_email);
                                    } else if (pass != confirm) {
                                      showErrorSnackBar(context, S.of(context).signUp_Passwords_do_not_match);
                                    } else {
                                      cubit.signUp(
                                        name: name,
                                        email: email,
                                        password: pass,
                                        type: widget.role,
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
                          onPressed: () => pushAndRemoveUntil(context, LoginScreen()),
                          child: Text(
                            S.of(context).signUp_Already_have_an_account_SIGN_IN,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildTextField(TextEditingController controller, TextInputType type, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
