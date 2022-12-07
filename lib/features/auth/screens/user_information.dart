import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';

class UserInformation extends ConsumerStatefulWidget {
  static const routeName = '/user-information-screen';

  const UserInformation({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformation> {
  File? profilePic;
  final nameController = TextEditingController();

  void setImage() async {
    profilePic = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, profilePic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  (profilePic == null)
                      ? const CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/no_avatar.png',
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(profilePic!),
                          radius: 64,
                        ),
                  Positioned(
                      left: 80,
                      bottom: -10,
                      child: IconButton(onPressed: setImage, icon: const Icon(Icons.add_a_photo))),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Enter your name'),
                    ),
                  ),
                  IconButton(onPressed: storeUserData, icon: const Icon(Icons.done)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
}
