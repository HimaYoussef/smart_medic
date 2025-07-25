// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose`
  String get Super_Visor_type_choose {
    return Intl.message(
      'Choose',
      name: 'Super_Visor_type_choose',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get Super_Visor_type_Doctor {
    return Intl.message(
      'Doctor',
      name: 'Super_Visor_type_Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get Super_Visor_type_Family {
    return Intl.message(
      'Family',
      name: 'Super_Visor_type_Family',
      desc: '',
      args: [],
    );
  }

  /// `Neighbor`
  String get Super_Visor_type_Neighbor {
    return Intl.message(
      'Neighbor',
      name: 'Super_Visor_type_Neighbor',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get Login_Head {
    return Intl.message('login', name: 'Login_Head', desc: '', args: []);
  }

  /// `Welcome Back`
  String get Login_Welcome_Back {
    return Intl.message(
      'Welcome Back',
      name: 'Login_Welcome_Back',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email`
  String get Login_Email {
    return Intl.message(
      'Enter your Email',
      name: 'Login_Email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Password`
  String get Login_password {
    return Intl.message(
      'Enter your Password',
      name: 'Login_password',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get Login_SIGN_IN {
    return Intl.message('SIGN IN', name: 'Login_SIGN_IN', desc: '', args: []);
  }

  /// `Please fill in all fields.`
  String get Login_SnackBar {
    return Intl.message(
      'Please fill in all fields.',
      name: 'Login_SnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? SIGN UP`
  String get Login_Dont_have_an_account {
    return Intl.message(
      'Don’t have an account? SIGN UP',
      name: 'Login_Dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Email not verified yet`
  String get Login_Email_not_verified_yet {
    return Intl.message(
      'Email not verified yet',
      name: 'Login_Email_not_verified_yet',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get Login_Resend {
    return Intl.message('Resend', name: 'Login_Resend', desc: '', args: []);
  }

  /// `Verification email resent. Check your inbox.`
  String get Login_Verification_email_resent_Check_your_inbox {
    return Intl.message(
      'Verification email resent. Check your inbox.',
      name: 'Login_Verification_email_resent_Check_your_inbox',
      desc: '',
      args: [],
    );
  }

  /// `Failed to resend verification email`
  String get Login_Failed_to_resend_verification_email {
    return Intl.message(
      'Failed to resend verification email',
      name: 'Login_Failed_to_resend_verification_email',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get Login_Forgot_Password {
    return Intl.message(
      'Forgot Password?',
      name: 'Login_Forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent! Please check your inbox.`
  String get resetPass_Password_reset_email_sent_Please_check_your_inbox {
    return Intl.message(
      'Password reset email sent! Please check your inbox.',
      name: 'resetPass_Password_reset_email_sent_Please_check_your_inbox',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get resetPass_Reset_Your_Password {
    return Intl.message(
      'Reset Your Password',
      name: 'resetPass_Reset_Your_Password',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password? Sign in now`
  String get resetPass_Remember_your_password_Sign_in_now {
    return Intl.message(
      'Remember your password? Sign in now',
      name: 'resetPass_Remember_your_password_Sign_in_now',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get resetPass_Welcome_Back {
    return Intl.message(
      'Welcome Back',
      name: 'resetPass_Welcome_Back',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get resetPass_Please_enter_a_valid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'resetPass_Please_enter_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email`
  String get resetPass_Enter_your_Email {
    return Intl.message(
      'Enter your Email',
      name: 'resetPass_Enter_your_Email',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetPass_Reset {
    return Intl.message('Reset', name: 'resetPass_Reset', desc: '', args: []);
  }

  /// `Account created successfully!`
  String get signUp_SnackBar {
    return Intl.message(
      'Account created successfully!',
      name: 'signUp_SnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp_Head {
    return Intl.message('Sign Up', name: 'signUp_Head', desc: '', args: []);
  }

  /// `Hello`
  String get signUp_Hello {
    return Intl.message('Hello', name: 'signUp_Hello', desc: '', args: []);
  }

  /// `Enter your Name`
  String get signUp_Name {
    return Intl.message(
      'Enter your Name',
      name: 'signUp_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email`
  String get signUp_Email {
    return Intl.message(
      'Enter your Email',
      name: 'signUp_Email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Password`
  String get signUp_password {
    return Intl.message(
      'Enter your Password',
      name: 'signUp_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your Password`
  String get signUp_Confirm_Password {
    return Intl.message(
      'Confirm your Password',
      name: 'signUp_Confirm_Password',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get signUp_SIGN_UP {
    return Intl.message('SIGN UP', name: 'signUp_SIGN_UP', desc: '', args: []);
  }

  /// `Please continue...`
  String get signUp_SnackBar_Please_Continue {
    return Intl.message(
      'Please continue...',
      name: 'signUp_SnackBar_Please_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get signUp_Please_enter_a_valid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'signUp_Please_enter_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get signUp_Passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'signUp_Passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? SIGN IN`
  String get signUp_Already_have_an_account_SIGN_IN {
    return Intl.message(
      'Already have an account? SIGN IN',
      name: 'signUp_Already_have_an_account_SIGN_IN',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. User is null.`
  String get login_cubit_errorMessage1 {
    return Intl.message(
      'Login failed. User is null.',
      name: 'login_cubit_errorMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Email not verified yet.`
  String get login_cubit_errorMessage2 {
    return Intl.message(
      'Email not verified yet.',
      name: 'login_cubit_errorMessage2',
      desc: '',
      args: [],
    );
  }

  /// `User data not found.`
  String get login_cubit_errorMessage3 {
    return Intl.message(
      'User data not found.',
      name: 'login_cubit_errorMessage3',
      desc: '',
      args: [],
    );
  }

  /// `No user found with this email`
  String get login_cubit_errorMessage4 {
    return Intl.message(
      'No user found with this email',
      name: 'login_cubit_errorMessage4',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get login_cubit_errorMessage5 {
    return Intl.message(
      'Incorrect password',
      name: 'login_cubit_errorMessage5',
      desc: '',
      args: [],
    );
  }

  /// `Authentication error`
  String get login_cubit_errorMessage6 {
    return Intl.message(
      'Authentication error',
      name: 'login_cubit_errorMessage6',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred`
  String get login_cubit_errorMessage7 {
    return Intl.message(
      'Unexpected error occurred',
      name: 'login_cubit_errorMessage7',
      desc: '',
      args: [],
    );
  }

  /// `This email already used`
  String get sign_up_cubit_SignUpFailure1 {
    return Intl.message(
      'This email already used',
      name: 'sign_up_cubit_SignUpFailure1',
      desc: '',
      args: [],
    );
  }

  /// `The password is too weak`
  String get sign_up_cubit_SignUpFailure2 {
    return Intl.message(
      'The password is too weak',
      name: 'sign_up_cubit_SignUpFailure2',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred`
  String get sign_up_cubit_SignUpFailure3 {
    return Intl.message(
      'Unexpected error occurred',
      name: 'sign_up_cubit_SignUpFailure3',
      desc: '',
      args: [],
    );
  }

  /// `Verification email has been sent`
  String get sign_up_cubit_EmailVerification1 {
    return Intl.message(
      'Verification email has been sent',
      name: 'sign_up_cubit_EmailVerification1',
      desc: '',
      args: [],
    );
  }

  /// `User is already verified or not logged in`
  String get sign_up_cubit_EmailVerification2 {
    return Intl.message(
      'User is already verified or not logged in',
      name: 'sign_up_cubit_EmailVerification2',
      desc: '',
      args: [],
    );
  }

  /// `Continue As..`
  String get Role_Selection_Head {
    return Intl.message(
      'Continue As..',
      name: 'Role_Selection_Head',
      desc: '',
      args: [],
    );
  }

  /// `Patient`
  String get Role_Selection_patient {
    return Intl.message(
      'Patient',
      name: 'Role_Selection_patient',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor`
  String get Role_Selection_Supervisor {
    return Intl.message(
      'Supervisor',
      name: 'Role_Selection_Supervisor',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Role_Selection_Next {
    return Intl.message(
      'Next',
      name: 'Role_Selection_Next',
      desc: '',
      args: [],
    );
  }

  /// `This is the Home tab to manage your medications.`
  String get Nav_bar_Home {
    return Intl.message(
      'This is the Home tab to manage your medications.',
      name: 'Nav_bar_Home',
      desc: '',
      args: [],
    );
  }

  /// `View your medication logs here.`
  String get Nav_bar_Logs {
    return Intl.message(
      'View your medication logs here.',
      name: 'Nav_bar_Logs',
      desc: '',
      args: [],
    );
  }

  /// `Access health awareness content here.`
  String get Nav_bar_Awar {
    return Intl.message(
      'Access health awareness content here.',
      name: 'Nav_bar_Awar',
      desc: '',
      args: [],
    );
  }

  /// `Manage your profile settings here.`
  String get Nav_bar_Profile {
    return Intl.message(
      'Manage your profile settings here.',
      name: 'Nav_bar_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Pills`
  String get Add_New_Medicine_Pills {
    return Intl.message(
      'Pills',
      name: 'Add_New_Medicine_Pills',
      desc: '',
      args: [],
    );
  }

  /// `Add Time`
  String get Add_New_Medicine_Add_Time {
    return Intl.message(
      'Add Time',
      name: 'Add_New_Medicine_Add_Time',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth not connected. Data will be sent later.`
  String get Add_New_Medicine_Bluetooth_not_connected_Data_will_be_sent_later {
    return Intl.message(
      'Bluetooth not connected. Data will be sent later.',
      name: 'Add_New_Medicine_Bluetooth_not_connected_Data_will_be_sent_later',
      desc: '',
      args: [],
    );
  }

  /// `Add New Medicine`
  String get Add_New_Medicine_Head {
    return Intl.message(
      'Add New Medicine',
      name: 'Add_New_Medicine_Head',
      desc: '',
      args: [],
    );
  }

  /// `Compartment Number`
  String get Add_New_Medicine_Compartment_Number {
    return Intl.message(
      'Compartment Number',
      name: 'Add_New_Medicine_Compartment_Number',
      desc: '',
      args: [],
    );
  }

  /// `Medicine Name`
  String get Add_New_Medicine_Med_Name {
    return Intl.message(
      'Medicine Name',
      name: 'Add_New_Medicine_Med_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter medicine name`
  String get Add_New_Medicine_labelText1 {
    return Intl.message(
      'Enter medicine name',
      name: 'Add_New_Medicine_labelText1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a medicine name`
  String get Add_New_Medicine_validatorText1 {
    return Intl.message(
      'Please enter a medicine name',
      name: 'Add_New_Medicine_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Number of pills`
  String get Add_New_Medicine_labelText2 {
    return Intl.message(
      'Number of pills',
      name: 'Add_New_Medicine_labelText2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter number of pills`
  String get Add_New_Medicine_validatorText2 {
    return Intl.message(
      'Please enter number of pills',
      name: 'Add_New_Medicine_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Dosage`
  String get Add_New_Medicine_Dosage {
    return Intl.message(
      'Dosage',
      name: 'Add_New_Medicine_Dosage',
      desc: '',
      args: [],
    );
  }

  /// `Enter dosage`
  String get Add_New_Medicine_labelText3 {
    return Intl.message(
      'Enter dosage',
      name: 'Add_New_Medicine_labelText3',
      desc: '',
      args: [],
    );
  }

  /// `Please enter dosage`
  String get Add_New_Medicine_validatorText3 {
    return Intl.message(
      'Please enter dosage',
      name: 'Add_New_Medicine_validatorText3',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Type`
  String get Add_New_Medicine_Schedule_Type {
    return Intl.message(
      'Schedule Type',
      name: 'Add_New_Medicine_Schedule_Type',
      desc: '',
      args: [],
    );
  }

  /// `Select Schedule Type`
  String get Add_New_Medicine_Select_Type {
    return Intl.message(
      'Select Schedule Type',
      name: 'Add_New_Medicine_Select_Type',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get Add_New_Medicine_Daily {
    return Intl.message(
      'Daily',
      name: 'Add_New_Medicine_Daily',
      desc: '',
      args: [],
    );
  }

  /// `Every X Days`
  String get Add_New_Medicine_Every_X_Days {
    return Intl.message(
      'Every X Days',
      name: 'Add_New_Medicine_Every_X_Days',
      desc: '',
      args: [],
    );
  }

  /// `Specific Days`
  String get Add_New_Medicine_Specific_Days {
    return Intl.message(
      'Specific Days',
      name: 'Add_New_Medicine_Specific_Days',
      desc: '',
      args: [],
    );
  }

  /// `How many times per day?`
  String get Add_New_Medicine_How_many_times_per_day {
    return Intl.message(
      'How many times per day?',
      name: 'Add_New_Medicine_How_many_times_per_day',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of times`
  String get Add_New_Medicine_labelText4 {
    return Intl.message(
      'Enter number of times',
      name: 'Add_New_Medicine_labelText4',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a number between 1 and 4`
  String get Add_New_Medicine_validatorText4 {
    return Intl.message(
      'Please enter a number between 1 and 4',
      name: 'Add_New_Medicine_validatorText4',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a number between 1 and 4`
  String get Add_New_Medicine_SnackBar {
    return Intl.message(
      'Please enter a number between 1 and 4',
      name: 'Add_New_Medicine_SnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Every how many days?`
  String get Add_New_Medicine_Every_how_many_days {
    return Intl.message(
      'Every how many days?',
      name: 'Add_New_Medicine_Every_how_many_days',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of days`
  String get Add_New_Medicine_labelText5 {
    return Intl.message(
      'Enter number of days',
      name: 'Add_New_Medicine_labelText5',
      desc: '',
      args: [],
    );
  }

  /// `Please enter number of days`
  String get Add_New_Medicine_validatorText5 {
    return Intl.message(
      'Please enter number of days',
      name: 'Add_New_Medicine_validatorText5',
      desc: '',
      args: [],
    );
  }

  /// `Select Specific Days`
  String get Add_New_Medicine_Select_Specific_Days {
    return Intl.message(
      'Select Specific Days',
      name: 'Add_New_Medicine_Select_Specific_Days',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Add_New_Medicine_Submit {
    return Intl.message(
      'Submit',
      name: 'Add_New_Medicine_Submit',
      desc: '',
      args: [],
    );
  }

  /// `Please select a schedule type`
  String get Add_New_Medicine_Please_select_a_schedule_type {
    return Intl.message(
      'Please select a schedule type',
      name: 'Add_New_Medicine_Please_select_a_schedule_type',
      desc: '',
      args: [],
    );
  }

  /// `Please select all times for daily schedule`
  String get Add_New_Medicine_Please_select_all_times_for_daily_schedule {
    return Intl.message(
      'Please select all times for daily schedule',
      name: 'Add_New_Medicine_Please_select_all_times_for_daily_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time for every X days schedule`
  String get Add_New_Medicine_Please_select_a_time_for_every_X_days_schedule {
    return Intl.message(
      'Please select a time for every X days schedule',
      name: 'Add_New_Medicine_Please_select_a_time_for_every_X_days_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one day for specific days schedule`
  String
  get Add_New_Medicine_Please_select_at_least_one_day_for_specific_days_schedule {
    return Intl.message(
      'Please select at least one day for specific days schedule',
      name:
          'Add_New_Medicine_Please_select_at_least_one_day_for_specific_days_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time for specific days schedule`
  String get Add_New_Medicine_Please_select_a_time_for_specific_days_schedule {
    return Intl.message(
      'Please select a time for specific days schedule',
      name: 'Add_New_Medicine_Please_select_a_time_for_specific_days_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Select an Option`
  String get Add_New_Medicine_Select_Option {
    return Intl.message(
      'Select an Option',
      name: 'Add_New_Medicine_Select_Option',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get Add_New_Medicine_Take_Photo {
    return Intl.message(
      'Take Photo',
      name: 'Add_New_Medicine_Take_Photo',
      desc: '',
      args: [],
    );
  }

  /// `Pick from Gallery`
  String get Add_New_Medicine_Pick_From_Gallery {
    return Intl.message(
      'Pick from Gallery',
      name: 'Add_New_Medicine_Pick_From_Gallery',
      desc: '',
      args: [],
    );
  }

  /// `Analyze Medicine Name`
  String get Add_New_Medicine_Analyze_Name {
    return Intl.message(
      'Analyze Medicine Name',
      name: 'Add_New_Medicine_Analyze_Name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a medicine name`
  String get Add_New_Medicine_Please_Enter_Medicine_Name {
    return Intl.message(
      'Please enter a medicine name',
      name: 'Add_New_Medicine_Please_Enter_Medicine_Name',
      desc: '',
      args: [],
    );
  }

  /// `Analyze Medicine`
  String get Add_New_Medicine_Analyze_Options {
    return Intl.message(
      'Analyze Medicine',
      name: 'Add_New_Medicine_Analyze_Options',
      desc: '',
      args: [],
    );
  }

  /// `Add Time`
  String get Add_New_Medicine_AddTime {
    return Intl.message(
      'Add Time',
      name: 'Add_New_Medicine_AddTime',
      desc: '',
      args: [],
    );
  }

  /// `Change Time`
  String get Add_New_Medicine_ChangeTime {
    return Intl.message(
      'Change Time',
      name: 'Add_New_Medicine_ChangeTime',
      desc: '',
      args: [],
    );
  }

  /// `Add Another Time`
  String get Add_New_Medicine_Add_AnotherTime {
    return Intl.message(
      'Add Another Time',
      name: 'Add_New_Medicine_Add_AnotherTime',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Result`
  String get Add_New_Medicine_Analysis_Result {
    return Intl.message(
      'Analysis Result',
      name: 'Add_New_Medicine_Analysis_Result',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get Add_New_Medicine_OK {
    return Intl.message('OK', name: 'Add_New_Medicine_OK', desc: '', args: []);
  }

  /// `Error`
  String get Add_New_Medicine_Error {
    return Intl.message(
      'Error',
      name: 'Add_New_Medicine_Error',
      desc: '',
      args: [],
    );
  }

  /// `Please select a schedule type`
  String get EditMedicine_Please_select_a_schedule_type {
    return Intl.message(
      'Please select a schedule type',
      name: 'EditMedicine_Please_select_a_schedule_type',
      desc: '',
      args: [],
    );
  }

  /// `Please select all times for daily schedule`
  String get EditMedicine_Please_select_all_times_for_daily_schedule {
    return Intl.message(
      'Please select all times for daily schedule',
      name: 'EditMedicine_Please_select_all_times_for_daily_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time for every X days schedule`
  String get EditMedicine_Please_select_a_time_for_every_X_days_schedule {
    return Intl.message(
      'Please select a time for every X days schedule',
      name: 'EditMedicine_Please_select_a_time_for_every_X_days_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one day for specific days schedule`
  String
  get EditMedicine_Please_select_at_least_one_day_for_specific_days_schedule {
    return Intl.message(
      'Please select at least one day for specific days schedule',
      name:
          'EditMedicine_Please_select_at_least_one_day_for_specific_days_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Edit Medicine`
  String get EditMedicine_Edit_Medicine {
    return Intl.message(
      'Edit Medicine',
      name: 'EditMedicine_Edit_Medicine',
      desc: '',
      args: [],
    );
  }

  /// `Compartment Number`
  String get EditMedicine_Compartment_Number {
    return Intl.message(
      'Compartment Number',
      name: 'EditMedicine_Compartment_Number',
      desc: '',
      args: [],
    );
  }

  /// `Med Name`
  String get EditMedicine_Med_Name {
    return Intl.message(
      'Med Name',
      name: 'EditMedicine_Med_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name of the Medicine`
  String get EditMedicine_labelText1 {
    return Intl.message(
      'Enter the name of the Medicine',
      name: 'EditMedicine_labelText1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the name of the medicine`
  String get EditMedicine_validatorText1 {
    return Intl.message(
      'Please enter the name of the medicine',
      name: 'EditMedicine_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Pills`
  String get EditMedicine_Pills {
    return Intl.message(
      'Pills',
      name: 'EditMedicine_Pills',
      desc: '',
      args: [],
    );
  }

  /// `Enter the number of pills added`
  String get EditMedicine_labelText2 {
    return Intl.message(
      'Enter the number of pills added',
      name: 'EditMedicine_labelText2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of pills`
  String get EditMedicine_validatorText2 {
    return Intl.message(
      'Please enter the number of pills',
      name: 'EditMedicine_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Dosage`
  String get EditMedicine_Dosage {
    return Intl.message(
      'Dosage',
      name: 'EditMedicine_Dosage',
      desc: '',
      args: [],
    );
  }

  /// `Enter the number of pills every time`
  String get EditMedicine_labelText3 {
    return Intl.message(
      'Enter the number of pills every time',
      name: 'EditMedicine_labelText3',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of the pills`
  String get EditMedicine_validatorText3 {
    return Intl.message(
      'Please enter the number of the pills',
      name: 'EditMedicine_validatorText3',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Type`
  String get EditMedicine_Schedule_Type {
    return Intl.message(
      'Schedule Type',
      name: 'EditMedicine_Schedule_Type',
      desc: '',
      args: [],
    );
  }

  /// `How many times per day?`
  String get EditMedicine_How_many_times_per_day {
    return Intl.message(
      'How many times per day?',
      name: 'EditMedicine_How_many_times_per_day',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of times per day`
  String get EditMedicine_labelText4 {
    return Intl.message(
      'Enter number of times per day',
      name: 'EditMedicine_labelText4',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of the times`
  String get EditMedicine_validatorText4 {
    return Intl.message(
      'Please enter the number of the times',
      name: 'EditMedicine_validatorText4',
      desc: '',
      args: [],
    );
  }

  /// `Number of times must be between 1 and 4`
  String get EditMedicine_SnackBar {
    return Intl.message(
      'Number of times must be between 1 and 4',
      name: 'EditMedicine_SnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Add Time`
  String get EditMedicine_Add_Time {
    return Intl.message(
      'Add Time',
      name: 'EditMedicine_Add_Time',
      desc: '',
      args: [],
    );
  }

  /// `Every how many days`
  String get EditMedicine_Every_how_many_days {
    return Intl.message(
      'Every how many days',
      name: 'EditMedicine_Every_how_many_days',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of days`
  String get EditMedicine_labelText5 {
    return Intl.message(
      'Enter number of days',
      name: 'EditMedicine_labelText5',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of the days`
  String get EditMedicine_validatorText5 {
    return Intl.message(
      'Please enter the number of the days',
      name: 'EditMedicine_validatorText5',
      desc: '',
      args: [],
    );
  }

  /// `Select Specific Days`
  String get EditMedicine_Select_Specific_Days {
    return Intl.message(
      'Select Specific Days',
      name: 'EditMedicine_Select_Specific_Days',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get EditMedicine_Update {
    return Intl.message(
      'Update',
      name: 'EditMedicine_Update',
      desc: '',
      args: [],
    );
  }

  /// `Select Type`
  String get EditMedicine_Select_Type {
    return Intl.message(
      'Select Type',
      name: 'EditMedicine_Select_Type',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get EditMedicine_Daily {
    return Intl.message(
      'Daily',
      name: 'EditMedicine_Daily',
      desc: '',
      args: [],
    );
  }

  /// `Every X Days`
  String get EditMedicine_Every_X_Days {
    return Intl.message(
      'Every X Days',
      name: 'EditMedicine_Every_X_Days',
      desc: '',
      args: [],
    );
  }

  /// `Specific Days`
  String get EditMedicine_Specific_Days {
    return Intl.message(
      'Specific Days',
      name: 'EditMedicine_Specific_Days',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth not connected. Data will be sent later.`
  String get EditMedicine_Bluetooth_not_connected_Data_will_be_sent_later {
    return Intl.message(
      'Bluetooth not connected. Data will be sent later.',
      name: 'EditMedicine_Bluetooth_not_connected_Data_will_be_sent_later',
      desc: '',
      args: [],
    );
  }

  /// `Refill Medicine`
  String get Refill_Medicine_Head {
    return Intl.message(
      'Refill Medicine',
      name: 'Refill_Medicine_Head',
      desc: '',
      args: [],
    );
  }

  /// `Num of Pills`
  String get Refill_Medicine_Num_of_Pills {
    return Intl.message(
      'Num of Pills',
      name: 'Refill_Medicine_Num_of_Pills',
      desc: '',
      args: [],
    );
  }

  /// `Enter The Num of pills added`
  String get Refill_Medicine_Enter_The_Num_of_pills_added {
    return Intl.message(
      'Enter The Num of pills added',
      name: 'Refill_Medicine_Enter_The_Num_of_pills_added',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of pills`
  String get Refill_Medicine_Please_enter_the_number_of_pills {
    return Intl.message(
      'Please enter the number of pills',
      name: 'Refill_Medicine_Please_enter_the_number_of_pills',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Patient_Main_view_Home {
    return Intl.message(
      'Home',
      name: 'Patient_Main_view_Home',
      desc: '',
      args: [],
    );
  }

  /// `Error loading medications`
  String get Patient_Main_view_Error_loading_medications {
    return Intl.message(
      'Error loading medications',
      name: 'Patient_Main_view_Error_loading_medications',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to add a medication`
  String get Patient_Main_view_Empty_Icon {
    return Intl.message(
      'Tap here to add a medication',
      name: 'Patient_Main_view_Empty_Icon',
      desc: '',
      args: [],
    );
  }

  /// `Awareness`
  String get Awareness_view_Awareness {
    return Intl.message(
      'Awareness',
      name: 'Awareness_view_Awareness',
      desc: '',
      args: [],
    );
  }

  /// `Mental Health`
  String get Awareness_view_title1 {
    return Intl.message(
      'Mental Health',
      name: 'Awareness_view_title1',
      desc: '',
      args: [],
    );
  }

  /// `During the COVID-19 pandemic, young people experienced spikes in mental health difficulties, with girls taking a harder hit.`
  String get Awareness_view_description1 {
    return Intl.message(
      'During the COVID-19 pandemic, young people experienced spikes in mental health difficulties, with girls taking a harder hit.',
      name: 'Awareness_view_description1',
      desc: '',
      args: [],
    );
  }

  /// `Daily Calorie`
  String get Awareness_view_title2 {
    return Intl.message(
      'Daily Calorie',
      name: 'Awareness_view_title2',
      desc: '',
      args: [],
    );
  }

  /// `Whether you're trying to lose weight, gain weight, or stick to your current weight, it's important to know how many calories you need to eat each day.`
  String get Awareness_view_description2 {
    return Intl.message(
      'Whether you\'re trying to lose weight, gain weight, or stick to your current weight, it\'s important to know how many calories you need to eat each day.',
      name: 'Awareness_view_description2',
      desc: '',
      args: [],
    );
  }

  /// `Always Finish Your Antibiotics—Even If You Feel Better`
  String get Awareness_view_title3 {
    return Intl.message(
      'Always Finish Your Antibiotics—Even If You Feel Better',
      name: 'Awareness_view_title3',
      desc: '',
      args: [],
    );
  }

  /// `If your doctor gives you antibiotics, it’s important to finish the full course. Even if you feel better after a few days, stopping early can cause the infection to return—stronger than before. Your smart box keeps track of how many days are left and reminds you until the last pill. It’s a simple way to protect yourself from future illness. Let’s treat the infection right the first time.`
  String get Awareness_view_description3 {
    return Intl.message(
      'If your doctor gives you antibiotics, it’s important to finish the full course. Even if you feel better after a few days, stopping early can cause the infection to return—stronger than before. Your smart box keeps track of how many days are left and reminds you until the last pill. It’s a simple way to protect yourself from future illness. Let’s treat the infection right the first time.',
      name: 'Awareness_view_description3',
      desc: '',
      args: [],
    );
  }

  /// `Are You Taking Multiple Medications? Stay Safe`
  String get Awareness_view_title4 {
    return Intl.message(
      'Are You Taking Multiple Medications? Stay Safe',
      name: 'Awareness_view_title4',
      desc: '',
      args: [],
    );
  }

  /// `Many older adults take more than one medicine a day—and that’s okay, but it needs care. Some pills don’t mix well together. Your smart medical box and app help organize everything so you take the right pills at the right time. If anything ever feels off, always call your doctor. Staying informed is one of the best ways to stay healthy.`
  String get Awareness_view_description4 {
    return Intl.message(
      'Many older adults take more than one medicine a day—and that’s okay, but it needs care. Some pills don’t mix well together. Your smart medical box and app help organize everything so you take the right pills at the right time. If anything ever feels off, always call your doctor. Staying informed is one of the best ways to stay healthy.',
      name: 'Awareness_view_description4',
      desc: '',
      args: [],
    );
  }

  /// `Why It’s Important to Take Your Medicine on Time`
  String get Awareness_view_title5 {
    return Intl.message(
      'Why It’s Important to Take Your Medicine on Time',
      name: 'Awareness_view_title5',
      desc: '',
      args: [],
    );
  }

  /// `Your medicine works best when taken at the right time every day. Missing a dose can make it harder to manage conditions like high blood pressure or diabetes. That’s why your smart medical box gives you friendly reminders. It helps you stay safe and keeps your health on the right track. Trust the system—it’s here to support you.`
  String get Awareness_view_description5 {
    return Intl.message(
      'Your medicine works best when taken at the right time every day. Missing a dose can make it harder to manage conditions like high blood pressure or diabetes. That’s why your smart medical box gives you friendly reminders. It helps you stay safe and keeps your health on the right track. Trust the system—it’s here to support you.',
      name: 'Awareness_view_description5',
      desc: '',
      args: [],
    );
  }

  /// `What Happens If You Skip a Dose?`
  String get Awareness_view_title6 {
    return Intl.message(
      'What Happens If You Skip a Dose?',
      name: 'Awareness_view_title6',
      desc: '',
      args: [],
    );
  }

  /// `Sometimes we forget to take a pill, but skipping medicine can be risky. It may cause problems like dizziness, high sugar levels, or breathing trouble—depending on your condition. That’s why your smart box alerts you gently, so you never miss an important dose. Following your medication plan can keep you out of the hospital and feeling better every day. One small habit can protect your whole body.`
  String get Awareness_view_description6 {
    return Intl.message(
      'Sometimes we forget to take a pill, but skipping medicine can be risky. It may cause problems like dizziness, high sugar levels, or breathing trouble—depending on your condition. That’s why your smart box alerts you gently, so you never miss an important dose. Following your medication plan can keep you out of the hospital and feeling better every day. One small habit can protect your whole body.',
      name: 'Awareness_view_description6',
      desc: '',
      args: [],
    );
  }

  /// `Easy Ways to Remember Your Pills`
  String get Awareness_view_title7 {
    return Intl.message(
      'Easy Ways to Remember Your Pills',
      name: 'Awareness_view_title7',
      desc: '',
      args: [],
    );
  }

  /// `We all forget things from time to time. That’s why your smart medical box is designed to make life easier. It lights up, makes a sound, and even sends a message to your phone when it’s time for your medicine. No need to memorize anything—just follow the gentle alert. Let the technology take care of remembering, so you can focus on living well.`
  String get Awareness_view_description7 {
    return Intl.message(
      'We all forget things from time to time. That’s why your smart medical box is designed to make life easier. It lights up, makes a sound, and even sends a message to your phone when it’s time for your medicine. No need to memorize anything—just follow the gentle alert. Let the technology take care of remembering, so you can focus on living well.',
      name: 'Awareness_view_description7',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get Patient_Logs_View_logs {
    return Intl.message(
      'Logs',
      name: 'Patient_Logs_View_logs',
      desc: '',
      args: [],
    );
  }

  /// `Error loading logs`
  String get Patient_Logs_View_Error_loading_logs {
    return Intl.message(
      'Error loading logs',
      name: 'Patient_Logs_View_Error_loading_logs',
      desc: '',
      args: [],
    );
  }

  /// `No logs available`
  String get Patient_Logs_View_No_logs_available {
    return Intl.message(
      'No logs available',
      name: 'Patient_Logs_View_No_logs_available',
      desc: '',
      args: [],
    );
  }

  /// `No valid logs available`
  String get Patient_Logs_View_No_valid_logs_available {
    return Intl.message(
      'No valid logs available',
      name: 'Patient_Logs_View_No_valid_logs_available',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get ImagePreviewScreen_Profile_Image {
    return Intl.message(
      'Profile Image',
      name: 'ImagePreviewScreen_Profile_Image',
      desc: '',
      args: [],
    );
  }

  /// `Error loading image`
  String get ImagePreviewScreen_Error_loading_image {
    return Intl.message(
      'Error loading image',
      name: 'ImagePreviewScreen_Error_loading_image',
      desc: '',
      args: [],
    );
  }

  /// `Supervisors`
  String get Supervision_view_Head {
    return Intl.message(
      'Supervisors',
      name: 'Supervision_view_Head',
      desc: '',
      args: [],
    );
  }

  /// `Error loading supervisors`
  String get Supervision_view_Error_loading_supervisors {
    return Intl.message(
      'Error loading supervisors',
      name: 'Supervision_view_Error_loading_supervisors',
      desc: '',
      args: [],
    );
  }

  /// `No supervisors found`
  String get Supervision_view_No_supervisors_found {
    return Intl.message(
      'No supervisors found',
      name: 'Supervision_view_No_supervisors_found',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to add a new supervisor`
  String get Supervision_view_Add_Supervisor {
    return Intl.message(
      'Tap here to add a new supervisor',
      name: 'Supervision_view_Add_Supervisor',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Patient_Profile_view_Profile {
    return Intl.message(
      'Profile',
      name: 'Patient_Profile_view_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to view your profile`
  String get Patient_Profile_view_Please_log_in_to_view_your_profile {
    return Intl.message(
      'Please log in to view your profile',
      name: 'Patient_Profile_view_Please_log_in_to_view_your_profile',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get Patient_Profile_view_Dark_Mode {
    return Intl.message(
      'Dark Mode',
      name: 'Patient_Profile_view_Dark_Mode',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor`
  String get Patient_Profile_view_Supervisor {
    return Intl.message(
      'Supervisor',
      name: 'Patient_Profile_view_Supervisor',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get Patient_Profile_view_Change_Language {
    return Intl.message(
      'Change Language',
      name: 'Patient_Profile_view_Change_Language',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get Patient_Profile_view_Log_out {
    return Intl.message(
      'Log out',
      name: 'Patient_Profile_view_Log_out',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get Patient_Profile_view_Rewards {
    return Intl.message(
      'Rewards',
      name: 'Patient_Profile_view_Rewards',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Edit Your Profile`
  String get Patient_Profile_view_Tap_here_to_edit_your_profile_information {
    return Intl.message(
      'Click Here To Edit Your Profile',
      name: 'Patient_Profile_view_Tap_here_to_edit_your_profile_information',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Toggle Between Dark & Light Mode`
  String get Patient_Profile_view_Toggle_between_light_and_dark_themes {
    return Intl.message(
      'Click Here To Toggle Between Dark & Light Mode',
      name: 'Patient_Profile_view_Toggle_between_light_and_dark_themes',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Add Your Supervisor`
  String get Patient_Profile_view_View_or_manage_your_supervisors {
    return Intl.message(
      'Click Here To Add Your Supervisor',
      name: 'Patient_Profile_view_View_or_manage_your_supervisors',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Change Your Language`
  String get Patient_Profile_view_Switch_between_languages {
    return Intl.message(
      'Click Here To Change Your Language',
      name: 'Patient_Profile_view_Switch_between_languages',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Log out From Your Acoount`
  String get Patient_Profile_view_Sign_out_of_your_account {
    return Intl.message(
      'Click Here To Log out From Your Acoount',
      name: 'Patient_Profile_view_Sign_out_of_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To See Review your Progress`
  String get Patient_Profile_view_reward {
    return Intl.message(
      'Click Here To See Review your Progress',
      name: 'Patient_Profile_view_reward',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get Patient_Profile_view_Change_password {
    return Intl.message(
      'Change Password',
      name: 'Patient_Profile_view_Change_password',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewardsView_Rewards {
    return Intl.message(
      'Rewards',
      name: 'rewardsView_Rewards',
      desc: '',
      args: [],
    );
  }

  /// `Error loading Rewards`
  String get rewardsView_Error_loading_Rewards {
    return Intl.message(
      'Error loading Rewards',
      name: 'rewardsView_Error_loading_Rewards',
      desc: '',
      args: [],
    );
  }

  /// `your streak`
  String get rewardsView_your_streak {
    return Intl.message(
      'your streak',
      name: 'rewardsView_your_streak',
      desc: '',
      args: [],
    );
  }

  /// `No rewards available`
  String get rewardsView_No_rewards_available {
    return Intl.message(
      'No rewards available',
      name: 'rewardsView_No_rewards_available',
      desc: '',
      args: [],
    );
  }

  /// `Rewards has been used`
  String get rewardsView_Rewards_has_been_used {
    return Intl.message(
      'Rewards has been used',
      name: 'rewardsView_Rewards_has_been_used',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get rewardsView_Use {
    return Intl.message('Use', name: 'rewardsView_Use', desc: '', args: []);
  }

  /// `Click Here To Display The Supervisors in the System`
  String get Admin_Profile_Supervisor_Data {
    return Intl.message(
      'Click Here To Display The Supervisors in the System',
      name: 'Admin_Profile_Supervisor_Data',
      desc: '',
      args: [],
    );
  }

  /// `Click Here To Display The Patient in the System`
  String get Admin_Profile_Patient_Data {
    return Intl.message(
      'Click Here To Display The Patient in the System',
      name: 'Admin_Profile_Patient_Data',
      desc: '',
      args: [],
    );
  }

  /// `Patients Data`
  String get Admin_Profile_Patient_Data_Display {
    return Intl.message(
      'Patients Data',
      name: 'Admin_Profile_Patient_Data_Display',
      desc: '',
      args: [],
    );
  }

  /// `Supervisors Data`
  String get Admin_Profile_Supervisor_Data_Display {
    return Intl.message(
      'Supervisors Data',
      name: 'Admin_Profile_Supervisor_Data_Display',
      desc: '',
      args: [],
    );
  }

  /// `Change Password `
  String get Admin_Profile_Change_Password {
    return Intl.message(
      'Change Password ',
      name: 'Admin_Profile_Change_Password',
      desc: '',
      args: [],
    );
  }

  /// `No patients found.`
  String get Patient_Data_No_patients_found {
    return Intl.message(
      'No patients found.',
      name: 'Patient_Data_No_patients_found',
      desc: '',
      args: [],
    );
  }

  /// `No supervisors found.`
  String get Superviosr_Data_No_supervisors_found {
    return Intl.message(
      'No supervisors found.',
      name: 'Superviosr_Data_No_supervisors_found',
      desc: '',
      args: [],
    );
  }

  /// `Add Supervisor`
  String get Add_Supervisor_Add_Supervisor {
    return Intl.message(
      'Add Supervisor',
      name: 'Add_Supervisor_Add_Supervisor',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Add_Supervisor_Name {
    return Intl.message(
      'Name',
      name: 'Add_Supervisor_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter The name of the Supervisor`
  String get Add_Supervisor_labelText1 {
    return Intl.message(
      'Enter The name of the Supervisor',
      name: 'Add_Supervisor_labelText1',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter The name of the Supervisor`
  String get Add_Supervisor_validatorText1 {
    return Intl.message(
      'Please Enter The name of the Supervisor',
      name: 'Add_Supervisor_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Add_Supervisor_Email {
    return Intl.message(
      'Email',
      name: 'Add_Supervisor_Email',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter the Email of the Supervisor`
  String get Add_Supervisor_validatorText2 {
    return Intl.message(
      'Please Enter the Email of the Supervisor',
      name: 'Add_Supervisor_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Enter The Email of the Supervisor`
  String get Add_Supervisor_labelText2 {
    return Intl.message(
      'Enter The Email of the Supervisor',
      name: 'Add_Supervisor_labelText2',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor type`
  String get Add_Supervisor_Supervisor_type {
    return Intl.message(
      'Supervisor type',
      name: 'Add_Supervisor_Supervisor_type',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get Add_Supervisor_Supervisor_Add {
    return Intl.message(
      'Add',
      name: 'Add_Supervisor_Supervisor_Add',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get Add_Supervisor_Choose {
    return Intl.message(
      'Choose',
      name: 'Add_Supervisor_Choose',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid Supervisor type`
  String get Add_Supervisor_Please_select_a_valid_Supervisor_type {
    return Intl.message(
      'Please select a valid Supervisor type',
      name: 'Add_Supervisor_Please_select_a_valid_Supervisor_type',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get Edit_Profile_Head {
    return Intl.message(
      'Edit Profile',
      name: 'Edit_Profile_Head',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Edit_Profile_Name {
    return Intl.message('Name', name: 'Edit_Profile_Name', desc: '', args: []);
  }

  /// `Please Enter Your Name`
  String get Edit_Profile_labelText1 {
    return Intl.message(
      'Please Enter Your Name',
      name: 'Edit_Profile_labelText1',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter A valid Name`
  String get Edit_Profile_validatorText1 {
    return Intl.message(
      'Please Enter A valid Name',
      name: 'Edit_Profile_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Edit_Profile_Email {
    return Intl.message(
      'Email',
      name: 'Edit_Profile_Email',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Email`
  String get Edit_Profile_labelText2 {
    return Intl.message(
      'Please Enter Your Email',
      name: 'Edit_Profile_labelText2',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter your Email`
  String get Edit_Profile_validatorText2 {
    return Intl.message(
      'Please Enter your Email',
      name: 'Edit_Profile_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get Edit_Profile_Age {
    return Intl.message('Age', name: 'Edit_Profile_Age', desc: '', args: []);
  }

  /// `Please Enter Your Age`
  String get Edit_Profile_labelText3 {
    return Intl.message(
      'Please Enter Your Age',
      name: 'Edit_Profile_labelText3',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Age`
  String get Edit_Profile_validatorText3 {
    return Intl.message(
      'Please Enter Your Age',
      name: 'Edit_Profile_validatorText3',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get Edit_Profile_Edit {
    return Intl.message('Edit', name: 'Edit_Profile_Edit', desc: '', args: []);
  }

  /// `No user is signed in.`
  String get Edit_Profile_No_user_is_signed_in {
    return Intl.message(
      'No user is signed in.',
      name: 'Edit_Profile_No_user_is_signed_in',
      desc: '',
      args: [],
    );
  }

  /// `Name must contain only letters and spaces.`
  String get Edit_Profile_Name_must_contain_only_letters_and_spaces {
    return Intl.message(
      'Name must contain only letters and spaces.',
      name: 'Edit_Profile_Name_must_contain_only_letters_and_spaces',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully!`
  String get Edit_Profile_Profile_updated_successfully {
    return Intl.message(
      'Profile updated successfully!',
      name: 'Edit_Profile_Profile_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Edit Supervisor`
  String get Edit_Supervisor_Head {
    return Intl.message(
      'Edit Supervisor',
      name: 'Edit_Supervisor_Head',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Edit_Supervisor_Name {
    return Intl.message(
      'Name',
      name: 'Edit_Supervisor_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter The name of the Supervisor`
  String get Edit_Supervisor_labelText1 {
    return Intl.message(
      'Enter The name of the Supervisor',
      name: 'Edit_Supervisor_labelText1',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter The name of the Supervisor`
  String get Edit_Supervisor_validatorText1 {
    return Intl.message(
      'Please Enter The name of the Supervisor',
      name: 'Edit_Supervisor_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Edit_Supervisor_Email {
    return Intl.message(
      'Email',
      name: 'Edit_Supervisor_Email',
      desc: '',
      args: [],
    );
  }

  /// `Enter The Email of the Supervisor`
  String get Edit_Supervisor_labelText2 {
    return Intl.message(
      'Enter The Email of the Supervisor',
      name: 'Edit_Supervisor_labelText2',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter The Email of the Supervisor`
  String get Edit_Supervisor_validatorText2 {
    return Intl.message(
      'Please Enter The Email of the Supervisor',
      name: 'Edit_Supervisor_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Supervisor type`
  String get Edit_Supervisor_Supervisor_type {
    return Intl.message(
      'Supervisor type',
      name: 'Edit_Supervisor_Supervisor_type',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get Edit_Supervisor_update {
    return Intl.message(
      'Update',
      name: 'Edit_Supervisor_update',
      desc: '',
      args: [],
    );
  }

  /// `Supervision`
  String get Supervision_Supervision {
    return Intl.message(
      'Supervision',
      name: 'Supervision_Supervision',
      desc: '',
      args: [],
    );
  }

  /// `No patients found`
  String get Supervision_No_patients_found {
    return Intl.message(
      'No patients found',
      name: 'Supervision_No_patients_found',
      desc: '',
      args: [],
    );
  }

  /// `Error loading patients`
  String get Supervision_Error_loading_patients {
    return Intl.message(
      'Error loading patients',
      name: 'Supervision_Error_loading_patients',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Supervisor_Profile_view_Profile {
    return Intl.message(
      'Profile',
      name: 'Supervisor_Profile_view_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to view your profile`
  String get Supervisor_Profile_view_Please_log_in_to_view_your_profile {
    return Intl.message(
      'Please log in to view your profile',
      name: 'Supervisor_Profile_view_Please_log_in_to_view_your_profile',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get Supervisor_Profile_view_Dark_Mode {
    return Intl.message(
      'Dark Mode',
      name: 'Supervisor_Profile_view_Dark_Mode',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get Supervisor_Profile_view_Change_Language {
    return Intl.message(
      'Change Language',
      name: 'Supervisor_Profile_view_Change_Language',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get Supervisor_Profile_view_Log_out {
    return Intl.message(
      'Log out',
      name: 'Supervisor_Profile_view_Log_out',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get Supervisor_Profile_view_Change_password {
    return Intl.message(
      'Change password',
      name: 'Supervisor_Profile_view_Change_password',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter A valid email`
  String get build_text_field_validatorText1 {
    return Intl.message(
      'Please Enter A valid email',
      name: 'build_text_field_validatorText1',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get build_text_field_validatorText2 {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'build_text_field_validatorText2',
      desc: '',
      args: [],
    );
  }

  /// `Password must include uppercase, lowercase, and digits`
  String get build_text_field_validatorText3 {
    return Intl.message(
      'Password must include uppercase, lowercase, and digits',
      name: 'build_text_field_validatorText3',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Your Age`
  String get build_text_field_validatorText4 {
    return Intl.message(
      'Please Enter Your Age',
      name: 'build_text_field_validatorText4',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter a valid Age`
  String get build_text_field_validatorText5 {
    return Intl.message(
      'Please Enter a valid Age',
      name: 'build_text_field_validatorText5',
      desc: '',
      args: [],
    );
  }

  /// `Value must be greater than 0`
  String get build_text_field_validatorText6 {
    return Intl.message(
      'Value must be greater than 0',
      name: 'build_text_field_validatorText6',
      desc: '',
      args: [],
    );
  }

  /// `New password and confirmation do not match.`
  String get changePassPage_New_password_and_confirmation_do_not_match {
    return Intl.message(
      'New password and confirmation do not match.',
      name: 'changePassPage_New_password_and_confirmation_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `no-user`
  String get changePassPage_no_user {
    return Intl.message(
      'no-user',
      name: 'changePassPage_no_user',
      desc: '',
      args: [],
    );
  }

  /// `No user is signed in.`
  String get changePassPage_No_user_is_signed_in {
    return Intl.message(
      'No user is signed in.',
      name: 'changePassPage_No_user_is_signed_in',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully!`
  String get changePassPage_Password_changed_successfully {
    return Intl.message(
      'Password changed successfully!',
      name: 'changePassPage_Password_changed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.`
  String get changePassPage_An_unexpected_error_occurred {
    return Intl.message(
      'An unexpected error occurred.',
      name: 'changePassPage_An_unexpected_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassPage_Change_Password {
    return Intl.message(
      'Change Password',
      name: 'changePassPage_Change_Password',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get changePassPage_Current_Password {
    return Intl.message(
      'Current Password',
      name: 'changePassPage_Current_Password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get changePassPage_Please_enter_your_current_password {
    return Intl.message(
      'Please enter your current password',
      name: 'changePassPage_Please_enter_your_current_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Current Password`
  String get changePassPage_Enter_Current_Password {
    return Intl.message(
      'Enter Current Password',
      name: 'changePassPage_Enter_Current_Password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get changePassPage_New_Password {
    return Intl.message(
      'New Password',
      name: 'changePassPage_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid new password (at least 6 characters)`
  String
  get changePassPage_Please_enter_a_valid_new_password_at_least_6_characters {
    return Intl.message(
      'Please enter a valid new password (at least 6 characters)',
      name:
          'changePassPage_Please_enter_a_valid_new_password_at_least_6_characters',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Password`
  String get changePassPage_Enter_New_Password {
    return Intl.message(
      'Enter New Password',
      name: 'changePassPage_Enter_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get changePassPage_Confirm_New_Password {
    return Intl.message(
      'Confirm New Password',
      name: 'changePassPage_Confirm_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password`
  String get changePassPage_Please_confirm_your_new_password {
    return Intl.message(
      'Please confirm your new password',
      name: 'changePassPage_Please_confirm_your_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete Medicine`
  String get CustomBoxFilled_Delete_Medicine {
    return Intl.message(
      'Delete Medicine',
      name: 'CustomBoxFilled_Delete_Medicine',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get CustomBoxFilled_Cancel {
    return Intl.message(
      'Cancel',
      name: 'CustomBoxFilled_Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Alert!!`
  String get CustomBoxIcon_Alert {
    return Intl.message(
      'Alert!!',
      name: 'CustomBoxIcon_Alert',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to add a new medication?`
  String get CustomBoxIcon_Are_you_sure_you_want_to_add_a_new_medication {
    return Intl.message(
      'Are you sure you want to add a new medication?',
      name: 'CustomBoxIcon_Are_you_sure_you_want_to_add_a_new_medication',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get CustomBoxIcon_yes {
    return Intl.message('Yes', name: 'CustomBoxIcon_yes', desc: '', args: []);
  }

  /// `No`
  String get CustomBoxIcon_No {
    return Intl.message('No', name: 'CustomBoxIcon_No', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
