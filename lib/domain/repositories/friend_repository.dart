import '../entities/friend_entity.dart';

abstract class FriendRepository {
  Future<void> addFriend(String friendUserId);
  Future<void> removeFriend(String friendUserId);
  Stream<List<FriendEntity>> getFriends();
}
