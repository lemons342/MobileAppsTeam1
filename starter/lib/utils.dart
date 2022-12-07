import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailed_page.dart';
import 'account_model.dart';

/// gets all activities from the database
Future<QuerySnapshot<Map<String, dynamic>>> getAllActivities() {
  final allActivities = FirebaseFirestore.instance.collection('activities');
  return allActivities.get();
}

/// creates a new route to display the details page of the clicked on activity
void showDetailedInfo(
    AccountModel model, BuildContext context, currentActivity, // update type
    {required bool isSignedUp}) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => DetailedPage(
              model: model,
              activity: currentActivity,
              withDeleteButton: isSignedUp,
            )),
  );
}

/// signs the user up for the activity
void addUserToActivity(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);

  activityFromDB.get().then((value) {
    db.doc(selectedActivity['title']).update({
      'signedUp': FieldValue.arrayUnion([userEmail]),
    }).then((value) {
      var snackBar = SnackBar(
        content: const Text('Successfully added!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () =>
              removeUserFromActivity(context, model, selectedActivity),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  });
}

/// removes the user from the activity
void removeUserFromActivity(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);

  activityFromDB.get().then((value) {
    db.doc(selectedActivity['title']).update({
      'signedUp': FieldValue.arrayRemove([userEmail]),
    }).then((value) {
      var snackBar = SnackBar(
        content: const Text('Successfully removed!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => addUserToActivity(context, model, selectedActivity),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  });
}
