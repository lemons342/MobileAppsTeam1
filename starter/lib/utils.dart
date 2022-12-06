import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';

/// gets all activities from the database
Future<QuerySnapshot> getAllActivities() {
  final allActivities = FirebaseFirestore.instance.collection('activities');
  return allActivities.get();
}

/// Gets the activities for the given [day]
/// (Will be implemented to pull from database)
List<Activity> getEventsForDay(DateTime day) {
  // method will be changed to interact with the database to only
  // pull activities whose date matches the date in the parameter
  final allActivities = FirebaseFirestore.instance.collection('activities');
  List<Activity> validActivities = [];
  var formattedDay = day.toString().substring(0, 10);
  var query = allActivities.where('date', isEqualTo: formattedDay);
  query.get().then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      Activity currentActivity = Activity(
          title: doc['title'],
          description: doc['description'],
          date: DateTime.parse(doc['date']));
      print(currentActivity);
      validActivities.add(currentActivity);
    }
  });

  return validActivities;
}
