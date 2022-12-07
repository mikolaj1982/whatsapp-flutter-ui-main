import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

final contactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance),
);

final FutureProvider<List<Contact>> getContactsProvider = FutureProvider((ref) {
  final selectContactsRepo = ref.watch(contactsRepositoryProvider);
  return selectContactsRepo.getContacts();
  // return null;
});

final Provider<SelectContactController> selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(contactsRepositoryProvider);
  return SelectContactController(selectContactRepository: selectContactRepository, ref: ref);
});
