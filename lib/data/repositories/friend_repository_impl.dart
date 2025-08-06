import '../../domain/repositories/friend_repository.dart';
import '../datasources/friend_remote_datasource.dart';
import '../model/friend_model.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSource remoteDataSource;

  FriendRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<FriendModel>> searchUsersByEmail(String email) => remoteDataSource.searchUsersByEmail(email);

  @override
  Future<void> addFriend(String currentUserId, String friendUserId) =>
      remoteDataSource.addFriend(currentUserId, friendUserId);

  @override
  Stream<List<FriendModel>> getFriends(String userId) => remoteDataSource.getFriends(userId);
}
