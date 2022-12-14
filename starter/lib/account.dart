// ignore_for_file: avoid_types_as_parameter_names, slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account_model.dart';
import 'utils.dart';

/**
 * Name: Seth Frevert
 * Date: 12/13/2022
 * Description: Display user's email and favorite activities 
 * Bugs: None that I know of
 * Reflection: Beyond it being a bit lacking in displays it functions, looks fine
 */

class Account extends StatefulWidget {
  const Account({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activities');
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Will display the email of the user

              Expanded( flex: 1,
                child: Text('Email: ${widget.model.GetUserEmail()}',
                    style: const TextStyle(fontSize: 18.0)),
              ),
              //Will list the favorite activites entered or selected by the user
              _listOfFavorites(activities),
              _logoutButton()
            ]
      ),
    ));
  }

  Expanded _listOfFavorites(CollectionReference<Object?> activities) {
    return Expanded( flex: 10,
              child: StreamBuilder<QuerySnapshot>(
                  stream: activities
                      .where('favorited',
                          arrayContains: widget.model.GetUserEmail())
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot> currentActivities =
                          snapshot.data!.docs; // all docs
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Favorited Activites',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                //decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Divider(
                                color: Color(0xFF00FC87),
                                thickness: 4.0,
                                height: 1.0),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.separated(
                                itemCount: currentActivities.length,
                                itemBuilder: (context, index) {
                                  var currentActivity = currentActivities[
                                      index]; // the map stored in a QDS
                                  return ListTile(
                                    onTap: () => showDetailedInfo(
                                        widget.model, context, currentActivity,
                                        isSignedUp: false, isFavoritied: true),
                                    title: Text(currentActivity['title']),
                                    subtitle: Text(currentActivity['date']),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                      color: Colors.grey,
                                      thickness: 1.0,
                                      height: 1.0);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('This probably won\'t be returned'));
                    }
                  }),
            );
  }

  Expanded _logoutButton() {
    return Expanded( flex: 1,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _logout, child: const Text('Logout'))
              ],
            ));
  }

  //Logout the user by accessing the logout in the model
  void _logout() {
    widget.model.Logout();
  }
}
