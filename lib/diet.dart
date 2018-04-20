import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'data/dietList.dart';
import 'settings.dart';

class DietScreen extends StatelessWidget {

  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = orientation == Orientation.portrait ? width / 14 * 9 : 230.0;
    return new SingleChildScrollView(
      child: new Stack(
        children: <Widget>[
          new Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            height: containerHeight + windowTopPadding,
            child: new Container(
              color: Colors.green,
            ),
          ),
          new Positioned(
            top: containerHeight + windowTopPadding,
            right: 0.0,
            left: 0.0,
            height: (height - containerHeight < 300) ? 300.0 : height - containerHeight,
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: <Color>[
                    Colors.green,
                    Colors.grey[100],
                  ],
                ),
              ),
            ),
          ),
          new Container(
            constraints: new BoxConstraints(
              minHeight: height - 48.0,
            ),
            padding: new EdgeInsets.only(top: windowTopPadding),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: containerHeight,
                  width: width,
                  color: Colors.green,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(bottom: 8.0),
                        child: new IconTheme(
                          data: new IconThemeData(
                            size: 48.0,
                            color: Colors.white,
                          ),
                          child: new Icon(Icons.warning),
                        ),
                      ),
                      new Text(
                        'Your BMI is',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      new Text(
                        '28',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 48.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new Text(
                          'Here are some recommended diets for you:',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 32.0),
                  child: new Grid(
                    children: dietList,
                    columnCount: orientation == Orientation.portrait ? 2 : 3,
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            top: 28.0,
            right: 4.0,
            child: new Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new SettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Diet extends StatelessWidget {
  const Diet({
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.onPressed,
  });
  final IconData icon;
  final String image;
  final String name;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width / ((orientation == Orientation.portrait) ? 2 : 3) - 12.0;
    return new Container(
      height: width / ((orientation == Orientation.portrait) ? 1.3 : 1.6),
      width: width,
      margin: new EdgeInsets.all(4.0),
      child: new RaisedButton(
        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: new Container(
          padding: new EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (image != null)
                ? new Image.asset(
                  image,
                  height: 64.0,
                )
                : new Icon(
                  icon,
                  size: 64.0,
                  color: Colors.green,
                ),
              new Text(
                name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
