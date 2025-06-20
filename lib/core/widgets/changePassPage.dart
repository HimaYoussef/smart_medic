import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../core/widgets/BuildText.dart';
import '../../../../../core/widgets/Custom_button.dart';
import '../../../../../core/widgets/build_text_field.dart';
import '../../../../../core/utils/Colors.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S
                .of(context)
                .changePassPage_New_password_and_confirmation_do_not_match,
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: S.of(context).changePassPage_no_user,
          message: S.of(context).changePassPage_No_user_is_signed_in,
        );
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).changePassPage_Password_changed_successfully,
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect.';
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak.';
          break;
        case 'no-user':
          errorMessage = 'No user is signed in.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
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
            S.of(context).changePassPage_An_unexpected_error_occurred,
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.mainColorDark
              : AppColors.mainColor,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
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
                  : AppColors.cointainerColor,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text: S.of(context).changePassPage_Change_Password,
                            fonSize: 20),
                      ],
                    ),
                    const Gap(30),
                    CustomText(
                        text: S.of(context).changePassPage_Current_Password,
                        fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _currentPasswordController,
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validatorText: S
                          .of(context)
                          .changePassPage_Please_enter_your_current_password,
                      labelText:
                          S.of(context).changePassPage_Enter_Current_Password,
                      obscureText: _obscureCurrentPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                        text: S.of(context).changePassPage_New_Password,
                        fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _newPasswordController,
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validatorText: S
                          .of(context)
                          .changePassPage_Please_enter_a_valid_new_password_at_least_6_characters,
                      labelText:
                          S.of(context).changePassPage_Enter_New_Password,
                      obscureText: _obscureNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 25),
                    CustomText(
                        text: S.of(context).changePassPage_Confirm_New_Password,
                        fonSize: 15),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validatorText:
                          S.of(context).changePassPage_Confirm_New_Password,
                      labelText:
                          S.of(context).changePassPage_Confirm_New_Password,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _changePassword(),
                    ),
                    const Gap(30),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: S.of(context).changePassPage_Change_Password,
                            onPressed: _changePassword,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
