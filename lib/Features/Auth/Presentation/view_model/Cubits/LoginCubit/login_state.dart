part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class Loading extends LoginState {}

class Success extends LoginState {}

class AdminSuccess extends LoginState {}

class Failed extends LoginState {
  final String errorMessage;
  Failed({required this.errorMessage});
}

class PasswordVisibilityChanged extends LoginState {
  final bool isVisible;
  PasswordVisibilityChanged(this.isVisible);
}