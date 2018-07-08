import 'package:flutter/material.dart';
import 'main.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double padding = portrait ? 16.0 : 72.0;
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 24.0, padding, 12.0),
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
            contentPadding: EdgeInsets.symmetric(horizontal: padding),
            title: const Text('Profile'),
            subtitle: const Text('Details like your height and weight, age, etc.'),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: padding),
            title: const Text('Notifications'),
            subtitle: const Text('Choose when to notify you before each activity'),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding - 8.0, 0.0),
            title: const Text('Step Count'),
            onTap: () {},
            trailing: Switch(
              value: true,
              activeColor: darkMode ? Colors.lightBlue : Colors.blue,
              onChanged: (_) {},
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(padding, 0.0, padding - 8.0, 0.0),
            title: const Text('Dark Mode'),
            onTap: () {
              App.of(context).changeBrightness(darkMode ? Brightness.light: Brightness.dark);
            },
            trailing: Switch(
              value: darkMode,
              activeColor: darkMode ? Colors.lightBlue : Colors.blue,
              onChanged: (_) {
                App.of(context).changeBrightness(darkMode ? Brightness.light: Brightness.dark);
              },
            ),
          ),
        ],
      ),
    );
  }
}
