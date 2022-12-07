import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/providers/contact_providers.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = '/select-contacts-screen';

  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contacts'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactsList) {
            // debugPrint(contacts.toString());
            return ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                final contact = contactsList[index];
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(contact.name.first + contact.name.last),
                      leading: contact.photo != null
                          ? CircleAvatar(radius: 30, backgroundImage: MemoryImage(contact.photo!))
                          : null,
                    ),
                  ),
                );
              },
            );
          },
          error: (e, trace) {
            return ErrorScreen(error: e.toString());
          },
          loading: () => const Loader()),
    );
  }
}
