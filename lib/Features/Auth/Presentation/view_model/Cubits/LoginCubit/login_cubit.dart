import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;
  bool isPasswordVisible = false;

  LoginCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(LoginInitial());

  Future<bool> _isEmailVerified(User? user) async {
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  Future<void> login({required email,required pass}) async {
    emit(Loading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      bool isVerified = await _isEmailVerified(userCredential.user);
      if (!isVerified) {
        emit(Failed(errorMessage: 'Email not verified yet.'));
      }else {
        emit(Success());
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(Failed(errorMessage: 'No user found with this email'));
      } else if (e.code == 'wrong-password') {
        emit(Failed(errorMessage: 'Incorrect password'));
      }
    }
    catch (e){
      emit(Failed(errorMessage: 'Unexpected error occurred'));
      print("Error: $e");
    } /*finally {
      await Future.delayed(const Duration(seconds: 1));
      emit(LoginInitial());
    }*/
    }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
  }