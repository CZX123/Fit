import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'data/dietList.dart';

class DietScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Orientation orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = 172.0;
    return new SingleChildScrollView(
      child: new Stack(
        children: <Widget>[
          new Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            height: containerHeight + windowTopPadding,
            child: new Container(
              color: darkMode ? Colors.grey[900] : Colors.green,
            ),
          ),
          new Positioned(
            top: containerHeight - 1 + windowTopPadding,
            right: 0.0,
            left: 0.0,
            bottom: -64.0,
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: <Color>[
                    darkMode ? Colors.grey[900] : Colors.green,
                    darkMode ? Colors.grey[900] : Colors.green[50],
                  ],
                ),
              ),
            ),
          ),
          new Container(
            color: darkMode ? Colors.grey[900] : null,
            constraints: new BoxConstraints(
              minHeight: height - 48.0,
            ),
            padding: new EdgeInsets.only(top: windowTopPadding),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                  child: new Text(
                    'Diet',
                    style: new TextStyle(
                      height: 1.2,
                      color: Colors.white,
                      fontFamily: 'Renner*',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      child: new Text(
                        'Hello',
                        style: new TextStyle(
                          height: 1.2,
                          color: Colors.white,
                          fontFamily: 'Renner*',
                          fontSize: 48.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 20.0),
                      child: new Text(
                        'Here are some recommended diets for you:',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 32.0),
                  child: new Grid(
                    children: dietList,
                    columnCount: orientation == Orientation.portrait ? 2 : 3,
                  ),
                ),
                new Container(),
              ],
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
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width /
            ((orientation == Orientation.portrait) ? 2 : 3) -
        12.0;
    return new Container(
      height: width / ((orientation == Orientation.portrait) ? 1.3 : 1.6),
      width: width,
      margin: const EdgeInsets.all(4.0),
      child: new RaisedButton(
        elevation: darkMode ? 0.0 : 2.0,
        highlightElevation: darkMode ? 0.0 : 8.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: new Container(
          padding: const EdgeInsets.symmetric(
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
                  height: 1.2,
                  fontFamily: 'Renner*',
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
