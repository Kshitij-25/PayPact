import '../../data/model/friend_model.dart';

abstract class FriendRepository {
  Stream<List<FriendModel>> searchUsersByEmail(String email);
  Future<void> addFriend(String currentUserId, String friendUserId);
  Stream<List<FriendModel>> getFriends(String userId);
}
