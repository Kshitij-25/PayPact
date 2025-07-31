import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/activity_entity.dart';
import '../../../domain/repositories/activity_repository.dart';

class ActivityNotifier extends StateNotifier<AsyncValue<List<ActivityEntity>>> {
  final ActivityRepository _activityRepository;
  StreamSubscription? _subscription;

  ActivityNotifier(this._activityRepository) : super(const AsyncValue.loading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _activityRepository.getUserActivities().listen(
      (activities) {
        state = AsyncValue.data(activities);
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  Future<void> logActivity(ActivityEntity activity) async {
    await _activityRepository.logActivity(activity);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
