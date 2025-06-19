part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class Loading extends LoginState {}

final class Success extends LoginState {}

class AdminSuccess extends LoginState {}

final class Failed extends LoginState {
 String errorMessage;
  Failed({required this.errorMessage});
}

class PasswordVisibilityChanged extends LoginState {
  final bool isVisible;
  PasswordVisibilityChanged(this.isVisible);
}