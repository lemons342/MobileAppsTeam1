// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';

class Account extends StatelessWidget{
  Account({
    Key? key,
  }) : super(key: key);

  final List<String> activities = ["Soccer", "Baseball"];

  //Due to current issues with firestore, as of 11/18/2022, has been left unimplemented
  @override
  Widget build(BuildContext context){
    return Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      //Will display the email of the user
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        Text("Email: john.doe@gmail.com"),
      ],),
      //Will display the name if set
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        Text("Name: John Doe"),
      ],),
      //Will list the favorite activites entered or selected by the user
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: [
        SizedBox(height: 100.0, width: 250.0, child:
        ListView.separated( 
        itemCount: activities.length, 
        itemBuilder: (context, index) { 
          return ListTile( 
              title: Text(activities[index], style: const TextStyle(fontSize: 18.0))); 
        }, 
          separatorBuilder: (context, int) => 
            const Divider(color: Colors.black, thickness: 1.0, height: 1.0))
        )],
      ),
      //Takes the user to the page to edit account information
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Change Account Information"))
        )
      ],),
      //Takes the user to a spot or change password
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Change Password"))
        )
      ],),
    ],),));
  }
}