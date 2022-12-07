import 'package:whatsapp_ui/common/enums/massage_enum.dart';

class Message {
  final String receiverId;
  final String senderId;
  final String messageId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;

  Message({
    required this.receiverId,
    required this.senderId,
    required this.messageId,
    required this.type,
    required this.timeSent,
    required this.isSeen,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }

  @override
  String toString() {
    return '[Message receiverId: $receiverId\n '
        'senderId: $senderId\n '
        'messageId: $messageId\n '
        'text: $text\n '
        'isSeen: $isSeen\n '
        'timeSent: $timeSent\n '
        'type: $type]';
  }
}
