class UserEntity {
  final String userId;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? base64Image;

  const UserEntity({
    required this.userId,
    required this.email,
    this.name,
    this.photoUrl,
    this.base64Image,
  });
}
