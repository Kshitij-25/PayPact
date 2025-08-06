import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/friend_model.dart';

abstract class FriendRemoteDataSource {
  Stream<List<FriendModel>> searchUsersByEmail(String email);
  Future<void> addFriend(String currentUserId, String friendUserId);
  Stream<List<FriendModel>> getFriends(String userId);
}

class FriendRemoteDataSourceImpl implements FriendRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FriendRemoteDataSourceImpl(this._firestore, this._auth);

  @override
  Stream<List<FriendModel>> searchUsersByEmail(String email) {
    if (email.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: email)
        .where('email', isLessThan: '${email}z')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FriendModel.fromFirebase(doc.data())).toList());
  }

  @override
  Future<void> addFriend(String currentUserId, String friendUserId) async {
    final batch = _firestore.batch();

    // Add to current user's friends
    final currentUserFriendRef = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(friendUserId);

    batch.set(currentUserFriendRef, {'friendSince': DateTime.now()});

    // Add to friend's friends list (optional two-way relationship)
    final friendUserFriendRef = _firestore
        .collection('users')
        .doc(friendUserId)
        .collection('friends')
        .doc(currentUserId);

    batch.set(friendUserFriendRef, {'friendSince': DateTime.now()});

    await batch.commit();
  }

  @override
  Stream<List<FriendModel>> getFriends(String userId) {
    return _firestore.collection('users').doc(userId).collection('friends').snapshots().asyncMap((
      friendsSnapshot,
    ) async {
      if (friendsSnapshot.docs.isEmpty) return [];

      final friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();

      // Firestore has a limit of 10 for 'whereIn' queries
      final batches = [];
      for (var i = 0; i < friendIds.length; i += 10) {
        batches.add(friendIds.sublist(i, i + 10 > friendIds.length ? friendIds.length : i + 10));
      }

      final List<FriendModel> allFriends = [];
      for (final batch in batches) {
        final usersSnapshot = await _firestore.collection('users').where(FieldPath.documentId, whereIn: batch).get();

        allFriends.addAll(
          usersSnapshot.docs.map((doc) => FriendModel.fromFirebase(doc.data())),
        );
      }

      return allFriends;
    });
  }
}
