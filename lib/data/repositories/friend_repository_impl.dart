import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_constants.dart';
import '../../core/exceptions/auth_exceptions.dart';
import '../../core/exceptions/friend_exceptions.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/friend_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/friend_model.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;

  FriendRepositoryImpl(this._firestore, this._userRepository);

  @override
  Future<void> addFriend(String friendUserId) async {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) throw AuthException('User not authenticated');

    final batch = _firestore.batch();

    // Add to current user's friends
    final currentUserFriendRef = _firestore
        .collection('users')
        .doc(currentUser.id)
        .collection('friends')
        .doc(friendUserId);

    // Add to friend's friends list
    final friendUserRef = _firestore.collection('users').doc(friendUserId).collection('friends').doc(currentUser.id);

    final friendData = await _userRepository.getUser(friendUserId);
    if (friendData == null) throw const FriendException('User not found');

    batch.set(currentUserFriendRef, {
      'userId': friendUserId,
      'email': friendData.email,
      'name': friendData.name,
      'photoUrl': friendData.photoUrl,
      'friendsSince': FieldValue.serverTimestamp(),
    });

    batch.set(friendUserRef, {
      'userId': currentUser.id,
      'email': currentUser.email,
      'name': currentUser.name,
      'photoUrl': currentUser.photoUrl,
      'friendsSince': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Stream<List<FriendEntity>> getFriends() {
    final currentUser = _userRepository.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(currentUser.id)
        .collection('friends')
        .orderBy('friendsSince', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FriendModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> removeFriend(String friendUserId) async {
    try {
      final currentUser = _userRepository.currentUser;
      if (currentUser == null) throw const NotAuthenticatedException();

      final batch = _firestore.batch();

      // Remove from current user's friends
      final currentUserFriendRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUser.id)
          .collection(FirestoreConstants.friendsSubcollection)
          .doc(friendUserId);
      batch.delete(currentUserFriendRef);

      // Remove from friend's friends list
      final friendUserRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(friendUserId)
          .collection(FirestoreConstants.friendsSubcollection)
          .doc(currentUser.id);
      batch.delete(friendUserRef);

      await batch.commit();
    } on FirebaseException catch (e) {
      throw FriendException('Failed to remove friend: ${e.message}');
    } catch (e) {
      throw FriendException('Failed to remove friend');
    }
  }
}
