import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRemoteSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(String currentUserId, String friendEmail) async {
    // Find user by email
    final users =
        await _firestore
            .collection('users')
            .where('email', isEqualTo: friendEmail)
            .limit(1)
            .get();

    if (users.docs.isEmpty) throw Exception('User not found');
    final friendId = users.docs.first.id;

    // Update both users' friend lists
    final batch = _firestore.batch();

    final currentUserRef = _firestore.collection('users').doc(currentUserId);
    batch.update(currentUserRef, {
      'friends': FieldValue.arrayUnion([friendId]),
    });

    final friendRef = _firestore.collection('users').doc(friendId);
    batch.update(friendRef, {
      'friends': FieldValue.arrayUnion([currentUserId]),
    });

    await batch.commit();
  }
}
