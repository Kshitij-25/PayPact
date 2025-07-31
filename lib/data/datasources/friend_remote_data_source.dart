import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRemoteDataSource {
  final FirebaseFirestore _firestore;

  FriendRemoteDataSource(this._firestore);

  Future<void> addFriend(String userId, String friendUserId) async {
    final batch = _firestore.batch();

    final userFriendRef = _firestore.collection('users').doc(userId).collection('friends').doc(friendUserId);

    final friendUserRef = _firestore.collection('users').doc(friendUserId).collection('friends').doc(userId);

    final userDoc = await _firestore.collection('users').doc(friendUserId).get();

    batch.set(userFriendRef, {
      'userId': friendUserId,
      'email': userDoc['email'],
      'name': userDoc['name'],
      'photoUrl': userDoc['photoUrl'],
      'friendsSince': FieldValue.serverTimestamp(),
    });

    final currentUserDoc = await _firestore.collection('users').doc(userId).get();

    batch.set(friendUserRef, {
      'userId': userId,
      'email': currentUserDoc.data()?['email'],
      'name': currentUserDoc.data()?['name'],
      'photoUrl': currentUserDoc.data()?['photoUrl'],
      'friendsSince': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
