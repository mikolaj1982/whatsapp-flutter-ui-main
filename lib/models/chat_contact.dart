class ChatContact {
  final String name;
  final String profilePic;
  final String lastMessage;
  final String contactId;
  final DateTime timeSent;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.lastMessage,
      required this.contactId,
      required this.timeSent});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'receiverId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['receiverId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }

  @override
  String toString() {
    return '[ChatContact: $name\n '
        'profilePic: $profilePic\n '
        'lastMessage: $lastMessage\n '
        'contactId: $contactId\n '
        'timeSent: $timeSent]';
  }
}
