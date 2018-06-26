import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool darkMode = brightness == Brightness.dark;
    final String brightnessText = brightness == Brightness.light ? 'Light' : 'Dark';
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: new Text(
              'Settings',
              style: new TextStyle(
                fontSize: 24.0,
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
            title: new Text('Toggle App Theme'),
            subtitle: new Text('Current Theme: $brightnessText'),
            onTap: () {
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark ? Brightness.light: Brightness.dark);
            },
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
