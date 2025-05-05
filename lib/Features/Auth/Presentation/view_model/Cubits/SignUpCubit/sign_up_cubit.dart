import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
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

   Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String type,
    required BuildContext context,
  }) async {
    emit(SignUpLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User user= userCredential.user!;
      SmartMedicalDb.addUser(userId: user.uid, name: name, type: type, email: email).then((response) {
        print("User added successfully"); // "User added successfully"
      });
      emit(SignUpSuccess());
      await sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignUpFailure('This email already used'));
      } else if (e.code == 'weak-password') {
        emit(SignUpFailure('The password is too weak'));
      }
    } catch (e) {
      emit(SignUpFailure('Unexpected error occurred'));
    } finally{
      await Future.delayed(const Duration(seconds: 1));
      emit(SignUpInitial());
    }
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