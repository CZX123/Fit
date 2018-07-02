import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool darkMode = brightness == Brightness.dark;
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
            onChanged: (bool) {},
          ),
          new SwitchListTile(
            value: darkMode,
            activeColor: Colors.lightBlue,
            title: new Text('Dark Mode'),
            onChanged: (bool) {
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark ? Brightness.light: Brightness.dark);
            },
          ),
        ],
      ),
    );
  }
}
