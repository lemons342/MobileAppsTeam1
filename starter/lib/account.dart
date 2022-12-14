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
  final TextStyle titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 23,);

  final TextStyle dateStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 20,);

  final TextStyle descriptionStyle =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 18,);
      
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Will display the email of the user
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Account:   ${widget.model.GetUserEmail()}',
                    style: const TextStyle(fontSize: 18.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FC87)), 
                      child: const Text('Logout'),
                      )
                  ],
                ),
              ],
            ),
          ),
          //Will list the favorite activites entered or selected by the user
          Column(
            children: [
              Text('Favorited Activites', style: titleStyle),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Divider(
                              color: Color(0xFF00FC87), thickness: 4.0, height: 1.0
                              ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
                      future: _getFavoriteActivities(
                          email: widget.model.GetUserEmail()),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error'));
                        } else if (snapshot.hasData) {
                          List<QueryDocumentSnapshot> activities =
                              snapshot.data!.docs;
                          return SizedBox(
                              height: 400.0,
                              width: 350.0,
                              child: ListView.separated(
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text(activities[index]['title'],
                                            style: const TextStyle(
                                                fontSize: 18.0)));
                                  },
                                  separatorBuilder: (context, int) =>
                                      const Divider(
                                          color: Colors.grey,
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
    );
  }

  
  void _logout(){
    widget.model.Logout();
  }

  //Used to retrieve favorited activites of the user
  Future<QuerySnapshot> _getFavoriteActivities({required String email}) {
    return FirebaseFirestore.instance
        .collection('activities')
        .where('favorited', arrayContains: email)
        .get();
  }
}
