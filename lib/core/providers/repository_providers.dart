import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/activity_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/friend_repository_impl.dart';
import '../../data/repositories/group_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/friend_repository.dart';
import 'firebase_providers.dart';

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepositoryImpl(firestore);
});

final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  // Get dependencies
  final firestore = ref.watch(firestoreProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return FriendRepositoryImpl(firestore, userRepository);
});

final groupRepositoryProvider = Provider<GroupRepositoryImpl>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final activityRepo = ref.watch(activityRepositoryProvider);
  return GroupRepositoryImpl(firestore, activityRepo);
});

final expenseRepositoryProvider = Provider<ExpenseRepositoryImpl>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final activityRepo = ref.watch(activityRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return ExpenseRepositoryImpl(firestore, activityRepo, userRepository);
});

final activityRepositoryProvider = Provider<ActivityRepositoryImpl>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ActivityRepositoryImpl(firestore);
});
