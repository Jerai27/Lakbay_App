import '../models/activity_model.dart';

class ActivityService {
  // TODO: Replace with Firebase later
  
  /// Add new activity
  Future<Activity> addActivity({
  required String name,
  required String day,
  required String time,
  required String location,
  required int cost,
}) async {
  try {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final activity = Activity(
      id: id,
      name: name,
      day: day,
      time: time,
      location: location,
      cost: cost,
    );

    return activity;
  } catch (e) {
    throw Exception('Failed to add activity: $e');
  }
}
}