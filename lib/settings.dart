import 'package:flutter/material.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
            child: new Text(
              'Settings',
              style: new TextStyle(
                height: 1.2,
                fontSize: 22.0,
                fontFamily: 'Renner*',
                fontWeight: FontWeight.w500,
                color: darkMode ? Colors.white : Colors.blueGrey,
              ),
            ),
          ),
          new ListTile(
            title: new Text('Profile'),
            subtitle: new Text('Details like your height and weight, age, etc.'),
            onTap: () {},
          ),
          new ListTile(
            title: new Text('Notifications'),
            subtitle: new Text('Choose when to notify you before each activity'),
            onTap: () {},
          ),
          new SwitchListTile(
            value: true,
            activeColor: darkMode ? Colors.lightBlue : Colors.blue,
            title: new Text('Step Count'),
            onChanged: (value) {},
          ),
          new SwitchListTile(
            value: darkMode,
            activeColor: Colors.lightBlue,
            title: new Text('Dark Mode'),
            onChanged: (value) {
              App.of(context).changeBrightness(darkMode ? Brightness.light: Brightness.dark);
            },
          ),
        ],
      ),
    );
  }
}
