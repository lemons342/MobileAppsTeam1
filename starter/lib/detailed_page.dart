import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity.dart';
import 'utils.dart';

class DetailedPage extends StatelessWidget {
  final int activityIndex;
  final bool withDeleteButton;

  const DetailedPage(
      {Key? key, required this.activityIndex, required this.withDeleteButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getAllActivities(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('waiting'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('error'));
          } else if (snapshot.hasData) {
            var activityList = snapshot.data!.docs;
            var currentActivity = activityList[activityIndex];
            return Text(currentActivity['title']);
          } else {
            return const Center(
              child: Text('This shouldn\'t happen'),
            );
          }
        },
      ),
    );
  }

  // Activity? getCurrentActivity(int index) {
  //   Activity? activity;
  //   var allActivities = getAllActivities();
  //   allActivities.then((querySnapshot) {
  //     // var info = querySnapshot.docs[index];
  //     List<Map<String, dynamic>> list =
  //         querySnapshot.docs.map((doc) => doc.data()).toList();
  //     Map<String, dynamic> info = list[index];
  //     print('Details page: ' + info['title']);
  //     activity = Activity(
  //         title: info['title'],
  //         description: info['subtitle'],
  //         date: DateTime.parse(info['date']));
  //   });

  //   return activity;
  // }
}
