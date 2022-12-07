import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_information.dart';
import 'package:whatsapp_ui/features/status/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  void setUserState(bool isOnline) async {
    firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    debugPrint('3. REPO');
    debugPrint('signInWithPhone()');

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            debugPrint('verificationCompleted()');
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            showSnackBar(context: context, content: e.message!);
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            debugPrint('VerificationId $verificationId');
            Navigator.pushNamed(context, OTPScreen.routeName, arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            debugPrint('Auto resolution has timed out for $verificationId');
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  // 053232 code for test device
  void verifyOTP({required BuildContext context, required String verificationId, required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);

      // prevents user for going back to previous screen, we don't want user to go back to OTP screen once signed in
      Navigator.pushNamedAndRemoveUntil(context, UserInformation.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  // void saveUserDataToFirebase({required BuildContext context, required String name, required File? profilePic}) {}
  // if we need to interact with different providers we need to pass a ref
  // required ProviderRef ref
  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required BuildContext context,
    required ProviderRef ref,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      debugPrint('uid $uid');
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        String path = 'profilePic/$uid';
        photoUrl = await ref.read(storageProvider).storeFileToFirebase(path, profilePic);
        debugPrint('photoUrl $photoUrl');
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          phoneNumber: auth.currentUser!.phoneNumber!,
          isOnline: true,
          groupId: []);

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }
}
