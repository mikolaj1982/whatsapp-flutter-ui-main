class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final String phoneNumber;
  final bool isOnline;
  final List<String> groupId;

  UserModel(
      {required this.name,
      required this.uid,
      required this.profilePic,
      required this.phoneNumber,
      required this.isOnline,
      required this.groupId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }

  @override
  String toString() {
    return '[UserModel name: $name\n '
        'uid: $uid\n '
        'profilePic: $profilePic\n '
        'phoneNumber: $phoneNumber\n '
        'isOnline: $isOnline\n '
        'groupId: $groupId]';
  }
}
