import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSourceImpl(this._firestore);

  @override
  Future<UserModel> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception('User not found');
    return UserModel.fromFirebase(doc.data()!);
  }
}
