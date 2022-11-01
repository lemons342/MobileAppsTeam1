// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';

class Account extends StatelessWidget{
  Account({
    Key? key,
  }) : super(key: key);

  final List<String> activities = ["Soccer", "Baseball"];

  @override
  Widget build(BuildContext context){
    return Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        Text("Email: john.doe@gmail.com"),
      ],),
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        Text("Name: John Doe"),
      ],),
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
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Change Account Information"))
        )
      ],),
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Change Password"))
        )
      ],),
      Row(mainAxisAlignment:  MainAxisAlignment.start, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Logout"))
        )
      ],)
    ],),));
  }
}