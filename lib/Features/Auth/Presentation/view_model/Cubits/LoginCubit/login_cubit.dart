import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../Services/firebaseServices.dart';

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
        emit(Failed(errorMessage: 'Something went wrong. Please try again.'));
        return;
      }

      final isVerified = await _isEmailVerified(user);

      if (!isVerified) {
        emit(Failed(errorMessage: 'Email not verified yet'));
        return;
      }

      final userData = await SmartMedicalDb.getUserById(user.uid);

      if (userData == null) {
        emit(Failed(errorMessage: 'User data not found.'));
        return;
      }

      final String role = userData['type'] ?? '';


      if (role == 'Maintainer') {
        emit(AdminSuccess());
      } else {
        emit(Success(userRole: role));
      }

    } on FirebaseAuthException catch (e) {
      print('Firebase error code: ${e.code}');
      if (e.code == 'user-not-found') {
        emit(Failed(errorMessage: 'No user found with this email'));
      } else if (e.code == 'invalid-email') {
        emit(Failed(errorMessage: 'The email address is badly formatted'));
      } else if (e.code == 'invalid-credential') {
        emit(Failed(errorMessage: 'Invalid email or password'));
      } else {
        emit(Failed(errorMessage: 'something wrong. try again'));
      }
    } catch (e) {
      emit(Failed(errorMessage: 'Unexpected error occurred'));
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
}