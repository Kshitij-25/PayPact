import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  FriendModel({
    required super.userId,
    required super.email,
    required super.name,
    super.photoUrl,
    required super.friendsSince,
  });

  factory FriendModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendModel(
      userId: data['userId'],
      email: data['email'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      friendsSince: (data['friendsSince'] as Timestamp).toDate(),
    );
  }
}
