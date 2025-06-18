import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/Custom_button.dart';
import '../../../../core/utils/Colors.dart';
import '../../../../core/widgets/build_text_field.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added Form key
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void _dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset email sent! Please check your inbox.',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
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
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ),
    );
  }

  // Build background gradient
  Widget _buildBackground() {
    return Column(
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
    );
  }

  // Build main content
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            "Reset Your Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                _buildFormCard(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Remember your password? Sign in now",
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
  }

  // Build form card
  Widget _buildFormCard() {
    return Container(
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
            _buildIcon(),
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
            _buildEmailField(),
            const SizedBox(height: 40),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  // Build icon container
  Widget _buildIcon() {
    return Center(
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
    );
  }

  // Build email input field
  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      readOnly: false,
      validatorText: 'Please enter a valid email',
      labelText: 'Enter your Email',
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => sendPasswordResetEmail(),
    );
  }

  // Build reset button
  Widget _buildResetButton() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomButton(
      text: "Reset",
      onPressed: () => sendPasswordResetEmail(),
    );
  }
}