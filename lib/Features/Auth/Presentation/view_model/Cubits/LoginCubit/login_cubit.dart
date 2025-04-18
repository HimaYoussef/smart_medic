// LoginCubit with role validation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../Database/firestoreDB.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;
  final String expectedRole;
  bool isPasswordVisible = false;

  LoginCubit({required this.expectedRole, FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(LoginInitial());

  Future<void> login({required String email, required String pass}) async {
    emit(Loading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(Failed(errorMessage: 'Login failed. User is null.'));
        return;
      }

      await user.reload();
      if (!user.emailVerified) {
        emit(Failed(errorMessage: 'Email not verified yet.'));
        return;
      }

      final userData = await SmartMedicalDb.getUserById(user.uid);

      if (userData == null) {
        emit(Failed(errorMessage: 'User data not found.'));
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
        emit(Failed(errorMessage: 'No user found with this email'));
      } else if (e.code == 'wrong-password') {
        emit(Failed(errorMessage: 'Incorrect password'));
      } else {
        emit(Failed(errorMessage: e.message ?? 'Authentication error'));
      }
    } catch (e) {
      emit(Failed(errorMessage: 'Unexpected error occurred'));
      print("Error: \$e");
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityChanged(isPasswordVisible));
  }
}
