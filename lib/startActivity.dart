import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './data/newActivityList.dart';

class StartActivityScreen extends StatelessWidget {

  StartActivityScreen({
    this.icon: Icons.help,
    this.image,
    this.color,
    @required this.name,
  });

  final IconData icon;
  final String image;
  final Color color;
  final String name;

  String determineActivityType() {
    for (int i = 0; i < packageList.length; i++) {
      if (name == packageList[i].name) return 'Package';
    }
    return 'Task';
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color actualColor = color ?? (darkMode ? Colors.lightBlue : Colors.blue);
    String activityType = determineActivityType();
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 200.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                  height: 96.0,
                  width: 96.0,
                  child: new Hero(
                    tag: name + 'a',
                    child: (image != null)
                      ? new Image.asset(
                          image,
                          fit: BoxFit.contain,
                        )
                      : new FittedBox(
                          child: new Icon(
                            icon,
                            color: actualColor,
                          ),
                        ),
                  ),
                ),
                new Text(
                  name,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
