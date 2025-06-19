import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Services/firebaseServices.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;
  final String expectedRole;
  bool isPasswordVisible = false;

  LoginCubit({required this.expectedRole, FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(LoginInitial());

  String role = "";

  Future<bool> _isEmailVerified(User? user) async {
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  Future<void> login({required String email, required String pass}) async {
    emit(Loading());
    try {
      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final user = userCredential.user;
      if (user == null) {
        emit(Failed(errorMessage: 'User not found after sign-in'));
        return;
      }
      if (!user.emailVerified) {
        emit(Failed(errorMessage: 'Email not verified'));
        return;
      }
      // Success case: email is verified
      emit(Success());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Invalid email or password';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'user-not-found':
          errorMessage = 'User not found';
          break;
        case 'user-disabled':
          errorMessage = 'User account is disabled';
          break;
        default:
          errorMessage = 'Authentication failed';
      }
      emit(Failed(errorMessage: errorMessage));
      log('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      emit(Failed(errorMessage: 'Unexpected error occurred'));
      log('Error: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
}