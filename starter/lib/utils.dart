import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detailed_page.dart';
import 'account_model.dart';

/// Name: Stephanie Amundson
/// Date: 12/13/2022
/// Description: Utility functions used by multiple pages in the app.
/// Bugs: None that I know of
/// Reflection: Futures were a challenge at times but wasn't too
///             difficult once we figured that out

/// gets all activities from the database
Future<QuerySnapshot<Map<String, dynamic>>> getAllActivities() {
  final allActivities = FirebaseFirestore.instance.collection('activities');
  return allActivities.get();
}

/// creates a new route to display the details page of the clicked on activity
void showDetailedInfo(
    AccountModel model, BuildContext context, currentActivity, // update type
    {required bool isSignedUp,
    required bool isFavorited}) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => DetailedPage(
              model: model,
              activity: currentActivity,
              withDeleteButton: isSignedUp,
              withRemoveButton: isFavorited,
            )),
  );
}

/// signs the user up for the activity
void signUpForActivity(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);

  if (model.loggedIn) {
    activityFromDB.get().then((value) {
      db.doc(selectedActivity['title']).update({
        'signedUp': FieldValue.arrayUnion([userEmail]),
      }).then((value) {
        var snackBar = SnackBar(
          content: const Text('Successfully signed up!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                removeUserFromSignup(context, model, selectedActivity),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  } else {
    var snackBar =
        const SnackBar(content: Text('Please login to add activity'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// removes the user from the activity signup
void removeUserFromSignup(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);
      
  if (model.loggedIn) {
    activityFromDB.get().then((value) {
      db.doc(selectedActivity['title']).update({
        'signedUp': FieldValue.arrayRemove([userEmail]),
      }).then((value) {
        var snackBar = SnackBar(
          content: const Text('Successfully removed.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                signUpForActivity(context, model, selectedActivity),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }
}

/// adds the activity to the user's favorites
void favoriteActivity(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);

  if (model.loggedIn) {
    activityFromDB.get().then((value) {
      db.doc(selectedActivity['title']).update({
        'favorited': FieldValue.arrayUnion([userEmail]),
      }).then((value) {
        var snackBar = SnackBar(
          content: const Text('Favorited Activity'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                removeUserFromSignup(context, model, selectedActivity),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  } else {
    var snackBar =
        const SnackBar(content: Text('Please login to favorite an activity'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// removes the activity from the user's favorites
void removeUserFavorite(BuildContext context, AccountModel model,
    QueryDocumentSnapshot selectedActivity) {
  var userEmail = model.GetUserEmail();
  final db = FirebaseFirestore.instance.collection('activities');
  final activityFromDB =
      db.where('title', isEqualTo: selectedActivity['title']);

  if (model.loggedIn) {
    activityFromDB.get().then((value) {
      db.doc(selectedActivity['title']).update({
        'favorited': FieldValue.arrayRemove([userEmail]),
      }).then((value) {
        var snackBar = SnackBar(
          content: const Text('Removed Favorite'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                signUpForActivity(context, model, selectedActivity),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }
}
