import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'activity.dart';

/// Home screen page
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of user's activites (will be changed to pull from user's saved
  @override

  Widget build(BuildContext context) {

  List<Activity> activities = _getActivities();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'SIGNED UP ACTIVITIES:',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                decoration: TextDecoration.underline),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(activities[index].title),
                  subtitle: Text(activities[index].description ?? ''),
                  leading: activities[index].image,
                  trailing: Text(activities[index].getDateAsString()),
                  contentPadding: const EdgeInsets.all(10.0),
                );
              },
              itemCount: activities.length,
              separatorBuilder: (context, index) {
                return const Divider(
                    color: Colors.grey, thickness: 1.0, height: 1.0);
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Activity> _getActivities() {
    // method will be changed to interact with the database to only
    // pull activities whose date matches the date in the parameter
    final allActivities = FirebaseFirestore.instance.collection('activities');
    List<Activity> validActivities = [];
    var query = allActivities;
    query.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {   //setstate????
          Activity currentActivity = Activity(
              title: doc['title'],
              description: doc['description'],
              date: doc['date']);
          validActivities.add(currentActivity);
          // ignore: avoid_print
          print(currentActivity.toString());
        });
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
}
