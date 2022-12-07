// talks with login screen and auth repository

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  Stream<UserModel> userData(String userId) {
    return authRepository.userData(userId);
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    debugPrint('2. CONTROLLER');
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebase(BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, context: context, ref: ref);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
