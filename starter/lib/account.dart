// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account_model.dart';

class Account extends StatefulWidget {
  const Account({Key? key, required this.model}) : super(key: key);
  final AccountModel model;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  //Due to current issues with firestore, as of 11/18/2022, has been left unimplemented
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Will display the email of the user
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Email: ${widget.model.GetUserEmail()}'),
            ],
          ),
          //Will list the favorite activites entered or selected by the user
          Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [Text('Favorited Activites')]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
                      future:
                          _getFavoriteActivities(email: widget.model.GetUserEmail()),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: Text('Waiting'));
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error'));
                        } else if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> activities =
                              snapshot.data!.docs;
                          return SizedBox(
                              height: 100.0,
                              width: 250.0,
                              child: ListView.separated(
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text(activities[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 18.0)));
                                  },
                                  separatorBuilder: (context, int) =>
                                      const Divider(
                                          color: Colors.black,
                                          thickness: 1.0,
                                          height: 1.0)));
                        } else {
                          return const Center(
                              child: Text('This probably won\'t be returned'));
                        }
                      })
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<QuerySnapshot> _getFavoriteActivities({required String email}) {
    return FirebaseFirestore.instance
        .collection('activities')
        .where('favorited', arrayContains: email)
        .get();
  }
}
