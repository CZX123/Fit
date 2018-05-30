import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text('Settings'),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text('Profile'),
            subtitle: new Text('Details like your height and weight, age, etc.'),
            onTap: () {},
          ),
          new ListTile(
            title: new Text('App Theme'),
            subtitle: new Text('Current Theme: Light'),
            onTap: () {},
          ),
          new ListTile(
            title: new Text('Notifications'),
            subtitle: new Text('Choose when to notify you before each activity'),
            onTap: () {},
          ),
          new ListTile(
            title: new Text('More Stuff'),
            subtitle: new Text('To be available in future updates'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
