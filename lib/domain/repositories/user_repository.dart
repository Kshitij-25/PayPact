import '../../data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser(String userId);
}
