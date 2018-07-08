import 'package:flutter/material.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
            child: Text(
              'Settings',
              style: TextStyle(
                height: 1.2,
                fontSize: 22.0,
                fontFamily: 'Renner*',
                fontWeight: FontWeight.w500,
                color: darkMode ? Colors.white : Colors.blueGrey,
              ),
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            subtitle: const Text('Details like your height and weight, age, etc.'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Choose when to notify you before each activity'),
            onTap: () {},
          ),
          SwitchListTile(
            value: true,
            activeColor: darkMode ? Colors.lightBlue : Colors.blue,
            title: const Text('Step Count'),
            onChanged: (value) {},
          ),
          SwitchListTile(
            value: darkMode,
            activeColor: Colors.lightBlue,
            title: const Text('Dark Mode'),
            onChanged: (value) {
              App.of(context).changeBrightness(darkMode ? Brightness.light: Brightness.dark);
            },
          ),
        ],
      ),
    );
  }
}
