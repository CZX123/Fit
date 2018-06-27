import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewPackageScreen extends StatelessWidget {

  NewPackageScreen({
    this.icon: Icons.help,
    this.image,
    this.color,
    @required this.name,
    @required this.description,
  });

  final IconData icon;
  final String image;
  final Color color;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          'New $name Package',
          style: new TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
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
                    tag: name,
                    child: (image != null)
                      ? new Image.asset(
                          image,
                          fit: BoxFit.contain,
                        )
                      : new FittedBox(
                          child: new Icon(
                            icon,
                            color: color,
                          ),
                        ),
                  ),
                ),
                new Text(
                  name,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    height: 1.2,
                    fontFamily: 'Renner*',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 16.0),
            child: new Text(description),
          )
        ],
      ),
    );
  }

}

class NewTaskScreen extends StatelessWidget {

  NewTaskScreen({
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.description,
  });

  final IconData icon;
  final String image;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          'New $name Task',
          style: new TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
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
                    tag: name,
                    child: (image != null)
                      ? new Image.asset(
                          image,
                          fit: BoxFit.contain,
                        )
                      : new FittedBox(
                          child: new Icon(
                            icon,
                            color: Colors.blue,
                          ),
                        ),
                  ),
                ),
                new Text(
                  name,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    height: 1.2,
                    fontFamily: 'Renner*',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 16.0),
            child: new Text(description),
          )
        ],
      ),
    );
  }
}
