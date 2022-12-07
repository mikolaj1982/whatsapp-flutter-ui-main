import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      // get all users so we can loop though all of them to see if the selected user phone number belongs to our contact lists
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNumber = selectedContact.phones[0].number.replaceAll(' ', '');
        // debugPrint('selectedPhoneNumber $selectedPhoneNumber,  userData.phoneNumber: ${userData.phoneNumber}');
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': userData.name,
              'uid': userData.uid, // this uid is receiver uid, person who we wants to talk to
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(context: context, content: 'This number does not exist on this application.');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      // Request contact permission
      if (await FlutterContacts.requestPermission()) {
        // get all contacts fully fetched
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }
}
