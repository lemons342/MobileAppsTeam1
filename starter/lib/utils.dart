import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab3/detailed_page.dart';
import 'activity.dart';

/// gets all activities from the database
Future<QuerySnapshot<Map<String,dynamic>>> getAllActivities() {
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

void showDetailedInfo(BuildContext context, int index, {required bool isSignedUp}) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => DetailedPage(
              activityIndex: index,
              withDeleteButton: isSignedUp,
            )),
  );
}
