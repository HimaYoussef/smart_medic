import 'package:email_validator/email_validator.dart';

bool emailValidate(String email) {
  return EmailValidator.validate(email);
}