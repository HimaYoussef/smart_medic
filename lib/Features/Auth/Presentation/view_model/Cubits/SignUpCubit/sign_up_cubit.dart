import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../Services/firebaseServices.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseAuth _auth;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  SignUpCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(SignUpInitial());

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible, isConfirmPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible, isConfirmPasswordVisible));
  }

   Future<void> signUp({required String name,required String email, required String password,required String type}) async {
    if (name.trim().isEmpty) {
      emit(SignUpFailure('Name cannot be empty'));
      return;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      emit(SignUpFailure('Name must contain only letters and spaces'));
      return;
    }
    final domainValid = await DomainValid(email);
    if (!domainValid) {
      emit(SignUpFailure('Invalid email. please try by valid one'));
      return;
    }
        emit(SignUpLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User user= userCredential.user!;
      final response = await SmartMedicalDb.addUser(userId: user.uid, name: name, type: type, email: email);
      if (!response['success']) {
        emit(SignUpFailure(response['message'] ?? 'Failed to save user data'));
        return;
      }
      emit(SignUpSuccess());
      await sendEmailVerification();
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      String message = switch (e.code) {
        'email-already-in-use' => 'This email already used',
        'weak-password' => 'The password is too weak',
        'invalid-email' => 'Invalid email format',
        'operation-not-allowed' => 'Email/password accounts are not enabled',
        _ => 'Authentication failed: ${e.message}'
      };
      emit(SignUpFailure(message));
    } catch (e) {
      emit(SignUpFailure('Unexpected error occurred. try again'));
  } finally {
      await Future.delayed(const Duration(milliseconds: 100));
      emit(SignUpInitial());
    }
  }
  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Verification email has been sent.');
    } else {
      print('User is already verified or not logged in.');
    }
  }

  Future<bool> DomainValid(String email) async {
    try {
      final domain = email.split('@').last.toLowerCase(); // e.g. gmail.com
      final result = await InternetAddress.lookup(domain);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}


