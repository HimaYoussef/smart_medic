/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  login(String email, String password) async {
    emit(LoginLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        User user = credential.user!;
      }
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginErrorState(error: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState(error: 'wrong-password'));
      } else {
        emit(LoginErrorState(error: 'Please try again later'));
      }
    }
  }

  reset(String email,) async {
    emit(LoginLoadingState());
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'verification') {
        emit(LoginErrorState(error: 'verification failed'));
      } else {
        emit(LoginErrorState(error: 'Please try again later'));
      }
    }
  }

  Verify(String email,) async {
    emit(LoginLoadingState());
    try {
      User user = FirebaseAuth.instance.currentUser!;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
              print('Verification email has been sent.');

      }
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'verification') {
        emit(LoginErrorState(error: 'verification failed'));
      } else {
        emit(LoginErrorState(error: 'Please try again later'));
      }
    }
  }

  registerUser(String name, String email, String password, String Confirmpassword) async {
    emit(RegisterLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user!;
      user.updateDisplayName(name);

      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'image': null,
        'email': email,
      }, SetOptions(merge: true));

      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState(error: 'Weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState(error: ' Email already in use'));
      }
    } catch (e) {
      emit(RegisterErrorState(error: 'Please try again'));
    }
  }

  // updateUserData({
  //   required String uid,
  //   required String image,
  //   required String email,
  //   required String phone,
  // }) async {
  //   emit(UpdateLoadingState());
  //   try {
  //     FirebaseFirestore.instance.collection('users').doc(uid).set({
  //       'image': image,
  //       'phone': phone,
  //       'email': email,
  //     }, SetOptions(merge: true));
  //     emit(UpdateSuccessState());
  //   } catch (e) {
  //     emit(UpdateErrorState(error: e.toString()));
  //   }
  // }
}
*/
