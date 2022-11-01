import 'package:flutter/material.dart';

class CreateAccount extends StatelessWidget{
  const CreateAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), child: 
      Column(mainAxisAlignment:  MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text("Email:"),
        SizedBox(height: 50.0, child:
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Email',
          ),
        ),)
      ],)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), child: 
      Column(mainAxisAlignment:  MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text("Password:"),
        SizedBox(height: 50.0, child:
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Password',
          ),
        ),)
      ],)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), child: 
      Column(mainAxisAlignment:  MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text("Confirm Password:"),
        SizedBox(height: 50.0, child:
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Password',
          ),
        ),)
      ],)),
      Padding(padding: const EdgeInsets.all(15.0), child: 
      Row(mainAxisAlignment:  MainAxisAlignment.center, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("Create Account"))
        )
      ],)),
      Padding(padding: const EdgeInsets.all(15.0), child: 
      Row(mainAxisAlignment:  MainAxisAlignment.center, children: const [
        SizedBox(height: 50.0, width: 200.0, child: 
          ElevatedButton(onPressed: null, child: Text("To Login"))
        )
      ],)),
    ],));
  }
}