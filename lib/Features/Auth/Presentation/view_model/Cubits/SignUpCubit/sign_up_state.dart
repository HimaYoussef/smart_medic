  part of 'sign_up_cubit.dart';

  // @immutable
  sealed class SignUpState {}

  final class SignUpInitial extends SignUpState {}
  class SignUpLoading extends SignUpState {}

  class SignUpSuccess extends SignUpState {}

  class SignUpFailure extends SignUpState {
    final String errorMessage;
    SignUpFailure(this.errorMessage);
  }

  class PasswordVisibilityChanged extends SignUpState {
    final bool isPasswordVisible;
    final bool isConfirmPasswordVisible;
    PasswordVisibilityChanged(this.isPasswordVisible, this.isConfirmPasswordVisible);
  }