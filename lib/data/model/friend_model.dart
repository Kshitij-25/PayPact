import '../../domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  FriendModel({
    required super.userId,
    required super.email,
    super.name,
    super.base64Image,
    super.photoUrl,
  });

  factory FriendModel.fromFirebase(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      base64Image: json['base64Image'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toFirebase() => {
    'userId': userId,
    'email': email,
    'name': name,
    'base64Image': base64Image,
    'photoUrl': photoUrl,
  };
}
