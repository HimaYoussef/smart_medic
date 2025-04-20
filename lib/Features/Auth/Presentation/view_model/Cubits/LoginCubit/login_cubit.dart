// LoginCubit with role validation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path/path.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../../Database/firestoreDB.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;
  final String expectedRole;
  bool isPasswordVisible = false;

  LoginCubit({required this.expectedRole, FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(LoginInitial());

  Future<void> login({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {    emit(Loading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage1));
        return;
      }

      await user.reload();
      if (!user.emailVerified) {
        emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage2));
        return;
      }

      final userData = await SmartMedicalDb.getUserById(user.uid);

      if (userData == null) {
        emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage3));
        return;
      }

      final actualRole = userData['type'];
      if (actualRole != expectedRole) {
        emit(Failed(errorMessage: 'This email is not registered as $expectedRole.'));
        return;
      }

      emit(Success());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage4));
      } else if (e.code == 'wrong-password') {
        emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage5));
      } else {
  emit(Failed(
            errorMessage:
                e.message ?? S.of(context).login_cubit_errorMessage6));      }
    } catch (e) {
      emit(Failed(errorMessage: S.of(context).login_cubit_errorMessage7));
      print("Error: $e");
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
}
