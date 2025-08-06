import '../../data/model/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
}
