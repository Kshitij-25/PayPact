class FriendEntity {
  final String userId;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime friendsSince;

  FriendEntity({
    required this.userId,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.friendsSince,
  });
}
