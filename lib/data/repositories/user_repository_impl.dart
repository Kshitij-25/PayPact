import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firebase_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  UserEntity? get currentUser {
    final user = FirebaseHelper.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<UserEntity?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  @override
  Future<UserEntity?> findUserByEmail(String email) async {
    final query = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();
    return query.docs.isNotEmpty ? UserModel.fromFirestore(query.docs.first) : null;
  }

  @override
  Stream<UserEntity> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map(
          (doc) => UserModel.fromFirestore(doc),
        );
  }
}
