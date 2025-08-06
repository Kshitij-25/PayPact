enum ParticipantType { friend, group }

class FriendEntity {
  final String userId;
  final String email;
  final String? name;
  final String? base64Image;
  final String? photoUrl;

  FriendEntity({
    required this.userId,
    required this.email,
    this.name,
    this.base64Image,
    this.photoUrl,
  });
}
