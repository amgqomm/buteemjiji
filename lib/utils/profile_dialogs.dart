// utils/profile_dialogs.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user/user_cubit.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class ProfileDialogs {
  static void showEditUsernameDialog(BuildContext context, AppUser user) {
    // Same implementation as before
  }

  static void showEditEmailDialog(BuildContext context, AppUser appUser) {
    // Same implementation as before
  }

  static void showChangePasswordDialog(BuildContext context) {
    // Same implementation as before
  }

  static void showEditGenderDialog(BuildContext context, AppUser user) {
    // Same implementation as before
  }

  static void showEditAgeDialog(BuildContext context, AppUser user) {
    // Same implementation as before
  }

  static String getGenderText(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Эр';
      case Gender.female:
        return 'Эм';
      default:
        return 'Бусад';
    }
  }
}