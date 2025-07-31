import '../entities/activity_entity.dart';

abstract class ActivityRepository {
  Stream<List<ActivityEntity>> getUserActivities();
  Future<void> logActivity(ActivityEntity activity);
}
