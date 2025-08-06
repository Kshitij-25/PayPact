import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.email,
    super.name,
    super.photoUrl,
    super.base64Image,
  });

  factory UserModel.fromFirebase(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      base64Image: json['base64Image'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'base64Image': base64Image,
    };
  }
}
