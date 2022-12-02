import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';

List<Activity> getActivities() {
  // method will be changed to interact with the database to only
  // pull activities whose date matches the date in the parameter
  final allActivities = FirebaseFirestore.instance.collection('activities');
  List<Activity> validActivities = [];
  var query = allActivities;
  query.get().then((querySnapshot) {
    for (var doc in querySnapshot.docs) {
      // setState(() {
      //setstate????
      Activity currentActivity = Activity(
          title: doc['title'],
          description: doc['description'],
          date: DateTime.parse(doc['date']));
      validActivities.add(currentActivity);
      // ignore: avoid_print
      print(currentActivity.toString());
      // });
    }
  });

  // List<Activity> activities = HomeScreen().list;
  // for (var element in activities) {
  //   if (isSameDay(element.date, day)) {
  //     validActivities.add(element);
  //   }
  // }
  return validActivities;
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
