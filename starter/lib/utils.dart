import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailed_page.dart';

/// gets all activities from the database
Future<QuerySnapshot<Map<String,dynamic>>> getAllActivities() {
  final allActivities = FirebaseFirestore.instance.collection('activities');
  return allActivities.get();
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
