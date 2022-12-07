import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

final storageProvider = Provider((ref) => CommonFirebaseStorageRepository(storage: FirebaseStorage.instance));

// future provider
final userDataProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
  // return null;
});

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

// final name of the class lowercase plus word Provider = Provider ref => what we are providing
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage storage;

  CommonFirebaseStorageRepository({required this.storage});

  Future<String> storeFileToFirebase(String pathToFile, File file) async {
    UploadTask uploadTask = storage.ref().child(pathToFile).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    debugPrint('downloadUrl $downloadUrl');
    return downloadUrl;
  }
}
