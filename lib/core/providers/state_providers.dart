import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../../presentation/state/activity/activity_notifier.dart';
import '../../presentation/state/balance/balance_notifier.dart';
import '../../presentation/state/expense/expense_notifier.dart';
import '../../presentation/state/friends/friend_notifier.dart';
import '../../presentation/state/group/group_notifier.dart';
import 'repository_providers.dart';

final friendNotifierProvider = StateNotifierProvider<FriendNotifier, AsyncValue<List<FriendEntity>>>((ref) {
  final friendRepo = ref.watch(friendRepositoryProvider);
  return FriendNotifier(friendRepo);
});

final groupNotifierProvider = StateNotifierProvider<GroupNotifier, AsyncValue<List<GroupEntity>>>((ref) {
  final groupRepo = ref.watch(groupRepositoryProvider);
  return GroupNotifier(groupRepo);
});

final expenseNotifierProvider = StateNotifierProvider.autoDispose
    .family<ExpenseNotifier, AsyncValue<List<ExpenseEntity>>, String>((ref, groupId) {
      final expenseRepo = ref.watch(expenseRepositoryProvider);
      return ExpenseNotifier(expenseRepo, groupId);
    });

final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, AsyncValue<List<ActivityEntity>>>((ref) {
  final activityRepo = ref.watch(activityRepositoryProvider);
  return ActivityNotifier(activityRepo);
});

final balanceNotifierProvider = StateNotifierProvider.autoDispose
    .family<BalanceNotifier, AsyncValue<Map<String, double>>, String>((ref, groupId) {
      final expenseRepo = ref.watch(expenseRepositoryProvider);
      return BalanceNotifier(expenseRepo, groupId);
    });
